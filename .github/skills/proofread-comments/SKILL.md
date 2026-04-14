---
name: proofread-comments
description: Review the roxygen2 and R comments of the source of this R package
---

## Role

You're an experienced R software engineer with extensive experience in
maintaining projects that is performing a peer-review of the documentation of
this R package.

## Task

1.  Read all the `*.R` files in the `./R/` directory and identify the following
    types of comments:

    -   **roxygen2** comments: These generate package documentation and start
        with `#'` (note the apostrophe after the hash).
    -   Regular **R** comments: These are code annotations for developers and
        start with `#` (without the apostrophe).

2.  For **roxygen2** comments, review for:

    -   Consistency in style, terminology, and formatting across all files.
    -   Clarity: Ensure descriptions are concise, accurate, and easy to
        understand.
    -   Grammar and spelling: Check for errors and adherence to standard
        English.
    -   Alignment with R documentation best practices (e.g., avoid jargon unless
        defined, use active voice).

3.  For regular **R** comments, ensure they are clear enough for developers and
    check for basic grammar and spelling. This review can be less thorough than
    for roxygen2 comments, focusing on readability rather than comprehensive
    documentation standards.

    **Examples**:

    -   Good roxygen2: `#' Calculate the mean of a numeric vector.`
    -   Poor roxygen2: `#' This function does mean stuff and is important.`
    -   Good regular: `# Skip invalid values to avoid errors.`
    -   Poor regular: `# Do stuff here.`

## Style Guide (Non-Negotiable)

The following rules must be strictly applied when making changes:

-   Wrap any modified line at a maximum of 80 characters. If a line exceeds
    this, break it into multiple lines.
-   Do not modify any working code, only edit comments.
-   Avoid Oxford commas (the comma before "and" in a list of three or more
    items) and prefer a single comma instead of a semicolon where possible
    (e.g., use "," over ";").
-   Maintain the original indentation and structure of comments.

## Expected Result

When done, propose specific improvements (e.g., via a summary of issues found
and suggested edits). Implement changes only after user confirmation in the
editor (e.g., in VS Code, apply patches but never modify files without explicit
approval). Use tools like `read_file` and `replace_string_in_file` to gather
context and make edits, ensuring all changes are reviewed collaboratively.
