---
title: "Pure Pursuit"
summary: "Track a path by steering along the arc to a point one lookahead distance ahead."
date: 2026-11-16
tags: [Path tracking, Control]
links:
  code: "https://github.com/hyolmongima/robotics-autonomy-sim/blob/HEAD/sim/controllers/pure_pursuit.py"
draft: false
---

Pure pursuit tracks a polyline path by repeatedly choosing a **lookahead point** at a fixed distance \(L\) and commanding the circular arc that drives the robot to it.

- **In:** robot pose \((x, y, \theta)\), path \(P = [p_0, p_1, \dots]\), lookahead \(L\)
- **Out:** velocity command \((v, \omega)\)

{{< svg src="geometry.svg" caption="Left: the circle of radius L meets the path ahead at the lookahead point. Right: in the body frame, the arc tangent to the heading has its centre on the y-axis." >}}

## 1. Pick the lookahead point

Intersect the robot-centred circle of radius \(L\) with the path. To keep this stable and cheap:

- Track a **progress index**: the segment the robot projects onto. It only moves forward.
- Search only a **window** of segments ahead of it.
- Take the first intersection **ahead** of the robot, \(x_\text{body} > 0\).

If there is none, chase the final waypoint near the end of the path, or otherwise the projection onto the current segment.

## 2. Fit the arc

Express the lookahead point in the body frame, \(p_L = (x_L, y_L)\). The arc must pass through the robot, be tangent to its heading, and pass through \(p_L\). Tangency puts the centre on the body \(y\)-axis, \(C = (0, R)\). Then

$$
x_L^2 + (y_L - R)^2 = R^2
\;\Rightarrow\;
R = \frac{x_L^2 + y_L^2}{2 y_L} = \frac{L^2}{2 y_L},
\qquad
\kappa = \frac{1}{R} = \frac{2 y_L}{L^2}.
$$

The sign of \(y_L\) sets the turn direction: left for \(y_L > 0\), right for \(y_L < 0\).

## 3. Command \((v, \omega)\)

Along a circle of radius \(R\), arc length is \(ds = R\,d\theta\), so

$$
v = \frac{ds}{dt} = R \frac{d\theta}{dt} = R\omega
\quad\Rightarrow\quad
\omega = v\kappa.
$$

The intuition that works for me: picture a camera that translates with the robot but does not rotate. As the robot goes around the circle, its heading has to turn at exactly the rate that keeps it tangent, like a tidally locked moon that turns once per orbit.

Speed is a separate policy. The default keeps the turn rate within limits, \(v = \min\!\big(v_{\max},\ \omega_{\max} / |\kappa|\big)\), so the robot slows down in tight turns.

## Choosing \(L\)

With \(\alpha\) the angle from the heading to \(p_L\), \(y_L = L \sin\alpha\) and

$$
\omega = \frac{2v}{L} \sin\alpha .
$$

Pure pursuit is a proportional controller on the bearing to the lookahead, with gain \(2v/L\). A short \(L\) tracks tightly but oscillates. A long \(L\) is smooth but cuts corners.
