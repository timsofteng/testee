---@class Issue
---@field msg string
---@field path string
---@field lineno number
---@field test_name string

---@class Runner
---@field cmd TestCmd
---@field visualCmd TestCmd
---@field parser ParserFunc

---@class TestCmd
---@field project string[]
-- e.g TestifySuite
---@field scope? string[]
---@field file string[]
-- test of function or subtest of function
---@field unit string[]
