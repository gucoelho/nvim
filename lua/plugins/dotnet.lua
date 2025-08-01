return {
  {
    "OmniSharp/omnisharp-vim",
    dependencies = {
      "dense-analysis/ale", -- Para linting e formatação
    },
    config = function()
      vim.g.OmniSharp_server_use_net6 = 1

      -- Configurar atalho para ir até definições
      vim.keymap.set("n", "gd", "<Plug>(omnisharp_go_to_definition)")

      -- Configurar linting com ALE
      vim.g.ale_linters = {
        cs = {'OmniSharp'}
      }
      vim.g.ale_fixers = {
        cs = {'OmniSharp'}
      }
    end,
  }
}

