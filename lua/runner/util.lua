local M = {
	AskValue = function(prompt, default, callback)
        local ask_conf = {prompt=prompt}
        if default ~= nil then
            ask_conf[default] = default
        end
		vim.ui.input(ask_conf, function(input)
			if callback ~= nil then
				callback(input)
			end
		end)
	end,
}

return M
