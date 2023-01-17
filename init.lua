function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

---------------------------------------
-- vim option
---------------------------------------

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.showtabline = 2
vim.opt.expandtab = true

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

---------------------------------------
-- plugin
-- ------------------------------------

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
    use "williamboman/nvim-lsp-installer"
    use "neovim/nvim-lspconfig"
    use "EdenEast/nightfox.nvim"
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'
    use 'onsails/lspkind.nvim'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
            }
        end
    }
    use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
end)

---------------------------------------
-- plugin setting
-- ------------------------------------
vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        separator_style = 'slant',
        color_icons = true
    },
    highlights = {
        separator = {
            fg = '#073642',
            bg = '#002b36',
        },
        separator_selected = {
            fg = '#073642',
        },
        background = {
            fg = '#657b83',
            bg = '#002b36'
        },
        buffer_selected = {
            fg = '#fdf6e3',
            italic = true
        },
        fill = {
            bg = '#073642'
        }
    },
}
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})

require('lualine').setup()

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
map("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })

------------------

vim.cmd("colorscheme nightfox")

------------------

require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ensure_installed = { 'html', 'eslint', 'cssls', 'sumneko_lua', 'marksman', 'pyright' }
})

--local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.formatting_seq_sync() end
        })
    end
end

local cmp = require 'cmp'
local lspkind = require 'lspkind'
require('cmp').setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
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

local capabilities = require('cmp_nvim_lsp').default_capabilities(
--vim.lsp.protocol.make_client_capabilities()
)

require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require('lspconfig')['html'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require('lspconfig')['cssls'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require('lspconfig')['dockerls'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require('lspconfig')['marksman'].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
local eslint_config = require("lspconfig.server_configurations.eslint")
require('lspconfig')['eslint'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'yarn', 'exec', unpack(eslint_config.default_config.cmd) }
}

vim.cmd [[
    set completeopt=menuone,noinsert,noselect
    highlight! default link CmpItemKind CmpItemMenuDefault
]]
