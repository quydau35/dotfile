# Redis Version 5.0.7 (Stable)
# Ubuntu 18.04
# Install Redis (version 5.0.7)
1) sudo apt-get install build-essential tcl
mkdir ~/tmp
2) cd ~/tmp , curl -O http://download.redis.io/releases/redis-5.0.7.tar.gz
3) tar xzvf redis-5.0.7.tar.gz
4) cd redis-5.0.7
5) make
6) make test
7) sudo make install
8) sudo mkdir /etc/redis
9) sudo cp ~/tmp/redis-5.0.7/redis.conf /etc/redis
Edit: config redis
10) sudo vim /etc/redis/redis.conf
Edit: supervised systemd
11) sudo vim /etc/systemd/system/redis.service
-------------------------------------
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
-------------------------------------
14) sudo adduser --system --group --no-create-home redis
Create: Data Folder /var/lib/redis
15) sudo mkdir /var/lib/redis
16) sudo chown redis:redis /var/lib/redis
17) sudo chmod 775 /var/lib/redis
Create: Log Folder /var/log/redis/redis-server.log
... Do the same as above steps

18) sudo systemctl enable redis
19) sudo systemctl status redis

# Open Redis Port, Create Log Server
## Check Bind IP : Port
netstat -nlpt | grep 6379
## Change Binding IP, Log File, Data Folder, Proctected Mode
sudo vim /etc/redis/redis.conf
-----------------
Uncomment bind
#bind 127.0.0.1
logfile "/var/log/redis/redis-server.log"
dir /var/lib/redis
protected-mode no

-----------------
## data file permission
cd /var/lib/redis
sudo chown -R redis:redis redis
sudo chmod 775 redis
cd redis
sudo chmod 644 dump.rdb

sudo systemctl restart redis
sudo systemctl daemon-reload

## Check listenning port
netstat -ltnp

## Check for redis is running
redis-cli -h 167.71.212.11 -p 6379 ping

## Test Redis is ok
set a 1
get a
