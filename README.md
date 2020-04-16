# Hand

## Summary
This project is used to develop an animatronic hand.

## Setup
- Install Docker
- Clone repo
- Navigate to the working directory

## View
1. Run using `./run.sh`. This will do the following:
- Build the Docker image containing Ubuntu, ROS Melodic, MoveIt and Gazebo
- Name the build image `hand:1.0`
- Stop and remove any containers with the name `hand`
- Start a container at port `6080:80` named `hand` with the previously built image
2. Connect by navigating to `http://localhost:6080/`

