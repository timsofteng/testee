vim.api.nvim_create_user_command('TesteeFile', function()
  require('testee').run("file")
end, { desc = "test for testee" })
