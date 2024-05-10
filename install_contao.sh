set -e

composer create-project contao/managed-edition . '4.13.*'
chown -R www-data:www-data /var/www/html/contao
# Install Contao
#composer create-project contao/managed-edition /contao '4.13.*' --no-dev --no-interaction --prefer-dist
# Create the directory if it doesn't exist
cat composer.json
mkdir -p app/config
# Generate parameters.yml file
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

