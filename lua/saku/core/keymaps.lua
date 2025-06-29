-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- If you use which-key for group definitions, ensure this is present:
-- require("which-key").register({ b = { name = "Debugger" } }, { prefix = "<leader>" })

keymap.set("n", "<leader>bt", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })
keymap.set("n", "<leader>bc", function()
	require("dap").continue()
end, { desc = "DAP: Continue" })
keymap.set("n", "<leader>bi", function()
	require("dap").step_into()
end, { desc = "DAP: Step Into" })
keymap.set("n", "<leader>bo", function()
	require("dap").step_over()
end, { desc = "DAP: Step Over" })
keymap.set("n", "<leader>bu", function()
	require("dap").step_out()
end, { desc = "DAP: Step Out" })
keymap.set("n", "<leader>br", function()
	require("dap").repl.open()
end, { desc = "DAP: Open REPL" })
keymap.set("n", "<leader>bl", function()
	require("dap").run_last()
end, { desc = "DAP: Run Last" })
keymap.set("n", "<leader>bq", function()
	require("dap").terminate()
	require("dapui").close()
	require("nvim-dap-virtual-text").toggle()
end, { desc = "DAP: Terminate" })
keymap.set("n", "<leader>bb", function()
	require("dap").list_breakpoints()
end, { desc = "DAP: List Breakpoints" })
keymap.set("n", "<leader>be", function()
	require("dap").set_exception_breakpoints({ "all" })
end, { desc = "DAP: Set Exception Breakpoints" })
