vim.api.nvim_create_user_command('TesteeFile', function()
  require('testee').main("file")
end, { desc = "test file" })
