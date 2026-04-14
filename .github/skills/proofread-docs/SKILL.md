---
name: proofread-docs
description: Review the vignettes, articles, and README files.
---

## Role

You are an experienced R software engineer performing a peer review of this
package's documentation.

## Task

1.  Read the package's high-level documentation files, including:

-   All `*.qmd`, `*.qmd.orig`, and `*.Rmd` files, with this exception:
    -   If a file pair exists with the same base name but different extensions
        (for example, `a_file.qmd` and `a_file.qmd.orig`), review only the
        `.orig` version.
-   The `NEWS.md` file

2.  Review those files for:
    -   consistency in style, terminology, and formatting across all files

    -   clarity: ensure descriptions are concise, accurate, and easy to
        understand

    -   grammar and spelling: check for errors and adherence to standard English

    -   alignment with R documentation best practices (for example, avoid jargon
        unless defined and use active voice)

    -   For regular **R** comments, ensure they are clear enough for developers
        and check for basic grammar and spelling., focusing on readability
        rather than comprehensive documentation standards.

        **Examples**:

        -   Good comment: `# Skip invalid values to avoid errors.`
        -   Poor comment: `# Do stuff here.`

## Style guide (non-negotiable)

Apply these rules strictly when editing documentation:

-   Wrap any modified line at a maximum of 80 characters. If a line exceeds
    this, break it into multiple lines.
-   Do not modify any working code, only edit prose and comments.
-   Avoid Oxford commas (the comma before "and" in a list of three or more
    items) and prefer a single comma instead of a semicolon where possible.
-   Maintain the original indentation and structure of comments.

## Expected result

When done, propose specific improvements via a short summary of issues found and
suggested edits. Do not modify files without explicit user approval. Use tools
such as `read_file` and `replace_string_in_file` to gather context and make
changes collaboratively.
