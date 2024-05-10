set -e

composer create-project contao/managed-edition . '4.13.*'
chown -R www-data:www-data /var/www/html/contao

# print composer.json file to see configuration
cat composer.json

mkdir -p app/config

# Test database connection with environment variables
echo "Testing database connection..."
mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" -e "SELECT 1" || {
    echo "Failed to connect to the database."
    exit 1
}

# Generate parameters.yml file where environment data from docker-compose.yml file will be saved 
cat << EOF > app/config/parameters.yml
parameters:
    database_host: ${MYSQL_HOST}
    database_port: ${MYSQL_PORT}
    database_name: ${MYSQL_DATABASE}
    database_user: ${MYSQL_USER}
    database_password: ${MYSQL_PASSWORD}
EOF

cat app/config/parameters.yml

# Run Contao installation commands
composer install 
php vendor/bin/contao-console contao:install --no-interaction
php vendor/bin/contao-console contao:migrate --dry-run	

# Install Contao database schema
php vendor/bin/contao-console  contao:install --env=prod --no-interaction

