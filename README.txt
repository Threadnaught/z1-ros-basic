(REQUIRES LINUX AND DOCKER)

Basic setup to get the z1 sim running with keyboard control under docker. Also compiles and runs c++ and python sdk samples.

BASIC KEYBOARD MOVEMENT

1. Build docker container using (this will take some time)
	docker build -t z1_ros .

2. Expose your local gui to container using (required on reboot)
	xhost +local:docker

3. Run container using
	docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it z1_ros

4. In the container's terminal, begin sim environment by running
	roslaunch unitree_gazebo z1.launch &

5. Wait for GUI to load and show robot.

6. Hit enter on your terminal and you should see interactive control being given back to you

6. Go to directory containing the sim controller using
	cd ~/z1_controller/build/

7. Take keyboard control
	./sim_ctrl k
You should see:
	The control interface for ROS Gazebo simulation
	[GRIPPER] The arm has gripper
	FSM start from passive

8. Hit backtick (`) to enable robot control

9. Use keyboard to steer gripper like so:
	Joint ID	0	1	2	3	4	5	Gripper
	Keyboard	Q/A	W/S	D/E	R/F	T/G	Y/H	up/down

10. You should see it move in the sim. You can use the backtick again to return it to neutral position

SDK USAGE

You can also use the SDK to control the robot, located in /root/z1_sdk. The controller must be running in non-keyboard mode (./sim_ctrl) alongside the code samples.