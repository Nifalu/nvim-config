return {
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "lua_ls",      -- Lua
          "pyright",     -- Python
          "jdtls",       -- Java
          "rust_analyzer", -- Rust
          "kotlin_language_server", -- Kotlin
          "html",        -- HTML
          "cssls",       -- CSS
          "tsserver",    -- JavaScript/TypeScript
          "emmet_ls",    -- Emmet support for HTML/CSS
          "typst_lsp"    -- Typst
        }
      })

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Existing languages
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.jdtls.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      lspconfig.kotlin_language_server.setup({ capabilities = capabilities })
      lspconfig.typst_lsp.setup({
        capabilities = capabilities,
        settings = {
          exportPdf = "onSave",
        }
      })
      -- Web development
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { "html", "css", "javascriptreact", "typescriptreact" }
      })
    end
  }
}
