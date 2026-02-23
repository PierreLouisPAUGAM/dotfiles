-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local f = io.open(os.getenv("HOME") .. "/.config/theme", "r")
    if f then
      local flavour = f:read("*l")
      f:close()
      if flavour then
        local target = "catppuccin-" .. flavour
        if vim.g.colors_name ~= target then
          vim.cmd.colorscheme(target)
          local ok, lualine = pcall(require, "lualine")
          if ok then
            lualine.setup({})
          end
        end
      end
    end
  end,
})
