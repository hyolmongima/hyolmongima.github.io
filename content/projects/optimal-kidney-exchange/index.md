---
title: "Optimal Kidney Exchange"
summary: "Integer optimization to maximize transplants across incompatible donor-patient pairs."
date: 2024-12-09
tags: [Integer optimization]
links:
  paper: "paper.pdf"
featured: false
draft: false
---

MIT 6.C57, with Ashwini Suriyaprakash and Jin Gao.

## Problem Statement

More than 100,000 people in the United States need a kidney transplant at any given time, and about 12 die each day waiting for one. A patient whose willing donor is incompatible can swap donors with other such pairs, in a cycle of any length, or receive from an altruistic donor who starts a chain. A donor gives only if their own patient receives. The goal is to choose the exchanges that maximize transplants.

{{< svg src="exchange.svg" caption="Filled: donor. Ring: patient. Each arrow is a kidney, coloured by blood type." >}}

## Optimization Problem Formulation

\(y_{ij} = 1\) if the donor of pair \(i\) gives to the patient of pair \(j\), and \(c_{ij} = 1\) if they are compatible.

$$
\begin{aligned}
\max_{y}\quad & \textstyle\sum_{i,j} y_{ij} \\
\text{s.t.}\quad & \textstyle\sum_j y_{ij} \le 1 && \text{one kidney per donor} \\
& \textstyle\sum_i y_{ij} \le 1 && \text{one kidney per patient} \\
& \textstyle\sum_j y_{ij} = \sum_j y_{ji} && \text{give if and only if receive} \\
& y_{ij} \le c_{ij}, \;\; y_{ij} \in \{0,1\}
\end{aligned}
$$

Inflow equals outflow at every pair, so the solution is a set of disjoint cycles. The full model adds altruistic donors, blood-type match scores, transport cost to 20 transplant centers and center surgery capacity. Solved with JuMP and Gurobi.

## Results

On 1,000 synthetic pairs, the base model finds 640 transplants and altruistic donors raise it to 661, all exact blood-type matches. Transport cost and capacity keep all 661 at 222,291 km of total travel. On a smaller instance, accounting for transport cost cut travel by 84% with the same matches.

{{< svg src="cube.svg" class="narrow" caption="A three-pair cycle has three decision variables. Give-if-and-only-if-receive collapses the unit cube to its diagonal: the cycle happens entirely or not at all. The constraints form a flow problem whose corners are all whole numbers, so the LP relaxation already gives the integer answer. Gurobi solved the 1,000-pair model at the root node (640 = 640)." >}}
