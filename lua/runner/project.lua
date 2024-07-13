local save_path = vim.fn.stdpath("data") .. "/runner"
local util = require("util")

local function saveProject(name)
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

	local project_config_file = io.open(save_path .. "/" .. name .. ".json")
	json = vim.json.encode({})
	if not project_config_file then
		error("Could not save project config")
	else
		project_config_file:write(json)
		project_config_file:close()
	end
end

local M = {

	InitProject = function()
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
		util.AskValue("Project Name", saveProject)
	end,
}
return M
