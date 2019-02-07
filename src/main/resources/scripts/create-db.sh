mysqld_safe --no-watch
while !(mysqladmin ping)
do
   sleep 3
   echo "waiting for mysql ..."
done
mysqladmin create bukkit
mysql -e "CREATE USER mcuser IDENTIFIED BY 'mcpassword';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'mcuser' WITH GRANT OPTION;"

