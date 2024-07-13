---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        "dist",
        "node_modules",
        "pnpm-lock.yaml",
      },
    },
  }
}
