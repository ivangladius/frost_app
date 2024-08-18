# Use the official ROS Noetic image as a parent image
FROM ros:noetic-ros-base

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    ros-noetic-rospy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file to the server directory
COPY server/requirements.txt /app/server/requirements.txt

# Copy the start.sh script to the container
COPY start.sh /app/start.sh

# Install any needed packages specified in requirements.txt
RUN pip3 install --upgrade pip \
    && pip3 install -r /app/server/requirements.txt

# Expose the necessary ports
EXPOSE 8000 8765

# Set the command to run the start.sh script
CMD ["/app/start.sh"]