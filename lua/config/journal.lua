-- journal mode settings

_G.goyo_active = false

vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  callback = function()
    _G.goyo_active = true
    vim.cmd("Limelight")
    require("lualine").refresh()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  callback = function()
    _G.goyo_active = false
    vim.cmd("Limelight!")
    require("lualine").refresh()
  end,
})

