#!/bin/bash

# TODO:
# force add trailing slash at the end of the path

hostsFile=/private/etc/hosts
apacheFile=/etc/apache2/extra/httpd-vhosts.conf

read -e -p "What's the domain? http://" domain;
echo "All right, now I need to know where to put the docroot."
read -e -p "What's the local path? " path;

# replace ~ with absolute path
user=`whoami`
path=`echo $path | sed -E "s/~/\/Users\/$user/g"`

# remove the path trailing slash
path=`echo $path | sed 's#/*$##'`

sudo -s <<EOF

	function getvhost()
	{
	
	cat <<- _EOF_
	
		<Directory "$path/$domain/">
		Allow From All
		AllowOverride All
		</Directory>
		<VirtualHost *:80>
		        ServerName "$domain"
		        DocumentRoot "$path/$domain"
		</VirtualHost>
	
	_EOF_
	
	}

	#add the domain the the hosts file
	echo "127.0.0.1 $domain" >> $hostsFile
	getvhost >> $apacheFile
	apachectl restart;
EOF


echo "$domain has been created at $path/$domain	";
