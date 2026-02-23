local function get_flavour()
  local f = io.open(os.getenv("HOME") .. "/.config/theme", "r")
  if f then
    local flavour = f:read("*l")
    f:close()
    return flavour or "macchiato"
  end
  return "macchiato"
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = get_flavour(),
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-" .. get_flavour(),
    },
  },
}
