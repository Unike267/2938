---
name: Bug report with CI
about: This issue operates with the CIFERIS-(CI) o(f) the issu(e) trigge(r)ed by the (is)sue feature integrated
---

**Description**
A clear and concise description of what the issue is about.

**Expected behaviour**
What you expected to happen, and what is happening instead.

**How to reproduce?**
Tell us how to reproduce this issue. Please provide a Minimal Working Example (MWE). With sample code it's easier to reproduce the bug and it's much faster to fix it. For example:

```vhd
PASTE YOUR VHDL CODE-BLOCK HERE: feel free to use as many as you want
```

```sh
PASTE YOUR BASH CODE HERE: USE ONLY ONE CODE-BLOCK
Please, use any of these ghdl options -a|-e|--elab-run|-i|-m|-r options, but only these
```

> NOTE: Respect (DO NOT REMOVE) the type name (vhd|sh) of code-blocks (after the quotation marks)

> NOTE: only VHD and SH code-blocks are supported

> NOTE: Do not use triple quotation marks unless inserting one of the two supported types of code blocks

> NOTE: The CI for your issue will be performed using GHDL at the latest commit, with all backends, on GNU/Linux Ubuntu 24.04

> NOTE: Large files can be uploaded one-by-one or in a tarball/zipfile.

**Context**
Please, provide the following information:

- OS:
- Origin:
  - [ ] Package manager: `version`
  - [ ] Released binaries: `tarball_url`
  - [ ] Built from sources: `commit SHA`

If a `GHDL Bug occurred` block is shown in the log, please paste it here:

```
******************** GHDL Bug occurred ***************************
Please report this bug on https://github.com/ghdl/ghdl/issues
...
******************************************************************
```

**Additional context**
Add any other context about the problem here. If applicable, add screenshots to help explain your problem.
