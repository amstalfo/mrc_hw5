%% MRC Assignment 5 Exercise 2
% Matt Audette
% 20180510

clear all
clc
format compact

% Read in the bag file:
%bag = rosbag('~/mrc_hw5_data/joy.bag')
bag = rosbag('~/catkin_ws/src/mrc_hw5/waypoint.bag')

% Display a list of the topics and message types in the bag file:
bag.AvailableTopics

% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry
% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)

% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');

% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

% The time vector in the timeseries (ts.Time) is "Unix Time"
% which is a bit cumbersome.  Create a time vector that is relative
% to the start of the log file
tt = ts.Time-ts.Time(1);

%% Break out the time serias data:
xPos = ts.Data(:,1);
yPos = ts.Data(:,2);
linearVel = ts.Data(:,3);
angularVel = ts.Data(:,4);
orienW = ts.Data(:,5);
orienX = ts.Data(:,6);
orienY = ts.Data(:,7);
orienZ = ts.Data(:,8);


% Quarternion to Euler conversion
quat = cat(2,orienW, orienX, orienY, orienZ);
eul = quat2eul(quat);
yaw = eul(:,1);
%% Plots:
figure(1)
plot(xPos, yPos)
title("X Position vs Y Position")
axis('equal')
grid on

figure(2)
plot(tt, yaw)
title("Heading (yaw) vs Time")
%axis('equal')
grid on
grid minor

figure(3)
plot(tt, linearVel)
title("Linear Velocity vs Time")
%axis('equal')
grid on
grid minor

figure(4)
quiver(xPos, yPos, yaw, linearVel)
title("Quiver Plot of xPos, yPos, Yaw, and LinearVel")
axis('equal')
grid on
grid minor