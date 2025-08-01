return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- opcional para UI melhorada
    },
    config = function()
      require("flutter-tools").setup {
        lsp = {
          color = {
            enabled = true, -- Ativar destaque de cor
          },
          on_attach = function(client, bufnr)
            -- Configurações adicionais do LSP, como teclas de atalho
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          end,
        },
        debugger = {
          enabled = true,
          run_via_dap = true, -- Usar nvim-dap
        },
      }
    end
  }
}

