FROM ros:melodic

RUN apt update
RUN apt install ros-melodic-controller-interface  ros-melodic-gazebo-ros-control ros-melodic-joint-state-controller ros-melodic-effort-controllers ros-melodic-joint-trajectory-controller ros-melodic-robot-state-publisher ros-melodic-xacro vim -y

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

