# nvim

Neovim config built around `lazy.nvim`, small focused plugin specs, and centralized user keymaps.

## Structure

- `init.lua`: entrypoint
- `lua/config/`: base config bootstrapping
- `lua/plugins/`: plugin specs and plugin-local options
- `lua/keymap/`: user-defined keymaps
- `snippets/`: LuaSnip snippets
- `CHEAT.md`: practical usage reference

## Keymap rules

User-defined keymaps live in `lua/keymap/`.

- Do not define new user keymaps in `lua/plugins/`
- Do not add `keys = { ... }` to plugin specs for user-facing mappings
- Do not add ad-hoc `vim.keymap.set(...)` calls outside `lua/keymap/`
- If a keymap belongs to a `<leader>` group, put it into `lua/keymap/<char>-<group>.lua`
- Non-grouped shared mappings live in `lua/keymap/core.lua`

Current grouped modules:

- `b-buffer.lua`
- `c-code.lua`
- `d-database.lua`
- `f-find.lua`
- `g-git.lua`
- `h-http.lua`
- `l-line.lua`
- `m-markdown.lua`
- `t-todo.lua`

## What is allowed outside `lua/keymap/`

Plugin-native internal mappings are fine when they are part of the plugin's own configuration model, for example:

- completion plugin keymap presets
- textobject/operator mappings owned by the plugin
- file explorer window-local mappings
- pair/surround/comment plugin internal mappings

The rule is:

- explicit user keymap definitions belong in `lua/keymap/`
- plugin-internal control schemes may stay in plugin config

## Plugin guidelines

- Keep plugin specs focused on loading, dependencies, and plugin options
- Prefer `opts = { ... }` over large custom `config` blocks unless needed
- Keep formatting, linting, and LSP behavior predictable
- Prefer stable defaults over clever async hacks

## LSP and formatting

- `conform.nvim` is the primary formatter
- LSP formatting is used as fallback where no external formatter is configured
- YAML is formatted via `prettier`
- SQL is formatted via `sql-formatter`
- cleanup/format workflows should stay deterministic and easy to reason about

## Maintenance notes

- Update `CHEAT.md` when user-facing behavior changes
- Keep `which-key` group labels aligned with `lua/keymap/`
- When adding a new leader domain, add both:
  - a new `lua/keymap/<char>-<group>.lua`
  - a matching group entry in `lua/plugins/which-key.lua`

## Buffer pruning

Hidden regular file buffers are pruned automatically in least-recently-used order once their count exceeds `12`.

- Visible buffers are kept
- Modified buffers are kept
- Special buffers such as terminals, prompts, and plugin panels are ignored
- Override the limit with `vim.g.buffer_prune = { max_listed_buffers = 20 }`
- Run `:BufferPrune` to trigger the cleanup manually
