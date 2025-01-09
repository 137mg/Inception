#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

sleep 5
ping_mariadb_container() {
	nc -zv mariadb 3306 > /dev/null
	return $?
}
start_time=$(date +%s)
end_time=$((start_time + 20))
while [ $(date +%s) -lt $end_time ]; do
	ping_mariadb_container
	if [ $? -eq 0 ]; then
		echo "[========MARIADB IS UP AND RUNNING========]"
		break
	else
		echo "[========WAITING FOR MARIADB TO START...========]"
		sleep 1
	fi
done
if [ $(date +%s) -ge $end_time ]; then
    echo "[========MARIADB IS NOT RESPONDING========]"
fi

wp core download --allow-root
wp core config --path="/var/www/wordpress" --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER_N" --dbpass="$MYSQL_USER_P" --allow-root
wp config set WP_HOME "https://$DOMAIN_NAME" --allow-root
wp config set WP_SITEURL "https://$DOMAIN_NAME" --allow-root
wp core install --path="/var/www/wordpress" --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --skip-email --allow-root
wp user create "$WP_USER_N" "$WP_USER_E" --user_pass="$WP_USER_P" --role="$WP_USER_R" --allow-root

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
