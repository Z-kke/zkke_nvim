return {
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({
				-- optional configuration here
			})
			require("bamboo").load()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
