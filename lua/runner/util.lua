local M = {
    AskValue = function(prompt, default, callback)
	vim.ui.input({ prompt = prompt , default=default}, function(input)
		if callback ~= nil then
			callback(input)
		end
	end)
end
}

return M
