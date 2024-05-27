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
    trig = "assert",
    name = "assert",
    dscr = "Fails unless test is truthy",
    docstring = {
      "assert(test, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert "), i(1, "test") }),

  s({
    trig = "assert_empty",
    dscr = "Fails unless obj is empty",
    docstring = {
      "assert_empty(obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_empty "), i(1, "obj") }),

  s({
    trig = "assert_equal",
    dscr = "Fails unless exp == act printing the difference between the two, if possible",
    docstring = {
      "assert_equal(exp, act, msg = nil) ⇒ Object",
      "",
      "# If there is no visible difference but the assertion fails, you should suspect",
      "# that your #== is buggy, or your inspect output is missing crucial details. For",
      "# nicer structural diffing, set Minitest::Test.make_my_diffs_pretty!",
      "",
      "# For floats use assert_in_delta.",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_equal "), i(1, "exp"), t(", "), i(2, "act") }),

  s({
    trig = "assert_in_delta",
    dscr = "For comparing Floats. Fails unless exp and act are within delta of each other.",
    docstring = {
      "assert_in_delta(exp, act, delta = 0.001, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_in_delta "), i(1, "exp"), t(", "), i(2, "act"), t(", "), i(3, "delta") }),

  s({
    trig = "assert_in_epsilon",
    dscr = "For comparing Floats. Fails unless exp and act have a relative error less than epsilon.",
    docstring = {
      "assert_in_epsilon(exp, act, epsilon = 0.001, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_in_epsilon "), i(1, "exp"), t(", "), i(2, "act"), t(", "), i(3, "epsilon") }),

  s({
    trig = "assert_includes",
    dscr = "Fails unless collection includes obj",
    docstring = {
      "assert_includes(collection, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_includes "), i(1, "collection"), t(", "), i(2, "obj") }),

  s({
    trig = "assert_instance_of",
    dscr = "Fails unless obj is an instance of cls",
    docstring = {
      "assert_instance_of(cls, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_instance_of "), i(1, "cls"), t(", "), i(2, "obj") }),

  s({
    trig = "assert_kind_of",
    dscr = "Fails unless obj is a kind of cls",
    docstring = {
      "assert_kind_of(cls, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_kind_of "), i(1, "cls"), t(", "), i(2, "obj") }),

  s({
    trig = "assert_match",
    dscr = "Fails unless matcher =~ obj",
    docstring = {
      "assert_match(matcher, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_match "), i(1, "matcher"), t(", "), i(2, "obj") }),

  s({
    trig = "assert_mock",
    dscr = "Assert that the mock verifies correctly",
    docstring = {
      "assert_mock(mock) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_mock "), i(1, "mock") }),

  s({
    trig = "assert_nil",
    dscr = "Fails unless obj is nil",
    docstring = {
      "assert_nil(obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_nil "), i(1, "obj") }),

  s({
    trig = "assert_operator",
    dscr = "For testing with binary operators",
    docstring = {
      "assert_operator(o1, op, o2 = UNDEFINED, msg = nil) ⇒ Object",
      "",
      "assert_operator 5, :<=, 4",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_operator "), i(1, "o1"), t(", "), i(2, "op"), t(", "), i(3, "o2") }),

  s({
    trig = "assert_output",
    dscr = "Fails if stdout or stderr do not output the expected results.",
    docstring = {
      "assert_output(stdout = nil, stderr = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_output "), i(1, "nil"), t(", "), i(2, "nil") }),

  s({
    trig = "assert_path_exists",
    dscr = "Fails unless path exists",
    docstring = {
      "assert_path_exists(path, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_path_exists "), i(1, "path") }),

  s({
    trig = "assert_pattern",
    dscr = "For testing with pattern matching (only supported with Ruby 3.0 and later).",
    docstring = {
      "assert_pattern ⇒ Object",
      "",
      "# pass",
      "assert_pattern { [1,2,3] => [Integer, Integer, Integer] }",
      "",
      '# fail "length mismatch (given 3, expected 1)"',
      "assert_pattern { [1,2,3] => [Integer] }",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t({ "assert_pattern { " }), i(1, ""), t(" }") }),

  s({
    trig = "assert_predicate",
    dscr = "For testing with predicates",
    docstring = {
      "assert_predicate(o1, op, msg = nil) ⇒ Object",
      "",
      "",
      "# For testing with predicates. Eg:",
      "",
      "assert_predicate str, :empty?",
      "",
      "# This is really meant for specs and is front-ended by assert_operator:",
      "",
      "str.must_be :empty?",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_predicate "), i(1, "o1"), t(", "), i(2, "op") }),

  s({
    trig = "assert_raises",
    dscr = "Fails unless the block raises one of exp. Returns the exception matched\nso you can check the message, attributes, etc.",
    docstring = {
      "assert_raises(*exp) ⇒ Object",
      "",
      "```",
      "# `exp` takes an optional message on the end to help explain failures and",
      "# defaults to StandardError if no exception class is passed. Eg:",
      "",
      "assert_raises(CustomError) { method_with_custom_error }",
      "",
      "# With custom error message:",
      "",
      "assert_raises(CustomError, 'This should have raised CustomError') do",
      "  method_with_custom_error",
      "end",
      "",
      "```",
      "# Using the returned object:",
      "",
      "error = assert_raises(CustomError) do",
      "  raise CustomError, 'This is really bad'",
      "end",
      "",
      "assert_equal 'This is really bad', error.message",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_raises "), i(1, "*exp") }),

  s({
    trig = "assert_respond_to",
    dscr = "Fails unless obj responds to meth",
    docstring = {
      "assert_respond_to(obj, meth, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_respond_to "), i(1, "obj"), t(", "), i(2, "meth") }),

  s({
    trig = "assert_same",
    dscr = "Fails unless exp and act are #equal?",
    docstring = {
      "assert_same(exp, act, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_same "), i(1, "exp"), t(", "), i(2, "act") }),

  s({
    trig = "assert_send",
    dscr = "send_ary is a receiver, message and arguments",
    docstring = {
      "assert_send(send_ary, m = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_send "), i(1, "send_ary") }),

  s({
    trig = "assert_silent",
    dscr = "Fails if the block outputs anything to stderr or stdout.",
    docstring = {
      "assert_silent ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t({ "assert_silent do ", "  " }), i(1, ""), t({ "", "end" }) }),

  s({
    trig = "assert_throws",
    dscr = "Fails unless the block throws sym",
    docstring = {
      "assert_throws(sym, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("assert_throws "), i(1, "sym") }),

  s({
    trig = "diff",
    dscr = "Returns a diff between exp and act",
    docstring = {
      "diff(exp, act) ⇒ Object",
      "",
      "If there is no known diff command or if it doesn’t make sense to diff",
      "the output (single line, short output), then it simply returns a basic",
      "comparison between the two.",
      "",
      "See `things_to_diff` for more info.",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, t("diff "), i(1, "exp"), t(", "), i(2, "act")),

  s({
    trig = "exception_details",
    dscr = "Returns details for exception e",
    docstring = {
      "exception_details(e, msg) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, t("exception_details "), i(1, "e"), t(", "), i(2, "msg")),

  s({
    trig = "fail_after",
    dscr = "Fails after a given date (in the local time zone)",
    docstring = {
      "fail_after(y, m, d, msg) ⇒ Object",
      "",
      "This allows you to put time-bombs in your tests if you need to keep",
      "something around until a later date lest you forget about it.",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("fail_after "), i(1, "y"), t(", "), i(2, "m"), t(", "), i(3, "d"), t(", "), i(4, "msg") }),

  s({
    trig = "flunk",
    dscr = "Fails with msg",
    docstring = {
      "flunk(msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("flunk "), i(1, "msg (optional)") }),

  s({
    trig = "mu_pp",
    dscr = "This returns a human-readable version of obj",
    docstring = {
      "mu_pp(obj) ⇒ Object",
      "",
      "By default #inspect is called. You can override this to use `#pretty_inspect` if you want.",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("mu_pp "), i(1, "obj") }),

  s({
    trig = "mu_pp_for_diff",
    dscr = "This returns a diff-able more human-readable version of obj",
    docstring = {
      "mu_pp_for_diff(obj) ⇒ Object",
      "",
      "This differs from the regular mu_pp because it expands escaped newlines and makes",
      "hex-values (like object_ids) generic. This uses mu_pp to do the first pass and then",
      "cleans it up.",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("mu_pp_for_diff "), i(1, "obj") }),

  s({
    trig = "refute",
    dscr = "Fails if test is truthy",
    docstring = {
      "refute(test, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute "), i(1, "test") }),

  s({
    trig = "refute_empty",
    dscr = "Fails if obj is empty",
    docstring = {
      "refute_empty(obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_empty "), i(1, "obj") }),

  s({
    trig = "refute_equal",
    dscr = "Fails if exp == act",
    docstring = {
      "refute_equal(exp, act, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_equal "), i(1, "exp"), t(", "), i(2, "act") }),

  s({
    trig = "refute_in_delta",
    dscr = "For comparing Floats. Fails if exp is within delta of act.",
    docstring = {
      "refute_in_delta(exp, act, delta = 0.001, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_in_delta "), i(1, "exp"), t(", "), i(2, "act"), t(", "), i(3, "delta") }),

  s({
    trig = "refute_in_epsilon",
    dscr = "For comparing Floats. Fails if exp and act have a relative error less than epsilon.",
    docstring = {
      "refute_in_epsilon(a, b, epsilon = 0.001, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_in_epsilon "), i(1, "a"), t(", "), i(2, "b"), t(", "), i(3, "epsilon") }),

  s({
    trig = "refute_includes",
    dscr = "Fails if collection includes obj",
    docstring = {
      "refute_includes(collection, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_includes "), i(1, "collection"), t(", "), i(2, "obj") }),

  s({
    trig = "refute_instance_of",
    dscr = "Fails if obj is an instance of cls",
    docstring = {
      "refute_instance_of(cls, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_instance_of "), i(1, "cls"), t(", "), i(2, "obj") }),

  s({
    trig = "refute_kind_of",
    dscr = "Fails if obj is a kind of cls",
    docstring = {
      "refute_kind_of(cls, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_kind_of "), i(1, "cls"), t(", "), i(2, "obj") }),

  s({
    trig = "refute_match",
    dscr = "Fails if matcher =~ obj",
    docstring = {
      "refute_match(matcher, obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_match "), i(1, "matcher"), t(", "), i(2, "obj") }),

  s({
    trig = "refute_nil",
    dscr = "Fails if obj is nil",
    docstring = {
      "refute_nil(obj, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_nil "), i(1, "obj") }),

  s({
    trig = "refute_operator",
    dscr = "Fails if o1 is not op o2",
    docstring = {
      "refute_operator(o1, op, o2 = UNDEFINED, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_operator "), i(1, "o1"), t(", "), i(2, "op"), t(", "), i(3, "o2") }),

  s({
    trig = "refute_path_exists",
    dscr = "Fails if path exists",
    docstring = {
      "refute_path_exists(path, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_path_exists "), i(1, "path") }),

  s({
    trig = "refute_pattern",
    dscr = "For testing with pattern matching (only supported with Ruby 3.0 and later).",
    docstring = {
      "refute_pattern ⇒ Object",
      "",
      "# pass",
      "refute_pattern { [1,2,3] => [String] }",
      "",
      '# fail "NoMatchingPatternError expected, but nothing was raised."',
      "refute_pattern { [1,2,3] => [Integer, Integer, Integer] }",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t({ "refute_pattern { " }), i(1, ""), t({ " }" }) }),

  s({
    trig = "refute_predicate",
    dscr = "For testing with predicates",
    docstring = {
      "refute_predicate(o1, op, msg = nil) ⇒ Object",
      "",
      "# For testing with predicates.",
      "",
      "refute_predicate str, :empty?",
      "",
      "# This is really meant for specs and is front-ended by refute_operator:",
      "",
      "str.wont_be :empty?",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_predicate "), i(1, "o1"), t(", "), i(2, "op") }),

  s({
    trig = "refute_respond_to",
    dscr = "Fails if obj responds to the message meth",
    docstring = {
      "refute_respond_to(obj, meth, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_respond_to "), i(1, "obj"), t(", "), i(2, "meth") }),

  s({
    trig = "refute_same",
    dscr = "Fails if exp is the same (by object identity) as act",
    docstring = {
      "refute_same(exp, act, msg = nil) ⇒ Object",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t("refute_same "), i(1, "exp"), t(", "), i(2, "act") }),

  s({
    trig = "test",
    name = "A test case",
    docstring = {
      "test",
      "",
      "# Reference: https://www.rubydoc.info/gems/minitest/Minitest/Assertions",
    },
  }, { t('test "'), i(1), t({ '" do', "  " }), i(2), t({ "", "end" }) }),
})
