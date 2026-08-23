local flake = "(builtins.getFlake (toString ./.))"

vim.lsp.config("nixd", {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },

    settings = {
        nixd = {
            formatting = { command = { "nixfmt" } },
            nixpkgs = { expr = "import " .. flake .. ".inputs.nixpkgs { }" },
            options = {
                nix_darwin = { expr = flake .. ".darwinConfigurations.rho.options" },
            },
        },
    },
})
