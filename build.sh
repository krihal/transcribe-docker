#!/bin/sh

# Verify that Git
if ! command -v git &> /dev/null; then
	echo "Git is not installed. Please install Git to proceed."
	exit 1
fi

if command -v docker &> /dev/null ; then
	docker=$(which docker)
fi

if command -v podman &> /dev/null ; then
	docker=$(which podman)
fi

# Verify that Docker or Podman is installed
if [ -z "$docker" ]; then
	echo "Neither Docker nor Podman is installed. Please install one of them to proceed."
	exit 1
fi

if ! command -v docker-compose &> /dev/null; then
	echo "Docker Compose is not installed. Please install Docker Compose to proceed."
	exit 1
fi

# Clone each of the components
for i in transcribe-ui transcribe-backend transcribe-worker; do 
	if [ -d "$i" ]; then
		(cd $i && git pull)
	else
		(cd $i; git clone https://github.com/krihal/$i.git)
	fi
done

# Build the Docker images
for i in transcribe-ui transcribe-backend transcribe-worker; do
	echo "Building Docker image for $i"
	(cd $i; $docker build -f Dockerfile -t $i:latest .)
done

# Run!
docker-compose up -f docker-compose.yml -d

