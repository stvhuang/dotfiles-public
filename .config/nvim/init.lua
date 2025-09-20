local blinkcmp_fuzzy_implementation = "prefer_rust_with_warning" -- prefer_rust_with_warning, prefer_rust, rust, lua

vim.api.nvim_set_keymap("", "<space>", "<leader>", { noremap = false, silent = true })

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.breakindent = true
vim.o.colorcolumn = "80,100,120" -- TODO: replace string with table, https://github.com/neovim/neovim/issues/20107
vim.o.confirm = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.mouse = "a"
vim.o.mousefocus = true
vim.o.number = true
vim.o.pumheight = 20
vim.o.scrolloff = 4
vim.o.showbreak = "↪ "
vim.o.showmode = false
vim.o.signcolumn = "number"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smoothscroll = true
vim.o.splitbelow = true
vim.o.splitkeep = "topline"
vim.o.splitright = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undofile = true
vim.opt.shortmess = { -- TODO: replace vim.opt with vim.o, https://github.com/neovim/neovim/issues/20107
    A = true,
    F = true,
    I = true,
    O = true,
    T = true,
    W = true,
    a = true,
    c = true,
    o = true,
    s = true,
    t = true,
}

-- tab (https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd)
vim.o.expandtab = true
vim.o.softtabstop = -1

-- list and listchars
vim.o.list = true
vim.opt.listchars = { -- TODO: replace vim.opt with vim.o
    eol = "↵",
    extends = "›",
    nbsp = "␣",
    precedes = "‹",
    space = "·",
    tab = "<->",
    trail = "•",
}

-- grep and grepformat
if vim.fn.executable("rg") == 1 then
    vim.o.grepprg = "rg --hidden --smart-case --vimgrep"
    vim.opt.grepformat:append("%f:%l:%c:%m") -- TODO: replace vim.opt with vim.o
end

-- file types
vim.filetype.add({
    extension = {
        mkshrc = "sh",
        shrc = "sh",
    },
})

vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.undotree")
vim.pack.add({
    -- { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/barrettruth/canola.nvim", version = "canola" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvimtools/hydra.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("v1.x") },
    { src = "https://github.com/stevearc/aerial.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/stvhuang/memo.nvim" },
    { src = "https://github.com/yorickpeterse/nvim-jump" },
    -- colorscheme
    { src = "https://github.com/oskarnurm/koda.nvim" },
    { src = "https://github.com/savq/melange-nvim" },
})

-- UI2 (:h ui2)
-- https://www.reddit.com/r/neovim/comments/1sa95g4/no_more_press_enter_with_ui2_with_example/
require("vim._core.ui2").enable({
    enable = true,
    msg = {
        targets = {
            [""] = "msg",
            bufwrite = "msg",
            completion = "cmd",
            confirm = "cmd",
            echo = "msg",
            echoerr = "pager",
            echomsg = "msg",
            empty = "cmd",
            emsg = "pager",
            list_cmd = "pager",
            lua_error = "pager",
            lua_print = "msg",
            progress = "pager",
            quickfix = "msg",
            rpc_error = "pager",
            search_cmd = "cmd",
            search_count = "cmd",
            shell_cmd = "pager",
            shell_err = "pager",
            shell_out = "pager",
            shell_ret = "msg",
            typed_cmd = "cmd",
            undo = "msg",
            verbose = "pager",
            wildlist = "cmd",
            wmsg = "msg",
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.5,
            timeout = 4000,
        },
        pager = {
            height = 1,
        },
    },
})

-- lsp
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    },
})
vim.lsp.enable({
    "clangd",
    "copilot",
    "lua_ls",
    "ruff",
    "tinymist",
    "tombi",
    "ts_ls",
    "ty",
    "typos_lsp",
})
-- vim.lsp.inline_completion.enable()
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client_id = vim.lsp.get_client_by_id(ev.data.client_id)
        if client_id then
            vim.notify("[LSP] " .. client_id.name .. ": attached", vim.log.levels.INFO)
            if client_id.server_capabilities.semanticTokensProvider ~= nil then
                vim.notify("[LSP] " .. client_id.name .. ": semantic token disabled", vim.log.levels.INFO)
                client_id.server_capabilities.semanticTokensProvider = nil
            end
        end
    end,
})

-- barrettruth/canola.nvim
vim.g.canola = {
    columns = {
        "type",
        "permissions",
        "size",
        "ctime",
        "mtime",
        "atime",
    },
    sort = {
        by = { { "type", "asc" }, { "name", "asc" } },
        ignore_case = true,
        natural = true,
    },
    view_options = {
        show_hidden = true,
    },
}

-- ibhagwan/fzf-lua
local fzf_lua_profile = "default"
if vim.fn.executable("sk") == 1 then
    fzf_lua_profile = "skim"
    vim.notify("[FZF] using skim as backend.", vim.log.levels.INFO)
end
require("fzf-lua").setup({
    fzf_lua_profile,
    defaults = {
        file_icons = false,
    },
    winopts = {
        border = "single", -- :h winborder
        height = 0.95,
        preview = {
            border = "single", -- :h winborder
        },
        width = 0.9,
    },
})

-- nvim-lualine/lualine.nvim
require("lualine").setup({
    options = {
        always_divide_middle = false,
        component_separators = {
            left = "¦",
            right = "¦",
        },
        globalstatus = true,
        icons_enabled = false,
        section_separators = {
            left = " ",
            right = " ",
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "diagnostics", sources = { "nvim_diagnostic" } }, { "filename", path = 1 } },
        lualine_x = { "searchcount", "lsp_status", "encoding", "fileformat", "filetype", "filesize" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
    },
    tabline = {
        lualine_a = { { "buffers", show_filename_only = false, mode = 2 } },
        lualine_z = { { "tabs", mode = 0 } },
    },
})

-- nvim-mini/mini.nvim
require("mini.cursorword").setup({
    delay = 0,
})
require("mini.diff").setup({
    view = {
        delay = {
            text_change = 0,
        },
    },
})
local mini_hipatterns = require("mini.hipatterns")
mini_hipatterns.setup({
    highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    },
})
require("mini.surround").setup({})

-- nvimtools/hydra.nvim (moved to bottom of the file)

-- saghen/blink.cmp
package.loaded["blinkcmp_source_copilot"] = (function()
    -- adapter that converts Copilot's `textDocument/inlineCompletion` responses into standard CompletionItem objects for blink.cmp's completion menu.
    -- injected into package.loaded so blink.cmp can require() it without a separate file.
    local M = {}
    function M.new()
        return setmetatable({}, { __index = M })
    end
    function M:get_completions(ctx, callback)
        local clients = vim.lsp.get_clients({ name = "copilot", bufnr = ctx.bufnr })
        if #clients == 0 then
            callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = {} })
            return function() end
        end
        local client = clients[1]
        local row, col = ctx.cursor[1] - 1, ctx.cursor[2]
        local params = {
            textDocument = vim.lsp.util.make_text_document_params(ctx.bufnr),
            position = { line = row, character = col },
            context = { triggerKind = 2 },
        }
        local ok, req_id = client:request("textDocument/inlineCompletion", params, function(err, result)
            if err or not result then
                callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = {} })
                return
            end
            local raw = vim.islist(result) and result or (result.items or {})
            local items = {}
            for i, item in ipairs(raw) do
                local text = type(item.insertText) == "table" and item.insertText.value or item.insertText
                if text and #text > 0 then
                    local label = text:match("^([^\n]*)") or text
                    if #label > 60 then
                        label = label:sub(1, 57) .. "..."
                    end
                    local range = item.range
                        or {
                            start = { line = row, character = col },
                            ["end"] = { line = row, character = col },
                        }
                    table.insert(items, {
                        label = label,
                        kind = vim.lsp.protocol.CompletionItemKind.Text,
                        sortText = string.format("%03d", i),
                        insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
                        textEdit = { range = range, newText = text },
                    })
                end
            end
            callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
        end)
        if ok and req_id then
            return function()
                client:cancel_request(req_id)
            end
        end
        return function() end
    end
    return M
end)()
require("blink.cmp").setup({
    appearance = {
        use_nvim_cmp_as_default = true,
    },
    completion = {
        accept = {
            auto_brackets = {
                enabled = false,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 10,
            treesitter_highlighting = true,
        },
        ghost_text = {
            enabled = true,
        },
        keyword = {
            range = "full",
        },
        list = {
            selection = {
                auto_insert = function(ctx)
                    return ctx.mode ~= "cmdline"
                end,
                preselect = function(ctx)
                    return ctx.mode ~= "cmdline"
                end,
            },
        },
        menu = {
            auto_show = true,
            draw = {
                columns = {
                    { "label", "label_description" },
                    { "kind" },
                    { "source_name" },
                },
                gap = 1,
            },
        },
    },
    fuzzy = { implementation = blinkcmp_fuzzy_implementation },
    keymap = {
        ["<tab>"] = { "select_next", "fallback" },
        ["<s-tab>"] = { "select_prev", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
    },
    signature = { enabled = true },
    sources = {
        default = {
            "copilot",
            "buffer",
            "lsp",
            "path",
            "snippets",
        },
        providers = {
            copilot = {
                async = true,
                module = "blinkcmp_source_copilot", -- see `package.loaded["blinkcmp_source_copilot"]` above for implementation
                name = "Copilot",
                score_offset = 100,
            },
        },
    },
})

-- nvim-treesitter/nvim-treesitter
if not vim.fn.executable("tree-sitter") == 1 then
    vim.notify("[TS]: CLI is not installed.", vim.log.levels.WARN)
end
local treesitter_filetypes = {
    "awk",
    "bash",
    "bibtex",
    "c",
    "cmake",
    "comment",
    "commonlisp",
    "cpp",
    "css",
    "csv",
    "cuda",
    "diff",
    "dockerfile",
    "editorconfig",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gpg",
    "html",
    "http",
    "ini",
    "java",
    "javascript",
    "jinja",
    "jinja_inline",
    "jq",
    "json",
    "json5",
    "latex",
    "ledger",
    "llvm",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "ninja",
    "ocaml",
    "perl",
    "proto",
    "python",
    "regex",
    "requirements",
    "rst",
    "rust",
    "scheme",
    "sql",
    "ssh_config",
    "teal",
    "tmux",
    "todotxt",
    "toml",
    "tsv",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zsh",
}
require("nvim-treesitter").install(treesitter_filetypes)
vim.api.nvim_create_autocmd("FileType", {
    callback = function(_)
        vim.treesitter.start()
    end,
    pattern = treesitter_filetypes,
})

-- nvim-treesitter/nvim-treesitter-textobjects
require("nvim-treesitter-textobjects").setup({})
vim.keymap.set({ "o", "x" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "o", "x" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "o", "x" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "o", "x" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)

-- stevearc/aerial.nvim
require("aerial").setup({
    layout = {
        default_direction = "prefer_left",
        max_width = { 40 },
    },
})

-- stevearc/conform.nvim
require("conform").setup({
    format_on_save = { timeout_ms = 500 },
    formatters = {
        custom_shfmt = { args = { "-s", "-ln", "mksh", "-i", "2", "-filename", "$FILENAME" }, command = "shfmt" },
        custom_prettier = {
            args = { "--ignore-path", ".prettierignore", "--stdin-filepath", "$FILENAME" },
            command = "prettier",
        },
    },
    formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "custom_prettier" },
        cuda = { "clang-format" },
        fish = { "fish_indent" },
        html = { "custom_prettier" },
        javascript = { "custom_prettier" },
        json = { "custom_prettier" },
        ledger = { "hledger-fmt" },
        lua = { "stylua" },
        make = { "bake" },
        markdown = { "custom_prettier" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        sh = { "custom_shfmt" },
        sql = { "pg_format" },
        swift = { "swift_format" },
        toml = { "tombi" },
        typescript = { "custom_prettier" },
        typst = { "typstyle" },
        yaml = { "custom_prettier" },
    },
})

-- -- stevearc/oil.nvim
-- local columns = {
--     "type",
--     "permissions",
--     "size",
--     "ctime",
--     "mtime",
--     "atime",
-- }
-- local winbar = table.concat(columns, "    ")
-- require("oil").setup({
--     columns = columns,
--     view_options = {
--         show_hidden = true,
--     },
--     win_options = {
--         winbar = winbar,
--     },
-- })

-- stvhuang/memo.nvim
-- vim.opt.runtimepath:append("~/docs/memo.nvim")
require("memo").setup({
    path = "~/Google Drive/My Drive/_me/kiwi",
})

-- yorickpeterse/nvim-jump
require("jump").setup({
    label = "TermCursor", -- :hi to see available highlight groups
})
vim.keymap.set({ "n", "x", "o" }, "gs", require("jump").start, { desc = "jump.start" })

-- colorscheme
vim.cmd.colorscheme("melange")

-- use ctrl-h/j/k/l to move in command mode
vim.keymap.set({ "c" }, "<c-h>", "<left>", { desc = "<left>" })
vim.keymap.set({ "c" }, "<c-j>", "<down>", { desc = "<down>" })
vim.keymap.set({ "c" }, "<c-k>", "<up>", { desc = "<up>" })
vim.keymap.set({ "c" }, "<c-l>", "<right>", { desc = "<right>" })

-- yank and put to system clipboard
vim.keymap.set({ "x" }, "<leader>P", '"+p', { desc = "put text from clipboard" })
vim.keymap.set({ "x" }, "<leader>Y", '"+y', { desc = "yank text into clipboard" })
vim.keymap.set({ "x" }, "<leader>p", '"*p', { desc = "put text from clipboard" })
vim.keymap.set({ "x" }, "<leader>y", '"*y', { desc = "yank text into clipboard" })

-- move by display lines
vim.keymap.set({ "n" }, "U", vim.cmd.redo, { desc = "redo one change" })
vim.keymap.set({ "n" }, "j", function()
    return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "j" or "gj"
end, { expr = true, silent = true })
vim.keymap.set({ "n" }, "k", function()
    return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "k" or "gk"
end, { expr = true, silent = true })

-- autocmd
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function(_)
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
    desc = "restore cursor position",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function(_)
        vim.cmd.wincmd("L")
    end,
    desc = "open help files in right split",
    pattern = "help",
})

-- user command
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("MeInstallTreeSitterCLI", function()
    local version = "v0.26.8"

    local uname = vim.uv.os_uname()
    local sysname_map = {
        Darwin = "macos",
        -- Linux = "linux",
    }
    local sysname = sysname_map[uname.sysname]
    local machine_map = {
        -- aarch64 = "arm64",
        arm64 = "arm64",
        -- x64 = "x64",
        -- x86_64 = "x64",
    }
    local machine = machine_map[uname.machine]
    if not sysname or not machine then
        vim.notify(
            string.format("[TS] unsupported sysname/machine: %s/%s", uname.sysname, uname.machine),
            vim.log.levels.ERROR
        )
        return
    end
    vim.notify(string.format("[TS] detected sysname/machine: %s/%s", sysname, machine), vim.log.levels.INFO)

    local url = string.format(
        "https://github.com/tree-sitter/tree-sitter/releases/download/%s/tree-sitter-cli-%s-%s.zip",
        version,
        sysname,
        machine
    )

    local bin_dir = vim.env.HOME .. "/.local/bin"
    vim.fn.mkdir(bin_dir, "p")
    local tmp_zip = vim.fn.tempname() .. ".zip"

    vim.notify(string.format("[TS] downloading %s", url), vim.log.levels.INFO)
    vim.system({ "curl", "-fLsS", "-o", tmp_zip, url }, { text = true }, function(curl_result)
        if curl_result.code ~= 0 then
            vim.schedule(function()
                vim.notify("[TS] download failed: " .. (curl_result.stderr or ""), vim.log.levels.ERROR)
            end)
            return
        end

        vim.system({ "unzip", "-o", tmp_zip, "-d", bin_dir }, { text = true }, function(unzip_result)
            vim.schedule(function()
                vim.fn.delete(tmp_zip)
                if unzip_result.code ~= 0 then
                    vim.notify("[TS] unzip failed: " .. (unzip_result.stderr or ""), vim.log.levels.ERROR)
                    return
                end
                local bin_path = bin_dir .. "/tree-sitter"
                vim.system({ "chmod", "+x", bin_path }):wait()
                vim.notify(string.format("[TS] installed tree-sitter cli to %s", bin_path), vim.log.levels.INFO)
            end)
        end)
    end)
end, { desc = "Download and install tree-sitter CLI to ~/.local/bin" })

-- misc
local status_misc, _ = pcall(require, "misc")
if not status_misc then
    vim.notify("[*]: Failed to load misc.lua.", vim.log.levels.WARN)
end

-- disable built-in plugins
for _, plugin in pairs({
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logiPat",
    "matchit",
    "matchparen",
    "netrw",
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "remote_plugins",
    "rrhelper",
    "shada_plugin",
    "spellfile_plugin",
    "tar",
    "tarPlugin",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}) do
    vim.g["loaded_" .. plugin] = 1
end

-- nvimtools/hydra.nvim
local hydra = require("hydra")

hydra({
    body = "<leader>f",
    config = { hint = { type = "cmdline" }, invoke_on_body = true },
    mode = "n",
    name = "FZF",
    heads = {
        {
            "b",
            function()
                require("fzf-lua").buffers()
            end,
            { desc = "buffers", exit = true },
        },
        {
            "c",
            function()
                require("fzf-lua").commands()
            end,
            { desc = "commands", exit = true },
        },
        {
            "C",
            function()
                require("fzf-lua").command_history()
            end,
            { desc = "command_history", exit = true },
        },
        {
            "f",
            function()
                require("fzf-lua").files()
            end,
            { desc = "files", exit = true },
        },
        -- {
        --     "g",
        --     function()
        --         require("fzf-lua").live_grep()
        --     end,
        --     { desc = "live_grep", exit = true },
        -- },
        {
            "g",
            function()
                require("fzf-lua").live_grep_native()
            end,
            { desc = "live_grep_native", exit = true },
        },
        {
            "h",
            function()
                require("fzf-lua").helptags()
            end,
            { desc = "helptags", exit = true },
        },
        {
            "k",
            function()
                require("fzf-lua").keymaps()
            end,
            { desc = "keymaps", exit = true },
        },
        {
            "r",
            function()
                require("fzf-lua").registers()
            end,
            { desc = "registers", exit = true },
        },
        {
            "s",
            function()
                require("fzf-lua").search_history()
            end,
            { desc = "search_history", exit = true },
        },
    },
})

hydra({
    body = "<leader>j",
    config = { hint = { type = "cmdline" }, invoke_on_body = true },
    mode = "n",
    name = "MISC",
    heads = {
        {
            "a",
            function()
                require("aerial").toggle()
            end,
            { desc = "aerial", exit = true },
        },
        {
            "d",
            vim.diagnostic.setloclist,
            { desc = "diag.setlocallist", exit = true },
        },
        {
            "f",
            function()
                require("conform").format({ timeout_ms = 5000, async = true })
            end,
            { desc = "conform", exit = true },
        },
        {
            "k",
            function()
                -- require("kiwi").open_wiki_index("main")
                require("memo").open()
            end,
            { desc = "memo", exit = true },
        },
        {
            "u",
            function()
                require("undotree").open()
            end,
            { desc = "undotree.open", exit = true },
        },
        {
            "U",
            function()
                vim.pack.update()
            end,
            { desc = "vim.pack.update", exit = true },
        },
    },
})

hydra({
    body = "<leader>l",
    config = { hint = { type = "cmdline" }, invoke_on_body = true },
    mode = "n",
    name = "FZF LSP",
    heads = {
        {
            "a",
            function()
                require("fzf-lua").lsp_code_actions({ silent = true })
            end,
            { desc = "code_actions", exit = true },
        },
        {
            "d",
            function()
                require("fzf-lua").lsp_definitions()
            end,
            { desc = "defs", exit = true },
        },
        {
            "D",
            function()
                require("fzf-lua").lsp_declarations()
            end,
            { desc = "decs", exit = true },
        },
        {
            "i",
            function()
                require("fzf-lua").lsp_implementations()
            end,
            { desc = "impls", exit = true },
        },
        {
            "n",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            { desc = "diags_document", exit = true },
        },
        {
            "N",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            { desc = "diags_workspace", exit = true },
        },
        {
            "r",
            function()
                require("fzf-lua").lsp_references()
            end,
            { desc = "refs", exit = true },
        },
        {
            "R",
            function()
                vim.lsp.buf.rename()
            end,
            { desc = "rename", exit = true },
        },
    },
})

hydra({
    body = "<leader>w",
    config = { hint = { type = "cmdline" }, invoke_on_body = true },
    mode = "n",
    name = "WINDOW",
    heads = {
        -- swap
        { "w", "<c-w>w", { exit = true } },
        { "h", "<c-w>h", { exit = true } },
        { "j", "<c-w>j", { exit = true } },
        { "k", "<c-w>k", { exit = true } },
        { "l", "<c-w>l", { exit = true } },
        -- resize
        { "=", "<c-w>=", { desc = "height=width" } },
        { "K", "2<c-w>+", { desc = "+height" } },
        { "J", "2<c-w>-", { desc = "-height" } },
        { "L", "2<c-w>>", { desc = "+width" } },
        { "H", "2<c-w><", { desc = "-width" } },
    },
})
