-- telescope
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "find files" })

vim.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").live_grep()
end, { desc = "find word in files" })

vim.keymap.set("n", "<leader>fz", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "find in current buffer" })

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
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "toggle comment" }) -- for normal mode: comment current line

vim.keymap.set("v", "<leader>/", ":<C-u>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
  desc = "toggle comment (visual)"
}) -- for visual mode: comment selection

-- tab settings
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true }) -- move to next tab
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true }) -- move to last tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true }) -- opens new tab
vim.keymap.set("n", "<leader>te", ":tabedit ", { noremap = true }) -- waits for filename
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true }) -- closes tab
