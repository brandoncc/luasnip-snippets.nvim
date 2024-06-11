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

local function to_pascal_case(str)
  return str
    :gsub("(%a)(%w*)", function(first, rest)
      return first:upper() .. rest:lower()
    end)
    :gsub("_", "")
end

local function relative_file_path_without_extension()
  return vim.fn.expand("%:.:r")
end

local function path_without_rails_organization_directories(path)
  if path:find("^app/[^/]+/") then
    return path:gsub("^app/[^/]+/", "") -- removes "app/[^/]+/" from the beginning of the string
  elseif path:find("^test/[^/]+/") then
    return path:gsub("^test/[^/]+/", "") -- removes "test/[^/]+" from the beginning of the string
  elseif path:find("^lib/") then
    return path:gsub("^lib/", "") -- removes "lib/" from the beginning of the string
  end

  return path
end

local function project_has_application_test_case()
  vim.fn.system("rg ApplicationTestCase -q -t ruby")

  return vim.v.shell_error == 0
end

local function project_has_application_integration_test()
  vim.fn.system("rg ApplicationIntegrationTest -q -t ruby")

  return vim.v.shell_error == 0
end

local function project_has_admin_controller()
  vim.fn.system("rg AdminController -q -t ruby")

  return vim.v.shell_error == 0
end

local function inheritance_node()
  local path = relative_file_path_without_extension()

  if path:find("^app/controllers/concerns") or path:find("^app/models/concerns") then
    return nil
  elseif path:find("^app/controllers/admin") and project_has_admin_controller() then
    return t(" < AdminController")
  elseif path:find("^app/controllers/") then
    return t(" < ApplicationController")
  elseif path:find("^app/jobs/") then
    return t(" < ApplicationJob")
  elseif path:find("^app/models/") then
    return t(" < ApplicationRecord")
  elseif path:find("^test/controllers/") then
    if project_has_application_integration_test() then
      return t(" < ApplicationIntegrationTest")
    else
      return t(" < ActionDispatch::IntegrationTest")
    end
  elseif path:find("^test/integration/") then
    if project_has_application_integration_test() then
      return t(" < ApplicationIntegrationTest")
    else
      return t(" < ActionDispatch::IntegrationTest")
    end
  elseif path:find("^test/system/") then
    return t(" < ApplicationSystemTestCase")
  elseif path:find("^test/jobs/") then
    return t(" < ActiveJob::TestCase")
  elseif path:find("^test/") then
    -- fallback, use parent based on ActiveSupport::TestCase if a more specific parent class wasn't identified
    if project_has_application_test_case() then
      return t(" < ApplicationTestCase")
    else
      return t(" < ActiveSupport::TestCase")
    end
  end
end

local function current_file_name()
  return vim.fn.expand("%:t:r")
end

local function current_file_pascal_case()
  return to_pascal_case(current_file_name())
end

local function build_ruby_class_structure(constants, structure, indentation_level)
  structure = structure or {}
  constants = constants or {}

  if indentation_level == nil then
    indentation_level = 0
  end

  if #constants == 0 then
    return structure
  end

  local class_options = { t("module"), t("class") }

  if #constants == 1 then
    class_options = { t("class"), t("module") }
  end

  -- if the first constant is "Concerns", remove it from the list of constants and default to using a module
  if #structure == 0 and constants[1] == "Concerns" then
    constants = vim.list_slice(constants, 2, #constants)
    class_options = { t("module"), t("class") }
  end

  table.insert(structure, t({ ("  "):rep(indentation_level) }))
  table.insert(structure, c(#constants + 1, class_options))
  table.insert(structure, t(" " .. constants[1]))

  if #constants > 1 then
    table.insert(structure, t({ "", "" }))

    build_ruby_class_structure(vim.list_slice(constants, 2, #constants), structure, indentation_level + 1)
  else
    local inheritance = inheritance_node()

    if inheritance then
      table.insert(structure, inheritance)
    end

    table.insert(structure, t({ "", "" }))

    -- build the blank line where the cursor gets dropped
    table.insert(structure, t(("  "):rep(indentation_level + 1)))
    table.insert(structure, i(#constants))
  end

  table.insert(structure, t({ "", ("  "):rep(indentation_level) .. "end" }))

  return structure
end

local function ruby_class_structure_nodes()
  local path = path_without_rails_organization_directories(relative_file_path_without_extension())
  local parts = vim.tbl_map(function(p)
    return to_pascal_case(p)
  end, vim.split(path, "/", {}))

  return build_ruby_class_structure(parts)
end

ls.add_snippets("ruby", {
  s("fc", f(current_file_pascal_case)),
  s(
    "fs",
    d(1, function()
      return sn(nil, ruby_class_structure_nodes())
    end)
  ),
  s({
    trig = "profile",
    name = "Profile code with StackProf (alternative snippet: flamegraph)",
    docstring = {
      "Requirements:",
      "  - gem install stackprof (or add it the bundle)",
      "  - add `require 'stackprof'` to the top of the file (or add it to the bundle)",
      "",
      "Usage:",
      "  - Execute the code",
      "  - Run `stackprof --d3-flamegraph stackprof.dump > stackprof.html`",
      "  - Open `stackprof.html` in a browser",
      "",
      "Recommendation:",
      "  - gem install stackprof-webnav (or add it to the bundle)",
      "  - Run `stackprof-webnav -d .` within the tmp directory",
      "  - Open `http://localhost:9292` in a browser",
    },
  }, {
    t('StackProf.run(mode: :wall, raw: true, ignore_gc: true, out: "tmp/stackprof.dump") do'),
    t({ "", "  " }),
    i(1),
    t({ "", "end" }),
  }),
  s({
    trig = "flamegraph",
    name = "Profile code with the singed gem",
    docstring = {
      "Requirements:",
      "  - bundle add singed",
      "",
      "Usage:",
      "flamegraph { code_to_profile }",
      "",
      "flamegraph do",
      "  # code_to_profile",
      "end",
      "",
      "Reference: https://github.com/rubyatscale/singed",
      "", -- fix cmd+hover opening link
    },
  }, {
    t("flamegraph do"),
    t({ "", "  " }),
    i(1),
    t({ "", "end" }),
  }),
  s({
    trig = "rt",
    name = "Require test_helper for minitest",
  }, {
    t('require "test_helper"'),
  }),
})
