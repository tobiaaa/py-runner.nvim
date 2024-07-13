local util = require("runner.util")
local config = require("runner.config")
local project = require("runner.project")

local M = {}

M.RunCurrent = function()
	local current_file = util.RelativePath()

	config.GetConfig(current_file, M.RunConfig)
end

M.RunLast = function()
	if project.last_config == nil then
		M.RunCurrent()
	else
		M.RunConfig(project.last_config)
	end
end

M.RunConfig = function(run_config)
	project.SaveLast(run_config)

	-- Send to terminal
	if run_config ~= nil then
		local term = require("toggleterm")
		term.exec(run_config)
	else
		error("Config nil")
	end
end

local run_selected = function(choice)
	if choice == nil then
		return
	end

	local _, selected_config = next(util.split(choice, ":"), 2)

	M.RunConfig(selected_config)
end

M.RunSelection = function()
	local choices = {}
	for key, value in pairs(project.project_configs) do
		table.insert(choices, key .. ": " .. value)
	end

	-- Choose which config to edit
	vim.ui.select(choices, {
		prompt = "Select configuration to run",
	}, run_selected)
end

return M
