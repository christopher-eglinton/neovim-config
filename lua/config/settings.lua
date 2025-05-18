-- leader!:
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- line number options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

-- search stuff
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- this activates line numbers after entering a file since we want them disabled
-- on the buffalo startscreen :)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
})

