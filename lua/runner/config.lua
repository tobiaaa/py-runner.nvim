local util = require("runner.util")

local save_path = vim.fn.stdpath("data") .. "/runner"

local M = {}

function M.save_config(file, config)
	local save_file = io.open(save_path .. "/configs.json", "r")
	local save_table = {}
	if save_file then
		save_table = vim.json.decode(save_file:read("*a"))
		save_file:close()
	end
	-- Save config in table with file path as key
	save_table[file] = config

	save_file = io.open(save_path .. "/configs.json", "w+")
	local json = vim.json.encode(save_table)
	if not save_file then
		error("Could not save config")
	else
		save_file:write(json)
		save_file:close()
	end
end

function M.ask_new_config(callback)
	util.AskValue("Enter Configuration", function(input)
		local filename = vim.fn.expand("%:p")
		M.save_config(filename, input)
		if callback ~= nil then
			callback()
		end
	end)
end

function M.get_config(project, file, callback)
	local save_file = io.open(save_path .. "/" .. "configs.json", "r")
	local save_table = {}
	if save_file then
		save_table = vim.json.decode(save_file:read("*a"))
		save_file:close()
	end
	local config = save_table[file]
	if config ~= nil then
		if callback ~= nil then
			callback(config)
		end
		return config
	else
		M.ask_new_config(callback)
	end
end

local edit_config = function(project, filename, closure)
	local current_config = M.get_config(project, filename)
	vim.ui.input({ prompt = "Enter configuration", completion = "file", default = current_config }, function(input)
		if filename == nil then
			filename = vim.fn.expand("%:p")
		end
		save_config(filename, input)
		if closure ~= nil then
			closure(input)
		end
	end)
end

return M
