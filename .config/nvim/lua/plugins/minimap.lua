return {
  "Isrothy/neominimap.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/gitsigns.nvim",
  },
  init = function()
    vim.g.neominimap = {
      auto_enable = true,
      layout = "float",
      float = {
        minimap_width = 12,
        window_border = "none",
      },
      treesitter = { enabled = true },
      git = { enabled = true },
      diagnostic = { enabled = true },
      search = { enabled = true },
      mark = { enabled = true },
      fold = { enabled = true },
    }
  end,
  keys = {
    { "<leader>um", "<cmd>Neominimap toggle<cr>", desc = "Toggle minimap" },
  },
}
