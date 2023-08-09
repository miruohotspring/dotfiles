-- lazy.nvim
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g['fern#default_hidden'] = true

require('lazy').setup({
    -- colorscheme
    {
        'tomasr/molokai',
        config = function()
            vim.cmd [[
            try
            colorscheme molokai
            catch /^Vim\%((\a\+)\)\=:E185/
            colorscheme default
            set background=dark
            endtry
            ]]
        end,
    },
    -- tree view
    {
        'lambdalisue/fern.vim',
        dependencies = {
            'lambdalisue/nerdfont.vim',
            'lambdalisue/fern-renderer-nerdfont.vim',
        },
        config = function()
            vim.g['fern#renderer'] = 'nerdfont'
        end,
    },
    -- status bar
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup{
                options = {
                    icons_enabled = true,
                    theme = 'solarized_dark',
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = '' },
                    disabled_filetypes = {}
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch' },
                    lualine_c = { {
                        'filename',
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 0 -- 0 = just filename, 1 = relative path, 2 = absolute path
                    } },
                    lualine_x = {
                        { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
                        hint = ' ' } },
                        'encoding',
                        'filetype'
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { {
                        'filename',
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
                    } },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                extensions = { 'fugitive' }
            }
        end,
    },
    -- completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',
        },
    },
    -- LSP Utility
    {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'onsails/lspkind.nvim',
        'glepnir/lspsaga.nvim',
    },
    -- Toggle Terminal
    {
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup()
            local Terminal = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true
            })
            function _lazygit_toggle()
                lazygit:toggle()
            end
        end
    },
    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
    },
    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        config = function ()
        end
    },
    -- lines
    {
        'lukas-reineke/indent-blankline.nvim',
        'lewis6991/gitsigns.nvim',
    },
    -- telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },
    {
        'stevearc/dressing.nvim',
    },
    {
        'aznhe21/actions-preview.nvim',
        config = function ()
            vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions)
        end
    },
    -- Go
    {
        'mattn/vim-goimports',
    },
    {
        "ray-x/go.nvim",
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
})

require('gitsigns').setup()
require('mason').setup();
require('mason-lspconfig').setup_handlers({ function(server)
    local opt = {
        -- -- Function executed when the LSP server startup
        -- on_attach = function(client, bufnr)
            --   local opts = { noremap=true, silent=true }
            --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
            -- end,
            capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
            ),
        }
        require('lspconfig')[server].setup(opt)

        -- additional settings
        require('lspconfig').pyright.setup {
            settings = {
                python = {
                    pythonPath = "python3",
                    useLibraryCodeForTypes = true
                }
            }
        }
        require('lspconfig').terraformls.setup(opt)
    end
})

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "help", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "c", "rust", "markdown" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    }),
    experimental = {
        ghost_text = true,
    },
    formatting = {
        format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
    }
})

require('nvim-treesitter.configs').setup {
    ignore_install = {
        'markdown',
    }
}

vim.cmd [[
set updatetime=500
set completeopt=menuone,noinsert,noselect
highlight! default link CmpItemKind CmpItemMenuDefault
highlight CmpItemAbbr guibg=NONE guifg=#FFFFFF
highlight CmpItemKind guibg=NONE guifg=#FFFFFF
highlight CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
highlight CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight CmpItemKindMethod guibg=NONE guifg=#C586C0
highlight CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
]]
