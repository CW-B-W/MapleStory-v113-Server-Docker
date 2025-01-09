###### forked from [D363N6UY/MapleStory-v113-Server-Eimulator](https://github.com/D363N6UY/MapleStory-v113-Server-Eimulator)

# MapleStory v113 Server

This is a MapleStory v113 server implementation with automated management scripts.

## Requirements
- Docker
- Docker Compose

## Quick Start

1. Clone this repository
2. Unzip wz.zip
```
unzip wz.zip
```
3. Make the run script executable:
```bash
chmod +x run.sh
```
4. Start the server:
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
