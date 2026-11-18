---
title: "Autonomous Mobile Robot"
summary: "An indoor differential-drive robot, built up from a 2D simulator to hardware."
date: 2026-11-01
tags: [ROS 2, Planning, Estimation, Mobile robots]
links:
  code: "https://github.com/hyolmongima/robotics-autonomy-sim"
featured: true
weight: 2
draft: false
---

## Plan

Each layer works before the next one is built.

1. **Simulation:** a 2D world with a kinematic plant, A\* global planning and a [Pure Pursuit]({{< relref "/notes/pure-pursuit" >}}) tracker. Done.
2. **Estimation:** IMU attitude estimation, a velocity EKF, then SLAM.
3. **Port:** C++ and ROS 2, tested against Gazebo.
4. **Hardware:** the robot below, running the same stack.

{{% fold title="Hardware" %}}

Two driven wheels and a caster. Each wheel is a gear motor whose driver accepts a speed command. Control is a cascade, with each loop 5 to 10 times slower than the one below it: path on the Pi, body velocity on the ESP32, wheel speed and current on the drivers.

{{< svg src="stack.svg" caption="Commands go down, measurements come back up. The Pi only ever sends cmd_vel, the standard ROS base-controller interface, so slam_toolbox and Nav2 plug in unchanged and Gazebo can stand in for the robot." >}}

| Part | Choice |
|---|---|
| Compute | Raspberry Pi 5, 8 GB, Ubuntu 24.04 and ROS 2 Jazzy, booting from NVMe |
| Base controller | ESP32-S3 with an ICM-42688-P IMU |
| Drive | Two gear motors with encoder feedback on drivers that close the speed and current loops |
| Range | A 360\(^\circ\) 2D lidar (RPLIDAR A1 or LD19) and a bumper switch |

**Safety lives on the ESP32.** If the Pi or the link dies, a command timeout stops the motors.

**Estimation runs in two layers.** The ESP32 runs a velocity EKF on \([v, \omega, b_g]\), where \(b_g\) is the gyro bias. The wheels give a second measure of \(\omega\) and standing still exposes the bias, so every state is observable. The Pi integrates that velocity into a smooth odom pose for control. Lidar corrects drift in a separate map frame that may jump, so the corrections never disturb the controllers.

**Every sensor does what it is best at.** Wheel encoders give forward speed, the gyro gives yaw rate, and the accelerometer only flags slip and collisions. It is never integrated for speed.

**Build order:** wheels and teleop, then gyro heading hold, then the ROS bridge, then lidar mapping and Nav2 go-to-goal.

{{% /fold %}}
