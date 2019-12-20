#!/bin/bash


cert_gen(){
    openssl genrsa -out /etc/nginx/cert/server.key 2048
    openssl req -new -out /etc/nginx/cert/server.csr -key /etc/nginx/cert/server.key -subj /CN=localhost
    openssl x509 -req -days 3600 -in /etc/nginx/cert/server.csr -signkey /etc/nginx/cert/server.key -out /etc/nginx/cert/server.crt
}
# ${REGION} 环境变量
if [ "${REGION}" == "true"  ];then
   NGINX_CONFIG_80="nginx_region_80.conf"
   NGINX_CONFIG_SSL="nginx_region_ssl.conf"
else 
   NGINX_CONFIG_80="nginx_80.conf"
   NGINX_CONFIG_SSL="nginx_ssl.conf"
fi

# ${SSL} 环境变量
if [ "${SSL}" != "true" ];then
    cp -rf /opt/nginx/${NGINX_CONFIG_80} /etc/nginx/conf.d/default.conf
else
    if [ $(ls /etc/nginx/cert/*.crt 2> /dev/null) ];then
        SSL_CERT=$(ls /etc/nginx/cert/*.crt)
        SSL_CERT_KEY=$(ls /etc/nginx/cert/*.key)
    else
        cert_gen
        SSL_CERT=$(ls /etc/nginx/cert/*.crt)
        SSL_CERT_KEY=$(ls /etc/nginx/cert/*.key)
    fi
    cp -rf /opt/nginx/${NGINX_CONFIG_SSL} /etc/nginx/conf.d/default.conf
    sed -i s%DOMAIN_NAME%${DOMAIN_NAME}%g /etc/nginx/conf.d/default.conf
    sed -i s%SSL_CERT%${SSL_CERT}%g /etc/nginx/conf.d/default.conf
    sed -i s%SSL_KEY%${SSL_CERT_KEY}%g /etc/nginx/conf.d/default.conf

fi

if [ "${REGION}" == "true"  ];then
  echo "REGION"
else
    if [ -z "${WF}" -o "${WF}" == "true"  ];then
          cat   << EOF >> /etc/nginx/conf.d/default.conf
    	     location /edoc2Flow-web {  
    		#proxy_redirect off;
    		proxy_set_header Host \$host;
    		proxy_set_header X-Real-IP \$remote_addr; 
    		proxy_set_header REMOTE-HOST \$remote_addr; 
    		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    		proxy_pass http://wf:8080/edoc2Flow-web/; 
    		index  index.html index.htm;
    		allow all;
        }
      }	  
EOF
    else 
         echo '}'  >> /etc/nginx/conf.d/default.conf
    	 
    fi
fi
nginx -g "daemon off;"




