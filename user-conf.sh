#!/bin/bash
useradd -m -U quasar
echo "quasar:quasar" | chpasswd
usermod -aG wheel quasar
echo search moda.net > /etc/resolv.conf
echo nameserver 10.0.0.6 >> /etc/resolv.conf






