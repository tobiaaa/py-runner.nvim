local util = require("runner.util")
local project = require("runner.project")

local save_path = vim.fn.stdpath("data") .. "/runner"

local M = {}

function M.SaveConfig(file, config)
    project.project[file] = config
    project.SaveProject()
end

function M.AskNewConfig(callback)
	local filename = util.RelativePath()
	util.AskValue("Enter Configuration", function(input)
		M.SaveConfig(filename, input)
		if callback ~= nil then
			callback()
		end
	end, "python " .. filename)
end

function M.GetConfig(file, callback)
	local config = project.project[file]
	if config ~= nil then
		if callback ~= nil then
			callback(config)
		end
		return config
	else
		M.AskNewConfig(callback)
	end
end

function M.EditConfig(filename, closure)
	local current_config = M.GetConfig(project, filename)
	vim.ui.input({ prompt = "Enter configuration", completion = "file", default = current_config }, function(input)
		if filename == nil then
			filename = util.RelativePath()
		end
		M.SaveConfig(filename, input)
		if closure ~= nil then
			closure(input)
		end
	end)
end

return M
