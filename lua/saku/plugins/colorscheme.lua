return {
	-- Oxocarbon theme
	{
		"nyoom-engineering/oxocarbon.nvim",
		config = function()
			vim.cmd("colorscheme oxocarbon")
		end,
	},
	-- Tokyo Night theme
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	},
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({ flavour = "mocha" })
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		-- Kanagawa theme
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({})
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
}
