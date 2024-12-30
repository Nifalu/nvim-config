return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { 
        "lua", 
        "python", 
        "java", 
        "rust", 
        "kotlin",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx"
      },
      auto_install = true,
      highlight = { enable = true },
    })
  end
}
