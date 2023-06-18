local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Don't auto commenting new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor location when file is opened
autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
        vim.cmd('let g:indentLine_conceallevel = 0')
    end
})

autocmd({ "BufWritePre" }, {
    pattern = { "*.py", "*.tf", "*.tfvars" },
    callback = function()
        vim.lsp.buf.format { async = true }
    end,
})

local function on_attach(client, bufnr)
    -- Find the clients capabilities
    local cap = client.resolved_capabilities
    if cap.document_highlight then
        vim.cmd([[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]])
        vim.cmd([[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
        vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]) 
    end
end

