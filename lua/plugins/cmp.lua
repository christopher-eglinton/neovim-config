return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Helper to check if there's text before the cursor
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        -- Tab to navigate or expand snippet
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Shift-Tab to go backwards in the menu/snippet
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Enter confirms the selected completion item
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        -- Manual completion popup
        ["<C-Space>"] = cmp.mapping.complete(),
      },
      cmp.setup({
  -- ...
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 3, max_item_count = 5 },
    { name = "path" },
  },

  formatting = {
    format = function(entry, vim_item)
      -- prevent duplicate-looking items from different sources
      vim_item.dup = ({
        nvim_lsp = 0,
        luasnip = 1,
        buffer = 1,
        path = 1,
      })[entry.source.name] or 0
      return vim_item
    end,
  },
})
    })
  end,
}

