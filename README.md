- Download the project
- Run the cmd
- go to project root
- execute the docker-compose up --build  in cmd 

Issue:
if encounter any issue like this 
php-1   | chown: cannot access '/var/www/html/contao'$'\r': No such file or directory
open the install_contao.sh file in notepad++ and go to Edit->EOL->Unix
