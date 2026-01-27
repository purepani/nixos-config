{ inputs
, cell
,
}:
let
  nixvim_config = { config, pkgs, lib, ... }:
    let
      helpers = config.lib.nixvim;
      uv = pkgs.uv;
      #basedpyright = pkgs.basedpyright;

      venv-selector-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "venv-selector.nvim";
        version = "0-unstable-2026-01-26";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "2210d8718afcf76fd5f38582c1e54182f7eba8eb";
          hash = "sha256-KHq2yjTgvq1etE76llvi3o0vQzTmo5T+5klndPclU2g=";
        };
        meta.homepage = "https://github.com/linux-cultist/venv-selector.nvim/";
        meta.hydraPlatforms = [ ];
      };
    in
    {

      programs.nixvim.imports =
        [
          ({ lib, ... }: {
            enable = true;
            #extraLuaPackages = [cell.packages.luaPackages.nvim-nio cell.packages.luaPackages.neorg];
            autoCmd = [
              {
                command = "set filetype=fsharp";
                event = [
                  "BufNewFile"
                  "BufRead"
                ];
                pattern = [
                  "*.fs"
                  "*.fsx"
                  "*.fsi"
                ];
              }


            ];
            extraPackages = [
              #cell.nixpkgs.pkgs.texlive.combined.scheme-full
              pkgs.dcmtk
              pkgs.ripgrep
              pkgs.uv
            ];
            globals.mapleader = ";";
            globals.maplocalleader = ";";
            colorschemes.onedark.enable = true;
            clipboard.providers.wl-copy.enable = true;
            opts = {
              number = true;
              signcolumn = "yes:1";
              conceallevel = 2;
              expandtab = true;
              tabstop = 4;
            };


            lsp = {
              servers = {
                jetls = {
                  enable = true;
                  config = {
                    cmd = [ (lib.nixvim.utils.mkRaw "os.getenv('HOME') .. \"/.julia/bin/jetls\"") "--threads=auto" "--" ];
                    filetypes = [ "julia" ];
                    root_markers = [
                      "Project.toml"
                      "Manifest.toml"
                    ];
                  };
                };
              };
            };
            plugins = {
              fidget = {
                enable = true;
                settings = {
                  notification.override_vim_notify = true;
                };
              };
              comment.enable = true;
              dap.enable = true;
              debugprint.enable = true;
              diffview.enable = true;
              distant = {
                enable = true;
                settings = {
                  #client.bin = "${lib.getExe config.programs.nixvim.plugins.distant.distantPackage}";
                  #manager.daemon = true;
                };
              };
              image = {
                enable = false;
                settings.integrations = {
                  backend = "kitty";
                  #neorg = {
                  #enabled = true;
                  #filetypes = [ "norg" ];
                  #};
                };
              };
              jupytext = {
                enable = true;
                python3Dependencies = p: with p; [
                  jupytext
                ];
              };

              lsp = {
                enable = true;
                inlayHints = true;
                keymaps = {
                  diagnostic = {
                    "<leader>j" = "goto_next";
                    "<leader>k" = "goto_prev";
                  };
                  lspBuf = {
                    K = "hover";
                    gD = "references";
                    gd = "definition";
                    gi = "implementation";
                    gt = "type_definition";
                    gr = "rename";
                    ga = "code_action";
                  };

                };
                servers = {
                  bashls.enable = true;
                  clangd.enable = true;
                  cmake.enable = true;
                  csharp_ls.enable = true;
                  cssls.enable = true;
                  dartls.enable = true;
                  fsautocomplete.enable = true;
                  futhark_lsp.enable = true;
                  html.enable = true;
                  htmx.enable = true;
                  julials = {
                    enable = false;
                    package = null;
                  };
                  lua_ls.enable = true;
                  #nil_ls.enable = true;
                  nixd = {
                    enable = true;
                    settings = {
                      formatting.command = [ "nixpkgs-fmt" ];
                    };
                  };

                  ruff.enable = true;
                  ty = {
                    enable = true;
                  };
                  basedpyright =
                    {
                      enable = false;
                      #onAttach = {
                      #  function = ''
                      #    local path = vim.api.nvim_buf_get_name(bufnr)
                      #    print(path)
                      #    local cmd = string.format("${uv}/bin/uv run --with-requirements %s ${basedpyright}/bin/basedpyright-langserver --stdio", path)
                      #    print(cmd)
                      #    client.cmd = cmd
                      #    return client
                      #  '';
                      #};
                      settings = {
                        basedpyright.analysis.typeCheckingMode = "standard";
                      };
                      extraOptions = {
                        python = {
                          pythonPath = helpers.mkRaw "py_path";
                        };
                      };
                    };
                  #pylyzer.enable=true;
                  pylsp = {
                    enable = false;
                    #package = pkgs.python312Packages.python-lsp-server; 
                    #pythonPackage = pkgs.python312;
                    settings = {
                      plugins = {
                        #black.enabled=true;
                        #flake8.enabled=true;
                        isort.enabled = false;
                        jedi_completion.enabled = false;
                        jedi_hover.enabled = false;
                        jedi_references.enabled = false;
                        #jedi_signature_help=true;
                        #jedi_symbols=true;
                        pylsp_mypy = {
                          enabled = false;
                          report_progress = false;
                          overrides = [ "--python-executable" (helpers.mkRaw "py_path") true ];
                        };

                        rope.enabled = false;
                        rope_autoimport.enabled = false;
                        rope_completion.enabled = false;
                        ruff.enabled = true;
                      };
                    };
                  };
                  rust_analyzer = {
                    enable = true;
                    package = cell.nixpkgs.pkgs.rust-analyzer;
                    installCargo = false;
                    installRustc = false;
                    settings = {
                      inlayHints = {
                        typeHints = {
                          enable = true;
                        };
                        chainingHints.enable = true;
                        closureReturnTypeHints.enable = "always";
                        closingBraceHints.enable = true;
                        discriminantHints.enable = "always";
                        parameterHints.enable = true;
                        genericParameterHints = {
                          const.enable = true;
                          type.enable = true;
                        };

                      };
                    };

                  };
                  svelte = {
                    enable = true;
                  };
                  texlab = {
                    enable = true;

                  };
                  tailwindcss.enable = true;
                  ts_ls.enable = true;
                  zls.enable = true;
                };
              };
              lsp-format.enable = true;
              lsp-lines.enable = true;
              lspkind = {
                enable = true;
                cmp.enable = false;
              };
              lspsaga = {
                enable = true;
              };
              luasnip.enable = true;
              lualine.enable = true;
              molten = {
                enable = true;
                python3Dependencies = p: with p; [
                  pynvim
                  jupyter-client
                  cairosvg
                  pnglatex
                  plotly
                  kaleido
                  pyperclip
                  nbformat
                  pillow
                  requests
                  websocket-client
                ];
              };
              #neocord.enable = true;
              neogit.enable = true;
              neogen.enable = true;
              neotest = {
                enable = false;
                adapters = {
                  python = {
                    enable = false;
                    settings = {
                      python = helpers.mkRaw "py_path";
                    };
                  };
                };
              };
              #nix.enable = true;
              nix-develop.enable = true;
              none-ls.enable = true;
              nvim-autopairs.enable = true;
              blink-cmp = {
                enable = true;
                autoLoad = true;
                setupLspCapabilities = true;
                settings = {
                  fuzzy = {
                    use_frecency = true;
                    use_proximity = true;
                  };
                  completion = {
                    accept.auto_brackets.enabled = true;
                    documentation = {
                      auto_show = true;
                      auto_show_delay_ms = 50;
                      update_delay_ms = 50;

                    };
                  };
                  signature = {
                    enabled = true;
                  };
                  keymap = {
                    preset = "default";
                  };
                  sources = {
                    default = [
                      "lsp"
                      "path"
                      "snippets"
                      "buffer"
                    ];
                  };


                };
              };

              nvim-lightbulb = {
                enable = false;
                settings = {
                  autocmd = {
                    enabled = true;
                    updatetime = 200;
                  };
                  float = {
                    enabled = false;
                    text = " 󰌶 ";
                    win_opts = {
                      border = "rounded";
                    };
                  };
                  line = {
                    enabled = false;
                  };
                  number = {
                    enabled = false;
                  };
                  sign = {
                    enabled = false;
                    text = "󰌶";
                  };
                  status_text = {
                    enabled = false;
                    text = " 󰌶 ";
                  };
                  virtual_text = {
                    enabled = true;
                    text = "󰌶";
                  };
                };
              };
              nvim-tree = {
                enable = true;
                openOnSetup = true;
                openOnSetupFile = true;
              };
              obsidian = {
                enable = true;
                settings = {
                  workspaces = [
                    { name = "Notes"; path = "~/Notes"; }
                  ];
                };
              };
              otter.enable = true;
              #oil.enable = true;
              #project-nvim = {
              #  enable = true;
              #  enableTelescope = true;
              #
              #          };
              quarto = {
                enable = true;
              };
              rustaceanvim = {
                enable = false;
                #rustAnalyzerPackage = cell.nixpkgs.pkgs.rust-analyzer;
                settings = {
                  server = {
                    default_settings = {
                      rust-analyzer = {
                        inlayHints = {
                          typeHints = {
                            enable = true;
                          };
                          chainingHints.enable = true;
                          closureReturnTypeHints.enable = "always";
                          closingBraceHints.enable = true;
                          discriminantHints.enable = "always";
                          parameterHints.enable = true;
                          genericParameterHints = {
                            const.enable = true;
                            type.enable = true;
                          };

                        };
                      };
                    };
                  };
                };
              };
              #specs.enable = true;
              rainbow-delimiters.enable = true;

              telescope = {
                enable = true;
                extensions = {
                  file-browser.enable = true;
                  frecency.enable = true;
                  fzf-native.enable = true;
                  #fzy-native.enable = true;
                  media-files.enable = true;
                  project.enable = true;
                  manix.enable = true;
                  ui-select.enable = true;
                  undo.enable = true;
                };
              };
              treesitter = {
                enable = true;
                highlight.enable = true;
                indent.enable = true;
                #folding.enable = true;
                nixvimInjections = true;
                settings = {
                  incremental_selection.enable = true;
                };
              };
              #treesitter-context.enable = true;
              #treesitter-refactor.enable = true;
              treesitter-textobjects.enable = true;
              trouble.enable = true;
              typescript-tools.enable = true;
              venv-selector = {
                enable = true;
                package = venv-selector-nvim;
                settings = { options = { debug = true; set_environment_variables = true; }; };
              };
              vimtex = {
                enable = true;
                texlivePackage = null;
                zathuraPackage = null;
                settings = {
                  view_method = "zathura";
                  compiler_method = "latexmk";
                };
              };
              vim-slime = {
                enable = true;
                settings = {
                  target = "zellij";
                  default_config = {
                    session_id = "slime";
                    relative_pane = "current";
                  };
                  bracketed_paste = true;
                };
              };
              web-devicons.enable = true;
              which-key.enable = true;
              zig.enable = true;
            };

            extraPlugins = [
              pkgs.vimPlugins.nvim-surround
              (pkgs.vimUtils.buildVimPlugin {
                name = "vim-dicom";
                src = pkgs.fetchFromGitHub {
                  owner = "kkumler";
                  repo = "vim-dicom";
                  hash = "sha256-4jGJSl9JWos1/7WvHcAuYY2NAzDZDivS1z0v2Sc/Y3I=";
                  rev = "855105a766a0b79da71d10fbc332b414703b7aed";
                };
              })
              #pkgs.vimPlugins.nvim-lilypond-suite
            ];

            extraConfigLuaPre = ''
              	local venv_path = os.getenv('VIRTUAL_ENV') -- or vim.fn.exepath('python')
              	local path_python = vim.fn.exepath('python')
              	local py_path = nil
              	if venv_path ~= nil then
              	  py_path = venv_path .. "/bin/python3"
              	elseif path_python ~=nil then
              	  py_path = path_python
              	else
              	  py_path = vim.g.python3_host_prog
              	end
              	print(py_path)
              	'';

            extraConfigLua = ''
                  	require("nvim-surround").setup({
                          -- Configuration here, or leave empty to use defaults
                      })
              	'';
          })
        ];


    };
in
{

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    nixvim_config
  ];
}
