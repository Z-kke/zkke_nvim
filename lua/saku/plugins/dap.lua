return {
	-- Core nvim-dap plugin
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy", -- Load late to ensure other plugins are ready [1]
		dependencies = {
			"rcarriga/nvim-dap-ui", -- Provides a graphical user interface for debugging [1]
			"nvim-neotest/nvim-nio", -- Required by nvim-dap-ui for asynchronous I/O [1]
			"jay-babu/mason-nvim-dap.nvim", -- Simplifies debugger installation via Mason [1]
			"theHamsta/nvim-dap-virtual-text", -- Displays variable values inline [1]

			-- Dependencies for JavaScript/TypeScript/React debugging (added in Step 4)
			{
				"microsoft/vscode-js-debug",
				-- Crucial build command to prepare the debug adapter [2]
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*", -- Specify a compatible version [2]
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					require("dap-vscode-js").setup({
						-- Path to vscode-js-debug installation (adjust if your lazy.nvim path is different) [2]
						debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
						-- Specify which adapters to register. pwa-node for Node.js, pwa-chrome for browser debugging. [2]
						adapters = { "pwa-node", "pwa-chrome" },
						-- Optional: Enable logging for troubleshooting (useful if you encounter connection issues) [2]
						-- log_file_path = vim.fn.stdpath("cache").. "/dap_vscode_js.log",
						-- log_file_level = vim.log.levels.DEBUG,
					})
				end,
			},
			-- Optional: For handling launch.json files that use JSON5 syntax (e.g., with comments) [2]
			{ "Joakker/lua-json5", build = "./install.sh" },
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")
			local dap_virtual_text = require("nvim-dap-virtual-text")

			-- DAP UI setup: Provides a visual interface for debugging [1]
			ui.setup()

			-- DAP Virtual Text setup: Displays variable values directly in the editor [1]
			dap_virtual_text.setup()

			-- Mason DAP setup: Automatically installs debug adapters [1]
			require("mason-nvim-dap").setup({
				automatic_installation = true, -- Automatically install debuggers [1]
				handlers = {
					-- Default handler for debuggers installed via Mason
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
				-- Ensure Python debugger is installed (added in Step 3)
				ensure_installed = { "python" },
			})

			-- Auto-open/close DAP UI based on debug session events [1, 3]
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end

			-- Define breakpoint signs for visual clarity in the gutter [3]
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "", linehl = "", numhl = "" })

			-- Python DAP Configuration (from Step 3)
			dap.adapters.python = {
				type = "executable",
				command = "python3", -- Or the specific path to your python executable
				args = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}", -- Debugs the current file [4, 1, 5]
					pythonPath = function()
						-- Dynamically determine the Python interpreter, prioritizing virtual environments [1, 5]
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python3" -- Fallback to a common system-wide Python
						end
					end,
					cwd = "${workspaceFolder}", -- Sets the working directory to the Neovim workspace folder [6]
					stopOnEntry = false, -- Controls whether the debugger should pause at the program's entry point [7]
				},
				{
					type = "python",
					request = "attach",
					name = "Attach remote (with path mapping)",
					connect = function()
						local host = vim.fn.input("Host [127.0.0.1]: ")
						host = host ~= "" and host or "127.0.0.1"
						local port = tonumber(vim.fn.input("Port : ")) or 5678
						return { host = host, port = port }
					end,
					pathMappings = {
						{
							localRoot = function()
								local cwd = vim.fn.getcwd()
								local local_path = vim.fn.input("Local path mapping [" .. cwd .. "]: ")
								return local_path ~= "" and local_path or cwd
							end,
							remoteRoot = function()
								local remote_path = vim.fn.input("Remote path mapping [. ]: ")
								return remote_path ~= "" and remote_path or "."
							end,
						},
					},
				},
			}

			-- JavaScript/TypeScript/React DAP Configuration (from Step 4)
			local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					-- Launch: Debug single Node.js files [2]
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file (Node.js)",
						program = "${file}", -- Debugs the current file
						cwd = "${workspaceFolder}", -- Sets the working directory to the project root
						sourceMaps = true, -- Crucial for debugging transpiled TypeScript/JSX [2]
						stopOnEntry = false, -- Whether to break at the first line of code [7]
					},
					-- Attach: Connect to already running Node.js processes [2]
					-- Ensure your Node.js process is started with --inspect or --inspect-brk (e.g., `node --inspect your_app.js`) [8, 9]
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to Node.js process",
						processId = require("dap.utils").pick_process, -- Prompts to select a running Node.js process [2]
						cwd = "${workspaceFolder}",
						sourceMaps = true, -- Essential for mapping transpiled code back to source [2]
					},
					-- Launch & Debug Chrome: Debug client-side web applications [2]
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = function()
							-- Prompts the user for the URL of the web application [2]
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:3000", -- Common for Next.js/React dev servers
								}, function(url)
									coroutine.resume(co, url)
								end)
							end)
						end,
						webRoot = "${workspaceFolder}", -- Sets the root for web content
						protocol = "inspector",
						sourceMaps = true, -- Enables source map support for transpiled web code [2]
						userDataDir = false, -- Prevents creating a new user data directory for Chrome [2]
					},
				}
			end
		end,
	},
}
