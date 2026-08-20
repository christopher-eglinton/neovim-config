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
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify("No LSP client", vim.log.levels.WARN)
    return
  end

  local client = clients[1]

  local params = vim.lsp.util.make_position_params(
    0,
    client.offset_encoding or "utf-16"
  )

  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx)
    if err then
      vim.notify(err.message or "LSP error", vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify("Definition not found", vim.log.levels.INFO)
      return
    end

    local def = vim.islist(result) and result[1] or result

    local uri = def.uri or def.targetUri
    if not uri then
      vim.notify("Definition has no URI", vim.log.levels.ERROR)
      return
    end

    local fname = vim.uri_to_fname(uri)
    local current = vim.api.nvim_buf_get_name(0)

    -- if target file is already open in another tab, switch to it
    if fname ~= current then
      local found = false

      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)

          if bufname == fname then
            vim.api.nvim_set_current_tabpage(tab)
            vim.api.nvim_set_current_win(win)
            found = true
            break
          end
        end

        if found then
          break
        end
      end

      -- file not already open anywhere
      if not found then
        vim.cmd("tabnew")
      end
    end

    local target_client = vim.lsp.get_client_by_id(ctx.client_id)

    local offset_encoding = target_client
        and target_client.offset_encoding
        or client.offset_encoding
        or "utf-16"

    local ok, res = pcall(
      vim.lsp.util.show_document,
      def,
      offset_encoding,
      {
        reuse_win = false,
        focus = true,
      }
    )

    if not ok then
      vim.notify(
        "Could not open definition: " .. tostring(res),
        vim.log.levels.ERROR
      )
    end
  end)
end, { desc = "Go to definition in smart tab" })

-- tab settings
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true }) -- move to next tab
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true }) -- move to last tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true }) -- opens new tab
vim.keymap.set("n", "<leader>te", ":tabedit ", { noremap = true }) -- waits for filename
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true }) -- closes tab

-- git blame current line
vim.keymap.set("n", "<leader>gb", function()
  require("config.git").blame_line()
end, { desc = "Git blame current line" })
