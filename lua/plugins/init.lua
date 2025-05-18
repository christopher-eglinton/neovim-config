local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
	"git", "clone", "--filter=blob:none",
	"https://github.com/folke/lazy.nvim", lazypath
})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}

local plugin_files = {
	"plugins.treesitter",
	"plugins.lualine",
	"plugins.telescope",
	"plugins.lsp",
    "plugins.mason",
}

for _, file in ipairs(plugin_files) do 
	local plugin = require(file)
	table.insert(plugins, plugin)
end

require("lazy").setup(plugins)
