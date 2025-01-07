#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create logs directory if it doesn't exist
LOGS_BASE_DIR="./logs"
mkdir -p "$LOGS_BASE_DIR"

# Function to create timestamped log directory
create_log_directory() {
    local timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    local log_dir="${LOGS_BASE_DIR}/logs_${timestamp}"
    mkdir -p "$log_dir"
    echo "$log_dir"
}

# Function to print success messages
success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print error messages
error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Function to display usage
usage() {
    echo "Usage: $0 {start|stop|restart} [--build] [--logs]"
    exit 1
}

# Function to start services and log output
start_services() {
    success "Starting services..."
    local log_dir=$(create_log_directory)  # Create log directory

    # Start containers and log output in a subshell
    # This is to prevent the docker compose command from being killed when the script exits
    ( docker compose up $UP_OPTION > "${log_dir}/startup.log" 2>&1 ) &
    local compose_pid=$!
    echo $compose_pid > "${log_dir}/compose.pid"

    success "Services are starting. Logs are being collected in: $log_dir"
    success "To view logs in real-time, use: tail -f ${log_dir}/startup.log"

    # Tail logs if requested
    if [[ "$1" == "--logs" ]]; then
        local retries=5
        local count=0
        local log_file="${log_dir}/startup.log"

        # Retry logic
        while [[ ! -f "$log_file" && $count -lt $retries ]]; do
            echo "Waiting for log file to be created..."
            sleep 1
            ((count++))
        done

        # Check if the log file exists after retries
        if [[ -f "$log_file" ]]; then
            tail -f "$log_file"  # Tail logs if --logs is specified
        else
            error "Log file not found after $retries attempts."
        fi
    fi
}

# Function to stop services
stop_services() {
    success "Stopping services..."

    # Find and terminate the compose process
    if [ -d "$LOGS_BASE_DIR" ]; then
        for pid_file in "$LOGS_BASE_DIR"/logs_*/compose.pid; do
            if [ -f "$pid_file" ]; then
                local compose_pid=$(cat "$pid_file")
                if kill -0 $compose_pid 2>/dev/null; then
                    kill $compose_pid
                    wait $compose_pid 2>/dev/null
                fi
                rm "$pid_file"
            fi
        done
    fi

    # Ensure everything is stopped
    docker compose down || error "Failed to stop services"
    success "Containers stopped."
}

# Check if the command is provided
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
    usage
fi

# Determine if --build or --remote option is provided for start
UP_OPTION="--build"
if [ "$1" == "start" ]; then
    if [ "$2" == "--build" ]; then
        UP_OPTION="--build"
    fi

    # Check for --logs option
    if [[ "$@" == *"--logs"* ]]; then
        start_services "--logs"  # Call the function to start services with logs
        exit 0
    fi

    if [ $# -gt 2 ]; then
        usage
    fi
fi

# Main script
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        start_services
        ;;
    *)
        usage
        ;;
esac