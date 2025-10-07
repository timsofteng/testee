local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local parser = xml2lua.parser(handler)

---@param xml_string string
---@return JUnitRoot
local function parse(xml_string)
	parser:parse(xml_string)
	---@type JUnitRoot
	return handler.root
end

return {
	parse = parse,
}
