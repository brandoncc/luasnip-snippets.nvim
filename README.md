# luasnip-snippets.nvim

My personal collection of snippets.

## Usage

### lazy.nvim

```lua
return {
  "brandoncc/luasnip-snippets.nvim",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  event = "InsertEnter",
  opts = {
    exclude = {
      "ruby.minitest", -- these snippets are coming from somewhere else; friendly-snippets?
      "ruby.active_support.testing", -- these snippets are coming from somewhere else; friendly-snippets?
    },
  },
}
```
