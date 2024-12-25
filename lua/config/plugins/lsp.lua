return {
  "neovim/nvim-lspconfig",
  dependencies = {
    'saghen/blink.cmp',
    {
      "folke/lazydev.nvim",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require("lspconfig").lua_ls.setup { capabilites = capabilities }
    -- format the current buffer on save
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf, -- listen on current buffer
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end
          })
        end
      end
    })
  end
}
