local go = require("go")
---@type VisualOutput
local visual_writer = {
	terminal = function(cmd)
		local strCmd = table.concat(cmd, " ")
		vim.cmd("terminal " .. strCmd)
		vim.cmd("startinsert")
	end,
	tmux = function(_)
		-- TODO add code
	end,
}

---@param issues Issue[]
local function add_issues_to_qf(issues)
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

local function handle_test(proccess_hidden, proccess_visual)
	return function(out)
		if out.code == 0 then
			vim.notify("All tests success", vim.log.levels.INFO)
			return
		else
			vim.notify("Errors", vim.log.levels.ERROR)
			proccess_hidden(out.stderr)
			proccess_visual(out.stderr)
		end
	end
end

---@param filetype string
---@param filepath string
---@return Runner
local function get_runner(filetype, filepath)
	local langs = {
		go = require("go").runner(filepath),
	}

	return langs[filetype]
end

---@param method  TestScope
local function main(method)
	local ft = vim.bo.filetype
	local file_path = vim.fn.expand("%:p")

	local runner = get_runner(ft, file_path)
	local cmd = runner.cmd[method]
	local parser = runner.parser
	local visual_parser = runner.visual_parser

	vim.system(cmd, { text = true }, handle_test)

	visual_writer.terminal(visualCmd)
end

main("file")

return {
	main = main,
}
