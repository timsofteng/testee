---@class Issue
---@field msg string
---@field path string
---@field lineno number
---@field test_name string

---@class Runner
---@field cmd TestCmd
---@field parser ParserFunc
---@field visual_parser ParserFunc

---@class TestCmd
---@field project string[]
-- e.g TestifySuite
---@field scope? string[]
---@field file string[]
-- test of function or subtest of function
---@field unit string[]

---@alias ErrorsHub "quickfix"

---@alias TestScope "project" | "file" | "unit"

---@alias ParserFunc fun(out: string):Issue[]

---@alias VisualOutputFunc fun(cmd: string[])

---@class VisualOutput
---@field terminal VisualOutputFunc
---@field tmux VisualOutputFunc
