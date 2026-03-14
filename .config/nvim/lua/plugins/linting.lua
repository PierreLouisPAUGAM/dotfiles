return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          condition = function(ctx)
            return not ctx.filename:find("_bmad", 1, true)
          end,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          root_dir = function(bufnr, cb)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname:find("_bmad", 1, true) then
              return
            end
            local root = vim.fs.dirname(vim.fs.find({ ".marksman.toml", ".git" }, {
              path = fname,
              upward = true,
            })[1])
            cb(root)
          end,
        },
      },
    },
  },
}
