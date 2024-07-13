local save_path = vim.fn.stdpath("data") .. "/runner"
local util = require("runner.util")

local M = {}

M.project_files = {}
M.project_configs = {}
M.project_name = ""
M.last_config = nil

function M.SaveNewProject(name)
	local project_table = {}
	-- Load existing projects
	local project_file = io.open(save_path .. "/projects.json", "r")
	if project_file then
		project_table = vim.json.decode(project_file:read("*a"))
		project_file:close()
	end

	-- Add new to existing
	local project_path = vim.fn.getcwd()
	project_table[project_path] = name

	-- Save project in project json
	project_file = io.open(save_path .. "/projects.json", "w+")
	local json = vim.json.encode(project_table)
	if not project_file then
		error("Could not save project")
	else
		project_file:write(json)
		project_file:close()
	end

	local project_config_file = io.open(save_path .. "/" .. name .. ".json", "w+")
	json = vim.json.encode({ files = M.project_files, configs = M.project_configs })
	if not project_config_file then
		error("Could not save project config")
	else
		project_config_file:write(json)
		project_config_file:close()
	end
	M.project_name = name
end

function M.SaveProjectConfigs()
	local project_config_file = io.open(save_path .. "/" .. M.project_name .. ".json", "w+")
	local json = vim.json.encode({ files = M.project_files, configs = M.project_configs })
	if not project_config_file then
		error("Could not save project config")
	else
		project_config_file:write(json)
		project_config_file:close()
	end
end

function M.LoadProject()
	local project_path = vim.fn.getcwd()
	local project_table = {}
	local project_file = io.open(save_path .. "/projects.json", "r")
	if project_file then
		project_table = vim.json.decode(project_file:read("*a"))
		project_file:close()
	end

	local project_name = project_table[project_path]
	if project_name == nil then
		print("Project not found, run PyInitProject")
		M.project_configs = {}
		return
	end
	M.project_name = project_name
	local project_save = util.SafeLoadJSON(save_path .. "/" .. project_name .. ".json")

    if next(project_save) ~= nil then
        M.project_configs = project_save["configs"]
        M.project_files = project_save["files"]
    end

	local last_table = util.SafeLoadJSON(save_path .. "/last.json")
	if next(last_table) ~= nil then
		local last_config = last_table[project_name]
		if last_config ~= nil then
			M.last_config = last_config
		end
	end
end

function M.InitProject()
	-- Check if project at path exists
	local project_table = {}

	local project_file = io.open(save_path .. "/projects.json", "r")
	if project_file then
		project_table = vim.json.decode(project_file:read("*a"))
		project_file:close()
	end

	local project_path = vim.fn.getcwd()
	if project_table[project_path] ~= nil then
		return project_table[project_path]
	end

	-- Ask name
	util.AskValue("Project Name", M.SaveNewProject)
end

function M.SaveLast(config)
	M.last_config = config

	local last_save_table = util.SafeLoadJSON(save_path .. "/last.json")

	last_save_table[M.project_name] = config

	local last_save_file = io.open(save_path .. "/last.json", "w+")
	local json = vim.json.encode(last_save_table)
	if not last_save_file then
		error("Could not save last config")
	else
		last_save_file:write(json)
		last_save_file:close()
	end
end

M.LoadProject()

return M
