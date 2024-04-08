{
  inputs,
  cell,
}:
let  
 getHelpers = pkgs: _nixvimTests:
    import "${inputs.nixvim}/lib/helpers.nix" {
      inherit pkgs _nixvimTests;
      inherit (pkgs) lib;
    };
 nixvim_config = {pkgs, ...}: 
 let
 	helpers = getHelpers pkgs false;

 in {
  programs.nixvim = {
    enable = true;
    #globals.mapleader = ";";
    colorschemes.onedark.enable = true;
    clipboard.providers.wl-copy.enable = true;
    options.number = true;

    plugins = {
      fidget = {
      	enable = true;
	notification.overrideVimNotify = true;
      };
      comment-nvim.enable = true;
      dap.enable = true;
      debugprint.enable = true;
      diffview.enable = true;
      image = {
      		enable=true;
		integrations = {
			neorg.enabled=true;
		};
	};

      lsp = {
        enable = true;
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
			};
			
	};
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          csharp-ls.enable = true;
          cssls.enable = true;
          dartls.enable = true;
          html.enable = true;
          htmx.enable = true;
          lua-ls.enable = true;
          #nil_ls.enable = true;
          nixd.enable = true;
          pyright = {
	  	enable = false;
		extraOptions = {
			python = {
				pythonPath = helpers.mkRaw "py_path";
			};
		};
	  };
	  #pylyzer.enable=true;
	  pylsp = {
	  	enable = true;
		settings = {
			plugins = {
				#black.enabled=true;
				#flake8.enabled=true;
				isort.enabled=true;
				jedi_completion.enabled=true;
				jedi_hover.enabled=true;
				jedi_references.enabled=true;
				#jedi_signature_help=true;
				#jedi_symbols=true;
				pylsp_mypy = {
					enabled=true;
					report_progress=true;
					overrides = ["--python-executable" (helpers.mkRaw "py_path") true];
				};
				
				rope.enabled=true;
				rope_autoimport.enabled=true;
				rope_completion.enabled=true;
				ruff.enabled=true;
			};
		};
	  };
          #rust-analyzer = {
          #  enable = true;
          #  installCargo = true;
          #  installRustc = true;
          #};
          svelte.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          zls.enable = true;
        };
      };
      lsp-format.enable = true;
      #lsp-lines.enable=true;
      lspkind.enable = true;
      lspsaga.enable=true;
      luasnip.enable=true;
      lualine.enable = true;
      molten.enable = true;
      #neocord.enable = true;
      neogit.enable = true;
      neorg = {
      		enable = true;
		modules = {
			"core.defaults" = {
				__empty = null;
			};
			"core.autocommands" = { };
			"core.integrations.treesitter" = {};
			"core.integrations.telescope" = {};
			"core.integrations.image" = {};
			"core.neorgcmd" = {};
			"core.dirman" = {
				config = {
					workspaces = {
						main="~/notes";
					};
				};
			};
			#"core.latex.renderer" = {
				#config = {
					#conceal = true;
					#render_on_enter = true;
				#};
			#};
			"core.completion" = {
				config = {
					engine = "nvim-cmp";
				};
			};
			"core.concealer" = {
				config = {
					folds = true;
					icon_preset = "basic";
				};
			};
			"core.summary" = {
				config = {
					strategy="default";
				};
			};
		};

	};
      neotest = {
      	enable=true;
	adapters = {
		python.enable=true;
	};
      };
      #nix.enable = true;
      nix-develop.enable = true;
      none-ls.enable = true;
      nvim-autopairs.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
	settings = {
		matching.disallow_partial_fuzzy_matching=false;
		sources = [
			{name = "nvim_lsp";}
			{name = "treesitter";}
			{name = "neorg";}
			{name = "luasnip";}
			{name = "path";}
			{name = "buffer";}
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
      cmp-nvim-lsp.enable=true;
      nvim-lightbulb.enable = true;
      nvim-tree = {
      	enable = true;
	openOnSetup = true;
	openOnSetupFile = true;
	};
      #oil.enable = true;
      project-nvim.enable = true; 
      rustaceanvim.enable = true;
      #specs.enable = true;
      rainbow-delimiters.enable = true; 

      telescope = {
        enable = true;
        extensions = {
          file_browser.enable = true;
          frecency.enable = true;
          fzf-native.enable = true;
          media_files.enable = true;
          project-nvim.enable = true;
          ui-select.enable = true;
        };
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
        incrementalSelection.enable = true;
      };
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      trouble.enable = true;
      typescript-tools.enable = true;
      which-key.enable = true;
      zig.enable = true;
    };

    extraPlugins = [
    	pkgs.vimPlugins.nvim-surround
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
	'';

    extraConfigLua = ''
    	require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
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
