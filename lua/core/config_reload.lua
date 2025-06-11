vim.api.nvim_create_augroup("AutoReloadConfig", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "AutoReloadConfig",
  pattern = { vim.fn.stdpath("config") .. "/lua/core/*.lua" },
  callback = function()
    dofile(vim.fn.expand("%"))
    vim.notify("Config reloaded!", vim.log.levels.INFO)
  end,
})
