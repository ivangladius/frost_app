# Define variables
BUILD_NAME := ros-marsrover-server
CONTAINER_NAME := ros-marsrover-container
VENV_DIR := server/venv

# Create virtual environment and install dependencies
venv:
	python3 -m venv $(VENV_DIR)
	. $(VENV_DIR)/bin/activate && pip install --upgrade pip && pip install -r server/requirements.txt

# Build the Docker image without cache
docker-build-no-cache: venv
	sudo docker build -t $(BUILD_NAME) . --no-cache

# Build the Docker image
docker-build: venv
	sudo docker build -t $(BUILD_NAME) .

# Run the Docker container in interactive mode with volumes
docker-run: venv
	-@sudo docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-@sudo docker rm $(CONTAINER_NAME) 2>/dev/null || true
	sudo docker run -it --name $(CONTAINER_NAME) -p 8000:8000 -p 8765:8765 -v $(PWD):/app $(BUILD_NAME)

# Run the Docker container in detached mode with volumes
docker-run-d: venv
	-@sudo docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-@sudo docker rm $(CONTAINER_NAME) 2>/dev/null || true
	sudo docker run -it -d --name $(CONTAINER_NAME) -p 8000:8000 -p 8765:8765 -v $(PWD):/app $(BUILD_NAME)

# Clean up the Docker container and image
docker-clean:
	-@sudo docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-@sudo docker rm $(CONTAINER_NAME) 2>/dev/null || true
	-@sudo docker rmi $(BUILD_NAME) 2>/dev/null || true

.PHONY: venv docker-build-no-cache docker-build docker-run docker-run-d docker-clean