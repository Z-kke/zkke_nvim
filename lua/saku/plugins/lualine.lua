return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			black = "#000000",
			white = "#FFFFFF",
			gray = "#808080",
			dark_gray = "#2E2E2E",
			light_gray = "#D3D3D3",
			fg = "#c3ccdc",
			bg = "#121212",
			inactive_bg = "#1C1C1C",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.white, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.white },
				c = { bg = colors.bg, fg = colors.gray },
			},
			insert = {
				a = { bg = colors.light_gray, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.white },
				c = { bg = colors.bg, fg = colors.gray },
			},
			visual = {
				a = { bg = colors.gray, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.white },
				c = { bg = colors.bg, fg = colors.gray },
			},
			command = {
				a = { bg = colors.dark_gray, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.white },
				c = { bg = colors.bg, fg = colors.gray },
			},
			replace = {
				a = { bg = colors.gray, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.white },
				c = { bg = colors.bg, fg = colors.gray },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.light_gray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.light_gray },
				c = { bg = colors.inactive_bg, fg = colors.light_gray },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#A9A9A9" }, -- adjust to match the monochrome theme
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
