#!/bin/sh

# Verify that Git is installed
if ! command -v git &> /dev/null; then
	echo "Git is not installed. Please install Git to proceed."
	exit 1
fi

# Check if Docker is installed
if command -v docker &> /dev/null ; then
	docker=$(which docker)
fi

# Check if Podman is installed
if command -v podman &> /dev/null ; then
	docker=$(which podman)
fi

# If neither Docker nor Podman is installed, exit with an error
if [ -z "$docker" ]; then
	echo "Neither Docker nor Podman is installed. Please install one of them to proceed."
	exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
	echo "Docker Compose is not installed. Please install Docker Compose to proceed."
	exit 1
fi

# Clone each of the components
for i in transcribe-ui transcribe-backend; do 
	if [ -d "$i" ]; then
		(cd $i && git pull)
	else
		(cd $i; git clone https://github.com/krihal/$i.git)
	fi

	echo "Building Docker image for $i"
	(cd $i; $docker build -f Dockerfile -t $i:latest .)
done
