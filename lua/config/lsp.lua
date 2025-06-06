-- mason/mason-lspconfig/nvim-lspconfig

local nproc = vim.fn.systemlist("nproc")[1]

local ensure_installed_servers = {
	"clangd",
	"lua_ls",
}

local server_opts = {
	["clangd"] = {
		cmd = {
			"clangd",
			"--header-insertion=never",
			"-j=" .. nproc,
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--rename-file-limit=0",
			"--background-index",
			"--background-index-priority=normal",
			"--clang-tidy",
			"--malloc-trim"
		},
		filetypes = {"c", "cpp", "objc", "objcpp"},
	},

	["lua_ls"] = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						vim.fn.stdpath("data") .. "/lazy/",
						-- "${3rd}/luv/library"
						-- "${3rd}/busted/library",
					},
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				},
			},
		},
	},

	["pylsp"] = {
		cmd = { "pylsp" },
		filetypes = { "python" }
	},

}

local common_capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require('cmp_nvim_lsp').default_capabilities() or {}
)

local server_handlers = {
	function (server_name)
		local opts = vim.tbl_deep_extend("force", {
			capabilities = vim.deepcopy(common_capabilities),
		}, server_opts[server_name] or {})
		require('lspconfig')[server_name].setup(opts)
	end,
}

local mason_opts = {
	ui = {
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require('mason').setup(mason_opts)
require('mason-lspconfig').setup({
	ensure_installed = ensure_installed_servers,
	automatic_installation = true,
	handlers = server_handlers,
})


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>zz')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>zz')
    bufmap('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<CR>zz')
    bufmap('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<CR>zz')
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    bufmap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
    bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  end
})

-- Diagnostics
vim.diagnostic.config({
  float = { source = "always" },
  virtual_text = true,
  underline = false,
  signs = true,
})

vim.keymap.set('n', '<C-E>', function()
	-- If we find a floating window, close it.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= '' then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	vim.diagnostic.open_float(nil, { focus = false })
end, { desc = 'Toggle Diagnostics' })
