#!/bin/bash
systemctl stop nginx
certbot renew --agree-tos --standalone
systemctl start nginx
