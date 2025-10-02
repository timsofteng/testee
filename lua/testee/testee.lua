local M = {}

function M.foo()
  vim.notify("Hello, World!", vim.log.levels.INFO)
end

return M
