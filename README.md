# [Unike267](https://github.com/Unike267) 2938 | (CI) o(f) the issu(e) trigge(r)ed by the (is)sue - CIFERIS

- **University**: UPV/EHU.
- **Doctoral Programme**: Engineering Physics.
- **Department**: Electronics Technology.
- **Group**: Digital Electronics Design Group, GDED (GIU21/007).
- **PhD Student**: Unai Sainz-Estebanez.

---

## SEE 

https://github.com/ghdl/ghdl/issues/2938

## TODO

- Support for packages/libraries (scan library names) to populate the `--work=$lib` field.
- Simulation support with VHDL-93 standard (many issues involve features from VHDL-2008, which are not the cause of the crash)
- Add support to trigger CI for code blocks in comments, not just the main issue description.
- Adapt all paths to relative paths; consider adding a `PREFIX` variable.
- Support for this type of sh block to correctly extract the `$top` name:

```sh
comp_files="debug_mwe/debug.vhd debug_mwe/debug_tb.vhd"
top_module="debug_tb"
ghdl -c --std=08 -v $comp_files -r $top_module --wave=waveforms/"${top_module%% *}".ghw --ieee-asserts=disable-at-0
```

- Taking Tristan's comment into account:

```
I think finding automatically the top unit is supported by synth and command -c (for jit backends).

BTW, this new backtrace is available only during elaboration.
I think we also need to tune the conditions to display it.
```

- Maybe the `top_scanner` is redundant, since with the `-c` command and a just-in-time backend (such as mcode), the top of the design could be auto-completed.
  - What would be needed is a scanner/searcher to find library names and fill in the `--work=$lib` field.

- Another approach could be **instead of scanning/searching for the top/library from the SH code block, directly running the SH code block.** ❗ ❗ ❗

- Add another script to process the GHDL result. Then:
  - Add new job in CI to run this script and fill a variable, for example `$processing_result`, depending on the script result.
The value of this variable could be:
    - `mwe reproducible`
    - `mwe not reproducible`
    - `pending bug`
  - With the command `gh issue edit --add-label $processing_result`, label the issue.
  - When a change in ghdl code is made, trigger (only) the CI of the issues labeled with `pending bug`, and close them through `gh issue close` if the CI doesn't break.

## Brainstorming:

- Parser:
  - **Choosing the right language is a hard decision**
    - I only know how to speak VHDL, C, and a bit of Bash, so which language should I use?
      - Maybe C?
      - In Unai's words, "You have to use each language for its intended purpose." In this case, something like Python, Go, or TypeScript might be better.
      - However, I am more familiar with CNC programming than with these languages.
      - Actually, C++ might be a good choice. 🤔
      - Currently, the selected language is BASH.
  - **REMEBER:** do not reinvent the wheel! FTR:
    - See [parser-generator](https://github.com/topics/parser-generator), such as:
      - [antlr4](https://github.com/antlr/antlr4)
- CI:
  - ~Instead of using a specific container image, build the container directly in CI.~
  - This is redundant because the last step of the GHDL's CI, when a change is made, is to build a container on `Docker.io`:
    - Specifically, we would be interested in:
      - `docker.io/ghdl/ghdl:6.0.0-dev-mcode-ubuntu-24.04`
      - `docker.io/ghdl/ghdl:6.0.0-dev-llvm-ubuntu-24.04`
      - `docker.io/ghdl/ghdl:6.0.0-dev-llvm-jit-ubuntu-24.04`
      - `docker.io/ghdl/ghdl:6.0.0-dev-gcc-ubuntu-24.04`
  - Access to the issue main comment/other comments through the GH CLI. 
    - See job: `fetch_issue`
  - Access to the issue number through:

```yml
    on:
      issues:
        types:
          - opened
          - edited
          - reopened
      workflow_dispatch:
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      NUMBER: ${{ github.event.issue.number }}

...

      - name: Get issue text
        run: |
          gh issue view ${{ github.event.issue.number }} > issue.txt
```

  - Maybe the issue could include a field to specify the GHDL commit to run, inserting this info as an environment variable..

```yml
  run_HDL_code-blocks_with_ghdl_in_specific_commit_version:
    runs-on: ubuntu-latest
    env:
      commit: $commit¿?

    steps:
      - name: '🧰 Checkout'
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: 'Build GHDL from custom commit and run code-blocks'
        run: |
          sed -i '44s|^|\n|' .github/ghdl.containerfile
          sed -i '44s|^| \&\& git checkout '"$commit"' \\|' .github/ghdl.containerfile
          podman build -f  .github/ghdl.containerfile -t ghdl:$commit --target ghdl
          podman run --rm -tv $(pwd):/wrk:Z -w /wrk ghdl:$commit code-blocks-run.sh 
```

## Discarded ideas:

  - Use the `.github/ghdl.containerfile` file to build an image from the latest commit. The build command:
    - `podman build -f  .github/ghdl.containerfile -t ghdl:commit-hash --target ghdl`
  - Then, run the CI with this image, something like:

```yml
  run_HDL_code-blocks_with_ghdl_in_latest_commit_version:
    runs-on: ubuntu-latest

    steps:
      - name: '🧰 Checkout'
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: 'Build GHDL from latest commit and run code-blocks'
        run: |
          git clone https://github.com/ghdl/ghdl
          cd ghdl
          commit=$(git describe --always)
          cd ..
          rm -rf ghdl
          podman build -f  .github/ghdl.containerfile -t ghdl:$commit --target ghdl
          podman run --rm -tv $(pwd):/wrk:Z -w /wrk ghdl:$commit code-blocks-run.sh
```

## References

- GH CLI:
  - [gh_issue_view](https://cli.github.com/manual/gh_issue_view)
- Markdown parsers:
  - [marked](https://github.com/markedjs/marked)
  - [markdown-it](https://github.com/markdown-it/markdown-it) 
  - [markdown-it.github.io](https://markdown-it.github.io/)
- JSON VHDL PARSER:
  - [Paebbels/JSON-for-VHDL](https://github.com/Paebbels/JSON-for-VHDL)
- Source of this idea:
  - [umarcor/issue-runner](https://github.com/umarcor/issue-runner)
