{
  inputs,
  cell,
}: {
  lilypond = {
    pkgs,
    lib,
    config,
    ...
  }: let
    usingNvimCmp = config.vim.autocomplete.enable && config.vim.autocomplete.type == "nvim-cmp";
  in
    with lib; {
      config = {
        build.rawPlugins = {
          "nvim-lilypond-suite" = {src = inputs.plugin-nvim-lilypond-suite;};
        };
        vim.startPlugins = ["nvim-lilypond-suite"];
        vim.luaConfigRC.nvim-lilypond-suite = nvim.dag.entryAfter ["theme"] ''
          require('nvls').setup({
            lilypond = {
              mappings = {
                player = "<F3>",
                compile = "<F5>",
                open_pdf = "<F6>",
                switch_buffers = "<A-Space>",
                insert_version = "<F4>",
                hyphenation = "<F12>",
                hyphenation_change_lang = "<F11>",
                insert_hyphen = "<leader>ih",
                add_hyphen = "<leader>ah",
                del_next_hyphen = "<leader>dfh",
                del_prev_hyphen = "<leader>dFh"
              },
              options = {
                pitches_language = "default",
                output = "pdf",
                backend = nil,
                main_file = "main.ly",
                main_folder = "%:p:h",
                include_dir = nil,
                hyphenation_language = "en_DEFAULT",
                diagnostics = false,
                pdf_viewer = nil,
              },
              highlights = {
                lilyString = { link = "String" },
                lilyDynamic = { bold = true },
                lilyComment = { link = "Comment" },
                lilyNumber = { link = "Number" },
                lilyVar = { link = "Tag" },
                lilyBoolean = { link = "Boolean" },
                lilySpecial = { bold = true },
                lilyArgument = { link = "Type" },
                lilyScheme = { link = "Special" },
                lilyLyrics = { link = "Special" },
                lilyMarkup = { bold = true },
                lilyFunction = { link = "Statement" },
                lilyArticulation = { link = "PreProc" },
                lilyContext = { link = "Type" },
                lilyGrob = { link = "Include" },
                lilyTranslator = { link = "Type" },
                lilyPitch = { link = "Function" },
                lilyChord = {
                  ctermfg = "lightMagenta",
                  fg = "lightMagenta",
                  bold = true
                },
              },
            },
            latex = {
              mappings = {
                compile = "<F5>",
                open_pdf = "<F6>",
                lilypond_syntax = "<F3>"
              },
              options = {
                clean_logs = false,
                main_file = "main.tex",
                main_folder = "%:p:h",
                include_dir = nil,
                lilypond_syntax_au = "BufEnter",
                pdf_viewer = nil,
              },
            },
            player = {
              mappings = {
                quit = "q",
                play_pause = "p",
                loop = "<A-l>",
                backward = "h",
                small_backward = "<S-h>",
                forward = "l",
                small_forward = "<S-l>",
                decrease_speed = "j",
                increase_speed = "k",
                halve_speed = "<S-j>",
                double_speed = "<S-k>",
              },
              options = {
                row = "2%",
                col = "99%",
                width = "37",
                height = "1",
                border_style = "single",
                winhighlight = "Normal:Normal,FloatBorder:Normal",
                midi_synth = "fluidsynth",
                audio_format = "mp3",
                mpv_flags = {
                  "--msg-level=cplayer=no,ffmpeg=no",
                  "--loop",
                  "--config-dir=/dev/null"
                }
              },
            },
          })

          vim.api.nvim_create_autocmd('BufEnter', {
            command = "syntax sync fromstart",
            pattern = { '*.ly', '*.ily', '*.tex' }
          })
        '';
      };
    };

  svelte = {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib;
    with builtins; let
      cfg = config.vim.languages.svelte;

      defaultServer = "svelte";
      servers = {
        svelte = {
          package = ["nodePackages" "svelte-language-server"];
          lspConfig =
            /*
            lua
            */
            ''
              lspconfig.svelte.setup {
                capabilities = capabilities;
                on_attach = attach_keymaps,
                cmd = {"${nvim.languages.commandOptToCmd cfg.lsp.package "svelteserver"}", "--stdio"},
              }
            '';
        };
      };

      # TODO: specify packages
      defaultFormat = "prettier";
      formats = {
        prettier = {
          package = ["nodePackages" "prettier"];
          nullConfig =
            /*
            lua
            */
            ''
              table.insert(
                ls_sources,
                null_ls.builtins.formatting.prettier.with({
                  command = "${nvim.languages.commandOptToCmd cfg.format.package "prettier"}",
                })
              )
            '';
        };
      };

      # TODO: specify packages
      defaultDiagnostics = ["eslint"];
      diagnostics = {
        eslint = {
          package = pkgs.nodePackages.eslint;
          nullConfig = pkg:
          /*
          lua
          */
          ''
            table.insert(
              ls_sources,
              null_ls.builtins.diagnostics.eslint.with({
                command = "${pkg}/bin/eslint",
              })
            )
          '';
        };
      };
    in {
      options.vim.languages.svelte = {
        enable = mkEnableOption "Svelte language support";

        treesitter = {
          enable = mkOption {
            description = "Enable Svelte treesitter";
            type = types.bool;
            default = config.vim.languages.enableTreesitter;
          };
          sveltePackage = nvim.options.mkGrammarOption pkgs "svelte";
          tsPackage = nvim.options.mkGrammarOption pkgs "tsx";
          jsPackage = nvim.options.mkGrammarOption pkgs "javascript";
        };

        lsp = {
          enable = mkOption {
            description = "Enable Svelte LSP support";
            type = types.bool;
            default = config.vim.languages.enableLSP;
          };
          server = mkOption {
            description = "Svelte LSP server to use";
            type = with types; enum (attrNames servers);
            default = defaultServer;
          };
          package = nvim.options.mkCommandOption pkgs {
            description = "Svelte LSP server";
            inherit (servers.${cfg.lsp.server}) package;
          };
        };

        format = {
          enable = mkOption {
            description = "Enable Svelte formatting";
            type = types.bool;
            default = config.vim.languages.enableFormat;
          };
          type = mkOption {
            description = "Svelte formatter to use";
            type = with types; enum (attrNames formats);
            default = defaultFormat;
          };
          package = nvim.options.mkCommandOption pkgs {
            description = "Svelte formatter";
            inherit (formats.${cfg.format.type}) package;
          };
        };

        extraDiagnostics = {
          enable = mkOption {
            description = "Enable extra Svelte diagnostics";
            type = types.bool;
            default = config.vim.languages.enableExtraDiagnostics;
          };
          types = nvim.options.mkDiagnosticsOption {
            langDesc = "Svelte";
            inherit diagnostics;
            inherit defaultDiagnostics;
          };
        };
      };

      config = mkIf cfg.enable (mkMerge [
        (mkIf cfg.treesitter.enable {
          vim.treesitter.enable = true;
          vim.treesitter.grammars = [cfg.treesitter.sveltePackage cfg.treesitter.tsPackage cfg.treesitter.jsPackage];
        })

        (mkIf cfg.lsp.enable {
          vim.lsp.lspconfig.enable = true;
          vim.lsp.lspconfig.sources.svelte-lsp = servers.${cfg.lsp.server}.lspConfig;
        })

        (mkIf cfg.format.enable {
          vim.lsp.null-ls.enable = true;
          vim.lsp.null-ls.sources.svelte-format = formats.${cfg.format.type}.nullConfig;
        })

        (mkIf cfg.extraDiagnostics.enable {
          vim.lsp.null-ls.enable = true;
          vim.lsp.null-ls.sources = lib.nvim.languages.diagnosticsToLua {
            lang = "svelte";
            config = cfg.extraDiagnostics.types;
            inherit diagnostics;
          };
        })
      ]);
    };
}
