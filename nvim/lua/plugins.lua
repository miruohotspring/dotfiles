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
        'nvimdev/lspsaga.nvim',
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
    -- markdown
    {
        'iamcco/markdown-preview.nvim',
        'mzlogin/vim-markdown-toc',
        build = "cd app && yarn install",
        enabled = true,
        ft = "markdown",
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
            "dense-analysis/ale",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- Resize
    {
        "simeji/winresizer",
    },
    {
        "mattn/vim-sqlfmt",
    },
    {
        "mattn/vim-maketable",
    },
    -- swagger
    {
      "vinnymeller/swagger-preview.nvim",
      config = function()
        require("swagger-preview").setup({
          port = 8003,
          host = "localhost",
        })
      end
    },
})

require('gitsigns').setup()
require('mason').setup();
require('mason-lspconfig').setup_handlers({ function(server)
    local lspconfig = require('lspconfig')
    local opt = {
            capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
            ),
        }
        lspconfig[server].setup(opt)
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
        require('lspconfig').biome.setup({
          cmd = { "biome", "lsp-proxy" },
          on_new_config = function(new_config)
            local pnpm = lspconfig.util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(vim.api.nvim_buf_get_name(0))
            local cmd = { "npx", "biome", "lsp-proxy" }
            if pnpm then
              cmd = { "pnpm", "biome", "lsp-proxy" }
            end
            new_config.cmd = cmd
          end,
          settings = {
            biome = {
              enableTsconfigPaths = true,  -- この行を追加
              tsconfigPath = "tsconfig.json"  -- 必要に応じてパスを設定
            }
          },
          on_attach = function(client, bufnr)
            -- その他の設定やキーバインディングをここに追加
          end,
        })
        require('lspconfig').vacuum.setup({})
    end
})


-- 自動補完
local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  }
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]

-- 構文ハイライト
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "json", "tsx", "c", "lua", "vim", "help", "query", "sql" },
    sync_install = false,
    auto_install = true,
    ignore_install = { "help" },

    highlight = {
        enable = true,
        disable = { "markdown" },
    },
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

-- prettier
vim.g["ale_fixers"] = {
   typescript = {'biome'},
   typescriptreact = {'biome'},
   javascript = {'biome'},
   javascriptreact = {'biome'},
   vue = {'biome'},
}
vim.g["ale_fix_on_save"] = 1
vim.g["ale_javascript_prettier_use_local_config"] = 1

vim.filetype.add {
  pattern = {
    ['.*openapi.*%.ya?ml'] = 'yaml.openapi',
    ['.*openapi.*%.json'] = 'json.openapi',
  },
}
