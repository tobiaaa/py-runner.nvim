local util = require("runner.util")
local project = require("runner.project")

local M = {}

function M.SaveConfig(file, config)
	project.project_configs[file] = config
	project.project_files[file] = file
	project.SaveProjectConfigs()
end

function M.AskNewFileConfig(callback)
	local filename = util.RelativePath()
	util.AskValue("Enter Configuration", function(input)
		M.SaveConfig(filename, input)
		if callback ~= nil then
			callback(input)
		end
	end, "python " .. filename)
end

function M.GetConfig(file, callback)
	local config_name = project.project_files[file]
	local config = project.project_configs[config_name]
	if config ~= nil then
		if callback ~= nil then
			callback(config)
		end
		return config
	else
		M.AskNewFileConfig(callback)
	end
end

function M.EditConfig()
    -- Choose which config to edit
    vim.ui.select({project.project_configs},{
        prompt = "Select Configuration to edit"
    }, function (choice)
        print(choice)
    end)
end

return M
