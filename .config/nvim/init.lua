--  ▘  ▗
--  ▌▛▘▜▘▛▘ Jean Carlos (jctr)
--  ▌▙▖▐▖▌  https://github.com/jeanctr/
-- ▙▌       https://jeanctr.me

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---------- Options ----------
vim.opt.hidden = true
vim.opt.encoding = "utf-8"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.errorbells = false
vim.opt.wildmenu = true
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/dist/*", "*/build/*", "*.o", "*.pyc" })

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "81"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 2
vim.opt.background = "dark"

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.wrap = false
vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.undofile = true

-- ---------- Colorscheme ----------
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
vim.cmd.colorscheme("kanagawa")

-- ---------- Essential keymaps ----------
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save" })
vim.keymap.set("n", "<C-q>", ":wq<CR>", { desc = "Save and quit" })
vim.keymap.set("n", "<C-b>", ":bd<CR>", { desc = "Close buffer" })

-- Resize windows
vim.keymap.set("n", "<M-j>", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<M-k>", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", { desc = "Increase width" })

-- Move lines in visual mode
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move selection up" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move selection down" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- ---------- Plugins ----------
vim.pack.add({
  -- Syntax
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main",                   build = ":TSUpdate" },
  -- Fuzzy finder
  "https://github.com/ibhagwan/fzf-lua",
  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  -- Autocompletion
  { src = "https://github.com/saghen/blink.cmp",                version = vim.version.range("1.*") },
  -- Git, autopairs, comment, surround, file explorer, statusline
  "https://github.com/echasnovski/mini.nvim",
  -- Format on save
  "https://github.com/stevearc/conform.nvim",
})

-- ---------- Syntax (treesitter) ----------
require("nvim-treesitter").setup({})

-- Add/remove languages here as needed
local ensure_installed = { "lua", "python", "javascript", "typescript", "c", "cpp", "go", "bash", "json", "markdown" }
local ts_config = require("nvim-treesitter.config")
local installed = ts_config.get_installed()
local to_install = {}
for _, lang in ipairs(ensure_installed) do
  if not vim.tbl_contains(installed, lang) then
    table.insert(to_install, lang)
  end
end
if #to_install > 0 then
  require("nvim-treesitter").install(to_install)
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if vim.list_contains(ts_config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
      vim.treesitter.start(args.buf)
    end
  end,
})

-- ---------- Fuzzy finder ----------
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>f", function()
  require("fzf-lua").files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>g", function()
  require("fzf-lua").live_grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", function()
  require("fzf-lua").buffers()
end, { desc = "Buffers" })

-- ---------- LSP + autocompletion ----------
require("mason").setup({})

-- Add/remove language servers here as needed
local servers = { "lua_ls", "pyright", "ts_ls", "clangd", "gopls", "bashls" }
require("mason-lspconfig").setup({ ensure_installed = servers })

require("blink.cmp").setup({
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "buffer", "snippets" } },
})

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", require("fzf-lua").lsp_references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>a", vim.diagnostic.setloclist, opts)
  end,
})

vim.lsp.enable(servers)

-- ---------- Autopairs, comment, surround ----------
require("mini.pairs").setup({})
require("mini.comment").setup({})
require("mini.surround").setup({})

-- ---------- Git ----------
require("mini.git").setup({})
require("mini.diff").setup({
  view = { style = "sign", signs = { add = "+", change = "~", delete = "_" } },
})
vim.keymap.set("n", "<leader>gj", function()
  require("mini.diff").goto_hunk("next")
end, { desc = "Next git hunk" })
vim.keymap.set("n", "<leader>gk", function()
  require("mini.diff").goto_hunk("prev")
end, { desc = "Prev git hunk" })
vim.keymap.set("n", "<leader>gs", require("mini.diff").operator, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gb", function()
  require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })

-- ---------- File explorer ----------
require("mini.files").setup({})
vim.keymap.set("n", "<leader>n", function()
  require("mini.files").open()
end, { desc = "Toggle file explorer" })

-- ---------- Statusline ----------
require("mini.statusline").setup({})

-- ---------- Format on save ----------
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    go = { "gofumpt" },
    sh = { "shfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})
