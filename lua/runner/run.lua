local util = require("runner.util")
local config = require("runner.config")

local M = {}

M.RunCurrent = function()
	local current_file = util.RelativePath()

	config.GetConfig(current_file, M.RunConfig)
end

M.RunConfig = function(run_config)
	config.SaveLast(run_config)

	-- Send to terminal
	if config ~= nil then
		local term = require("toggleterm")
		term.exec(config)
	end
end

return M
