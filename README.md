###### forked from [D363N6UY/MapleStory-v113-Server-Eimulator](https://github.com/D363N6UY/MapleStory-v113-Server-Eimulator)

# MapleStory v113 Server

This is a MapleStory v113 server implementation with automated management scripts.

## Requirements
- Docker
- Docker Compose

## Quick Start

1. Clone this repository
    ```
    git clone https://github.com/CW-B-W/MapleStory-v113-Server-Docker.git
    ```
2. Unzip wz.zip
    ```
    unzip wz.zip
    ```
3. Set server IP in `Settings.ini`, e.g.
    ```
    tms.IP            = ec2-cwbw.ddns.net
    ```
    Server will send `tms.IP` to the client, so that the client knows where to send game packets.
4. Make the run script executable:
    ```bash
    chmod +x run.sh
    ```
5. Start the server:
    ```bash
    ./run.sh start
    ```

## Managing the Server

- To stop the server:
```bash
./run.sh stop
```

- To restart the server:
```bash
./run.sh restart
```

## Logs

Logs are automatically stored in the `logs/` directory with timestamps. Each run creates a new log directory.

## Troubleshooting

### Can login. But disconnected when choosing a character
Check `tms.IP` in `Settings.ini` is set correctly.
