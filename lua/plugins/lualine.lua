return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function word_count()
      if not _G.goyo_active then
        return ""
      end
      local wc = vim.fn.wordcount()
      return "Words: " .. wc.words
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename", word_count }, -- ✅ add word_count here
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return "LSP: off"
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return "lsp: " .. table.concat(names, ", ")
            end,
            cond = function()
              return vim.bo.filetype ~= "" and #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
          },
          "encoding", "fileformat", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
