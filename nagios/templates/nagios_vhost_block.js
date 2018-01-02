    auth_basic "Nagios Restricted Access";
    auth_basic_user_file /etc/nagios3/htpasswd.users;
    
    index index.php index.html;

    location /stylesheets {
        alias /etc/nagios3/stylesheets;
    }
    
    location ~ \.cgi$ {
        root /usr/lib/cgi-bin/nagios3;
        rewrite ^/cgi-bin/nagios3/(.*)$ /$1;
        include /etc/nginx/fastcgi_params;
        fastcgi_param AUTH_USER $remote_user;
        fastcgi_param REMOTE_USER $remote_user;
        fastcgi_param SCRIPT_FILENAME /usr/lib/cgi-bin/nagios3$fastcgi_script_name;    
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
    }
