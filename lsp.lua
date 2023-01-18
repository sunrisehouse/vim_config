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
