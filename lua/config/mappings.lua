-- telescope
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").live_grep()
end, { desc = "Find word in files" })

vim.keymap.set("n", "<leader>fz", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Find in current buffer" })

-- telescope
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").live_grep()
end, { desc = "Find word in files" })

vim.keymap.set("n", "<leader>fz", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Find in current buffer" })

-- netrw, toggleable with <leader>e
vim.keymap.set("n", "<leader>e", function()
  if vim.bo.filetype == "netrw" then
    vim.cmd("bd") -- close netrw buffer
  else
    vim.cmd("Ex") -- open netrw in current window
  end
end, { desc = "toggle netrw" })

-- allow <leader>y to write to system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- commenting with <leader>/ instead of gcc, gb, gc
-- for normal mode: comment current line
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

-- for visual mode: comment selection
vim.keymap.set("v", "<leader>/", ":<C-u>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
  desc = "Toggle comment (visual)"
})

