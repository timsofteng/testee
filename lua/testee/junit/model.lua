--- @meta
--- This file defines type annotations for a parsed JUnit XML structure in Lua.
--- It uses LuaLS annotations to provide type safety for the resulting Lua table after parsing.
--- The structure is universal, supporting optional fields, arrays for multiple elements, and nested structures.
--- It assumes a parser like xml2lua that produces tables with '_attr' for attributes and '_text' for text content.
--- Usage: After parsing XML to a Lua table, annotate it as ---@type JUnitRoot
--- Example: local parsed = xml2lua.parse(xml_string) ---@type JUnitRoot

--- Attributes for the root <testsuites> element.
---@class TestsuitesAttr
---@field name string? Name of the entire test run
---@field tests integer? Total number of tests
---@field failures integer? Total number of failed tests
---@field errors integer? Total number of errored tests
---@field skipped integer? Total number of skipped tests
---@field assertions integer? Total number of assertions
---@field time number? Aggregated time in seconds
---@field timestamp string? ISO 8601 timestamp

--- The root structure for the parsed JUnit XML (wraps <testsuites>).
---@class JUnitRoot
---@field testsuites Testsuites The main testsuites element

--- The <testsuites> element, which may contain multiple <testsuite>.
---@class Testsuites
---@field _attr TestsuitesAttr Attributes of testsuites
---@field testsuite Testsuite[] Array of testsuite elements (can be empty)

--- Attributes for a <testsuite> element.
---@class TestsuiteAttr
---@field name string? Name of the suite (e.g., class or folder)
---@field tests integer? Total tests in suite
---@field failures integer? Failed tests in suite
---@field errors integer? Errored tests in suite
---@field skipped integer? Skipped tests in suite
---@field assertions integer? Assertions in suite
---@field time number? Time in seconds
---@field timestamp string? ISO 8601 timestamp
---@field file string? Source code file

--- A <testsuite> element, grouping test cases.
---@class Testsuite
---@field _attr TestsuiteAttr Attributes of testsuite
---@field properties Property[]? Array of properties (optional)
---@field ["system-out"] string? Standard output for the suite
---@field ["system-err"] string? Standard error for the suite
---@field testcase Testcase[] Array of testcase elements (can be empty)

--- Attributes for a <property> element.
---@class PropertyAttr
---@field name string Name of the property
---@field value string? Value (if not text-based)

--- A <property> element, for metadata like version or config.
---@class Property
---@field _attr PropertyAttr Attributes
---@field _text string? Text content (for multi-line values)

--- Attributes for a <testcase> element.
---@class TestcaseAttr
---@field name string Name of the test case (e.g., method name)
---@field classname string? Parent class name
---@field assertions integer? Number of assertions
---@field time number? Execution time in seconds
---@field file string? Source code file
---@field line integer? Line number in file

--- A <testcase> element, representing an individual test.
---@class Testcase
---@field _attr TestcaseAttr Attributes
---@field skipped Skipped? Skipped status (optional)
---@field failure Failure? Failure details (optional)
---@field error Error? Error details (optional)
---@field ["system-out"] string? Standard output for the test
---@field ["system-err"] string? Standard error for the test
---@field properties Property[]? Array of properties (optional)

--- Attributes for a <skipped> element.
---@class SkippedAttr
---@field message string? Reason for skipping

--- A <skipped> element inside a testcase.
---@class Skipped
---@field _attr SkippedAttr Attributes
---@field _text string? Additional text (rarely used)

--- Attributes for a <failure> element.
---@class FailureAttr
---@field message string? Failure message
---@field type string? Type (e.g., AssertionError)

--- A <failure> element inside a testcase.
---@class Failure
---@field _attr FailureAttr Attributes
---@field _text string? Description or stack trace

--- Attributes for an <error> element.
---@class ErrorAttr
---@field message string? Error message
---@field type string? Type (e.g., ArithmeticError)

--- An <error> element inside a testcase.
---@class Error
---@field _attr ErrorAttr Attributes
---@field _text string? Description or stack trace
