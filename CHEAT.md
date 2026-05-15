# Neovim Cheat Sheet

Generated from the latest uploaded config. Leader is `<Space>`. Local leader is `,`. Alt / Option is written as `<M-...>`.

## Quick survival kit

| Action | Keys |
|---|---|
| Save file | `<leader>w` |
| Close current window | `<leader>q` |
| Clear search highlight | `<Esc>` |
| Command line popup | `:` |
| Find files | `<leader><leader>` |
| Toggle file explorer | `<leader>e` |
| Focus/reveal file explorer | `<leader>E` |
| Format code | `<leader>cf` |
| Lint code | `<leader>cl` |
| Current line diagnostic | `<leader>cd` |
| Diagnostics to location list | `<leader>cq` |
| Flash jump | `<leader>jj` |
| Neogit | `<leader>gg` |
| Diffview working tree diff | `<leader>gd` |
| Run task | `<leader>rr` |
| Toggle task panel | `<leader>rt` |
| Toggle database UI | `<leader>dd` |

## Modes

| Mode | Enter with | Purpose |
|---|---|---|
| Normal | `Esc` | Movement, commands, text operations. Live here most of the time. |
| Insert | `i`, `a`, `o`, `O` | Typing text. |
| Visual | `v` | Character-wise selection. |
| Visual line | `V` | Line-wise selection. |
| Visual block | `<C-v>` | Block / column selection. |
| Command | `:` | Ex commands like `:w`, `:q`, `:sort`. |
| Operator-pending | after `d`, `c`, `y`, `g~`, etc. | Waits for a motion or text object, like `diw`, `ci"`, `yip`. |

## Core movement

| Action | Keys |
|---|---|
| Left / down / up / right | `h` / `j` / `k` / `l` |
| Next word | `w` |
| End of word | `e` |
| Previous word | `b` |
| End of previous word | `ge` |
| Big-word versions | `W`, `E`, `B`, `gE` |
| Start of line | `0` |
| First non-blank character | `^` |
| End of line | `$` |
| Last non-blank character | `g_` |
| Start of file | `gg` |
| End of file | `G` |
| Go to line 42 | `42G` or `:42` |
| Half-page down / up | `<C-d>` / `<C-u>` |
| Page down / up | `<C-f>` / `<C-b>` |
| Top / middle / bottom of screen | `H` / `M` / `L` |
| Center current line | `zz` |
| Put current line at top / bottom | `zt` / `zb` |
| Jump to matching bracket | `%` |
| Back / forward in jump list | `<C-o>` / `<C-i>` |

## Your Alt / Option word movement

Works in normal, visual, operator-pending, and insert mode.

| Action | Keys |
|---|---|
| Word left | `<M-Left>` or `<M-b>` |
| Word right | `<M-Right>` or `<M-f>` |

## Search in the current buffer

| Action | Keys |
|---|---|
| Search forward | `/text` |
| Search backward | `?text` |
| Next match | `n` |
| Previous match | `N` |
| Search word under cursor forward | `*` |
| Search word under cursor backward | `#` |
| Clear highlight | `<Esc>` |

## Operators: action + range

Vim often works as `operator` + `motion/text object`.

| Operator | Meaning |
|---|---|
| `y` | yank / copy |
| `d` | delete / cut |
| `c` | change: delete and enter insert mode |
| `>` | indent right |
| `<` | indent left |
| `=` | auto-indent |
| `g~` | toggle case |
| `gu` | lowercase |
| `gU` | uppercase |

Examples:

| Action | Keys |
|---|---|
| Copy current line | `yy` |
| Delete current line | `dd` |
| Change current line | `cc` |
| Copy to end of line | `y$` |
| Delete to end of line | `d$` or `D` |
| Change to end of line | `c$` or `C` |
| Delete one character | `x` |
| Replace one character | `r<char>` |
| Paste after cursor | `p` |
| Paste before cursor | `P` |
| Undo | `u` |
| Redo | `<C-r>` |
| Repeat last change | `.` |

## Text objects

`i` means inside. `a` means around, including the wrapper or nearby whitespace.

| Text object | Meaning |
|---|---|
| `iw` / `aw` | inside / around word |
| `iW` / `aW` | inside / around WORD |
| `i"` / `a"` | inside / around double quotes |
| `i'` / `a'` | inside / around single quotes |
| `` i` `` / `` a` `` | inside / around backticks |
| `i(` / `a(` | inside / around parentheses |
| `ib` / `ab` | same as parentheses, block `()` |
| `i[` / `a[` | inside / around square brackets |
| `i{` / `a{` | inside / around curly braces |
| `iB` / `aB` | same as curly braces, block `{}` |
| `ip` / `ap` | paragraph |
| `it` / `at` | tag, usually HTML/TSX |
| `ih` | git hunk, via gitsigns |
| `io` / `ao` | sortable region, via sort.nvim |

### Common text-object examples

| Situation | Action | Keys |
|---|---|---|
| Cursor on `hello` | change word | `ciw` |
| Cursor on `hello` | delete word | `diw` |
| Cursor on `hello` | copy word | `yiw` |
| Cursor on a word in a sentence | delete word plus spacing | `daw` |
| Cursor inside `"hello"` | change quote contents | `ci"` |
| Cursor inside `"hello"` | delete quote contents | `di"` |
| Cursor inside `"hello"` | copy quote contents | `yi"` |
| Cursor inside `"hello"` | delete including quotes | `da"` |
| Cursor inside `(foo)` | change parentheses contents | `cib` or `ci(` |
| Cursor inside `(foo)` | delete parentheses contents | `dib` or `di(` |
| Cursor inside `{ foo }` | change block contents | `ciB` or `ci{` |
| Cursor inside `{ foo }` | delete block contents | `diB` or `di{` |
| Cursor in a paragraph | copy paragraph | `yip` |
| Cursor in a paragraph | delete paragraph | `dip` |
| Cursor on current git hunk | select hunk | `vih` |
| Cursor on current git hunk | copy hunk | `yih` |

## Visual mode

| Action | Keys |
|---|---|
| Character-wise selection | `v` |
| Line-wise selection | `V` |
| Block selection | `<C-v>` |
| Reselect last visual selection | `gv` |
| Swap active end of selection | `o` |
| Copy selection | `y` |
| Delete selection | `d` |
| Change selection | `c` |
| Indent selection | `>` / `<` |

Examples:

| Action | Keys |
|---|---|
| Select current word | `viw` |
| Select inside quotes | `vi"` |
| Select including quotes | `va"` |
| Select paragraph | `vip` |
| Select current git hunk | `vih` |

## Insert mode

| Action | Keys |
|---|---|
| Insert before cursor | `i` |
| Insert after cursor | `a` |
| Insert at start of line | `I` |
| Insert at end of line | `A` |
| New line below | `o` |
| New line above | `O` |
| Leave insert mode | `Esc` |
| Accept completion | `Enter` |
| Word left/right | `<M-Left>` / `<M-Right>` or `<M-b>` / `<M-f>` |

## Windows and buffers

| Action | Keys / command |
|---|---|
| Close current window | `<leader>q` |
| Move between windows | `<C-w>h/j/k/l` |
| Close all other windows | `:only` |
| Quit Neovim | `:qa` |
| Force quit Neovim | `:qa!` |
| Delete buffer | `:bd` |
| Force delete buffer | `:bd!` |

Note: this config currently does not map sequential window jumps like `<leader>aa` / `<leader>ss`. Native window movement is still available through `<C-w>h/j/k/l`.

## Command line

| Action | Keys |
|---|---|
| Open floating command line | `:` |

This is handled by `fine-cmdline.nvim`. Some special command-line behavior may still use native Neovim command-line UI, because software enjoys having exceptions.

## File explorer: Neo-tree

| Action | Keys |
|---|---|
| Toggle explorer | `<leader>e` |
| Focus/reveal explorer | `<leader>E` |
| Help inside Neo-tree | `?` |

Typical Neo-tree actions inside the panel:

| Action | Key |
|---|---|
| Open file / folder | `Enter` |
| Create file/folder | `a` |
| Delete | `d` |
| Rename | `r` |
| Cut / mark for move | `x` |
| Copy to clipboard | `y` |
| Paste | `p` |
| Move | `m` |
| Copy | `c` |

When unsure, press `?` inside Neo-tree. Local plugin help is usually the least wrong source of truth.

## Picker: fzf-lua

| Action | Keys |
|---|---|
| Find files | `<leader><leader>` |
| Find keymaps | `<leader>fk` |
| Recent files | `<leader>fr` |
| Resume picker | `<leader>fR` |
| Symbols in current document | `<leader>fs` |
| Symbols in workspace | `<leader>fS` |
| TODO comments | `<leader>ft` |

Useful commands that currently do not have direct mappings:

| Action | Command |
|---|---|
| Live grep | `:FzfLua live_grep` |
| Buffers | `:FzfLua buffers` |
| Commands | `:FzfLua commands` |
| Help tags | `:FzfLua helptags` |
| Search current buffer | `:FzfLua lgrep_curbuf` |

`fzf-lua` is registered as `vim.ui.select`, so many selection dialogs use it automatically.

## LSP and code actions

These mappings exist only in buffers where an LSP server is attached.

| Action | Keys |
|---|---|
| Go to definition | `gd` |
| Go to declaration | `gD` |
| Go to implementation | `gi` |
| References | `gr` |
| Hover | `K` |
| Signature help | `<leader>cs` |
| Rename symbol | `<leader>cr` |
| Code action | `<leader>ca` |
| Current line diagnostic | `<leader>cd` |
| Diagnostics to location list | `<leader>cq` |

Useful commands:

| Action | Command |
|---|---|
| LSP health/info | `:checkhealth vim.lsp` |
| Restart LSP | `:lsp restart` |
| Stop LSP | `:lsp stop` |
| LSP log | `:LspLog` |

Configured LSP servers:

| Language / area | Server |
|---|---|
| Lua | `lua_ls` |
| TypeScript / JavaScript | `ts_ls` |
| JSON | `jsonls` |
| TOML | `taplo` |
| Tailwind CSS | `tailwindcss` |
| YAML | `yamlls` |
| GitHub Actions | `gh_actions_ls` |

## Formatting and linting

| Action | Keys / command |
|---|---|
| Format code | `<leader>cf` |
| Lint code | `<leader>cl` |
| Conform info | `:ConformInfo` |

Current formatters:

| Filetype | Formatter |
|---|---|
| Lua | `stylua` |
| JS/TS/JSX/TSX | `biome` |
| JSON/JSONC | `biome` |
| CSS | `biome` |

Current linters:

| Filetype | Linter |
|---|---|
| JS/TS/JSX/TSX | `biomejs` |
| JSON/JSONC | `biomejs` |
| CSS | `biomejs` |
| Markdown | `markdownlint-cli2` |

## Git

### Neogit

| Action | Keys |
|---|---|
| Open Neogit | `<leader>gg` |

Inside Neogit, press `?` for local help. Diff integration is configured to use Diffview.

### Diffview

| Action | Keys |
|---|---|
| Working tree diff | `<leader>gd` |
| Staged diff | `<leader>gD` |
| Current file history | `<leader>gh` |
| Repository history | `<leader>gH` |
| Close Diffview | `<leader>gx` |

### Gitsigns

| Action | Keys |
|---|---|
| Next hunk | `<leader>gn` |
| Previous hunk | `<leader>gN` |
| Preview hunk | `<leader>gp` |
| Inline preview hunk | `<leader>gi` |
| Stage hunk | `<leader>gs` |
| Reset hunk | `<leader>gr` |
| Stage whole buffer | `<leader>gS` |
| Reset whole buffer | `<leader>gR` |
| Blame line | `<leader>gb` |
| Hunks to quickfix | `<leader>gq` |
| Hunk text object | `ih` |

Examples:

| Action | Keys |
|---|---|
| Select current hunk | `vih` |
| Copy current hunk | `yih` |
| Delete current hunk | `dih` |

## Trouble: diagnostics and lists

| Action | Keys |
|---|---|
| All diagnostics | `<leader>xx` |
| Current buffer diagnostics | `<leader>xb` |
| Quickfix | `<leader>xq` |
| Location list | `<leader>xl` |
| Symbols | `<leader>xs` |
| LSP references | `<leader>xr` |
| TODO list | `<leader>xt` |

## TODO comments

Configured keywords: `TODO` and `NOTE`.

Use this shape:

```lua
-- TODO: finish this
-- NOTE: useful note
```

| Action | Keys |
|---|---|
| Next TODO/NOTE | `<leader>tn` |
| Previous TODO/NOTE | `<leader>tp` |
| TODO/NOTE through Trouble | `<leader>xt` |
| TODO/NOTE through fzf-lua | `<leader>ft` |

Search uses `rg`, so an unsaved TODO may not appear in pickers until you run `:w`.

## Markdown

| Action | Keys |
|---|---|
| Toggle inline render | `<leader>mp` |
| Markdown preview split | `<leader>mP` |

Markdown linting runs through `markdownlint-cli2`.

## Database UI

| Action | Keys / command |
|---|---|
| Toggle DB UI | `<leader>dd` |
| Find DB buffer | `<leader>df` |
| Open DB UI | `:DBUI` |
| Toggle DB UI | `:DBUIToggle` |
| Add connection | `:DBUIAddConnection` |
| Find DB buffer | `:DBUIFindBuffer` |

Current config stores DB UI data under Neovim data path, not the project directory.

## Task runner: Overseer

| Action | Keys / command |
|---|---|
| Run task | `<leader>rr` |
| Toggle task panel | `<leader>rt` |
| Run task | `:OverseerRun` |
| Toggle panel | `:OverseerToggle right` |

Inside the task panel:

| Action | Key |
|---|---|
| Close panel | `q` |
| Task action | `Enter` |
| Open output | `o` |
| Restart | `r` |
| Stop | `s` |
| Dispose | `d` |

## Search and replace: Grug-Far

| Action | Keys |
|---|---|
| Project search/replace | `<leader>sr` |
| Search/replace in current file | `<leader>sR` |

In visual mode, select text and press `<leader>sr`; Grug-Far uses the selection as the search text.

Difference from LSP rename:

| Tool | Use it for |
|---|---|
| `<leader>cr` | LSP symbol rename: variables, functions, types, references. |
| `<leader>sr` | General text replacement: strings, configs, YAML, Markdown, i18n keys, routes. |

## Sorting: sort.nvim

| Action | Keys |
|---|---|
| Sort visual selection | `<leader>ls` |
| Reverse sort visual selection | `<leader>lS` |
| Sort visual selection and keep unique lines | `<leader>lu` |
| Sort operator | `go` |
| Inner sortable region | `io` |
| Around sortable region | `ao` |
| Next delimiter | `]o` |
| Previous delimiter | `[o` |

Examples:

| Action | Keys |
|---|---|
| Select several lines and sort | `Vjj` then `<leader>ls` |
| Sort current line through operator | `gogo` |
| Sort inner sortable region | `goio` |
| Sort around sortable region | `goao` |

## Moving lines: mini.move

| Action | Keys |
|---|---|
| Move current line up | `<M-Up>` |
| Move current line down | `<M-Down>` |
| Move visual selection up | select text, then `<M-Up>` |
| Move visual selection down | select text, then `<M-Down>` |

If this does not work, your terminal probably does not send Option/Alt as Meta. Configure Option as `Esc+` / Meta.

## Comments: mini.comment

| Action | Keys |
|---|---|
| Toggle comment on current line | `gcc` |
| Toggle comment over motion | `gc{motion}` |
| Toggle comment on visual selection | select, then `gc` |

Examples:

| Action | Keys |
|---|---|
| Comment paragraph | `gcip` |
| Comment selected lines | `Vjj` then `gc` |

## Surround: mini.surround

| Action | Keys |
|---|---|
| Add surround | `gsa` |
| Delete surround | `gsd` |
| Replace surround | `gsr` |
| Find surround to the right | `gsf` |
| Find surround to the left | `gsF` |
| Highlight surround | `gsh` |
| Update `n_lines` | `gsn` |

Examples:

| Action | Keys |
|---|---|
| Wrap current word in double quotes | `gsaiw"` |
| Wrap selection in double quotes | select, then `gsa"` |
| Delete surrounding double quotes | `gsd"` |
| Replace double quotes with single quotes | `gsr"'` |

## Completion: blink.cmp

| Action | Keys |
|---|---|
| Accept selected completion | `Enter` |
| Close completion menu | usually `<C-e>` |
| Move in completion menu | plugin default keymap preset `enter` |

## Notifications

Notifications use `nvim-notify`.

| Action | Command |
|---|---|
| Notification history | `:Notifications` |
| Clear notifications | `:NotificationsClear` |

## Mason

| Action | Command |
|---|---|
| Open Mason UI | `:Mason` |
| Update registry/packages | `:MasonUpdate` |
| Install packages | `:MasonInstall <name>` |
| Health check | `:checkhealth mason` |

## Useful Ex commands

| Action | Command |
|---|---|
| Write file | `:w` |
| Quit window | `:q` |
| Force quit window | `:q!` |
| Write and quit | `:wq` |
| Quit all | `:qa` |
| Force quit all | `:qa!` |
| Edit file | `:e path/to/file` |
| Reload current file from disk | `:e!` |
| Show current file path | `:echo expand('%:p')` |
| Show current filetype | `:set ft?` |
| Show current working directory | `:pwd` |
| Change current working directory | `:cd path` |

## Mental model reminders

- Do not live in insert mode. Move and edit in normal mode, type in insert mode.
- Prefer `operator + text object`: `ciw`, `ci"`, `dib`, `yip`, `gcip`.
- Use LSP rename for symbols. Use Grug-Far for plain text across files.
- Use Diffview to read diffs, Neogit to drive Git, and Gitsigns for small hunk operations in the current file.
- Use fzf-lua for finding, Neo-tree for browsing, Oil-style workflows only if you add or use an editable filesystem buffer later.
