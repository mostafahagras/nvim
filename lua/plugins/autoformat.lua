-- plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.biome.with({
          args = { "format", "--stdin-file-path", "$FILENAME" },
        }),
        require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
        require("none-ls.formatting.ruff_format"),
        require("none-ls.formatting.rustfmt"),
        null_ls.builtins.formatting.shfmt.with({ args = { "-i", "2" } }),
        null_ls.builtins.formatting.clang_format,
      },
      on_attach = function(client, bufnr)
        local ft = vim.bo[bufnr].filetype
        local disable_filetypes = { c = true, cpp = true }

        if client.supports_method("textDocument/formatting") and not disable_filetypes[ft] then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.defer_fn(function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  timeout_ms = 1000,
                  filter = function(c)
                    return c.name == "null-ls"
                  end,
                })
              end, 1000)
            end,
          })
        end
      end,
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      vim.lsp.buf.format({
        async = true,
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end, { desc = "[F]ormat buffer" })
  end,
}
-- return { -- Autoformat
--   "stevearc/conform.nvim",
--   event = { "BufWritePre" },
--   cmd = { "ConformInfo" },
--   keys = {
--     {
--       "<leader>f",
--       function()
--         require("conform").format({ async = true, lsp_format = "fallback" })
--       end,
--       mode = "",
--       desc = "[F]ormat buffer",
--     },
--   },
--   formatters = {
--     biome = {
--       command = "biome",
--       args = { "format", "--stdin-file-path", "$FILENAME" },
--       stdin = true,
--     },
--   },
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       -- have a well standardized coding style. You can add additional
--       -- languages here or re-enable it for the disabled ones.
--       local disable_filetypes = { c = true, cpp = true }
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       else
--         return {
--           timeout_ms = 500,
--           lsp_format = "fallback",
--         }
--       end
--     end,
--     formatters_by_ft = {
--       lua = { "stylua" },
--       javascript = { "biome" },
--       typescript = { "biome" },
--       javascriptreact = { "biome" },
--       typescriptreact = { "biome" },
--       json = { "biome" },
--       jsonc = { "biome" },
--       html = { "biome" },
--       css = { "biome" },
--       astro = { "biome" },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use 'stop_after_first' to run the first available formatter from the list
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   },
-- }
