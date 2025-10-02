local T = {}

function T.foo()
	vim.notify("Hello, World!", vim.log.levels.INFO)
end

local visual_output = {
	terminal = function(cmd)
		vim.cmd("terminal " .. cmd)
		vim.cmd("startinsert")
	end,
}

function T.run()
	local file = vim.fn.expand("%:p")
	local cmd = "go test " .. file .. " -v"

	visual_output.terminal(cmd)
end

return T
