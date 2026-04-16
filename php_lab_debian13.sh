#!/bin/bash
# PHP 8 Lab Setup Script - Debian 13 (Trixie)
# Run with: sudo bash php_lab_debian13.sh

set -e

echo "PHP 8 Lab Setup - Debian 13 Trixie"
echo ""

echo "[1] Updating system..."
apt-get update -y
apt-get upgrade -y

echo "[2] Adding Sury PHP repo..."
apt-get install -y lsb-release ca-certificates curl

curl -fsSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg

echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ trixie main" > /etc/apt/sources.list.d/sury-php.list

apt-get update -y

echo "[3] Installing PHP 8.0..."
apt-get install -y php8.0 libapache2-mod-php8.0
php -v

echo "[4] Installing PHP 8.0 extensions..."
apt-get install -y \
  php8.0-mysql \
  php8.0-cli \
  php8.0-common \
  php8.0-imap \
  php8.0-ldap \
  php8.0-xml \
  php8.0-fpm \
  php8.0-curl \
  php8.0-mbstring \
  php8.0-zip
php -m

echo "[5] Installing Apache2..."
apt-get install -y apache2
a2enmod php8.0
systemctl enable apache2
systemctl restart apache2

echo "[6] Setting up website2..."
mkdir -p /var/www/website2

cat > /etc/apache2/sites-available/website2.conf <<EOF
<VirtualHost *:80>
    ServerName website2
    DocumentRoot /var/www/website2
    <Directory /var/www/website2>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/website2_error.log
    CustomLog \${APACHE_LOG_DIR}/website2_access.log combined
</VirtualHost>
EOF

a2ensite website2.conf
systemctl reload apache2

if ! grep -q "website2" /etc/hosts; then
    echo "127.0.0.1   website2" >> /etc/hosts
fi

echo "[7] Creating phpinfo() page..."
cat > /var/www/html/index.php <<EOF
<?php
    phpinfo();
?>
EOF

echo ""
echo "Visit http://$(hostname -I | awk '{print $1}')/index.php to verify, then press ENTER to continue."
read -p ""

rm /var/www/html/index.php

echo "[8] Creating myfirstprogram.php..."
cat > /var/www/html/myfirstprogram.php <<EOF
<?php
    print "Hello World";
?>
EOF

echo "[9] Creating variables.php..."
cat > /var/www/html/variables.php <<EOF
<?php
\$name      = "Alice";
\$age       = 30;
\$gpa       = 3.85;
\$isStudent = true;

echo "<h2>PHP Variable Examples</h2>";
echo "<p>Name: "    . \$name . "</p>";
echo "<p>Age: "     . \$age  . "</p>";
echo "<p>GPA: "     . \$gpa  . "</p>";
echo "<p>Student: " . (\$isStudent ? "Yes" : "No") . "</p>";
echo "<hr>";
echo "<h3>Variable Types</h3>";
echo "<p>\$name is a: "      . gettype(\$name)      . "</p>";
echo "<p>\$age is a: "       . gettype(\$age)       . "</p>";
echo "<p>\$gpa is a: "       . gettype(\$gpa)       . "</p>";
echo "<p>\$isStudent is a: " . gettype(\$isStudent) . "</p>";
?>
EOF

echo "[10] Creating practice.php..."
cat > /var/www/html/practice.php <<EOF
<?php
\$a = 50;
\$b = 10;

echo "<h2>PHP Practice Programs</h2>";
echo "<p>a = \$a, b = \$b</p><hr>";

echo "<h3>Q1: Output Hello World! if a > b</h3>";
if (\$a > \$b) {
    echo "<p>Hello World!</p>";
}

echo "<h3>Q2: Output Hello World! if a != b</h3>";
if (\$a != \$b) {
    echo "<p>Hello World!</p>";
}

echo "<h3>Q3: Yes if a == b, otherwise No</h3>";
if (\$a == \$b) {
    echo "<p>Yes</p>";
} else {
    echo "<p>No</p>";
}
?>
EOF

systemctl restart apache2

IP=$(hostname -I | awk '{print $1}')
echo ""
echo "Done. Pages to screenshot:"
echo "  http://$IP/myfirstprogram.php"
echo "  http://$IP/variables.php"
echo "  http://$IP/practice.php"
