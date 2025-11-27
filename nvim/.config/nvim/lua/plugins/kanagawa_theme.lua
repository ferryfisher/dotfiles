local italic = { italic = true }


return {
    "rebelot/kanagawa.nvim",

    opts = {
        commentStyle = italic,
        keywordStyle = italic,
        statementStyle = { bold = false },
        compile = true, -- do :KanagawaCompile after modifying theme and restarting
        transparent = true,
        terminalcolors = true,

        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "NONE"
                    }
                }
            }
        },

        overrides = function(colors)
            local c = require("kanagawa.lib.color")

            local theme = colors.theme
            local diag = theme.diag
            local ui = theme.ui

            local function makeDiagnosticColor(color)
                return { fg = color, bg = c(color):blend(ui.bg, 0.95):to_hex() }
            end

            -- add `blend = vim.o.pumblend` to enable transparency
            return {
                ColorColumn                = { link = "CursorLine" },
                CursorLine                 = { bg = ui.bg_p1 },
                CursorLineNr               = {
                    bold = false,
                    link = "CursorLine",
                    fg = ui.fg
                },
                DiagnosticVirtualTextHint  = makeDiagnosticColor(diag.hint),
                DiagnosticVirtualTextInfo  = makeDiagnosticColor(diag.info),
                DiagnosticVirtualTextWarn  = makeDiagnosticColor(diag.warning),
                DiagnosticVirtualTextError = makeDiagnosticColor(diag.error),
                FloatBorder                = { bg = "NONE" },
                FloatTitle                 = { bg = "NONE" },
                IndentLine                 = { fg = ui.whitespace },
                IndentLineCurrent          = { fg = ui.special },
                LineNr                     = { fg = theme.syn.comment },
                LazyNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                NormalFloat                = { bg = "NONE" },
                Pmenu                      = { fg = ui.shade0, bg = ui.bg_dim },
                PmenuKind                  = { fg = ui.shade0, bg = ui.bg_dim },
                PmenuExtra                 = { fg = ui.shade0, bg = ui.bg_dim },
                PmenuSel                   = { fg = "NONE", bg = ui.bg_reverse },
                PmenuKindSel               = { fg = "NONE", bg = ui.bg_reverse },
                PmenuExtraSel              = { fg = "NONE", bg = ui.bg_reverse },
                PmenuSbar                  = { bg = ui.bg_m1 },
                PmenuThumb                 = { bg = ui.bg_p1 },
                WinSeparator               = { fg = theme.syn.comment, bg = "NONE" },
            }
        end
    },
}
