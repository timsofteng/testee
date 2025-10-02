vim.api.nvim_create_user_command('Testee', function()
  require('testee').run()
end, { desc = "test for testee" })
