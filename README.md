# Portfolio

Hugo site. Write Markdown, preview live, build static HTML.

## Preview

```bash
cd portfolio
make dev          # open http://localhost:1313, Ctrl+C to stop
```

Every save reloads the browser. Drafts are visible here.

## New pages

```bash
make new p=visual-inertial-odometry   # content/projects/visual-inertial-odometry/index.md
make note p=ekf-derivation            # content/notes/ekf-derivation/index.md
```

Put images and videos in the same folder as `index.md`. A file named `cover.jpg` (or `.png`) becomes the thumbnail on the Projects page and the link preview image.

```
content/projects/visual-inertial-odometry/
  index.md
  cover.jpg
  rig.jpg
  demo.mp4
```

## Front matter

```yaml
title: "Visual-Inertial Odometry"
summary: "One line, shown under the title and in lists."
date: 2026-11-01
tags: [ROS 2, C++, EKF]
links:              # any names: code, paper, video, writeup, slides...
  code: "https://github.com/..."
  paper: "paper.pdf"  # shown as a "Read the paper" card under the title; a file in the same folder works too
weight: 1           # order within the same year: lower first (otherwise newest first)
toc: true           # force contents box on/off (auto past ~600 words)
draft: false        # true = preview only, excluded from the build
```

## Home page

Just your name, intro and links. Projects and notes are reached from the top menu.

- **Intro text:** `content/_index.md`
- **Name, links (GitHub, Scholar...) and email (pinned bottom left of the home page):** `hugo.toml`. Empty links are hidden; add more with another `[[params.links]]` block.
- **CV:** drop `static/cv.pdf` and a CV link appears in the navigation.

## Syntax

Reference page with every element and its Markdown: `content/projects/_example/index.md`, viewable at http://localhost:1313/projects/_example/ (draft, never published).

| Element | Markdown |
|---|---|
| Inline math | `$x_k$` |
| Display math | `$$ ... $$` |
| Image with caption | `![alt](rig.jpg "Caption")` |
| Wide image | same, then `{.wide}` on the next line |
| Side by side | `{{< row >}} ...images... {{< /row >}}` |
| Video | `{{< video src="demo.mp4" poster="poster.jpg" caption="..." >}}` |
| Looping clip | `{{< video src="clip.mp4" loop=true >}}` |
| YouTube | `{{< youtube VIDEO_ID >}}` |
| Diagram | a ` ```mermaid ` code block |
| Hand-made SVG (follows light/dark) | `{{< svg src="diagram.svg" caption="..." >}}` |
| Interactive 3D surface | `{{< surface src="sweep.json" caption="..." >}}`, JSON with `x`, `y`, `z` (rows follow `y`), `labels`, optional `log`, `marker` and `line` |
| Callout | `> [!NOTE]` on the first line of a quote |
| Collapsed section | `{{% fold title="Hardware" %}} ...markdown... {{% /fold %}}`; add `class="small"` for a compact toggle row |

A literal dollar sign is `\$`.

## Build

```bash
make build        # writes public/, drafts excluded
```

## Troubleshooting

- `hugo: command not found`: `export PATH="$HOME/.local/bin:$PATH"`
- Page not found in preview: stop and rerun `make dev`.
