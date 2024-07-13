local M = {}

local util = require("runner.util")
local project = require("runner.project")
local run = require("runner.run")
local config = require("runner.config")

local save_path = vim.fn.stdpath("data") .. "/runner"

function M.setup()
	-- Create Data dir
	pcall(vim.fn.mkdir, save_path)
	--project.LoadProject()
	--if next(project.project) == nil then
	--	print("Project not found, run PyInitProject")
	--end
end

-- Create User commands
-- vim.api.nvim_create_user_command("PyRunLast", run_last, {})
vim.api.nvim_create_user_command("PyAskConfig", config.ask_new_config, {})
vim.api.nvim_create_user_command("PyEditConfig", config.edit_config, {})
-- vim.api.nvim_create_user_command("PyRunCurrent", run_current, {})
-- vim.api.nvim_create_user_command("PyKillCurrent", kill, {})
vim.api.nvim_create_user_command("PyInitProject", project.InitProject, {})

-- Create Keybindings
local map = vim.keymap.set

map("n", "<leader>rr", "<cmd>PyRunLast<CR>", { desc = "Run last configuration" })
map("n", "<leader>R", "<cmd>PyRunCurrent<CR>", { desc = "Run current buffer" })
map("n", "<leader>re", "<cmd>PyEditConfig<CR>", { desc = "Edit configuration of current file" })

return M
