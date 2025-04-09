FROM ros:melodic

# Melodic image hasn't been changed for over a year. Lets give it a spring clean.
RUN apt update && \
	apt full-upgrade -y

# Install basic ROS deps
RUN apt install ros-melodic-controller-interface  ros-melodic-gazebo-ros-control ros-melodic-joint-state-controller ros-melodic-effort-controllers ros-melodic-joint-trajectory-controller ros-melodic-robot-state-publisher ros-melodic-xacro vim -y

# Deps to compile and run the python examples.
# For some reason eigen is in the wrong place by default
RUN apt install python3-pip -y
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install Cython && \
	pip3 install pybind11 numpy && \
	ln -s /usr/include/eigen3/Eigen /usr/include/Eigen

# Utils to configure the network
RUN apt install iputils-ping iproute2 -y

# Clone into ROS libs
RUN mkdir -p /root/unitree_ws/src && \
	cd /root/unitree_ws/src && \
	git clone https://github.com/unitreerobotics/unitree_ros && \
	git clone https://github.com/unitreerobotics/unitree_ros_to_real && \
	mv unitree_ros_to_real/unitree_legged_msgs . && \
	rm -rf unitree_ros_to_real

# Build ROS libs
RUN cd /root/unitree_ws && \
	. "/opt/ros/$ROS_DISTRO/setup.sh" && \
	/opt/ros/melodic/bin/catkin_make && \
	echo "source ~/unitree_ws/devel/setup.bash" >> /root/.bashrc

# Clone into and build z1 controller
RUN cd /root && \
	. "/opt/ros/$ROS_DISTRO/setup.sh" && \
	git clone https://github.com/unitreerobotics/z1_controller.git && \
	cd z1_controller && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make

# Compile SDK.
# Additional arguments to cmake required to build compatible python library.
RUN cd /root && \
	. "/opt/ros/$ROS_DISTRO/setup.sh" && \
	git clone https://github.com/unitreerobotics/z1_sdk.git && \
	cd z1_sdk && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_CXX_STANDARD=14  -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCMAKE_PREFIX_PATH=$(python3 -m pybind11 --cmakedir) .. && \
	make

COPY setup_networking.sh /root/setup_networking.sh

WORKDIR /root/