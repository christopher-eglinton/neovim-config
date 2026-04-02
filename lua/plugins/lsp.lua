return {
  "neovim/nvim-lspconfig",
  config = function()
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

    vim.o.updatetime = 250

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        vim.diagnostic.reset(nil, 0)
        vim.lsp.buf.format({ async = false })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })

    vim.lsp.config("gopls", {
      capabilities = capabilities,
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          gofumpt = true,
          buildFlags = {
            "-tags=integration",
          },
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    })
    vim.lsp.enable("gopls")

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("clangd", {
      capabilities = capabilities,
    })
    vim.lsp.enable("clangd")

    vim.lsp.config("phpactor", {
      cmd = { "phpactor", "language-server" },
      filetypes = { "php" },
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root =
          vim.fs.dirname(vim.fs.find({ "composer.json", ".git" }, { upward = true, path = fname })[1])
          or vim.fs.dirname(fname)

        on_dir(root)
      end,
      capabilities = capabilities,
      settings = {
        phpactor = {},
      },
    })
    vim.lsp.enable("phpactor")

    vim.lsp.config("pylsp", {
      cmd = { vim.fn.stdpath("data") .. "/mason/bin/pylsp" },
      capabilities = capabilities,
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
    vim.lsp.enable("pylsp")
  end,
}
