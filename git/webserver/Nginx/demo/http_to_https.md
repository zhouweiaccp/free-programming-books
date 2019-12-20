



#websoceket 使用map
map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
}

upstream abc.com
{
     server 47.***.***.1:8012; 
}
server {
    listen 80;
     server_name www.abc.com  abc.com;
    rewrite ^(.*) https://$host$1 permanent;
}
server
        {
                listen 443 ssl;
                server_name www.abc.com  abc.com;
                index index.html index.htm index.php;
                  ssl on;  
        ssl_certificate         /etc/letsencrypt/live/www.abc.com/fullchain.pem;
        ssl_certificate_key     /etc/letsencrypt/live/www.abc.com/privkey.pem; 
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
        ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNULL:!eNULL;
        ssl_prefer_server_ciphers   on;

                location /
                {
            proxy_pass http://abc.com;             
            proxy_set_header   X-Real-IP            $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
            proxy_set_header   Host                   $http_host;
            proxy_set_header   X-NginX-Proxy    true;
            proxy_set_header   Connection "";
            proxy_http_version 1.1;
            
            proxy_connect_timeout 1; 
            proxy_send_timeout 30; 
            proxy_read_timeout 60;
            
                }
        error_log   logs/abc_error.log;

  }