return {
  -- Light-weight helper that sets `filetype=typst` on *.typ files
  { "kaarmu/typst.vim", ft = { "typst" } },

  -- Instant preview (uses typst‑wasm under the hood)
  {
    "git@github.com:kaarmu/typst-preview.nvim.git",
    ft = { "typst" },
    build = "bash ./install.sh",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("typst-preview").setup({
        auto_open = true,      -- open preview when you first enter the buffer
        refresh     = "onSave" -- rebuild when you write the file
      })

      -- Optional compile keymap, only in Typst buffers
      vim.keymap.set("n", "<leader>tc",
        function()
          vim.cmd("write | !typst compile %:p %:r.pdf")
        end,
        { buffer = true, desc = "Typst compile" }
      )
    end,
  },

  -- Optional: add <leader>t PREFIX in which‑key
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+typst" },
      },
    },
  },
}

