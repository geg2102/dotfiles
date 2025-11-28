local M = {}

--- Toggle BasedPyright typeCheckingMode and inlay hints
function M.toggle_basedpyright_settings()
    -- Get the LSP client for basedpyright
    local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
    if not client then
        vim.notify("BasedPyright LSP is not active", vim.log.levels.WARN)
        return
    end

    -- Ensure settings structure exists
    if not client.config.settings then
        client.config.settings = {}
    end
    if not client.config.settings.basedpyright then
        client.config.settings.basedpyright = {}
    end
    if not client.config.settings.basedpyright.analysis then
        client.config.settings.basedpyright.analysis = {}
    end

    -- Get analysis settings
    local analysis = client.config.settings.basedpyright.analysis

    -- Toggle the typeCheckingMode
    if analysis.typeCheckingMode == "basic" then
        analysis.typeCheckingMode = "recommended"
    else
        analysis.typeCheckingMode = "basic"
    end

    -- Initialize inlayHints if it doesn't exist
    -- if not analysis.inlayHints then
    --     analysis.inlayHints = {
    --         variableTypes = true,
    --         functionReturnTypes = true,
    --         callArgumentNames = true
    --     }
    -- end

    -- Toggle the inlayHints settings
    local hints = analysis.inlayHints
    hints.variableTypes = not hints.variableTypes
    hints.functionReturnTypes = not hints.functionReturnTypes
    hints.callArgumentNames = not hints.callArgumentNames

    -- Restart the LSP to apply changes
    vim.lsp.stop_client(client.id)
    vim.defer_fn(function()
        vim.cmd("LspStart basedpyright")
        vim.notify(
            "BasedPyright restarted with typeCheckingMode: "
            .. analysis.typeCheckingMode
            .. "\nInlay Hints: "
            .. (hints.variableTypes and "enabled" or "disabled")
        )
    end, 100)
end

return M
