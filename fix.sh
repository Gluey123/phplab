sudo bash -c 'cat > /var/www/html/myfirstprogram.php <<EOF
<?php
    print "Hello World";
?>
EOF'

sudo bash -c 'cat > /var/www/html/variables.php <<EOF
<?php
\$name      = "Alice";
\$age       = 30;
\$gpa       = 3.85;
\$isStudent = true;
echo "<h2>PHP Variable Examples</h2>";
echo "<p>Name: " . \$name . "</p>";
echo "<p>Age: " . \$age . "</p>";
echo "<p>GPA: " . \$gpa . "</p>";
echo "<p>Student: " . (\$isStudent ? "Yes" : "No") . "</p>";
echo "<hr>";
echo "<h3>Variable Types</h3>";
echo "<p>\$name is a: " . gettype(\$name) . "</p>";
echo "<p>\$age is a: " . gettype(\$age) . "</p>";
echo "<p>\$gpa is a: " . gettype(\$gpa) . "</p>";
echo "<p>\$isStudent is a: " . gettype(\$isStudent) . "</p>";
?>
EOF'

sudo bash -c 'cat > /var/www/html/practice.php <<EOF
<?php
\$a = 50;
\$b = 10;
echo "<h2>PHP Practice Programs</h2>";
echo "<p>a = \$a, b = \$b</p><hr>";
echo "<h3>Q1: Hello World! if a > b</h3>";
if (\$a > \$b) { echo "<p>Hello World!</p>"; }
echo "<h3>Q2: Hello World! if a != b</h3>";
if (\$a != \$b) { echo "<p>Hello World!</p>"; }
echo "<h3>Q3: Yes if a == b, otherwise No</h3>";
echo (\$a == \$b) ? "<p>Yes</p>" : "<p>No</p>";
?>
EOF'
