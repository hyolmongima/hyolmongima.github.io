---
title: "Pure Pursuit"
summary: "Track a path by steering along the arc to a point one lookahead distance ahead."
date: 2026-11-16
tags: [Geometric Path tracking, Control, Mobile Robot]
links:
  code: "https://github.com/hyolmongima/robotics-autonomy-sim/blob/HEAD/sim/controllers/pure_pursuit.py"
draft: false
---
Pure Pursuit is a simple geometric path tracker used on many non-holonomic mobile robots. It sits between the path planner and the velocity controller layer: the planner hands it a path, and it turns that path into velocity commands \((v, \omega)\). At every step it picks a point on the path one lookahead distance ahead and steers along the circular arc that is tangent to the robot's heading and passes through that point.


- **In:** robot pose \((x, y, \theta)\), path \(P = [p_0, p_1, \dots]\), lookahead \(L\)
- **Out:** velocity command \((v, \omega)\)

{{< svg src="geometry.svg" caption="Left: the circle of radius L meets the path ahead at the lookahead point. Right: in the body frame, the arc tangent to the heading has its centre on the y-axis." >}}

{{% fold title="Steps" class="small" %}}
#### 1. Pick the lookahead point

Intersect the robot-centred circle of radius \(L\) with the path. To keep this stable and cheap:

- Track a **progress index**: the segment the robot projects onto. It only moves forward.
- Search only a **window** of segments ahead of it.
- Take the first intersection **ahead** of the robot, \(x_\text{body} > 0\).

If there is none, chase the final waypoint near the end of the path, or otherwise the projection onto the current segment.

#### 2. Fit the arc

Express the lookahead point in the body frame, \(p_L = (x_L, y_L)\). The arc must pass through the robot, be tangent to its heading, and pass through \(p_L\). Tangency puts the centre on the body \(y\)-axis, \(C = (0, R)\). Then

$$
x_L^2 + (y_L - R)^2 = R^2
\;\Rightarrow\;
R = \frac{x_L^2 + y_L^2}{2 y_L} = \frac{L^2}{2 y_L},
\qquad
\kappa = \frac{1}{R} = \frac{2 y_L}{L^2}.
$$

The sign of \(y_L\) sets the turn direction: left for \(y_L > 0\), right for \(y_L < 0\).

#### 3. Command \((v, \omega)\)

Along a circle of radius \(R\), arc length is \(ds = R\,d\theta\), so

$$
v = \frac{ds}{dt} = R \frac{d\theta}{dt} = R\omega
\quad\Rightarrow\quad
\omega = v\kappa.
$$

The intuition that works for me: picture a camera that translates with the robot but does not rotate. As the robot goes around the circle, its heading has to turn at exactly the rate that keeps it tangent, like a tidally locked moon that turns once per orbit.

Speed is a separate policy and can be anything. One option, and the default here, keeps the turn rate within limits, \(v = \min\!\big(v_{\max},\ \omega_{\max} / |\kappa|\big)\), so the robot slows down in tight turns.
{{% /fold %}}

{{% fold title="Choosing the lookahead distance" class="small" %}}

With \(\alpha\) the angle from the heading to \(p_L\), \(y_L = L \sin\alpha\) and

$$
\omega = \frac{2v}{L} \sin\alpha .
$$

Pure pursuit is a proportional controller on the bearing to the lookahead, with gain \(2v/L\). A short \(L\) tracks tightly but oscillates. A long \(L\) is smooth but cuts corners.
{{% /fold %}}




{{% fold title="Limitations" class="small" %}}
Pure pursuit is simple, inexpensive and it serves as well-known baseline for path tracking. However, there are some limitations to it. Following is an incomplete list:  
- What we get out of this approach is a curvature, not the actual control command \((v, \omega)\). We still need to choose our own linear velocity policy.
- The lookahead distance needs to be tuned for your particular robot and speed. An \(L\) that works at low speed can oscillate at high speed, which is why many implementations scale it with \(v\).
- The logic gets a bit blurry toward the end of the path. Once less than \(L\) of path is left, the circle has nothing to hit, so the goal needs its own rule, like chasing the last waypoint and stopping within a tolerance.
- It cuts corners. The robot follows the arc to a point ahead rather than the path itself, so on curves it settles slightly inside.
- It is purely kinematic. It assumes the robot follows the commanded arc exactly, so slip, actuator lag and inertia show up as tracking error, more so at speed.
- The robot has to start within \(L\) of the path. Otherwise the circle never meets the path and there is no lookahead point.
{{% /fold %}}
