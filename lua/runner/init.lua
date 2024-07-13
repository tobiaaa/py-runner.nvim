local M = {}

local util = require("runner.util")
local project = require("runner.project")
local run = require("runner.run")
local config = require("runner.config")

local save_path = vim.fn.stdpath("data") .. "/runner"

function M.setup()
	-- Create Data dir
	pcall(vim.fn.mkdir, save_path)
	project.LoadProject()
	if next(project.project) == nil then
		print("Project not found, run PyInitProject")
	end
end

local get_last = function(closure)
	local save_file = io.open(save_path .. "/last.json", "r")
	if not save_file then
		-- If no saved last config, return current file
		local config = get_config(vim.fn.expand("%:p"), closure)
		return config
	end
	local save_table = {}
	save_table = vim.json.decode(save_file:read("*a"))
	save_file:close()

	local project = vim.fn.getcwd()
	local config = save_table[project]

	if closure ~= nil then
		closure(config)
	end
	return config
end

local save_last = function(config)
	local save_file = io.open(save_path .. "/last.json", "r")
	local save_table = {}
	if save_file then
		save_table = vim.json.decode(save_file:read("*a"))
		save_file:close()
	end
	local project = vim.fn.getcwd()
	save_table[project] = config

	save_file = io.open(save_path .. "/last.json", "w+")
	local json = vim.json.encode(save_table)
	if not save_file then
		error("Could not save last config")
	else
		save_file:write(json)
		save_file:close()
	end
end

local run_config = function(config)
	save_last(config)

	-- Send to terminal
	if config ~= nil then
		local term = require("toggleterm")
		term.exec(config)
	end
end

local run_last = function()
	get_last(run_config)
end

local run_current = function()
	config.get_config(vim.fn.expand("%:p"), run_config)
end

local kill = function()
	local term = require("toggleterm")
	term.exec("<C-c>")
end

-- Create User commands
vim.api.nvim_create_user_command("PyRunLast", run_last, {})
vim.api.nvim_create_user_command("PyAskConfig", config.ask_new_config, {})
vim.api.nvim_create_user_command("PyEditConfig", config.edit_config, {})
vim.api.nvim_create_user_command("PyRunCurrent", run_current, {})
vim.api.nvim_create_user_command("PyKillCurrent", kill, {})
vim.api.nvim_create_user_command("PyInitProject", project.InitProject, {})

-- Create Keybindings
local map = vim.keymap.set

map("n", "<leader>rr", "<cmd>PyRunLast<CR>", { desc = "Run last configuration" })
map("n", "<leader>R", "<cmd>PyRunCurrent<CR>", { desc = "Run current buffer" })
map("n", "<leader>re", "<cmd>PyEditConfig<CR>", { desc = "Edit configuration of current file" })

return M
