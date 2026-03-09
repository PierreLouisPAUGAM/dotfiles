return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/gitsigns.nvim",
  },
  init = function()
    vim.g.neominimap = {
      auto_enable = true,
      layout = "split",
      split = {
        minimap_width = 12,
        fix_width = true,
        direction = "right",
        close_if_last_window = true,
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
    { "<leader>um", "<cmd>Neominimap Toggle<cr>", desc = "Toggle minimap" },
  },
}
