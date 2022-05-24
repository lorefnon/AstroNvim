local config = {

  -- Set colorscheme
  colorscheme = "default_theme",

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    colors = {
      bg = "none",
      fg = "#abb2bf",
    },
    -- Modify the highlight groups
    highlights = function(highlights)
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- Disable default plugins
  enabled = {
    bufferline = true,
    neo_tree = false,
    lualine = true,
    gitsigns = true,
    colorizer = true,
    toggle_term = true,
    comment = true,
    symbols_outline = true,
    indent_blankline = true,
    dashboard = true,
    which_key = true,
    neoscroll = false,
    ts_rainbow = true,
    ts_autotag = true,
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      {
        "kyazdani42/nvim-tree.lua",
        config = function()
          require'nvim-tree'.setup {
          }
        end,
        opt = false,
      },
      {
        "terryma/vim-expand-region"
      },
      {
        "tpope/vim-surround"
      },
      {
        "vim-scripts/copypath.vim"
      },
      {
        "phaazon/hop.nvim",
        cmd = {
          "HopWord",
          "HopLine",
          "HopChar1",
          "HopChar2",
          "HopPattern"
        },
        config = function()
          require'hop'.setup()
        end
      },
      {
        "tpope/vim-fugitive",
        cmd = {
          "G"
        }
      },
      {
        "tpope/vim-vinegar"
      },
      {
        "tpope/vim-sleuth"
      },
      {
        "qpkorr/vim-bufkill",
        event = "BufRead",
        cmd = {
          "BUN",
          "BD",
          "BW",
          "BB",
          "BF",
          "BA"
        }
      },
      {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function()
          require("lsp_signature").setup()
        end,
      },
      {
        "mbbill/undotree",
        cmd = {
          "UndotreeToggle"
        }
      },
      {
        "fsharp/vim-fsharp",
        ft = {
          "fs", "fsharp"
        }
      },
      {
        "jparise/vim-graphql",
        ft = {
          "graphql"
        }
      },
      {
          "edgedb/edgedb-vim",
          ft = {
              "edgeql"
          }
      },
      {
          "digitaltoad/vim-pug",
          ft = {
              "pug"
          }
      },
      {
        "mg979/vim-visual-multi",
        event = "BufRead"
      },
      {
        "FotiadisM/tabset.nvim",
        config = function()
          require("tabset").setup({
              defaults = {
                  tabwidth = 4
              },
              lua = {
                  tabwidth = 2
              }
          })
        end
      },
      {
        "prettier/vim-prettier",
        ft = {
          'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'
        },
        cmd = {
          'Prettier',
          'PrettierAsync',
          'PrettierPartial',
          'PrettierFragment'
        }
      },
      {
        "gpanders/editorconfig.nvim",
      }
    },
    -- All other entries override the setup() call for default plugins
    treesitter = {
      ensure_installed = { "lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
  },

  -- Add paths for including more VS Code style snippets in luasnip
  luasnip = {
    vscode_snippet_paths = {},
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings to the normal mode <leader> mappings
    register_n_leader = {
      -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   server:setup(opts)
    -- end

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- null-ls configuration
  ["null-ls"] = function()
    -- Formatting and linting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    local status_ok, null_ls = pcall(require, "null-ls")
    if not status_ok then
      return
    end

    -- Check supported formatters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting

    -- Check supported linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup {
      debug = false,
      sources = {
        -- Set a formatter
        formatting.rufo,
        -- Set a linter
        diagnostics.rubocop,
      },
      -- NOTE: You can remove this on attach function to disable format on save
      on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end,
    }
  end,

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    local map = vim.keymap.set
    local set = vim.opt
    -- Set options
    set.relativenumber = false
    set.incsearch = true

    -- Set key bindings
    local opts = { noremap = true, silent = true }
    map("n", "<leader>py", "<cmd>Prettier<CR>", opts)
    map("n", "s", "<cmd>HopChar1<CR>", opts)
    map("n", "S", "<cmd>HopLine<CR>", opts)
    map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
    map("n", "<leader>:", "<cmd>Telescope commands<CR>", opts)
    map("n", "<leader>.", "<cmd>Telescope resume<CR>", opts)

    map("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
    map("n", "F", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "R", vim.lsp.buf.rename, { desc = "Rename current symbol" })

    map("n", "<leader>ft", "<cmd>NvimTreeToggle<CR>", opts)
    map("n", "<leader>fq", "<cmd>NvimTreeFindFile<CR>", opts)
    map("n", "<leader>nx", function()
       require("notify").dismiss({pending = true}) 
    end, { desc = "Dismiss notifications"})

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
