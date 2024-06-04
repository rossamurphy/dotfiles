-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/rossmurphy/.cache/nvim/packer_hererocks/2.1.1699180677/share/lua/5.1/?.lua;/Users/rossmurphy/.cache/nvim/packer_hererocks/2.1.1699180677/share/lua/5.1/?/init.lua;/Users/rossmurphy/.cache/nvim/packer_hererocks/2.1.1699180677/lib/luarocks/rocks-5.1/?.lua;/Users/rossmurphy/.cache/nvim/packer_hererocks/2.1.1699180677/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/rossmurphy/.cache/nvim/packer_hererocks/2.1.1699180677/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["ChatGPT.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/ChatGPT.nvim",
    url = "https://github.com/jackMort/ChatGPT.nvim"
  },
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0006\3\0\0'\5\3\0B\3\2\0029\3\4\3B\3\1\2=\3\6\2B\0\2\1K\0\1\0\rpre_hook\1\0\0\20create_pre_hook7ts_context_commentstring.integrations.comment_nvim\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  catppuccin = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cellular-automaton.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/cellular-automaton.nvim",
    url = "https://github.com/eandrju/cellular-automaton.nvim"
  },
  ["cmp-dap"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/cmp-dap",
    url = "https://github.com/rcarriga/cmp-dap"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["gruvbox.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/gruvbox.nvim",
    url = "https://github.com/ellisonleao/gruvbox.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n� \0\0\b\0x\0�\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0005\3\6\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\t\0005\3\n\0B\0\3\0016\0\v\0'\2\f\0B\0\2\0029\0\r\0005\2\14\0005\3\15\0=\3\16\0025\3\18\0005\4\17\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\0035\4\29\0005\5\28\0=\5\30\4=\4\31\0035\4 \0=\4!\0035\4\"\0=\4#\0035\4$\0=\4%\0035\4&\0=\4'\0035\4(\0=\4)\3=\3*\0024\3\0\0=\3+\0025\3,\0005\4-\0=\4.\0035\0040\0005\5/\0=\0051\0045\0052\0005\0063\0=\0064\5=\0055\0045\0056\0005\0067\0=\0064\5=\0058\4=\0049\3=\3:\0024\3\0\0=\3;\0025\3D\0005\4<\0004\5\0\0=\5=\0044\5\0\0=\5>\0045\5?\0=\5@\0045\5A\0=\5B\0044\5\0\0=\5C\4=\4E\0035\4F\0=\4G\0035\4Z\0005\5H\0005\6I\0005\aJ\0=\a4\6=\6K\0055\6L\0=\6M\0055\6N\0=\6O\0055\6P\0=\6Q\0055\6R\0=\6S\0055\6T\0=\6U\0055\6V\0=\6W\0055\6X\0=\6Y\5=\0059\0045\5[\0=\5\\\4=\4:\0034\4\0\0=\4+\3=\3]\0025\3_\0005\4^\0=\4G\0035\4i\0005\5`\0005\6a\0005\ab\0=\a4\6=\6K\0055\6c\0=\6M\0055\6d\0=\6O\0055\6e\0=\6S\0055\6f\0=\6U\0055\6g\0=\6W\0055\6h\0=\6Y\5=\0059\4=\4:\3=\3j\0025\3u\0005\4k\0005\5l\0005\6m\0005\an\0=\a4\6=\6K\0055\6o\0=\6M\0055\6p\0=\6O\0055\6q\0=\6S\0055\6r\0=\6U\0055\6s\0=\6W\0055\6t\0=\6Y\5=\0059\4=\4:\3=\3\31\2B\0\2\0016\0\0\0009\0v\0'\2w\0B\0\2\1K\0\1\0#nnoremap \\ :Neotree reveal<cr>\bcmd\1\0\0\1\2\1\0\18order_by_type\vnowait\1\1\2\1\0\18order_by_size\vnowait\1\1\2\1\0\18order_by_name\vnowait\1\1\2\1\0\22order_by_modified\vnowait\1\1\2\1\0\25order_by_diagnostics\vnowait\1\1\2\1\0\21order_by_created\vnowait\1\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\a\aga\17git_add_file\agp\rgit_push\6A\16git_add_all\agg\24git_commit_and_push\agc\15git_commit\agr\20git_revert_file\agu\21git_unstage_file\1\0\1\rposition\nfloat\fbuffers\1\0\0\1\2\1\0\18order_by_type\vnowait\1\1\2\1\0\18order_by_size\vnowait\1\1\2\1\0\18order_by_name\vnowait\1\1\2\1\0\22order_by_modified\vnowait\1\1\2\1\0\25order_by_diagnostics\vnowait\1\1\2\1\0\21order_by_created\vnowait\1\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\3\abd\18buffer_delete\t<bs>\16navigate_up\6.\rset_root\1\0\2\18show_unloaded\2\21group_empty_dirs\2\1\0\2\20leave_dirs_open\1\fenabled\2\15filesystem\26fuzzy_finder_mappings\1\0\4\n<C-p>\19move_cursor_up\n<C-n>\21move_cursor_down\t<up>\19move_cursor_up\v<down>\21move_cursor_down\1\0\0\aot\1\2\1\0\18order_by_type\vnowait\1\aos\1\2\1\0\18order_by_size\vnowait\1\aon\1\2\1\0\18order_by_name\vnowait\1\aom\1\2\1\0\22order_by_modified\vnowait\1\aog\1\2\1\0\24order_by_git_status\vnowait\1\aod\1\2\1\0\25order_by_diagnostics\vnowait\1\aoc\1\2\1\0\21order_by_created\vnowait\1\6o\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\n\t<bs>\16navigate_up\a]g\22next_git_modified\6#\17fuzzy_sorter\6f\21filter_on_submit\6/\17fuzzy_finder\6D\27fuzzy_finder_directory\6H\18toggle_hidden\6.\rset_root\n<c-x>\17clear_filter\a[g\22prev_git_modified\24follow_current_file\1\0\2\20leave_dirs_open\1\fenabled\1\19filtered_items\1\0\3\27use_libuv_file_watcher\1\21group_empty_dirs\1\26hijack_netrw_behavior\17open_default\26never_show_by_pattern\15never_show\1\3\0\0\14.DS_Store\14thumbs.db\16always_show\1\3\0\0\16.gitignored\15.gitignore\20hide_by_pattern\17hide_by_name\1\0\4\18hide_dotfiles\2\fvisible\1\16hide_hidden\2\20hide_gitignored\2\18nesting_rules\vwindow\rmappings\6a\1\0\1\14show_path\tnone\1\2\0\0\badd\6P\vconfig\1\0\2\14use_float\2\19use_image_nvim\2\1\2\0\0\19toggle_preview\f<space>\1\0\24\6t\16open_tabnew\6q\17close_window\6A\18add_directory\6y\22copy_to_clipboard\6S\15open_split\18<2-LeftMouse>\topen\t<cr>\topen\6c\tcopy\6d\vdelete\6r\vrename\6x\21cut_to_clipboard\6w\28open_with_window_picker\6C\15close_node\6s\16open_vsplit\6<\16prev_source\6>\16next_source\6z\20close_all_nodes\6i\22show_file_details\6?\14show_help\6p\25paste_from_clipboard\6l\18focus_preview\6m\tmove\6R\frefresh\n<esc>\vcancel\1\2\1\0\16toggle_node\vnowait\1\20mapping_options\1\0\2\vnowait\2\fnoremap\2\1\0\2\nwidth\3(\rposition\tleft\rcommands\30default_component_configs\19symlink_target\1\0\1\fenabled\1\fcreated\1\0\2\19required_width\3n\fenabled\2\18last_modified\1\0\2\19required_width\3X\fenabled\2\ttype\1\0\2\19required_width\3z\fenabled\2\14file_size\1\0\2\19required_width\3@\fenabled\2\15git_status\fsymbols\1\0\0\1\0\t\14untracked\b\rconflict\b\fignored\b\rmodified\b\runstaged\t󰄱\fdeleted\b✖\frenamed\t󰁕\vstaged\b\nadded\b✚\tname\1\0\3\19trailing_slash\1\26use_git_status_colors\2\14highlight\20NeoTreeFileName\rmodified\1\0\2\vsymbol\b[+]\14highlight\20NeoTreeModified\ticon\1\0\5\17folder_empty\t󰜌\14highlight\20NeoTreeFileIcon\16folder_open\b\18folder_closed\b\fdefault\6*\vindent\1\0\t\fpadding\3\1\23last_indent_marker\b└\23expander_highlight\20NeoTreeExpander\18indent_marker\b│\17with_markers\2\16indent_size\3\2\23expander_collapsed\b\14highlight\24NeoTreeIndentMarker\22expander_expanded\b\14container\1\0\0\1\0\1\26enable_character_fade\2$open_files_do_not_replace_types\1\4\0\0\rterminal\ftrouble\aqf\1\0\6\22enable_git_status\2\23popup_border_style\frounded\25close_if_last_window\1\"enable_normal_mode_for_inputs\1\26sort_case_insensitive\1\23enable_diagnostics\2\nsetup\rneo-tree\frequire\1\0\2\vtexthl\23DiagnosticSignHint\ttext\t󰌵\23DiagnosticSignHint\1\0\2\vtexthl\23DiagnosticSignInfo\ttext\t \23DiagnosticSignInfo\1\0\2\vtexthl\23DiagnosticSignWarn\ttext\t \23DiagnosticSignWarn\1\0\2\vtexthl\24DiagnosticSignError\ttext\t \24DiagnosticSignError\16sign_define\afn\bvim\0" },
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["neodev.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neodev.nvim",
    url = "https://github.com/folke/neodev.nvim"
  },
  neotest = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-deno"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neotest-deno",
    url = "https://github.com/markemmons/neotest-deno"
  },
  ["neotest-python"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neotest-python",
    url = "https://github.com/nvim-neotest/neotest-python"
  },
  ["neotest-zig"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/neotest-zig",
    url = "https://github.com/lawrence-laz/neotest-zig"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-dap-vscode-js"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-dap-vscode-js",
    url = "https://github.com/mxsdev/nvim-dap-vscode-js"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\3\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\t\3=\3\v\2B\0\2\1K\0\1\0\17filter_rules\1\0\0\abo\fbuftype\1\3\0\0\rterminal\rquickfix\rfiletype\1\0\0\1\4\0\0\rneo-tree\19neo-tree-popup\vnotify\1\0\2\19autoselect_one\2\24include_current_win\1\nsetup\18window-picker\frequire\0" },
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["persistent-breakpoints.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/persistent-breakpoints.nvim",
    url = "https://github.com/Weissle/persistent-breakpoints.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["tabset.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/tabset.nvim",
    url = "https://github.com/FotiadisM/tabset.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["venv-selector.nvim"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/venv-selector.nvim",
    url = "https://github.com/linux-cultist/venv-selector.nvim"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-dadbod-completion"] = {
    after_files = { "/Users/rossmurphy/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion/after/plugin/vim_dadbod_completion.lua", "/Users/rossmurphy/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion/after/plugin/vim_dadbod_completion.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion",
    url = "https://github.com/kristijanhusak/vim-dadbod-completion"
  },
  ["vim-dadbod-ui"] = {
    commands = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/opt/vim-dadbod-ui",
    url = "https://github.com/kristijanhusak/vim-dadbod-ui"
  },
  ["vim-dotenv"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/vim-dotenv",
    url = "https://github.com/tpope/vim-dotenv"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-slime"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/vim-slime",
    url = "https://github.com/jpalardy/vim-slime"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  },
  ["vscode-js-debug"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/rossmurphy/.local/share/nvim/site/pack/packer/opt/vscode-js-debug",
    url = "https://github.com/microsoft/vscode-js-debug"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\5\0006\3\0\0'\5\3\0B\3\2\0029\3\4\3B\3\1\2=\3\6\2B\0\2\1K\0\1\0\rpre_hook\1\0\0\20create_pre_hook7ts_context_commentstring.integrations.comment_nvim\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\28etovxqpdygfblzhckisuran\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: nvim-window-picker
time([[Config for nvim-window-picker]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\3\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\t\3=\3\v\2B\0\2\1K\0\1\0\17filter_rules\1\0\0\abo\fbuftype\1\3\0\0\rterminal\rquickfix\rfiletype\1\0\0\1\4\0\0\rneo-tree\19neo-tree-popup\vnotify\1\0\2\19autoselect_one\2\24include_current_win\1\nsetup\18window-picker\frequire\0", "config", "nvim-window-picker")
time([[Config for nvim-window-picker]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n� \0\0\b\0x\0�\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0005\3\6\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\t\0005\3\n\0B\0\3\0016\0\v\0'\2\f\0B\0\2\0029\0\r\0005\2\14\0005\3\15\0=\3\16\0025\3\18\0005\4\17\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\0035\4\29\0005\5\28\0=\5\30\4=\4\31\0035\4 \0=\4!\0035\4\"\0=\4#\0035\4$\0=\4%\0035\4&\0=\4'\0035\4(\0=\4)\3=\3*\0024\3\0\0=\3+\0025\3,\0005\4-\0=\4.\0035\0040\0005\5/\0=\0051\0045\0052\0005\0063\0=\0064\5=\0055\0045\0056\0005\0067\0=\0064\5=\0058\4=\0049\3=\3:\0024\3\0\0=\3;\0025\3D\0005\4<\0004\5\0\0=\5=\0044\5\0\0=\5>\0045\5?\0=\5@\0045\5A\0=\5B\0044\5\0\0=\5C\4=\4E\0035\4F\0=\4G\0035\4Z\0005\5H\0005\6I\0005\aJ\0=\a4\6=\6K\0055\6L\0=\6M\0055\6N\0=\6O\0055\6P\0=\6Q\0055\6R\0=\6S\0055\6T\0=\6U\0055\6V\0=\6W\0055\6X\0=\6Y\5=\0059\0045\5[\0=\5\\\4=\4:\0034\4\0\0=\4+\3=\3]\0025\3_\0005\4^\0=\4G\0035\4i\0005\5`\0005\6a\0005\ab\0=\a4\6=\6K\0055\6c\0=\6M\0055\6d\0=\6O\0055\6e\0=\6S\0055\6f\0=\6U\0055\6g\0=\6W\0055\6h\0=\6Y\5=\0059\4=\4:\3=\3j\0025\3u\0005\4k\0005\5l\0005\6m\0005\an\0=\a4\6=\6K\0055\6o\0=\6M\0055\6p\0=\6O\0055\6q\0=\6S\0055\6r\0=\6U\0055\6s\0=\6W\0055\6t\0=\6Y\5=\0059\4=\4:\3=\3\31\2B\0\2\0016\0\0\0009\0v\0'\2w\0B\0\2\1K\0\1\0#nnoremap \\ :Neotree reveal<cr>\bcmd\1\0\0\1\2\1\0\18order_by_type\vnowait\1\1\2\1\0\18order_by_size\vnowait\1\1\2\1\0\18order_by_name\vnowait\1\1\2\1\0\22order_by_modified\vnowait\1\1\2\1\0\25order_by_diagnostics\vnowait\1\1\2\1\0\21order_by_created\vnowait\1\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\a\aga\17git_add_file\agp\rgit_push\6A\16git_add_all\agg\24git_commit_and_push\agc\15git_commit\agr\20git_revert_file\agu\21git_unstage_file\1\0\1\rposition\nfloat\fbuffers\1\0\0\1\2\1\0\18order_by_type\vnowait\1\1\2\1\0\18order_by_size\vnowait\1\1\2\1\0\18order_by_name\vnowait\1\1\2\1\0\22order_by_modified\vnowait\1\1\2\1\0\25order_by_diagnostics\vnowait\1\1\2\1\0\21order_by_created\vnowait\1\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\3\abd\18buffer_delete\t<bs>\16navigate_up\6.\rset_root\1\0\2\18show_unloaded\2\21group_empty_dirs\2\1\0\2\20leave_dirs_open\1\fenabled\2\15filesystem\26fuzzy_finder_mappings\1\0\4\n<C-p>\19move_cursor_up\n<C-n>\21move_cursor_down\t<up>\19move_cursor_up\v<down>\21move_cursor_down\1\0\0\aot\1\2\1\0\18order_by_type\vnowait\1\aos\1\2\1\0\18order_by_size\vnowait\1\aon\1\2\1\0\18order_by_name\vnowait\1\aom\1\2\1\0\22order_by_modified\vnowait\1\aog\1\2\1\0\24order_by_git_status\vnowait\1\aod\1\2\1\0\25order_by_diagnostics\vnowait\1\aoc\1\2\1\0\21order_by_created\vnowait\1\6o\1\0\2\ntitle\rOrder by\15prefix_key\6o\1\2\1\0\14show_help\vnowait\1\1\0\n\t<bs>\16navigate_up\a]g\22next_git_modified\6#\17fuzzy_sorter\6f\21filter_on_submit\6/\17fuzzy_finder\6D\27fuzzy_finder_directory\6H\18toggle_hidden\6.\rset_root\n<c-x>\17clear_filter\a[g\22prev_git_modified\24follow_current_file\1\0\2\20leave_dirs_open\1\fenabled\1\19filtered_items\1\0\3\27use_libuv_file_watcher\1\21group_empty_dirs\1\26hijack_netrw_behavior\17open_default\26never_show_by_pattern\15never_show\1\3\0\0\14.DS_Store\14thumbs.db\16always_show\1\3\0\0\16.gitignored\15.gitignore\20hide_by_pattern\17hide_by_name\1\0\4\18hide_dotfiles\2\fvisible\1\16hide_hidden\2\20hide_gitignored\2\18nesting_rules\vwindow\rmappings\6a\1\0\1\14show_path\tnone\1\2\0\0\badd\6P\vconfig\1\0\2\14use_float\2\19use_image_nvim\2\1\2\0\0\19toggle_preview\f<space>\1\0\24\6t\16open_tabnew\6q\17close_window\6A\18add_directory\6y\22copy_to_clipboard\6S\15open_split\18<2-LeftMouse>\topen\t<cr>\topen\6c\tcopy\6d\vdelete\6r\vrename\6x\21cut_to_clipboard\6w\28open_with_window_picker\6C\15close_node\6s\16open_vsplit\6<\16prev_source\6>\16next_source\6z\20close_all_nodes\6i\22show_file_details\6?\14show_help\6p\25paste_from_clipboard\6l\18focus_preview\6m\tmove\6R\frefresh\n<esc>\vcancel\1\2\1\0\16toggle_node\vnowait\1\20mapping_options\1\0\2\vnowait\2\fnoremap\2\1\0\2\nwidth\3(\rposition\tleft\rcommands\30default_component_configs\19symlink_target\1\0\1\fenabled\1\fcreated\1\0\2\19required_width\3n\fenabled\2\18last_modified\1\0\2\19required_width\3X\fenabled\2\ttype\1\0\2\19required_width\3z\fenabled\2\14file_size\1\0\2\19required_width\3@\fenabled\2\15git_status\fsymbols\1\0\0\1\0\t\14untracked\b\rconflict\b\fignored\b\rmodified\b\runstaged\t󰄱\fdeleted\b✖\frenamed\t󰁕\vstaged\b\nadded\b✚\tname\1\0\3\19trailing_slash\1\26use_git_status_colors\2\14highlight\20NeoTreeFileName\rmodified\1\0\2\vsymbol\b[+]\14highlight\20NeoTreeModified\ticon\1\0\5\17folder_empty\t󰜌\14highlight\20NeoTreeFileIcon\16folder_open\b\18folder_closed\b\fdefault\6*\vindent\1\0\t\fpadding\3\1\23last_indent_marker\b└\23expander_highlight\20NeoTreeExpander\18indent_marker\b│\17with_markers\2\16indent_size\3\2\23expander_collapsed\b\14highlight\24NeoTreeIndentMarker\22expander_expanded\b\14container\1\0\0\1\0\1\26enable_character_fade\2$open_files_do_not_replace_types\1\4\0\0\rterminal\ftrouble\aqf\1\0\6\22enable_git_status\2\23popup_border_style\frounded\25close_if_last_window\1\"enable_normal_mode_for_inputs\1\26sort_case_insensitive\1\23enable_diagnostics\2\nsetup\rneo-tree\frequire\1\0\2\vtexthl\23DiagnosticSignHint\ttext\t󰌵\23DiagnosticSignHint\1\0\2\vtexthl\23DiagnosticSignInfo\ttext\t \23DiagnosticSignInfo\1\0\2\vtexthl\23DiagnosticSignWarn\ttext\t \23DiagnosticSignWarn\1\0\2\vtexthl\24DiagnosticSignError\ttext\t \24DiagnosticSignError\16sign_define\afn\bvim\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'DBUIAddConnection', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUIAddConnection', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUIAddConnection ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DBUIFindBuffer', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUIFindBuffer', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUIFindBuffer ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DBUI', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUI', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUI ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DBUIToggle', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUIToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUIToggle ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType plsql ++once lua require("packer.load")({'vim-dadbod-completion'}, { ft = "plsql" }, _G.packer_plugins)]]
vim.cmd [[au FileType sql ++once lua require("packer.load")({'vim-dadbod-completion'}, { ft = "sql" }, _G.packer_plugins)]]
vim.cmd [[au FileType mysql ++once lua require("packer.load")({'vim-dadbod-completion'}, { ft = "mysql" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
