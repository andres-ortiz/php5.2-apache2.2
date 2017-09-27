#!/bin/bash

set -e
set -u

echo "Starting ..."

mkdir -p /usr/local/apache2/htdocs/logs_apache/
apachectl -D FOREGROUND
