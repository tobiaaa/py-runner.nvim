local M = {}

function M.setup()

end

local run_config = function()
    print("Running config...")
end

local save_config = function(file, config)
    local json = vim.json.encode({ file = config })
    print(json)
end

local run_last = function()
    print("Running Last")
end

local ask_new_config = function()
    vim.ui.input({ prompt = "Enter configuration" },
        function(input)
            local filename = vim.fn.expand('%:h')
            save_config(filename, input)
        end)
end

return M

-- Create User commands
vim.api.nvim_create_user_command('RunLast', run_last, {})
vim.api.nvim_create_user_command('AskConfig', ask_new_config, {})

-- Create Keybindings
local map = vim.keymap.set

map('n', '<leader>r', '<cmd>RunLast<CR>', { desc = "Run last configuration" })
