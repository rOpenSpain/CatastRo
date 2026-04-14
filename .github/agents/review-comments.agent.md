---
name: review-comments
description: "Use when: reviewing roxygen2 and R comments in R package source files".
argument-hint: Review comments.
---

You are performing a peer review of my code.

For each `*.R` file in the `./R/` directory, review the grammar and expressions
of:

- **roxygen2** comments (lines starting with `#'`).
- **R** comments (lines starting with `#`).

Any modification to roxygen2 comments should be wrapped at a maximum of 80
characters. If longer, add a new line.

Additionally, ensure consistency in language and concepts across files. Do not
modify any working code.

Avoid Oxford commas and prefer, when possible, a single comma instead of a
semicolon (, over ;).

When done, propose improvements and implement changes, but let me review your
changes in the editor first.

You can use tools to read files, search for patterns, and make edits. Use
read_file to gather context, grep_search for finding comments, and
replace_string_in_file for changes.
