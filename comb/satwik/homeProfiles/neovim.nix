{ inputs
, cell
,
}:
let
  nixvim_config = { config, pkgs, ... }:
    let
      helpers = config.lib.nixvim;
      distant_drv = {
      	rustPlatform,
	fetchFromGitHub,
	cmake,
	perl,
	stdenv,
      }: (rustPlatform.buildRustPackage {

      	pname = "distant";
	version = "0.20.0";
      	src = fetchFromGitHub {
		owner="chipsenkbeil";
		repo="distant";
		rev="v0.20.0";
		hash="sha256-DcnleJUAeYg3GSLZljC3gO9ihiFz04dzT/ddMnypr48=";
	};
	cargoHash = "sha256-7MNNdm4b9u5YNX04nBtKcrw+phUlpzIXo0tJVfcgb40=";
	nativeBuildInputs = [
		cmake
		perl
		stdenv.cc.cc.lib

	];
	doCheck = false;
      });

      distant = pkgs.callPackage distant_drv {};

    in
    {

      programs.nixvim = {
        enable = true;
        #extraLuaPackages = [cell.packages.luaPackages.nvim-nio cell.packages.luaPackages.neorg];
        extraPackages = [ 
		cell.nixpkgs.pkgs.texlive.combined.scheme-full 
		pkgs.dcmtk 
		distant
	];
        globals.mapleader = ";";
        globals.maplocalleader = ";";
        colorschemes.onedark.enable = true;
        clipboard.providers.wl-copy.enable = true;
        opts = {
          number = true;
          signcolumn = "yes:1";
        };

        plugins = {
          fidget = {
            enable = true;
            notification.overrideVimNotify = true;
          };
          comment.enable = true;
          dap.enable = true;
          debugprint.enable = true;
          diffview.enable = true;
          image = {
            enable = true;
            backend = "kitty";
            integrations = {
              neorg = {
                enabled = true;
                filetypes = [ "norg" ];
              };
            };
          };

          lsp = {
            enable = true;
            inlayHints = true;
	    capabilities = ''
		capabilites = require('blink.cmp').get_lsp_capabilities(capabilities)
	'';
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
              html.enable = true;
              htmx.enable = true;
              lua_ls.enable = true;
              #nil_ls.enable = true;
              nixd = {
                enable = true;
                settings = { };
              };
              basedpyright = {
                enable = true;
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
                enable = true;
                #package = pkgs.python312Packages.python-lsp-server; 
                #pythonPackage = pkgs.python312;
                settings = {
                  plugins = {
                    #black.enabled=true;
                    #flake8.enabled=true;
                    isort.enabled = false;
                    jedi_completion.enabled = true;
                    jedi_hover.enabled = true;
                    jedi_references.enabled = true;
                    #jedi_signature_help=true;
                    #jedi_symbols=true;
                    pylsp_mypy = {
                      enabled = false;
                      report_progress = false;
                      overrides = [ "--python-executable" (helpers.mkRaw "py_path") true ];
                    };

                    rope.enabled = false;
                    rope_autoimport.enabled = true;
                    rope_completion.enabled = true;
                    ruff.enabled = true;
                  };
                };
              };
              rust_analyzer = {
                enable = true;
		package = cell.nixpkgs.pkgs.rust-analyzer-nightly;
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
              tailwindcss.enable = true;
              ts_ls.enable = true;
              zls.enable = true;
            };
          };
          lsp-format.enable = true;
          lsp-lines.enable = true;
          lspkind.enable = true;
          lspsaga = {
            enable = true;
          };
          luasnip.enable = true;
          lualine.enable = true;
          molten.enable = true;
          #neocord.enable = true;
          neogit.enable = true;
          neogen.enable = true;
          neorg = {
            enable = true;
            package = cell.nixpkgs.pkgs.vimPlugins.neorg;
            modules = {
              "core.defaults" = {
                __empty = null;
              };
              "core.autocommands" = { };
              "core.integrations.treesitter" = { };
              "core.integrations.telescope" = { };
              "core.neorgcmd" = { };
              "core.dirman" = {
                config = {
                  workspaces = {
                    main = "~/notes";
                  };
                };
              };
              "core.integrations.image" = { };
              "core.latex.renderer" = {
                config = {
                  conceal = true;
                  render_on_enter = true;
                  renderer = "core.integrations.image";
                };
              };
              #"core.completion" = {
              #  config = {
              #    engine = "nvim-cmp";
              #  };
              #};
              "core.concealer" = {
                config = {
                  folds = true;
                  icon_preset = "basic";
                };
              };
              "core.summary" = {
                config = {
                  strategy = "default";
                };
              };
            };

          };
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
          cmp-nvim-lsp-document-symbol.enable = false;
          cmp-nvim-lsp-signature-help.enable = false;
          cmp = {
            enable = false;
            autoEnableSources = true;
            settings = {
              matching.disallow_partial_fuzzy_matching = false;
              sources = [
                { name = "nvim_lsp"; }
                { name = "treesitter"; }
                { name = "neorg"; }
                { name = "luasnip"; }
                { name = "path"; }
                { name = "buffer"; }
              ];
              snippet = {
                expand = "function(args) require('luasnip').lsp_expand(args.body) end";
              };
              mapping =
                {
                  "<C-Space>" = "cmp.mapping.complete()";
                  "<C-d>" = "cmp.mapping.scroll_docs(-4)";
                  "<C-e>" = "cmp.mapping.close()";
                  "<C-f>" = "cmp.mapping.scroll_docs(4)";
                  "<CR>" = "cmp.mapping.confirm({ select = true })";
                  "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                  "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                };
            };
          };
          cmp-nvim-lsp.enable = false;
	  blink-cmp = {
	  	enable = true;
		settings = {
			accept.auto_brackets.enabled=true;
			fuzzy = {
				use_frecency = true;
				use_proximity = true;
			};
			windows.documentation = {
				auto_show = true;
				auto_show_delay_ms = 0;
				update_delay_ms = 0;
				
			};
			keymap = {
				preset = "default";
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
          #oil.enable = true;
          project-nvim = {
            enable = true;
            enableTelescope = true;

          };
          rustaceanvim = {
            enable = false;
            rustAnalyzerPackage = cell.nixpkgs.pkgs.rust-analyzer;
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
              #file_browser.enable = true;
              #frecency.enable = true;
              fzf-native.enable = true;
              media-files.enable = true;
              #project-nvim.enable = true;
              ui-select.enable = true;
            };
          };
          treesitter = {
            enable = true;
            nixvimInjections = true;
            settings = {
              highlight.enable = true;
              incremental_selection.enable = true;
            };
          };
          treesitter-context.enable = true;
          treesitter-refactor.enable = true;
          treesitter-textobjects.enable = true;
          trouble.enable = true;
          typescript-tools.enable = true;
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
        pkgs.vimPlugins.distant-nvim
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
		require('distant'):setup({
			manager = {
				lazy=false,
				user=true
			}
		})
          	'';
      };


    };
in
{

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    nixvim_config
  ];
}
