return {
  {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        minimap_width = 10,
      })
      codewindow.apply_default_keybinds()
    end,
    evet = "VeryLazy", -- Optional: load only when needed
  },
}
