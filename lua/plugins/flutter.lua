return {
  -- Flutter Tools
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        closing_tags = {
          enabled = true,
          prefix = "// ",
        },
        widget_guides = {
          enabled = true,
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        dev_tools = {
          auto_open_browser = false,
        },
        lsp = {
          color = {
            enabled = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
          },
          on_attach = function(_, bufnr)
            local nmap = function(keys, cmd, desc)
              vim.keymap.set("n", keys, cmd, { buffer = bufnr, desc = desc })
            end
            local vmap = function(keys, cmd, desc)
              vim.keymap.set("v", keys, cmd, { buffer = bufnr, desc = desc })
            end

            -- Helper: code action filtrada por título
            local function filtered_action(filter_title)
              return function()
                vim.lsp.buf.code_action({
                  filter = function(action)
                    return action.title:find(filter_title) ~= nil
                  end,
                })
              end
            end

            -- Flutter commands
            nmap("<leader>Fr", "<cmd>FlutterRun<cr>", "Run")
            nmap("<leader>FR", "<cmd>FlutterRestart<cr>", "Restart")
            nmap("<leader>Fq", "<cmd>FlutterQuit<cr>", "Quit")
            nmap("<leader>Fd", "<cmd>FlutterDevices<cr>", "Devices")
            nmap("<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", "Outline")
            nmap("<leader>FE", "<cmd>FlutterEmulators<cr>", "Emulators")
            nmap("<leader>Fl", "<cmd>FlutterDevTools<cr>", "DevTools")
            nmap("<leader>Fs", "<cmd>FlutterSuper<cr>", "Super")
            nmap("<leader>FL", "<cmd>FlutterLogClear<cr>", "Log Clear")

            -- Widget refactoring (normal + visual)
            nmap("<leader>Fw", filtered_action("Wrap with"), "Wrap with...")
            vmap("<leader>Fw", filtered_action("Wrap with"), "Wrap with...")
            nmap("<leader>Fe", filtered_action("Extract Widget"), "Extract Widget")
            vmap("<leader>Fe", filtered_action("Extract Widget"), "Extract Widget")
            nmap("<leader>Fx", filtered_action("Remove this widget"), "Remove Widget")
            nmap("<leader>Fa", vim.lsp.buf.code_action, "All Code Actions")
            vmap("<leader>Fa", vim.lsp.buf.code_action, "All Code Actions")

            -- Registrar grupos no which-key
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({ { "<leader>F", group = "Flutter", buffer = bufnr } })
            end
          end,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(_)
            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter (debug)",
                program = "${workspaceFolder}/lib/main.dart",
              },
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter (profile)",
                program = "${workspaceFolder}/lib/main.dart",
                args = { "--profile" },
              },
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter (release)",
                program = "${workspaceFolder}/lib/main.dart",
                args = { "--release" },
              },
            }
          end,
        },
      })
    end,
  },

  -- Treesitter: garantir parser Dart
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dart" })
      end
    end,
  },

  -- Conform: formatter Dart
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dart = { "dart_format" },
      },
    },
  },

  -- LSP: desabilitar inlay hints duplicados para Dart
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        exclude = { "dart" },
      },
    },
  },

  -- Neotest: adaptador Dart/Flutter
  {
    "sidlatau/neotest-dart",
    lazy = true,
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "sidlatau/neotest-dart" },
    opts = {
      adapters = {
        ["neotest-dart"] = {
          command = "flutter",
          use_lsp = true,
        },
      },
    },
  },
}
