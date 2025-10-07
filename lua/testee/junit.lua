local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

-- Создаем обработчик для преобразования XML в Lua-таблицу
local handler = handler:new()
local parser = xml2lua.parser(handler)

local function parse_xml(xml_str)
	-- Парсинг XML
	parser:parse(xml_str)

	-- Доступ к корневому элементу <testsuites>
	local testsuites = handler.root.testsuites.testsuite

	-- Обработка тестовых наборов
	for i, testsuite in ipairs(testsuites) do
		-- Извлечение атрибутов testsuite
		local suite_name = testsuite._attr.name
		local tests = testsuite._attr.tests
		local failures = testsuite._attr.failures
		local suite_time = testsuite._attr.time

		print(string.format("Test Suite: %s", suite_name))
		print(string.format("  Total Tests: %s", tests))
		print(string.format("  Failures: %s", failures))
		print(string.format("  Time: %s seconds", suite_time))

		-- Обработка тест-кейсов
		for j, testcase in ipairs(testsuite.testcase) do
			local test_name = testcase._attr.name
			local classname = testcase._attr.classname
			local test_time = testcase._attr.time

			print(string.format("    Test Case: %s (Class: %s)", test_name, classname))
			print(string.format("      Time: %s seconds", test_time))

			-- Проверка на наличие ошибок (failure)
			if testcase.failure then
				local failure_message = testcase.failure._attr.message
				local failure_type = testcase.failure._attr.type
				local failure_details = testcase.failure[1] or "No details"
				print(string.format("      Failure: %s (%s)", failure_message, failure_type))
				print(string.format("      Details: %s", failure_details))
			end
		end
		print("") -- Пустая строка для разделения наборов
	end
end
