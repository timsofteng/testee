---@class Cfg
---@field output "terminal" | "tmux"

------@type Cfg
---local cfg = {
---	output = "terminal",
---}

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
	tmux = function(_)
		-- TODO add code
	end,
}

---@class TestCmd
---@field project string[]
-- e.g TestifySuite
---@field scope? string[]
---@field file string[]
-- test of function or subtest of function
---@field unit string[]

---@class Issue
---@field msg string
---@field path string
---@field lineno number
---@field test_name string

---@class Runner
---@field cmd TestCmd
---@field visualCmd TestCmd
---@field parser fun(str:string):TestCmd

---@return string
local function go_get_unit_ctx()
	-- TODO add treesitter
	return "test"
end

---@param json_lines string
---@return Issue[]
local function go_parser(json_lines)
	local issues_map = {}
	for line in json_lines do
		local ok, obj = pcall(vim.json.decode, line)
		if not ok then
			goto continue
		end

		local test_name = obj.Test

		local path, lineno = obj.Output:match("Error Trace:%s*(%S+):(%d+)")
		local msg = obj.Output:match("Error:%s*(.-)%s*\n")

		if not path or not msg then
			goto continue
		end

		issues_map[test_name] = issues_map[test_name] or {}
		issues_map[test_name].path = issues_map[test_name].path or path
		issues_map[test_name].lineno = issues_map[test_name].lineno or lineno
		issues_map[test_name].test_name = issues_map[test_name].test_name or test_name
		issues_map[test_name].msg = issues_map[test_name].msg or msg

		::continue::
	end

	local issues_array = {}
	for _, value in pairs(issues_map) do
		table.insert(issues_array, value)
	end

	return issues_array
end

--- @param path string
--- @return Runner
local function get_go_runner(path)
	--- @type TestCmd
	local cmd = {
		project = { "go", "test", "./...", "-json" },
		file = { "go", "test", path, "-json" },
		unit = { "go", "test", go_get_unit_ctx(), "-json" },
	}

	local visualCmd = {
		project = { "go", "test", "./..." },
		file = { "go", "test", path },
		unit = { "go", "test", go_get_unit_ctx() },
	}

	--- @type Runner
	local runner = {
		cmd = cmd,
		visualCmd = visualCmd,
		parser = go_parser,
	}

	return runner
end

---@param ft string
---@param file_path string
---@return Runner
local function get_runner(ft, file_path)
	local langs = {
		go = get_go_runner(file_path),
	}

	return langs[ft]
end

---@param out vim.SystemCompleted
local function handle_output(out)
	if out.code == 0 then
		print("Успех! Вывод команды:\n" .. (out.stdout or "пусто"))
	end
end

---@param method "project" | "file" | "unit"
local function main(method)
	local ft = vim.bo.filetype
	local file_path = vim.fn.expand("%:p")

	local runner = get_runner(ft, file_path)
	local cmd = runner.cmd[method]
	local visualCmd = runner.visualCmd[method]

	vim.system(cmd, { text = true }, handle_output)

	visual_output.terminal(visualCmd)
end

return {
	main = main,
}
