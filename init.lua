require("core.options")
require("core.keymaps")
require("core.autosave")
require("core.config_reload")

--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("plugins.theme"),
  require("plugins.neotree"),
  require("plugins.bufferline"),
  require("plugins.treesitter"),
  require("plugins.gitsigns"),
  -- require("plugins.precognition"),
  require("plugins.which_key"),
  require("plugins.misc"),
  require("plugins.lualine"),
  require("plugins.telescope"),
  require("plugins.lsp"),
  require("plugins.rust"),
  require("plugins.autoformat"),
  require("plugins.autocompletion"),
  require("plugins.alpha"),
  require("plugins.indent_blankline"),
  require("plugins.mini"),
  require("plugins.minimap"),
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
