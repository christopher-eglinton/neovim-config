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

-- go to function definition
vim.keymap.set("n", "<leader>gd", function()
  -- get the active LSP client
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if not client then
    print("No LSP client")
    return
  end

  -- create params with explicit position_encoding
  local params = vim.lsp.util.make_position_params(nil, client.offset_encoding)

  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      print("Definition not found")
      return
    end

    local def = result[1]
    local uri = def.uri or def.targetUri
    local fname = vim.uri_to_fname(uri)

    -- open new tab only if definition is in another file
    if fname ~= vim.api.nvim_buf_get_name(0) then
      vim.cmd("tabnew " .. fname)
      vim.lsp.util.jump_to_location(def, client.offset_encoding)
    else
      vim.lsp.util.jump_to_location(def, client.offset_encoding)
    end
  end)
end, { desc = "Go to definition in a new tab (smart)" })

-- tab settings
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true }) -- move to next tab
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true }) -- move to last tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true }) -- opens new tab
vim.keymap.set("n", "<leader>te", ":tabedit ", { noremap = true }) -- waits for filename
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true }) -- closes tab
