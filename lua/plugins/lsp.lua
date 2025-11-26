return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.HINT]  = "",
          [vim.diagnostic.severity.INFO]  = "",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            vim.diagnostic.open_float(nil, {focus = false, border = "rounded"})
        end,
    })

    vim.o.updatetime = 250

    lspconfig.gopls.setup({
      capabilities = capabilities,
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          gofumpt = true,
          buildFlags = {
            "-tags=integration"
          },
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        vim.diagnostic.reset(nil, 0)
        vim.lsp.buf.format({ async = false })
      end,
    })

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "vim" }, -- prevent "undefined global 'vim'" warning
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    lspconfig.clangd.setup({})

     lspconfig.phpactor.setup({
      cmd = { "phpactor", "language-server" },
      filetypes = { "php" },
      root_dir = function(fname)
        local util = require("lspconfig.util")
        return util.root_pattern("composer.json", ".git")(fname) or vim.fs.dirname(fname)
      end,
      capabilities = capabilities,
      settings = {
        phpactor = {
        },
      },
    })

    lspconfig.pylsp.setup({
      cmd = { vim.fn.stdpath("data") .. "/mason/bin/pylsp" },
      settings = {
        pylsp = {
          plugins = {
            pyflakes = { enabled = true },
            pycodestyle = { enabled = true },
            autopep8 = { enabled = true },
            mccabe = { enabled = false },
            black = { enabled = false },
            yapf = { enabled = false },
            ruff = { enabled = false },
            pylsp_mypy = { enabled = false },
          },
        },
      },
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })

  end,
}

