vim.api.nvim_create_user_command('Testee', function()
  require('testee').foo()
end, { desc = "test for testee" })
