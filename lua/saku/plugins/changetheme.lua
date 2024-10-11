local themes = {
	"kanagawa-dragon",
	"oxocarbon",
	"tokyonight",
	"catppuccin",
}

local current_theme = 1

-- Function to load a theme
local function load_theme(theme)
	vim.cmd("colorscheme " .. theme)
	-- Save the current theme to a file
	local file = io.open(vim.fn.stdpath("cache") .. "/theme.txt", "w")
	if file then
		file:write(theme)
		file:close()
	end
end

-- Function to switch themes
function SwitchTheme()
	current_theme = current_theme + 1
	if current_theme > #themes then
		current_theme = 1
	end
	load_theme(themes[current_theme])
end

-- Load last theme from file or default to Kanagawa
local function load_last_theme()
	local file = io.open(vim.fn.stdpath("cache") .. "/theme.txt", "r")
	local theme = file and file:read("*all") or themes[1] -- Default to Kanagawa
	if file then
		file:close()
	end

	-- Find index of the saved theme in the themes list
	for i, t in ipairs(themes) do
		if t == theme then
			current_theme = i
			break
		end
	end

	load_theme(theme)
end

-- Load the last theme when Neovim starts
load_last_theme()

-- Keymap to switch themes
vim.api.nvim_set_keymap("n", "<leader>tt", ":lua SwitchTheme()<CR>", { noremap = true, silent = true })
