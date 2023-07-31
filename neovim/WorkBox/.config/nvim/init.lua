--editor configs  
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.updatetime = 50
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd('colorscheme nightfox')

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

--remaps (stolem from theprimeagen's config)
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q!<CR>")
vim.keymap.set("n", "<leader>b", ":bd<CR>") --closes the current buffer

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", [["_dP]]) --won't lose yer copy
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) --delete to void
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) --findnreplace

--packer
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'EdenEast/nightfox.nvim'
    use { 'echasnovski/mini.tabline', branch = 'stable' }
    use { 'echasnovski/mini.pairs', branch = 'stable' }
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		 requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'nvim-lualine/lualine.nvim'
	use {
	  		'VonHeikemen/lsp-zero.nvim',
	  		branch = 'v2.x',
	  		requires = {
	     		'neovim/nvim-lspconfig',
	    		'williamboman/mason.nvim',
	    		'williamboman/mason-lspconfig.nvim',
	    		'hrsh7th/nvim-cmp',
	    		'hrsh7th/cmp-nvim-lsp',
	    		'L3MON4D3/LuaSnip',
	  		}
	}
	use 'terrortylor/nvim-comment'
    use 'mbbill/undotree'
    use 'folke/trouble.nvim'
    use 'ThePrimeagen/refactoring.nvim'
end)

--treesitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = {"lua", "vim", "go", "javascript", "hcl"},
    sync_install = false,
    auto_install = true,
	highlight = {
		enable = false,
        additional_vim_regex_highlighting = false,
	}
}

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({}) --mason
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'lua_ls'},
  handlers = {lsp.default_setup}
})

local cmp = require('cmp') --nvim cmp
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.setup()

--telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

--undo tree toggle
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

--trouble (shows diagnostics and stuff)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)

--refactoring
require('refactoring').setup({})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

--lualine
require("lualine").setup{
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = "|",
		section_separators = "",
	},
}

--comment
require("nvim_comment").setup({
	operator_mapping = "<leader>/"
})

--tabline
require('mini.tabline').setup()

--autopairs
require('mini.pairs').setup()

--nvimtree
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")