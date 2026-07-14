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
- `f-find.lua`
- `g-git.lua`
- `l-line.lua`
- `m-markdown.lua`
- `q-session.lua`
- `t-tools.lua`

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
- HTML, including embedded `<style>` and `<script>` blocks, is formatted via an HTML-only `prettier` profile
- Biome and the HTML-only Prettier profile share buffer-driven indentation, line width, and line endings
- SQL is formatted via `sql-formatter`
- Visual `<leader>bf` formats only the selected snippet with an explicitly chosen available formatter
- Smarty support uses local npm tools from this config:
  - `vscode-smarty-langserver-extracted` for LSP
  - `js-beautify` for formatting with Smarty templating enabled
- After cloning this config on a new machine, run `npm install` in this directory
- cleanup/format workflows should stay deterministic and easy to reason about

## Maintenance notes

- Update `CHEAT.md` when user-facing behavior changes
- Keep `which-key` group labels aligned with `lua/keymap/`
- Treat the Mason tool list as portable configuration; do not remove language support based only on one machine's installed or active tools
- When adding a new leader domain, add both:
  - a new `lua/keymap/<char>-<group>.lua`
  - a matching group entry in `lua/plugins/which-key.lua`

## Sessions and buffer pruning

The current-directory session is restored automatically when Neovim starts without file arguments. The most recently visited file remains the focused buffer even when Neovim was closed from a terminal, file explorer, or unnamed buffer. Headless runs never load or save sessions.

Named, listed file buffers are pruned automatically in deterministic least-recently-used order once their count exceeds `12`.

- Visible buffers are kept
- Modified buffers are kept
- Unnamed and special buffers such as terminals, prompts, and plugin panels do not count toward the limit
- The limit may be exceeded temporarily when every cleanup candidate is visible or modified
- Override the limit with `vim.g.buffer_prune = { max_file_buffers = 20 }`
- Run `:BufferPrune` to trigger the cleanup manually

Jump-list navigation uses the native `<C-o>` and `<C-i>` mappings and restores the saved window view where possible.
