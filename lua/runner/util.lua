local M = {}

M.AskValue = function(prompt, callback, default)
	local ask_conf = { prompt = prompt }
	if default ~= nil then
		ask_conf[default] = default
        print("Adding Default")
	end
	vim.ui.input(ask_conf, function(input)
		if callback ~= nil then
			callback(input)
		end
	end)
end

M.SafeLoadJSON = function(path)
	local file = io.open(path, "r")
	if file then
		local success, out = pcall(vim.json.decode, file:read("*a"))
		if success then
			return out
		else
			return {}
		end
	end
	return {}
end

M.RelativePath = function()
	return vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
end

M.split = function(input, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

return M
