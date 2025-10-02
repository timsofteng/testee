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
local function runner(path)
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

return {
	runner = runner,
}
