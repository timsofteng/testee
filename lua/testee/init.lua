---@class Cfg
---@field output "terminal" | "tmux"

---@alias VisualOutputFunc fun(cmd: string[])
---@alias ParserFunc fun(out: string):Issue[]

---@class VisualOutput
---@field terminal VisualOutputFunc
---@field tmux VisualOutputFunc

---@type VisualOutput
local visual_output = {
	terminal = function(cmd)
		local strCmd = table.concat(cmd, " ")
		vim.cmd("terminal " .. strCmd)
		vim.cmd("startinsert")
	end,
	tmux = function(_)
		-- TODO add code
	end,
}

---@param ft string
---@param file_path string
---@return Runner
local function get_runner(ft, file_path)
	local langs = {
		go = require("go").runner(file_path),
	}

	return langs[ft]
end

local function add_to_qf(issues)
	local qf_list = {}
	for _, issue in ipairs(issues) do
		table.insert(qf_list, {
			filename = issue.path,
			lnum = issue.lineno,
			text = issue.msg .. " (" .. issue.test_name .. ")",
			type = "E",
		})
	end

	vim.fn.setqflist(qf_list, "r")

	vim.cmd("copen")
end

---@param out vim.SystemCompleted
---@param out_method "quickfix"
---@param parser ParserFunc
local function handle_output(out, out_method, parser)
	if out.code == 0 then
		vim.notify("All tests success", vim.log.levels.INFO)
		return
	else
		vim.notify("Errors", vim.log.levels.ERROR)
		local issues = parser(out.stderr)

		if out_method == "quickfix" then
			add_to_qf(issues)
		end
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
