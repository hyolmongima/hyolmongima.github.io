---
title: "Pendubot"
summary: "Planned."
date: 2026-11-16
tags: [Underactuated, Nonlinear control]
links:
  code: ""
featured: true
weight: 3
draft: false
---

A two-link planar arm with a motor at the shoulder and a free elbow, known as a Pendubot. The goal is to swing the second link up and balance it inverted using shoulder torque alone. The motor's encoder measures the first link, and an IMU on the second link measures the free one.

{{< svg src="setup.svg" caption="Shoulder torque pumps energy into the free link until it swings up, and feedback holds both links inverted." >}}
