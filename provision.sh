# Vagrant Installation Script of Drupal in CentOS 6
# Version 1 Base Version of Drupal with Local Database
sudo yum update
sudo yum upgrade -y
# Re-compile Virtual Box Extensions
sudo /etc/init.d/vboxadd setup
# Install PHP first
sudo yum install php php-pear php-devel php-gd php-dom php-mbstring php-xml php-json php-hash -y
sudo pear channel-discover pear.drush.org
sudo pear install drush/drush
# Install GIT
echo Install GIT
sudo yum install git -y
# Version Checking
echo Check Versions Installed
sudo drush --version
sudo git --version
sudo php --version
# Install Apache2 package as httpd
echo Setup Apache2
sudo yum install httpd -y
sudo yum install httpd-docs -y
sudo yum install mod_php -y
sudo yum install mod_ssl -y
# Allow .htaccess to work using follow command
sudo perl -pi -e 's/AllowOverride None/AllowOverride All/i' /etc/httpd/conf/httpd.conf
sudo service httpd restart
# MySQL Server Installation
echo Install MySQL
sudo yum install mysql-server -y
sudo yum install mysql -y
sudo yum install php-mysql -y
# Make sure services will start after reboot
sudo chkconfig --levels 235 mysqld on
sudo chkconfig --levels 235 httpd on
# Check services are running
sudo service httpd start
sudo service mysqld start
sudo mysqladmin -u root password 'Ar0undMe'
sudo mysqladmin -u root -h localhost.localdomain password 'Ar0undMe'
db="create database drupal;GRANT ALL PRIVILEGES ON drupal.* TO root@localhost IDENTIFIED BY 'Ar0undMe';FLUSH PRIVILEGES;"
mysql -u root -pAr0undMe -e "$db"
echo Install Drupal
sudo pecl install uploadprogress
sudo touch /etc/php.d/uploadprogress.ini
sudo chmod u+w /etc/php.d/uploadprogress.ini
sudo echo "extension=uploadprogress.so" > /etc/php.d/uploadprogress
sudo service httpd reload
#cd /vagrant/files/www
#sudo mv /var/www/html /var/www/html_old
#sudo ln -s /vagrant/files/www/html /var/www/html
# sudo drush dl drupal-7.x
#cd /vagrant/files/www
cd /var/www/html
sudo drush -y dl drupal --drupal-project-rename=drupal
cd drupal
sudo drush -y site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:Ar0undMe@localhost/drupal --site-name=drupal
sudo drush -y dl ctools views token pathauto backup_migrate
sudo drush -y en ctools views token pathauto backup_migrate
