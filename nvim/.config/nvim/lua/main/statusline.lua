-- Modified https://github.com/nvimdev/modeline.nvim

local api, lsp, diagnostic = vim.api, vim.lsp, vim.diagnostic
local fnamemodify = vim.fn.fnamemodify

local str_format = string.format

local function stl_progress()
    local spinner = { "⣶", "⣧", "⣏", "⡟", "⠿", "⢻", "⣹", "⣼" }
    local idx = 1
    return {
        stl = function(args)
            if args.data and args.data.params then
                local val = args.data.params.value
                if val.message and val.kind ~= "end" then
                    idx = idx + 1 > #spinner and 1 or idx + 1
                    return str_format("  %s", spinner[idx - 1 > 0 and idx - 1 or 1])
                end
            end
            return ""
        end,
        name = "LspProgress",
        event = { "LspProgress" },
        attr = { link = "Type" },
    }
end

local function stl_lsp()
    return {
        stl = function(args)
            local clients = lsp.get_clients({ bufnr = -1 })
            if #clients == 0 then
                return ""
            end
            local root_dir = "single"
            local client_names = vim
                .iter(clients)
                :map(function(client)
                    if args.event == "LspDetach" and client.id == args.data.client_id then
                        return nil
                    end

                    if client.root_dir then
                        root_dir = client.root_dir
                    end
                    return str_format("%d_%s", client.id, client.name)
                end)
                :totable()

            local msg = str_format("[%s:%s]",
                root_dir ~= "single" and fnamemodify(root_dir, ":t") or "single",
                table.concat(client_names, ",")
            )
            if args.data and args.data.params then
                local val = args.data.params.value
                if val.message and val.kind ~= "end" then
                    msg = str_format("%s %s", val.title, (val.percentage and val.percentage .. "%" or ""))
                end
            end
            return "  %-20s" .. msg
        end,
        name = "Lsp",
        event = { "LspProgress", "LspAttach", "LspDetach", "BufEnter" },
    }
end

local function stl_gitinfo()
    local alias = { "Head", "Add", "Change", "Delete" }
    for i = 2, 4 do
        local color = api.nvim_get_hl(0, { name = "Diff" .. alias[i] })
        api.nvim_set_hl(0, "Git" .. alias[i], { fg = color.bg })
    end
    return {
        stl = function()
            return coroutine.create(function(pieces, idx)
                local signs = { "Git:", "+", "~", "-" }
                local order = { "head", "added", "changed", "removed" }

                local ok, dict = pcall(api.nvim_buf_get_var, 0, "gitsigns_status_dict")

                if not ok or vim.tbl_isempty(dict) then
                    pieces[idx] = ""
                    return
                end

                if dict["head"] == "" then
                    local co = coroutine.running()
                    vim.system(
                        { "git", "config", "--get", "init.defaultBranch" },
                        { text = true },
                        function(result)
                            coroutine.resume(co, #result.stdout > 0 and vim.trim(result.stdout) or nil)
                        end
                    )
                    dict["head"] = coroutine.yield()
                end

                local parts = ""

                for i = 1, 4 do
                    local dict_idx = dict[order[i]]

                    if i == 1 or (type(dict_idx) == "number" and dict_idx > 0) then
                        parts = str_format("%s %s",
                            parts,
                            str_format("%%#Git%s#%s%%*", alias[i], signs[i] .. dict_idx)
                        )
                    end
                end

                pieces[idx] = parts
            end)
        end,
        async = true,
        name = "git",
        event = { "User GitSignsUpdate", "BufEnter" },
    }
end

local function stl_diagnostic()
    return {
        stl = function()
            if not vim.diagnostic.is_enabled({ bufnr = 0 }) or #lsp.get_clients({ bufnr = 0 }) == 0 then
                return ""
            end
            local t = {}
            for i = 1, 3 do
                local count = #diagnostic.get(0, { severity = i })
                t[#t + 1] = str_format("%%#Diagnostic%s#%s%%*", vim.diagnostic.severity[i], count)
            end
            return str_format(" [%s]", table.concat(t, " "))
        end,
        cond = function()
            return tonumber(vim.fn.pumvisible()) == 0
        end,
        event = { "DiagnosticChanged", "BufEnter", "LspAttach", "LspDetach" },
    }
end

-- Implementation
local co, iter = coroutine, vim.iter
local hl = api.nvim_set_hl

local function stl_format(name, val)
    return str_format("%%#Statusline%s#%s%%*", name, val)
end

local function default()
    local comps = {
        "%{&fileencoding=='utf-8'||&fileencoding==''?'U':&fileencoding=='latin1'?'1':'-'}",
        "%{&encoding=='utf-8'?'U':''}",
        "%{&fileformat=='dos'?'\\\\':&fileformat=='mac'?'/':':'}",
        "%{&readonly?(&modified?'%*':'%%'):(&modified?'**':'--')}-",
        '  T%{tabpagenr()} ',
        '%#statusline#%< %{expand("%:h:t")}/%t', -- file name
        stl_progress(),
        stl_lsp(),
        stl_gitinfo(),
        '%=%=',
        [[%{(bufname() !=# '' && &bt != 'terminal' ? '(' : '')}]],
        "%{ (&ft == 'cpp' ? 'C++' : toupper(strpart(&ft, 0, 1)) . strpart(&ft, 1)) }",
        stl_diagnostic(),
        [[%{(bufname() !=# '' && &bt != 'terminal' ? ')' : '')}]],
        "  %P (%{printf('0x%03X, 0x%03X', line('.'), col('.'))})",
    }

    local e, pieces = {}, {}
    iter(next, (comps))
        :map(function(key, item)
            if type(item) == "string" then
                pieces[#pieces + 1] = item
            elseif type(item.stl) == "string" then
                pieces[#pieces + 1] = stl_format(item.name, item.stl)
            else
                pieces[#pieces + 1] = item.default and stl_format(item.name, item.default) or ""
                for _, event in next, item.event do
                    e[event] = e[event] or {}
                    e[event][#e[event] + 1] = key
                end
            end
            if item.attr and item.name then
                hl(0, str_format("Git%s", item.name), item.attr)
            end
        end)
        :totable()
    return comps, e, pieces
end

local function render(comps, events, pieces)
    return co.create(function(args)
        while true do
            local event = args.event == "User" and str_format("%s %s", args.event, args.match) or args.event
            for _, idx in next, (events[event]) do
                if comps[idx].cond and comps[idx].cond() == false then
                    goto continue
                end
                if comps[idx].async then
                    local child = comps[idx].stl()
                    coroutine.resume(child, pieces, idx)
                else
                    pieces[idx] = stl_format(comps[idx].name, comps[idx].stl(args))
                end
                ::continue::
            end

            vim.opt.stl = table.concat(pieces)
            args = co.yield()
        end
    end)
end

local comps, events, pieces = default()
local stl_render = render(comps, events, pieces)
local stl_group = api.nvim_create_augroup("statusline", {})

iter(vim.tbl_keys(events)):map(function(e)
    local tmp = e
    local pattern
    if e:find("User") then
        pattern = vim.split(e, "%s")[2]
        tmp = "User"
    end
    api.nvim_create_autocmd(tmp, {
        pattern = pattern,
        group = stl_group,
        callback = function(args)
            vim.schedule(function()
                local ok, res = co.resume(stl_render, args)
                if not ok then
                    vim.notify("[statusline] render failed " .. res, vim.log.levels.ERROR)
                end
            end)
        end,
    })
end)
