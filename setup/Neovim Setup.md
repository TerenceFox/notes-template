# Neovim Setup (LazyVim + vault plugins)

How to recreate the editing setup for this vault on a new machine. The base is **LazyVim**; everything below just layers on top of it.

> Editor config only — nothing confidential here. The one work-specific change is the obsidian workspace **path** (Section 3).

## 0. Prerequisites

- **Neovim** (recent — LazyVim needs ≥ 0.9).
- A **Nerd Font** in your terminal. LazyVim's icons *and* the obsidian checkbox glyphs (`󰄱 󰄲 󰳟 󰩺`) need one, or they render as tofu boxes. This is the #1 "why does it look broken" gotcha.
- **git**, a **C compiler**, **ripgrep**, and **fd** (LazyVim / telescope / treesitter want these).
- Gating question on a work laptop: can you even install these? If not, fall back to the Obsidian app or VS Code.

## 1. Install LazyVim

Follow the starter: https://www.lazyvim.org/installation

```bash
# back up any existing config first
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim   # let it bootstrap and install
```

## 2. What LazyVim already provides (don't re-add it)

lazy.nvim (plugin manager), **telescope + plenary**, treesitter, **blink.cmp** (completion), lualine, which-key, and more. So obsidian.nvim's declared deps (plenary, telescope) are already satisfied — you only add the specs below.

## 3. Add the vault plugins

Drop each of these as a file under `~/.config/nvim/lua/plugins/`. LazyVim auto-loads every `.lua` file there.

### `plugins/obsidian.lua`  ← the only work-specific change is the workspace path

```lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cmd = { "ObsidianToday", "ObsidianYesterday", "ObsidianTomorrow", "ObsidianNew", "ObsidianSearch", "ObsidianQuickSwitch", "ObsidianDailies", "ObsidianBacklinks" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow's note" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Browse dailies" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>oi", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
    { "<leader>ox", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox" },
  },
  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/work-notes",   -- CHANGE THIS to wherever you cloned the work vault
      },
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "00 Inbox",
    note_id_func = function(title)
      if title ~= nil and title ~= "" then
        return title
      end
      return tostring(os.time())
    end,
    daily_notes = {
      folder = "02 Areas/Journal",
      date_format = "%Y-%m-%d",
      template = "Daily Template.md",
    },
    templates = {
      folder = "templates",
    },
    disable_frontmatter = true,
    ui = {
      checkboxes = {
        [" "] = { order = 1, char = "󰄱" },
        ["x"] = { order = 2, char = "󰄲" },
        [">"] = { order = 3, char = "󰳟" },
        ["~"] = { order = 4, char = "󰩺" },
      },
    },
  },
}
```

### `plugins/autolist.lua`  ← bullet-journal behavior

```lua
return {
  "gaoDean/autolist.nvim",
  ft = "markdown",
  opts = {},
  keys = {
    { "<CR>", "<CR><cmd>AutolistNewBullet<cr>", mode = "i", ft = "markdown" },
    { "o", "o<cmd>AutolistNewBullet<cr>", ft = "markdown" },
    { "O", "O<cmd>AutolistNewBulletBefore<cr>", ft = "markdown" },
    { "<TAB>", "<cmd>AutolistTab<cr>", mode = "i", ft = "markdown" },
    { "<S-TAB>", "<cmd>AutolistShiftTab<cr>", mode = "i", ft = "markdown" },
    { "<leader>k", "<cmd>AutolistCycleNext<cr>", ft = "markdown", desc = "Cycle list type" },
  },
}
```

### `plugins/blink-autolist.lua`  ← REQUIRED alongside autolist

LazyVim uses **blink.cmp** for completion, which grabs `<Tab>`. This hands Tab/S-Tab to autolist inside markdown lists (so list indent/outdent works), while leaving snippet jumping and completion intact everywhere else. Without this, Tab in a markdown list triggers completion instead of indenting.

```lua
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = {
        "snippet_forward",
        function()
          if vim.bo.filetype == "markdown" then
            vim.cmd("AutolistTab")
            return true
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        function()
          if vim.bo.filetype == "markdown" then
            vim.cmd("AutolistShiftTab")
            return true
          end
        end,
        "fallback",
      },
    },
  },
}
```

### `plugins/wordcount.lua`  ← optional: live word count in the statusline for markdown

```lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, {
      function()
        local wc = vim.fn.wordcount()
        if wc.visual_words then
          return wc.visual_words .. " words selected"
        end
        return wc.words .. " words"
      end,
      cond = function()
        return vim.bo.filetype == "markdown"
      end,
    })
  end,
}
```

## 4. Optional quality-of-life (personal preference)

- `plugins/disable-news-alert.lua` — silence LazyVim/neovim news popups.
- `plugins/snacks-animated-scrolling-off.lua` — turn off scroll animation.
- `plugins/theme.lua` — set a colorscheme (mine is `flexoki-light`; pick anything). LazyVim ships tokyonight by default, so this is optional.

## 5. Do NOT port these (desktop/omarchy-specific)

- `all-themes.lua` + `omarchy-theme-hotreload.lua` — the omarchy live-theme-switching system; useless on a work machine.
- `example.lua` — LazyVim's disabled example file; a no-op.

## 6. Keymaps (from the specs above)

- `<leader>ot` / `oy` / `om` — today / yesterday / tomorrow's daily note
- `<leader>od` — browse dailies · `<leader>on` — new note
- `<leader>os` — search notes · `<leader>oq` — quick switch
- `<leader>ob` — backlinks · `<leader>oi` — insert template · `<leader>ox` — toggle checkbox
- autolist: `<CR>` / `o` / `O` continue bullets · `<Tab>` / `<S-Tab>` indent/outdent · `<leader>k` cycle list type

## 7. Adjust for the work vault

- obsidian workspace `path` → wherever you cloned this template (e.g. `~/work-notes`).
- The `daily_notes` folder (`02 Areas/Journal`), `templates` folder, and checkbox UI already match this vault's layout — no change needed.

## 8. config/ tweaks (port these)

LazyVim keeps user options/keymaps/autocmds in `~/.config/nvim/lua/config/`. Fold these in:

**`config/options.lua`** — comma leader + no relative numbers:

```lua
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.relativenumber = false
```

> Your `<leader>o*` obsidian keymaps assume leader = `,`. Keep LazyVim's default space leader instead and they just become `<space>o*` — either works, but comma matches your muscle memory.

**`config/autocmds.lua`** — auto-save markdown + auto-reload files changed externally. Both are core to how this workflow feels (notes save without `:w`; the buffer refreshes when an AI assistant or another tool edits a note under you):

```lua
-- Auto-save markdown files
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("autosave_markdown", { clear = true }),
  pattern = "*.md",
  callback = function(ev)
    if vim.bo[ev.buf].modified and vim.bo[ev.buf].buftype == "" then
      vim.cmd("silent write")
    end
  end,
})

-- Auto-reload files changed externally (e.g. by an AI assistant editing notes)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload", { clear = true }),
  command = "checktime",
})
```

`config/keymaps.lua` has no custom entries — nothing to port.
