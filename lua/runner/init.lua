local M = {}

local save_path = vim.fn.stdpath('data') .. '/runner'

function M.setup()
    -- Create Data dir
    pcall(vim.fn.mkdir, save_path)
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
        error("Could not save config")
    else
        save_file:write(json)
        save_file:close()
    end
end

local ask_new_config = function()
    vim.ui.input({ prompt = "Enter configuration" , completion = "file"},
        function(input)
            local filename = vim.fn.expand('%:p')
            save_config(filename, input)
        end)
end


local get_config = function(file)
    local save_file = io.open(save_path .. "/configs.json", "r")
    local save_table = {}
    if save_file then
        save_table = vim.json.decode(save_file:read("*a"))
        save_file:close()
    end
    local config = save_table[file]
    if config ~= nil then
        return config
    end
    error("No config found")
end


local get_last = function()
    local save_file = io.open(save_path .. "/last.json", "r")
    if not save_file then
        -- If no saved last config, return current file
        return vim.fn.expand('%:p')
    end
    local save_table = {}
    save_table = vim.json.decode(save_file:read("*a"))
    save_file:close()

    local project = vim.fn.getcwd()
    return save_table[project]
end

local save_last = function(config)
    local save_file = io.open(save_path .. "/last.json", "r")
    local save_table = {}
    if save_file then
        save_table = vim.json.decode(save_file:read("*a"))
        save_file:close()
    end
    local project = vim.fn.getcwd()
    save_table[project] = config

    save_file = io.open(save_path .. '/last.json', "w+")
    local json = vim.json.encode(save_table)
    if not save_file then
        error("Could not save config")
    else
        save_file:write(json)
        save_file:close()
    end
end

local run_config = function(config)
    save_last(config)

    -- Send to terminal
    local term = require("toggleterm")
    term.exec(config)
end

local run_last = function()
    local last_conf = get_last()

    run_config(last_conf)
end

local run_current = function()
    local conf = get_config(vim.fn.expand("%:p"))

    run_config(conf)
end

-- Create User commands
vim.api.nvim_create_user_command('RunLast', run_last, {})
vim.api.nvim_create_user_command('AskConfig', ask_new_config, {})
vim.api.nvim_create_user_command('RunCurrent', run_current, {})

-- Create Keybindings
local map = vim.keymap.set

map('n', '<leader>r', '<cmd>RunLast<CR>', { desc = "Run last configuration" })
map('n', '<leader>R', '<cmd>RunCurrent<CR>', { desc = "Run current buffer" })

return M
