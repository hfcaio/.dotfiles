vim.opt.exrc = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "100"
vim.opt.textwidth = 100

-- Leader key
vim.g.mapleader = " "

-- Move lines up and down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- setting color theme
--vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Keymaps
vim.keymap.set('n', '<Tab>', '>>', { desc = 'Indent line' })
vim.keymap.set('n', '<S-Tab>', '<<', { desc = 'Dedent line' })
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Dedent selection' })
vim.keymap.set('i', '<S-Tab>', '<C-d>', { desc = 'Dedent in insert mode' })

vim.keymap.set('n', '<leader>t', function()
	-- Abre um split horizontal embaixo
	vim.cmd('botright 5split')
	-- Abre o terminal
	vim.cmd('terminal')
	-- Entra em insert mode automaticamente
	vim.cmd('startinsert')
end, { desc = 'Open terminal' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>nr', function()
	vim.cmd('botright 15split')
	vim.cmd('terminal sudo nixos-rebuild switch --flake /home/caio/git_projects/.dotfiles#nixOS')
	vim.cmd('startinsert')
end, { desc = 'NixOS rebuild switch' })


-- Autoformat with Ctrl + t
vim.keymap.set({ 'n', 'i' }, "<C-t>", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format code" })

vim.keymap.set("n", "K", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics > 0 then
		vim.diagnostic.open_float()
	else
		vim.lsp.buf.hover()
	end
end, { desc = "Hover or show diagnostics" })

-- yazi (file manager)
local yazi = require("yazi")

vim.keymap.set('n', '<leader>y', function()
	local bufname = vim.api.nvim_buf_get_name(0)
	local is_directory = vim.fn.isdirectory(bufname) == 1
	yazi.yazi()
end, { desc = 'Open file manager' })

vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		yazi.setup({
			open_for_directories = true,
		})
	end,
})

-- Harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

vim.keymap.set('n', '<leader>a', harpoon_mark.add_file)
vim.keymap.set('n', '<leader>h', harpoon_ui.toggle_quick_menu)

vim.keymap.set('n', '<leader>1', function() harpoon_ui.nav_file(1) end)
vim.keymap.set('n', '<leader>2', function() harpoon_ui.nav_file(2) end)
vim.keymap.set('n', '<leader>3', function() harpoon_ui.nav_file(3) end)
vim.keymap.set('n', '<leader>4', function() harpoon_ui.nav_file(4) end)

-- Telescope
local builtin = require('telescope.builtin')

require('telescope').setup({
defaults = {
-- Argumentos que o live_grep passa ao rg. Os defaults do telescope nao
-- incluem --hidden, entao dotfiles ficavam de fora das procuras.
vimgrep_arguments = {
'rg', '--color=never', '--no-heading', '--with-filename',
'--line-number', '--column', '--smart-case', '--hidden', '--glob', '!.git',
},
},
extensions = {
-- Sorter nativo em C: o sorter padrao e Lua e arrasta-se em projetos grandes.
fzf = {
fuzzy = true,
override_generic_sorter = true,
override_file_sorter = true,
case_mode = 'smart_case',
},
},
})
require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })

-- Procura por CONTEUDO, nao por nome de ficheiro: o rg corre a cada tecla.
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep (conteudo)' })

-- Palavra debaixo do cursor, sem ter de a escrever.
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope grep palavra sob o cursor' })

-- O mesmo em modo visual, usando a seleccao. Guarda e repoe o registo v para
-- nao destruir o que o utilizador la tinha.
vim.keymap.set('v', '<leader>fw', function()
local saved = vim.fn.getreg('v')
local saved_type = vim.fn.getregtype('v')
vim.cmd('noautocmd normal! "vy')
builtin.grep_string({ search = vim.fn.getreg('v') })
vim.fn.setreg('v', saved, saved_type)
end, { desc = 'Telescope grep seleccao' })

-- Procura dentro do buffer actual (nao do projecto inteiro).
vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope procurar no buffer' })

-- lualine
require('lualine').setup({
	options = {
		theme = 'auto',
		icons_enabled = true,
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
})

-- LSP and cmp
local blink = require('blink.cmp')

blink.setup({
	keymap = { preset = 'default' },
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = 'mono',
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
})

local capabilities = blink.get_lsp_capabilities()


-- Configurar diagnósticos
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = true,
		header = '',
		prefix = '',
	},
})

-- Keymaps quando LSP anexa
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
		vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
	end,
})

-- C/Cpp LSP
vim.lsp.config('clangd', {
	cmd = { 'clangd' },
	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
	root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
	capabilities = capabilities,

})

-- Arduino LSP
local clangd = vim.fn.exepath("clangd")
local arduino_cli = vim.fn.exepath("arduino-cli")

vim.filetype.add({
	extension = {
		ino = "cpp"
	}
})

vim.lsp.config('arduino-language-server', {
	cmd = {
		'arduino-language-server',
		'-clangd', clangd,
		'-cli', arduino_cli,
		'-cli-config', vim.env.HOME .. '/.arduino15/arduino-cli.yaml',
		'-fqbn', 'arduino:mbed_rp2040:pico',
	},
	filetypes = { 'c', 'cpp', 'ino' },
	capabilities = capabilities,
})

-- Nix LSP
vim.lsp.config('nil_ls', {
	cmd = { 'nil' },
	filetypes = { 'nix' },
	root_markers = { 'flake.nix', '.git' },
	capabilities = capabilities,
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixfmt", "--width=100" },
			},
		}
	}
})
-- Typst LSP
vim.lsp.config('tinymist', {
	cmd = { 'tinymist' },
	filetypes = { 'typst' },
	capabilities = capabilities,
	settings = {
		formatterMode = "typstyle",
		typstyle = {
			columnWidth = 100,
		},
	},
})

-- Python LSP
vim.lsp.config('pyright', {
	cmd = { 'pyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
	capabilities = capabilities,
})

-- Lua LSP
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = {
				globals = { "vim", "it", "describe", "before_each", "after_each" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			format = {
				enable = true,
				defaultConfig = {
					max_line_length = "100",
				},
			},
		}
	}
})

-- QML LSP
vim.lsp.config('qmlls', {
	cmd = { 'qmlls' },
	filetypes = { 'qml' },
	capabilities = capabilities,
})

vim.lsp.enable({ 'clangd', 'nil_ls', 'pyright', 'lua_ls', 'tinymist', 'arduino-language-server',
	'qmlls' })
