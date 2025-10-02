local T = {}

function T.foo()
	vim.notify("Hello, World!", vim.log.levels.INFO)
end

---@class Cfg
---@field output "terminal" | "tmux"

---@type Cfg
local cfg = {
	output = "terminal",
}

---@alias VisualOutputFunc fun(cmd: string)

---@class VisualOutput
---@field terminal VisualOutputFunc
---@field tmux VisualOutputFunc

---@type VisualOutput
local visual_output = {
	terminal = function(cmd)
		vim.cmd("terminal " .. cmd)
		vim.cmd("startinsert")
	end,
	tmux = function(cmd)
		-- TODO add code
	end,
}

---@class TestCmd
---@field project string
-- e.g TestifySuite
---@field scope? string
---@field file string
-- test of function or subtest of function
---@field unit string

---@class Runner
---@field cmd TestCmd
---@field visualCmd TestCmd

---@return string
local function go_get_unit_ctx()
	-- TODO add treesitter
	return "test"
end

--- @param path string
--- @return Runner
local function get_go_runner(path)
	--- @type TestCmd
	local cmd = {
		project = "go test ./... -json",
		file = "go test ./" .. path .. " -json",
		unit = "go test ./" .. go_get_unit_ctx() .. " -json",
	}

	--- @type Runner
	local runner = {
		cmd = cmd,
		visualCmd = cmd,
	}

	return runner
end

---@param ft string
---@return Runner
local function get_runner(ft)
	local file_path = vim.fn.expand("%:p")

	local langs = {
		go = get_go_runner(file_path),
	}

	return langs[ft]
end

---@param method string
local function main(method)
	local ft = vim.bo.filetype

	local runner = get_runner(ft)

	visual_output.terminal(runner.visualCmd[method])
end

return {
	main = main,
}
