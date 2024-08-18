#!/bin/bash

# Source ROS setup
source /opt/ros/noetic/setup.bash

# Ensure the catkin workspace exists
if [ ! -d /app/ros/catkin_ws/src ]; then
  mkdir -p /app/ros/catkin_ws/src
  cd /app/ros/catkin_ws/src
  ln -s /app/frost_msgs .
fi

# Build the workspace if it hasn't been built yet
if [ ! -f /app/ros/catkin_ws/devel/setup.bash ]; then
  cd /app/ros/catkin_ws
  catkin_make
fi

# Source the workspace setup
source /app/ros/catkin_ws/devel/setup.bash

# Activate the virtual environment
source /app/server/venv/bin/activate

# Start roscore in the background
roscore &

# Wait for roscore to start
sleep 5

# Change to the correct directory
cd /app/server

# Print current working directory (for debugging)
pwd

# Replace the last command with exec
exec python3 server.py