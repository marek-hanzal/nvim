# Lightweight macOS Zsh / CLI Toolbelt

Working snapshot from the interactive cleanup after removing Oh My Zsh.

Goal: **plain Zsh, minimal magic, one tool per job, no duplicate tools fighting for the same workflow**.

Statuses:

- ✅ **KEEP** – accepted into the toolset / should stay.
- 🧠 **GOOD TO KNOW** – useful, but no reason to install by default yet.
- ❌ **SKIP** – rejected due to overlap, bad UX, too much magic, or no real use case.

---

# 0. Baseline

- Shell: macOS default **Zsh**
- Package manager: **Homebrew**
- Terminal: **Ghostty**
- Editor: **Neovim**
- Git TUI: **Lazygit**
- Oh My Zsh: removed

Remove Oh My Zsh:

```sh
uninstall_oh_my_zsh
```

Default editor:

```zsh
export EDITOR="nvim"
export VISUAL="nvim"
```

For Git explicitly:

```sh
git config --global core.editor nvim
```

---

# ✅ KEEP

## Shell / prompt / completion

| Tool | Purpose | Install |
|---|---|---|
| `starship` | lightweight cross-shell prompt | `brew install starship` |
| `zsh-autosuggestions` | fish-like history suggestions | `brew install zsh-autosuggestions` |
| `zsh-syntax-highlighting` | syntax / valid-command highlighting | `brew install zsh-syntax-highlighting` |
| `zsh-completions` | broader Zsh completion definitions | `brew install zsh-completions` |
| `fzf-tab` | fuzzy UI for Zsh completions | `brew install fzf-tab` |
| `fzf` | the single fuzzy-finder engine in the toolset | `brew install fzf` |
| `zoxide` | smart `cd`, frecency-based navigation | `brew install zoxide` |
| `mise` | runtime/tool versions + project environment | `brew install mise` |

### FZF quick reference

- `Ctrl-R` – fuzzy history search
- `Ctrl-T` – fuzzy-select a path and insert it into the current command
- `Alt-C` – fuzzy `cd`
- `Tab` – `fzf-tab`

### Zoxide

```sh
z arkini
zi
```

### Mise

Use it as the single layer for runtime versions + project environment.

**Do not add direnv unless there is a real use case.**

```toml
# mise.toml

[tools]
node = "24"

[env]
NODE_ENV = "development"
```

---

## Files / navigation / disk

| Tool | Purpose | Install |
|---|---|---|
| `eza` | modern `ls`, tree view | `brew install eza` |
| `bat` | readable `cat` with syntax highlighting | `brew install bat` |
| `fd` | modern `find` | `brew install fd` |
| `ripgrep` / `rg` | fast text search across codebases | `brew install ripgrep` |
| `yazi` | fast TUI file manager | `brew install yazi` |
| `dust` | quickly identify disk hogs | `brew install dust` |
| `dua` | interactively inspect disk usage and clean up | `brew install dua-cli` |
| `duf` | readable `df` / filesystem overview | `brew install duf` |
| `fclones` | find duplicate files | `brew install fclones` |
| `chafa` | render images directly in the terminal | `brew install chafa` |
| `oxipng` | lossless PNG optimization | `brew install oxipng` |

### Yazi integration

Launch Yazi through `y` so the parent shell changes into the directory where Yazi exits.

- `q` – quit + change shell cwd
- `Q` – quit without changing shell cwd
- `z` – fuzzy navigation through `fzf`
- `Z` – zoxide + fzf
- `s` – filename search through `fd`
- `S` – content search through `ripgrep`

### Disk workflow

```text
dust     -> quickly find what eats space
dua      -> interactively inspect / delete
fclones  -> find actual duplicate files
```

---

## Data / text

| Tool | Purpose | Install |
|---|---|---|
| `sd` | cleaner search/replace than `sed` | `brew install sd` |
| `jless` | TUI viewer for JSON/YAML | `brew install jless` |
| `jnv` | interactive `jq` playground | `brew install jnv` |
| `dasel` | query/update JSON/YAML/TOML/XML/etc. with one CLI | `brew install dasel` |
| `glow` | Markdown reader/TUI | `brew install glow` |
| `tokei` | codebase statistics by language | `brew install tokei` |
| `rnr` | safe batch rename, dry-run by default | `brew install rnr` |

### Tokei excludes

```sh
tokei . \
  -e '*.test.ts' \
  -e '*.test.tsx' \
  -e '*.spec.ts' \
  -e '*.spec.tsx'
```

Or use a project `.tokeignore`.

---

## System / processes

| Tool | Purpose | Install |
|---|---|---|
| `bottom` / `btm` | live system/process monitor | `brew install bottom` |
| `proc` | targeted process control / ports / ancestry | `brew install yazeed/proc/proc` |
| `bandwhich` | inspect which processes are using network bandwidth | `brew install bandwhich` |

### `btm` vs `proc`

```text
btm   -> observe the system
proc  -> act on a specific process
```

Useful `proc` examples:

```sh
proc on :3000
proc free :3000
proc kill :3000
proc stop node
proc why :3000
proc in .
```

---

## Databases

| Tool | Purpose | Install |
|---|---|---|
| `rainfrog` | TUI PostgreSQL/MySQL/SQLite client | `brew install rainfrog` |

Prefer it for local/dev databases. Be conservative with write access to production.

---

## Git / diff / repository maintenance

| Tool | Purpose | Install |
|---|---|---|
| `lazygit` | primary Git TUI + simple conflict resolver | `brew install lazygit` |
| `git-delta` / `delta` | pretty classic line-based diff | `brew install git-delta` |
| `difftastic` / `difft` | syntax-aware structural diff | `brew install difftastic` |
| `git-filter-repo` | surgical history rewriting | `brew install git-filter-repo` |
| `git-sizer` | audit pathological repository size/structure | `brew install git-sizer` |
| `git-who` | “git blame for a tree”, ownership by area | `brew install git-who` |

### Lazygit conflict resolver

Select a conflicted file, then press `Enter` to focus the main diff/merge panel.

```text
j / k   next / previous hunk
h / l   previous / next conflict
Space   accept current hunk
b       accept both
z       undo
e       open in editor
Esc     back
```

Verdict: **default resolver for simple merge conflicts**.

For ugly conflicts, use a proper 3-way tool/editor if needed.

### Delta vs Difftastic

```text
delta       -> classic Git diff, presented nicely
difftastic  -> structural view of code changes
```

Lazygit can use multiple pagers and switch between them.

### Git rule of thumb

```text
REBASE = move / replay my commits onto a new base
MERGE  = combine two independent histories / bring another branch into mine
```

During a rebase:

```text
ours   = the target state I am rebasing onto
theirs = the commit currently being replayed
```

Useful conflict-marker setup:

```sh
git config --global merge.conflictStyle zdiff3
```

---

## Other accepted utilities

| Tool | Purpose | Install |
|---|---|---|
| `topgrade` | orchestrate updates across multiple package managers | `brew install topgrade` |
| `numbat` | smart calculator with units/conversions | `brew install numbat` |

---

# 🧠 GOOD TO KNOW

Do not install these automatically. Pull them in only when a concrete use case appears.

| Tool / feature | Why it might matter |
|---|---|
| `hyperfine` | proper benchmarking for shell commands |
| `Atuin` | context-aware shell history backed by SQLite; overlaps with `fzf Ctrl-R` |
| `ouch` | unified compress/decompress/list for archives |
| `hexyl` | pleasant hex viewer |
| `grex` | generate regexes from examples |
| `oha` | HTTP load generator with live TUI |
| `csvlens` | TUI viewer for CSV/TSV |
| `ripgrep-all` / `rga` | `rg` through PDF/DOCX/archives/SQLite/etc. |
| `fq` (`wader/fq`) | structural queries over binary formats, MessagePack, etc. |
| `termscp` | TUI SFTP/SCP/FTP/S3/SMB/WebDAV/K8s file transfer |
| `jsonquill` | structural TUI JSON editor; Neovim already covers this |
| `git-absorb` | generate `fixup!` commits automatically based on changed lines |
| `git rerere` | remember conflict resolutions and reuse them later |
| `mergiraf` | syntax-aware Git merge driver; auto-resolves some conflicts |
| `serpl` | TUI multi-file search/replace with preview |
| `ast-grep` | structural AST search/rewrite; especially interesting through `serpl` |
| `EC` | standalone 3-way merge resolver; possible fallback for hard conflicts |
| `Hunk` / `Lumen` | other TUI diff/review directions, not deeply tested yet |

### `rerere` – maybe later

```sh
git config --global rerere.enabled true
```

Keep `rerere.autoupdate` disabled for now to preserve transparency.

### Serpl + ast-grep

If revisiting this combination:

```sh
brew install ast-grep
cargo install serpl --features ast_grep
```

The interesting part is **AST-aware matching + TUI preview before rewriting**.

---

# ❌ SKIP / NOT NEEDED

| Tool | Why |
|---|---|
| Oh My Zsh | unnecessary framework/bloat; replaced by explicit Zsh setup |
| `direnv` | overlaps with `mise`; do not stack multiple env/PATH managers |
| `tealdeer` / `tldr` | not useful enough for this workflow |
| `procs` | pretty `ps`, but `proc` covers the real process-control workflow better |
| `xh` | HTTP clients are generally unnecessary here |
| `posting` | same; TUI HTTP client has no use case |
| `watchexec` | current workflow does not need it |
| `doggo` | DNS CLI has no use case |
| `trippy` | ping/traceroute TUI has no use case |
| `choose` | column-selection CLI has no use case |
| `television` | nice fuzzy finder, but `fzf` stays the single fuzzy engine |
| `macmon` | overlaps too much with `btm` |
| `lazydocker` | Docker is used too rarely |
| `mprocs` | overkill; npm + argc cover the workflow more portably |
| `ghui` | GitHub PR workflow is not important enough |
| `Git Town` | too high-level / insufficiently transparent |
| `fzf-git.sh` | nice, but Lazygit already owns the Git UX |
| `gitleaks` | no current need |
| `kondo` | overlaps with `dua` + manual inspection |
| `miniserve` | existing transfer options are enough |
| `pastel` | color CLI has no real use case |
| `carapace` | would introduce a second completion engine |
| `zellij` | Ghostty already covers the needed terminal workflow |
| `age` | encryption tool without a use case |
| `shellcheck` | shell scripts are rarely written |
| `typos-cli` | spelling lint is not important |
| `pay-respects` | command autocorrection is unwanted |
| `trash` | explicit `rm` is preferred |
| `tailspin` | logs are not a meaningful workflow |
| `chezmoi` | dotfiles are managed differently already |
| `zsh-autopair` | too intrusive; can corrupt input flow |
| `dplex` | poor fit because manual file handling is undesirable |
| `saki` / `murasaki_rs` | tested; UI not clear enough, poor scrolling over conflicts |
| `diffview-plus.nvim` | tested; merge UX did not click |
| `git-conflict.nvim` | less interesting than Lazygit / a real 3-way resolver |

---

# Shell setup / important notes

## 1. `path` + `fpath` must stay unique

**Critical:**

```zsh
typeset -U path fpath
```

Without this, repeated `exec zsh` calls kept appending the same completion directories into `$fpath`.

That caused the number of completion files to grow on every shell start, forcing `compinit` to invalidate and regenerate `.zcompdump` every time.

Symptom:

```text
Loading dump file skipped, regenerating because:
number of files in dump ... differ from files found in $fpath ...
```

After the fix, profiled `compinit` time dropped from roughly **390 ms to ~34 ms**.

## 2. `compinit`

After configuring `fpath`:

```zsh
autoload -Uz compinit
compinit
```

Diagnostic mode:

```zsh
compinit -w
```

For insecure completion directories:

```sh
compaudit
```

Fix group/world-writable permissions properly. Do not blindly bypass checks with `compinit -u`.

## 3. Profiling Zsh startup

Temporarily add at the top of `.zshrc`:

```zsh
zmodload zsh/zprof
```

and at the bottom:

```zsh
zprof
```

Remove both afterwards.

## 4. Profiling Starship

```sh
starship timings
```

A stale `~/.config/gcloud` was found and removed because Starship was still displaying an old GCloud account even though `gcloud` itself was already gone.

Current notable timings were approximately:

```text
nodejs      ~60 ms
git_status  ~42 ms
directory   ~10 ms
```

That is good enough. Do not optimize further without a real perceived problem.

---

# Current `.zshrc`

> This is the current working configuration.
>
> On another Mac, replace hardcoded `/Users/marekhanzal/...` paths with `$HOME/...`.

```zsh
typeset -U path fpath

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

fpath=(
    /Users/marekhanzal/.docker/completions
    "$HOMEBREW_PREFIX/share/zsh-completions"
    $fpath
)

autoload -Uz compinit
compinit

source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/Users/marekhanzal/.bun/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '
    if [ -d {} ]; then
      eza --tree --level=2 {}
    elif file --brief --mime-type {} | grep -q \"^image/\"; then
      printf \"\033_Ga=d,d=A,q=2\033\\\\\"
      chafa -f kitty -s \"\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}\" {}
    else
      bat --color=always --style=numbers --line-range=:500 {}
    fi
  '
"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --tree --level=2 {}'
"

source <(fzf --zsh)

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fzf_select)"
  local ret=$?

  # Clear Kitty/Ghostty image placements left by chafa preview.
  printf '\033_Ga=d,d=A,q=2\033\\' > /dev/tty

  zle reset-prompt
  return $ret
}

zle -N fzf-file-widget

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd

  command yazi "$@" --cwd-file="$tmp"

  IFS= read -r -d '' cwd < "$tmp"

  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"

  command rm -f -- "$tmp"
}

eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

export EDITOR="nvim"
export VISUAL="nvim"

source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
```

## Portable version of the hardcoded paths

Prefer this on another machine:

```zsh
fpath=(
    "$HOME/.docker/completions"
    "$HOMEBREW_PREFIX/share/zsh-completions"
    $fpath
)

export PATH="$HOME/.bun/bin:$PATH"
```

---

# Bulk bootstrap – accepted Homebrew tools

Not every machine necessarily needs every tool, but this is the current accepted pool:

```sh
brew install \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-completions \
  fzf-tab \
  fzf \
  zoxide \
  mise \
  eza \
  bat \
  fd \
  ripgrep \
  yazi \
  dust \
  dua-cli \
  duf \
  fclones \
  chafa \
  oxipng \
  sd \
  jless \
  jnv \
  dasel \
  glow \
  tokei \
  rnr \
  bottom \
  bandwhich \
  rainfrog \
  lazygit \
  git-delta \
  difftastic \
  git-filter-repo \
  git-sizer \
  git-who \
  topgrade \
  numbat
```

`proc` uses its own tap:

```sh
brew install yazeed/proc/proc
```

---

# Final operating principle

```text
Zsh                 = shell
Starship            = prompt
fzf                  = single fuzzy engine
fzf-tab              = completion UI
zoxide               = smart cd
mise                 = runtimes + project env
Yazi                 = file navigation
eza/bat/fd/rg        = modern CLI primitives
dust/dua/fclones     = disk
btm/proc             = processes
jless/jnv/dasel      = structured data
Lazygit              = Git UI + simple conflicts
delta/difftastic     = diff
nvim                 = editor
```

Rule for the whole setup:

**Do not install another tool just because it looks nice. If it overlaps with something that already works, it must provide substantially better UX or solve a genuinely different problem. Otherwise it does not belong in the toolbelt.**
