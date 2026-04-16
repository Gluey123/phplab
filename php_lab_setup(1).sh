#!/bin/bash
# PHP 8 Lab Setup Script - Ubuntu 22.04 / 24.04
# Run with: sudo bash php_lab_setup.sh

set -e

echo "PHP 8 Lab Setup"
echo ""

echo "[1] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[2] Adding ondrej/php PPA..."
sudo apt-get install -y software-properties-common lsb-release ca-certificates apt-transport-https
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y

echo "[3] Installing PHP 8.0..."
sudo apt-get install -y php8.0 libapache2-mod-php8.0
php -v

echo "[4] Installing PHP 8.0 extensions..."
sudo apt-get install -y \
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
sudo apt-get install -y apache2
sudo a2enmod php8.0
sudo systemctl enable apache2
sudo systemctl restart apache2

echo "[6] Setting up website2..."
sudo mkdir -p /var/www/website2

sudo bash -c 'cat > /etc/apache2/sites-available/website2.conf <<EOF
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
EOF'

sudo a2ensite website2.conf
sudo systemctl reload apache2

if ! grep -q "website2" /etc/hosts; then
    echo "127.0.0.1   website2" | sudo tee -a /etc/hosts
fi

echo "[7] Creating phpinfo() page..."
sudo bash -c 'cat > /var/www/website2/index.php <<EOF
<?php
    phpinfo();
?>
EOF'

echo ""
echo "Visit http://website2/index.php to verify, then press ENTER to continue."
read -p ""

sudo rm /var/www/website2/index.php

echo "[8] Creating myfirstprogram.php..."
sudo bash -c 'cat > /var/www/website2/myfirstprogram.php <<EOF
<?php
    print "Hello World";
?>
EOF'

echo "[9] Creating variables.php..."
sudo bash -c 'cat > /var/www/website2/variables.php <<EOF
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
EOF'

echo "[10] Creating practice.php..."
sudo bash -c 'cat > /var/www/website2/practice.php <<EOF
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
EOF'

sudo systemctl restart apache2

echo ""
echo "Done. Pages to screenshot:"
echo "  http://website2/myfirstprogram.php"
echo "  http://website2/variables.php"
echo "  http://website2/practice.php"
