local M = {}

local project = require("runner.project")
local config = require("runner.config")
local run = require("runner.run")


local save_path = vim.fn.stdpath("data") .. "/runner"

function M.setup()
	-- Create Data dir
	pcall(vim.fn.mkdir, save_path)
end

-- Create User commands
vim.api.nvim_create_user_command("PyRunLast", run.RunLast, {})
vim.api.nvim_create_user_command("PyNewFileConfig", config.AskNewFileConfig, {})
vim.api.nvim_create_user_command("PyNewConfig", config.NewConfig, {})
vim.api.nvim_create_user_command("PyEditConfig", config.EditConfig, {})
vim.api.nvim_create_user_command("PyRunCurrent", run.RunCurrent, {})
vim.api.nvim_create_user_command("PyRunSelection", run.RunSelection, {})
vim.api.nvim_create_user_command("PyInitProject", project.InitProject, {})

-- Create Keybindings
local map = vim.keymap.set

map("n", "<leader>rr", "<cmd>PyRunLast<CR>", { desc = "Run last configuration" })
map("n", "<leader>R", "<cmd>PyRunCurrent<CR>", { desc = "Run current buffer" })
map("n", "<leader>re", "<cmd>PyEditConfig<CR>", { desc = "Edit configuration of current file" })

return M
