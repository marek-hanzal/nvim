# Neovim Cheat Sheet

Leader is `<Space>`. Local leader is `,`. Alt / Option is written as `<M-...>`.

## Quick survival kit

| Action | Keys |
|---|---|
| Save file | `:w` |
| Quit window | `:q` |
| Clear search highlight | `<Esc>` |
| Find files | `<leader><leader>` |
| Toggle file explorer | `<leader>e` |
| Focus file explorer | `<leader>E` |
| Format buffer | `<leader>bf` |
| Clean up buffer | `<leader>cf` |
| Lint code | `<leader>cl` |
| Current line diagnostic | `<leader>cd` |
| Diagnostics to location list | `<leader>cq` |
| LazyGit | `<leader>gg` |
| Run task | `<leader>rr` |
| Toggle task panel | `<leader>rt` |
| Toggle database UI | `<leader>dd` |

## Navigation

| Action | Keys |
|---|---|
| Left / down / up / right | `h` / `j` / `k` / `l` |
| Next word | `w` |
| Previous word | `b` |
| End of word | `e` |
| Start / end of line | `0` / `$` |
| Start / end of file | `gg` / `G` |
| Half page down / up | `<C-d>` / `<C-u>` |
| Jump back / forward | `<C-o>` / `<C-i>` |
| Match bracket | `%` |
| Center line | `zz` |

## Vim primer

Vim editing is usually `operator + motion` or `operator + text object`.

### Common operators

| Operator | Meaning |
|---|---|
| `y` | Yank / copy |
| `d` | Delete / cut |
| `c` | Change: delete, then enter insert mode |
| `>` | Indent right |
| `<` | Indent left |
| `=` | Reindent |
| `gu` | Lowercase |
| `gU` | Uppercase |
| `g~` | Toggle case |

### Common text objects

| Text object | Meaning |
|---|---|
| `iw` / `aw` | Inside / around word |
| `iW` / `aW` | Inside / around WORD |
| `i"` / `a"` | Inside / around double quotes |
| `i'` / `a'` | Inside / around single quotes |
| ``i` `` / ``a` `` | Inside / around backticks |
| `i(` / `a(` | Inside / around parentheses |
| `ib` / `ab` | Same as parentheses |
| `i[` / `a[` | Inside / around square brackets |
| `i{` / `a{` | Inside / around curly braces |
| `iB` / `aB` | Same as curly braces |
| `ip` / `ap` | Inside / around paragraph |
| `it` / `at` | Inside / around tag |

### Common examples

| Action | Keys |
|---|---|
| Change word | `ciw` |
| Delete word | `diw` |
| Yank word | `yiw` |
| Delete word with surrounding space | `daw` |
| Change inside quotes | `ci"` |
| Delete around quotes | `da"` |
| Change inside parentheses | `ci(` or `cib` |
| Delete inside braces | `di{` or `diB` |
| Yank paragraph | `yip` |
| Delete paragraph | `dip` |
| Reindent selection | select, then `=` |
| Comment paragraph | `gcip` |
| Wrap word in braces | `gsaiw{` |

### Useful built-ins

| Action | Keys |
|---|---|
| Undo | `u` |
| Redo | `<C-r>` |
| Repeat last change | `.` |
| Paste after cursor | `p` |
| Paste before cursor | `P` |
| Join lines | `J` |
| Search next / previous | `n` / `N` |
| Go to line | `42G` or `:42` |
| Clear current command-line or rename prompt input | `<C-u>` |

### Jump and return tricks

| Action | Keys |
|---|---|
| Jump back / forward in jump list | `<C-o>` / `<C-i>` |
| Go to last edit location | `` `. `` |
| Go to exact last insert exit position | `` `^ `` |
| Go to last change start | `` `[ `` |
| Go to last change end | `` `] `` |
| Go back to previous buffer | `<leader>ba` |

Examples:

| Action | Keys |
|---|---|
| Jump to definition, then return | `gd` then `<C-o>` |
| Jump through several files, then move forward again | `<C-o>` / `<C-i>` |
| Return to where the last edit happened | `` `. `` |
| Reopen alternate buffer | `<leader>ba` |
| Toggle between two buffers | `<leader>ba` repeatedly |

### Replace examples

| Action | Keys / command |
|---|---|
| Replace one character under cursor | `r<char>` |
| Replace word under cursor | `ciw` then type replacement |
| Replace inside quotes | `ci"` then type replacement |
| Replace current selection | select, then `c` then type replacement |
| Replace all in current file | `:%s/old/new/g` |
| Replace with confirmation | `:%s/old/new/gc` |
| Replace in visual selection only | select lines, then `:s/old/new/g` |

## Alt word movement

Works in normal, visual, operator-pending, and insert mode.

| Action | Keys |
|---|---|
| Word left | `<M-Left>` or `<M-b>` |
| Word right | `<M-Right>` or `<M-f>` |

## Search

| Action | Keys |
|---|---|
| Buffer fuzzy lines | `/` in normal mode |
| Native search | `<leader>/` |
| Project fuzzy grep | `<leader>fa` |
| Recent files | `<leader>fr` |
| Keymaps | `<leader>fk` |
| Resume picker | `<leader>fR` |
| Buffer symbols | `<leader>fs` |
| Workspace symbols | `<leader>fS` |

## Buffers

| Action | Keys |
|---|---|
| Next buffer | `<leader>bn` |
| Previous buffer | `<leader>bp` |
| Alternate buffer | `<leader>ba` |
| Buffer tree | `<leader>eb` |
| Delete buffer | `<leader>bd` |
| Force delete buffer | `<leader>bD` |
| Delete other buffers | `<leader>bo` |

## LSP and diagnostics

These mappings exist only in buffers with an attached LSP client.

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
| All diagnostics | `<leader>xx` |
| Buffer diagnostics | `<leader>xb` |
| Quickfix list | `<leader>xq` |
| Location list | `<leader>xl` |
| Symbols | `<leader>xs` |
| LSP references panel | `<leader>xr` |

## Formatting and linting

Conform is the primary formatter. LSP is used as a fallback when no external formatter is configured for the current filetype.

| Action | Keys / command |
|---|---|
| Format current buffer / selection | `<leader>bf` |
| Clean up current buffer | `<leader>cf` |
| Lint current buffer | `<leader>cl` |
| Conform info | `:ConformInfo` |

### Formatters

| Filetype | Formatter |
|---|---|
| Lua | `stylua` |
| JavaScript / TypeScript / JSX / TSX | `biome` |
| JSON / JSONC | `biome` |
| CSS | `biome` |
| Other filetypes with LSP formatting support | LSP fallback |

### Linters

| Filetype | Linter |
|---|---|
| JavaScript / TypeScript / JSX / TSX | `biomejs` |
| JSON / JSONC | `biomejs` |
| CSS | `biomejs` |
| Markdown | `markdownlint-cli2` |

## TypeScript

| Action | Keys |
|---|---|
| Remove unused imports + organize imports + format | `<leader>cf` |

`<leader>cf` always tries the configured cleanup code actions first and then formats the buffer. At the moment, the cleanup step targets TypeScript import cleanup actions; on filetypes or servers that do not support them, the cleanup step is skipped and formatting still runs.

## File explorer: Neo-tree

| Action | Keys |
|---|---|
| Toggle explorer | `<leader>e` |
| Focus / reveal explorer | `<leader>E` |
| Help inside Neo-tree | `?` |

### Neo-tree basics

| Action | Key |
|---|---|
| Open file / folder | `Enter` |
| Create | `a` |
| Delete | `d` |
| Rename | `r` |
| Cut | `x` |
| Copy to clipboard | `y` |
| Paste | `p` |
| Move | `m` |
| Copy | `c` |
| Collapse node | `<Left>` |
| Expand / open node | `<Right>` |

## Git

### Snacks LazyGit

| Action | Keys |
|---|---|
| Open LazyGit | `<leader>gg` |
| Git log | `<leader>gl` |
| Current file log | `<leader>gL` |

### Gitsigns

| Action | Keys |
|---|---|
| Next hunk | `<leader>gn` |
| Previous hunk | `<leader>gN` |
| Preview hunk | `<leader>gp` |
| Preview hunk inline | `<leader>gi` |
| Stage hunk | `<leader>gs` |
| Reset hunk | `<leader>gr` |
| Stage buffer | `<leader>gS` |
| Reset buffer | `<leader>gR` |
| Blame line | `<leader>gb` |
| Hunks to quickfix | `<leader>gq` |
| Git hunk text object | `ih` |

Examples:

| Action | Keys |
|---|---|
| Select current hunk | `vih` |
| Yank current hunk | `yih` |
| Delete current hunk | `dih` |

## TODO comments

Use `TODO:` and `NOTE:`.

| Action | Keys |
|---|---|
| Next todo | `<leader>tn` |
| Previous todo | `<leader>tp` |
| Todos in Trouble | `<leader>xt` |
| Todos in fzf-lua | `<leader>ft` |

## Tasks: Overseer

| Action | Keys / command |
|---|---|
| Run task | `<leader>rr` / `:OverseerRun` |
| Toggle task panel | `<leader>rt` / `:OverseerToggle right` |

Inside the task panel:

| Action | Key |
|---|---|
| Close | `q` |
| Task action | `Enter` |
| Open output | `o` |
| Restart | `r` |
| Stop | `s` |
| Dispose | `d` |

## HTTP: Kulala

| Action | Keys |
|---|---|
| Run request | `<leader>hr` |
| Run all requests | `<leader>ha` |
| Toggle response view | `<leader>ht` |
| Inspect request | `<leader>hi` |

## Database

| Action | Keys / command |
|---|---|
| Toggle DB UI | `<leader>dd` / `:DBUIToggle` |
| Find DB buffer | `<leader>df` / `:DBUIFindBuffer` |
| Open DB UI | `:DBUI` |
| Add connection | `:DBUIAddConnection` |

## Markdown

| Action | Keys |
|---|---|
| Toggle render | `<leader>mp` |
| Preview | `<leader>mP` |

## Sorting

| Action | Keys |
|---|---|
| Sort selection | `<leader>ls` |
| Reverse sort selection | `<leader>lS` |
| Unique sort selection | `<leader>lu` |
| Sort operator | `go` |
| Inner sortable region | `io` |
| Around sortable region | `ao` |
| Next delimiter | `]o` |
| Previous delimiter | `[o` |

Examples:

| Action | Keys |
|---|---|
| Sort selected lines | `Vjj` then `<leader>ls` |
| Reverse sort selected lines | `Vjj` then `<leader>lS` |
| Sort current sortable object | `goio` |

## Comments

| Action | Keys |
|---|---|
| Toggle current line comment | `gcc` |
| Toggle by motion | `gc{motion}` |
| Toggle visual selection | `gc` |

Examples:

| Action | Keys |
|---|---|
| Comment a word | `gciw` |
| Comment a paragraph | `gcip` |
| Comment selected lines | `Vjj` then `gc` |

## Surrounds

`mini.surround` is mapped under `gs*`.

| Action | Keys |
|---|---|
| Add surround | `gsa` |
| Delete surround | `gsd` |
| Find right surround | `gsf` |
| Find left surround | `gsF` |
| Highlight surround | `gsh` |
| Replace surround | `gsr` |
| Update search range | `gsn` |

Examples:

| Action | Keys |
|---|---|
| Wrap word in `{}` | `gsaiw{` |
| Wrap word in `()` | `gsaiw(` |
| Wrap line in `"` | `gsa$"` |
| Delete surrounding `"` | `gsd"` |
| Replace `"` with `'` | `gsr"'` |
| Replace `(` with `{` | `gsr({` |

## Move lines

| Action | Keys |
|---|---|
| Move line up | `<M-Up>` |
| Move line down | `<M-Down>` |
| Move visual selection up | select + `<M-Up>` |
| Move visual selection down | select + `<M-Down>` |

## Snippets

| Action | Keys |
|---|---|
| Expand or jump forward | `<Tab>` |
| Jump backward | `<S-Tab>` |

## Terminal

| Action | Keys |
|---|---|
| Exit terminal mode | `<Esc><Esc>` |
