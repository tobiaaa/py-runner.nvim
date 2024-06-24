local M = {}

local save_path = vim.fn.stdpath('data') .. '/runner'

function M.setup()
    -- Create Data dir
    print(save_path)
    if not vim.fn.isdirectory(save_path) then
        vim.fn.mkdir(save_path)
    end
end

local run_config = function()
    print("Running config...")
end

local save_config = function(file, config)
    local save_file = io.open(save_path .. "/configs.json", "r")
    local save_table = {}
    if save_file then
        save_table = vim.json.decode(save_file:read("*a"))
        save_file:close()
    end
    save_table[file] = config

    save_file = io.open(save_path .. '/configs.json', "w+")
    local json = vim.json.encode(save_table)
    if not save_file then
        print("Could not save config")
    else
        save_file:write(json)
        save_file:close()
    end
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


-- Create User commands
vim.api.nvim_create_user_command('RunLast', run_last, {})
vim.api.nvim_create_user_command('AskConfig', ask_new_config, {})

-- Create Keybindings
local map = vim.keymap.set

map('n', '<leader>r', '<cmd>RunLast<CR>', { desc = "Run last configuration" })

return M
