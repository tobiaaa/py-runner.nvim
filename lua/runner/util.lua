local M = {
	AskValue = function(prompt, callback, default)
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
