local success, ls = pcall(require, "luasnip")

if not success then
  return
end

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

ls.add_snippets("ruby", {
  s({
    trig = "assert_changes",
    dscr = "Assertion that the result of evaluating an expression is changed before and after invoking the passed in block.",
    docstring = {
      "assert_changes(expression, message = nil, from: UNTRACKED, to: UNTRACKED, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t("assert_changes "),
    i(1, "expression"),
    t({ " do", "  " }),
    i(2),
    t({ "", "end" }),
  }),
  s({
    trig = "assert_difference",
    dscr = "Test numeric difference between the return value of an expression as a result of what is evaluated in the yielded block.",
    docstring = {
      "assert_difference(expression, *args, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t("assert_difference "),
    i(1, "expression"),
    t({ " do", "  " }),
    i(2),
    t({ "", "end" }),
  }),
  s({
    trig = "assert_no_changes",
    dscr = "Assertion that the result of evaluating an expression is not changed before and after invoking the passed in block.",
    docstring = {
      "assert_no_changes(expression, message = nil, from: UNTRACKED, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t("assert_no_changes "),
    i(1, "expression"),
    t({ " do", "  " }),
    i(2),
    t({ "", "end" }),
  }),
  s({
    trig = "assert_no_difference",
    dscr = "Assertion that the numeric result of evaluating an expression is not changed before and after invoking the passed in block.",
    docstring = {
      "assert_no_difference(expression, message = nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t("assert_no_difference "),
    i(1, "expression"),
    t({ " do", "  " }),
    i(2),
    t({ "", "end" }),
  }),
  s({
    trig = "assert_not",
    dscr = "Asserts that an expression is not truthy. Passes if object is nil or false. “Truthy” means “considered true in a conditional” like if foo.",
    docstring = {
      "assert_not(object, message = nil)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t("assert_not "),
    i(1, "expression"),
  }),
  s({
    trig = "assert_nothing_raised",
    dscr = "Assertion that the block should not raise an exception.",
    docstring = {
      "assert_nothing_raised(&block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Assertions.html",
    },
  }, {
    t({ "assert_nothing_raised do", "  " }),
    i(1),
    t({ "", "end" }),
  }),
})
