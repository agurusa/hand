# Kudos to DOROWU and BPINAYA for their amazing VNC 16.04 KDE image and ROS/Gazebo image
FROM dorowu/ubuntu-desktop-lxde-vnc
LABEL maintainer "aarthi.gurusami@gmail.com"
ENV ROS_DISTRO "melodic"

# Copy meshes to Docker image
COPY meshes /usr/local/meshes

# Adding keys for ROS
RUN apt-get update && apt-get install -y dirmngr
RUN mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-key adv --homedir  ~/.gnupg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt-get update && apt-get install -y ros-${ROS_DISTRO}-desktop-full \
		wget git nano
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source ~/.bashrc"

# Install ROS dependencies for package building
RUN apt-get update && apt install -y python-rosdep \
        python-rosinstall \
        python-rosinstall-generator \
        python-wstool \
        build-essential \
        python-rosdep \ 
        ros-${ROS_DISTRO}-moveit \
        python-catkin-tools \
        ros-${ROS_DISTRO}-catkin
RUN rosdep init && rosdep update

# Update Gazebo 11
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update && apt-get install -y libgazebo11 gazebo11-common gazebo11
RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc && source /root/.bashrc"

# Create catkin workspace and package
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
                 mkdir -p ~/catkin_ws/src && \
                 cd ~/catkin_ws/src &&\
                 catkin_create_pkg hand std_msgs rospy roscpp && \
                 cd ~/catkin_ws && \
                 catkin_make &&\
                 source devel/setup.bash && \
                 echo $ROS_PACKAGE_PATH ~/catkin_ws/src:/opt/ros/${ROS_DISTRO}/share &&\
                 echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc"

