#!/bin/bash

mount -t tmpfs -o size=2G tmpfs /var/lib/mysql
exec "$@"
