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

local snippets = {
  s({
    trig = "debug_remote",
    name = "Remote debugging using the ruby/debug gem",
    docstring = 'require "debug/open"; debugger',
    dscr = "Use `rdbg -A` to connect to the debugger.",
  }, t('require "debug/open"; debugger')),

  s({
    trig = "pry_remote",
    name = "Remote debugging using the pry-remote gem",
    docstring = 'require "pry-remote"; binding.remote_pry',
    dscr = "Use `pry-remote` to connect to the debugger.",
  }, t('require "pry-remote"; binding.remote_pry')),
}

ls.add_snippets("ruby", snippets)
ls.add_snippets("eruby", snippets)
