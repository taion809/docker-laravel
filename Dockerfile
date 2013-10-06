FROM        johnsn/ap5
MAINTAINER  Nicholas Johns "nicholas.a.johns5@gmail.com"

# Force update 
# Install git because sometimes composer will pull from github
RUN         echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN         apt-get update; apt-get upgrade -y; apt-get install -y git

# Install Composer
RUN         curl -sS https://getcomposer.org/installer | php
RUN         mv composer.phar /usr/local/bin/composer

# Add our source
ADD         ./laravel /var/www/website
RUN         chown -RL www-data:www-data /var/www/website

# Build our vendors
RUN         composer --working-dir=/var/www/website install --prefer-dist

# Enable rewrite module
# start apache
ADD	    ./apache /etc/apache2/sites-enabled
RUN         ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Now let's binarify this
# So when we do "sudo docker run -d -p 8080:80 johnsn/laravel" 
# it will execute apache2 and pass the values defined in CMD
ENTRYPOINT  ["/usr/sbin/apache2"]
CMD         ["-D", "FOREGROUND"]
