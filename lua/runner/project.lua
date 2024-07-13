local save_path = vim.fn.stdpath("data") .. "/runner"
local util = require("runner.util")

local M = {}

M.project = {}
M.project_name = ""
M.last_config = nil

function M.SaveProject(name)
	local project_table = {}

	local project_file = io.open(save_path .. "/projects.json", "r")
	if project_file then
		project_table = vim.json.decode(project_file:read("*a"))
		project_file:close()
	end

	-- Save project in project json
	local project_path = vim.fn.getcwd()
	project_table[project_path] = name

	project_file = io.open(save_path .. "/projects.json", "w+")
	local json = vim.json.encode(project_table)
	if not project_file then
		error("Could not save project")
	else
		project_file:write(json)
		project_file:close()
	end

	local project_config_file = io.open(save_path .. "/" .. name .. ".json", "w+")
	json = vim.json.encode(M.project)
	if not project_config_file then
		error("Could not save project config")
	else
		project_config_file:write(json)
		project_config_file:close()
	end
	M.project = {}
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
		M.project = {}
		return
	end
	M.project_name = project_name
	M.project = util.SafeLoadJSON(save_path .. "/" .. project_name .. ".json")

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
	util.AskValue("Project Name", M.SaveProject)
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

return M
