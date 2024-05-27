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
    trig = "assert_emails",
    dscr = "Asserts that the number of emails sent matches the given number",
    docstring = {
      "assert_emails(number, &block)",
      "",
      "def test_emails",
      "  assert_emails 0",
      "  ContactMailer.welcome.deliver_now",
      "  assert_emails 1",
      "  ContactMailer.welcome.deliver_now",
      "  assert_emails 2",
      "end",
      "",
      "def test_emails_again",
      "  assert_emails 1 do",
      "    ContactMailer.welcome.deliver_now",
      "  end",
      "",
      "  assert_emails 2 do",
      "    ContactMailer.welcome.deliver_now",
      "    ContactMailer.welcome.deliver_later",
      "  end",
      "end",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActionMailer/TestHelper.html",
    },
  }, { t("assert_emails "), i(1) }),
  s({
    trig = "assert_enqueued_email_with",
    docstring = {
      'assert_enqueued_email_with(mailer, method, args: nil, queue: ActionMailer::Base.deliver_later_queue_name || "default", &block)',
      "",
      "# Asserts that a specific email has been enqueued, optionally matching arguments.",
      "",
      "def test_email",
      "  ContactMailer.welcome.deliver_later",
      "  assert_enqueued_email_with ContactMailer, :welcome",
      "end",
      "",
      "def test_email_with_arguments",
      '  ContactMailer.welcome("Hello", "Goodbye").deliver_later',
      '  assert_enqueued_email_with ContactMailer, :welcome, args: ["Hello", "Goodbye"]',
      "end",
      "",
      "# If a block is passed, that block should cause the specified email to be enqueued.",
      "",
      "def test_email_in_block",
      "  assert_enqueued_email_with ContactMailer, :welcome do",
      "    ContactMailer.welcome.deliver_later",
      "  end",
      "end",
      "",
      "# If args is provided as a Hash, a parameterized email is matched.",
      "",
      "def test_parameterized_email",
      "  assert_enqueued_email_with ContactMailer, :welcome,",
      "    args: {email: 'user@example.com'} do",
      "    ContactMailer.with(email: 'user@example.com').welcome.deliver_later",
      "  end",
      "end",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActionMailer/TestHelper.html",
    },
  }, {
    t("assert_enqueued_email_with "),
    i(1, "mailer"),
    t(", "),
    i(2, "method"),
  }),
  s({
    trig = "assert_enqueued_emails",
    docstring = {
      "assert_enqueued_emails(number, &block)",
      "",
      "# Asserts that the number of emails enqueued for later delivery matches the given number.",
      "",
      "def test_emails",
      "  assert_enqueued_emails 0",
      "  ContactMailer.welcome.deliver_later",
      "  assert_enqueued_emails 1",
      "  ContactMailer.welcome.deliver_later",
      "  assert_enqueued_emails 2",
      "end",
      "",
      "# If a block is passed, that block should cause the specified number of emails to be enqueued.",
      "",
      "def test_emails_again",
      "  assert_enqueued_emails 1 do",
      "    ContactMailer.welcome.deliver_later",
      "  end",
      "",
      "  assert_enqueued_emails 2 do",
      "    ContactMailer.welcome.deliver_later",
      "    ContactMailer.welcome.deliver_later",
      "  end",
      "end",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActionMailer/TestHelper.html",
    },
  }, {
    t("assert_enqueued_emails "),
    i(1, "number"),
  }),
  s({
    trig = "assert_no_emails",
    docstring = {
      "assert_no_emails(&block)",
      "",
      "# Asserts that no emails have been sent.",
      "",
      "def test_emails",
      "  assert_no_emails",
      "  ContactMailer.welcome.deliver_now",
      "  assert_emails 1",
      "end",
      "",
      "# If a block is passed, that block should not cause any emails to be sent.",
      "",
      "def test_emails_again",
      "  assert_no_emails do",
      "    # No emails should be sent from this block",
      "  end",
      "end",
      "",
      "# Note: This assertion is simply a shortcut for:",
      "",
      "assert_emails 0, &block",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActionMailer/TestHelper.html",
    },
  }, { t("assert_no_email") }),
  s({
    trig = "assert_no_enqueued_emails",
    docstring = {
      "assert_no_enqueued_emails(&block)",
      "",
      "# Asserts that no emails are enqueued for later delivery.",
      "",
      "def test_no_emails",
      "  assert_no_enqueued_emails",
      "  ContactMailer.welcome.deliver_later",
      "  assert_enqueued_emails 1",
      "end",
      "",
      "# If a block is provided, it should not cause any emails to be enqueued.",
      "",
      "def test_no_emails",
      "  assert_no_enqueued_emails do",
      "    # No emails should be enqueued from this block",
      "  end",
      "end",
      "",
      "# Reference: https://api.rubyonrails.org/classes/ActionMailer/TestHelper.html",
    },
  }, { t("assert_no_enqueued_emails") }),
})
