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
}
