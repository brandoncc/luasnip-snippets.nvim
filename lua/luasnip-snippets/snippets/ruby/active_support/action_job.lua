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
    trig = "assert_enqueued_jobs",
    dscr = "Asserts that the number of enqueued jobs matches the given number",
    docstring = {
      "assert_enqueued_jobs(number, only: nil, except: nil, queue: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_enqueued_jobs "),
    i(1, "1"),
    t(", only: "),
    i(2, "JobClass"),
  }),
  s({
    trig = "assert_enqueued_with",
    dscr = "Asserts that the job has been enqueued with the given arguments",
    docstring = {
      "assert_enqueued_with(job: nil, args: nil, at: nil, queue: nil, priority: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_enqueued_with job: "),
    i(1, "JobClass"),
    t(", args: "),
    i(2, "[1, 2, 3]"),
  }),
  s({
    trig = "assert_no_enqueued_jobs",
    dscr = "Asserts that no jobs have been enqueued",
    docstring = {
      "assert_no_enqueued_jobs(only: nil, except: nil, queue: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_no_enqueued_jobs only: "),
    i(1, "JobClass"),
  }),
  s({
    trig = "assert_no_performed_jobs",
    dscr = "Asserts that no jobs have been performed",
    docstring = {
      "assert_no_performed_jobs(only: nil, except: nil, queue: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_no_performed_jobs only: "),
    i(1, "JobClass"),
  }),
  s({
    trig = "assert_performed_jobs",
    dscr = "Asserts that the number of performed jobs matches the given number",
    docstring = {
      "assert_performed_jobs(number, only: nil, except: nil, queue: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_performed_jobs "),
    i(1, "1"),
    t(", only: "),
    i(2, "JobClass"),
  }),
  s({
    trig = "assert_performed_with",
    dscr = "Asserts that the job has been performed with the given arguments",
    docstring = {
      "assert_performed_with(job: nil, args: nil, at: nil, queue: nil, priority: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("assert_performed_with job: "),
    i(1, "JobClass"),
    t(", args: "),
    i(2, "[1, 2, 3]"),
  }),
  s({
    trig = "perform_enqueued_jobs",
    dscr = "Performs all enqueued jobs",
    docstring = {
      "perform_enqueued_jobs(only: nil, except: nil, queue: nil, at: nil, &block)",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActiveJob/TestHelper.html",
    },
  }, {
    t("perform_enqueued_jobs "),
    i(1, "only: JobClass"),
  }),
})
