#!/bin/bash

# Wait for MySQL to be ready
until mysql -w -h mysql -u root -pmaplestory -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MySQL to be ready..."
    sleep 3
done

mysql -w -h mysql -u root -pmaplestory -e "use MapleStory" 1> /dev/null 2>& 1
if [ "$?" = "1" ]
then
    echo "Initializing TMS database..."
    mysql -h mysql -u root -pmaplestory -e "create database MapleStory"
    mysql -h mysql -u root -pmaplestory MapleStory < /app/init_db/maplestory.sql
fi

echo "Starting TMS server..."
cd /app && export CLASSPATH=.:/app/dist/*:/app/dist/lib/* && java -Xmx1024M -server -Dnet.sf.odinms.wzpath=wz server.Start