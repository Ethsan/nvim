return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {}
	},
	{
		"neovim/nvim-lspconfig",
		cmd = "Mason",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function() require("config.lsp") end,
	},
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			{ "onsails/lspkind-nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ 'hrsh7th/cmp-cmdline'},
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function() require("config.cmp") end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function() require("config.treesitter") end,
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
			{ "<leader>U", "<cmd>UndotreeFocus<CR>", desc = "Focus Undotree" }
		},
	},
}
