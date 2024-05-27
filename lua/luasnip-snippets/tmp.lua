local lua_path = vim.fn.expand("%:p:h:h")

local snippets_directory = table.concat({ vim.fn.expand("%:p:h"), "snippets" }, "/")
local snippets = vim.fn.globpath(snippets_directory, "**/*.lua", true, true)

local paths = vim.tbl_map(function(file)
  return file:gsub(vim.pesc(lua_path) .. "/", ""):gsub(".lua", ""):gsub("%/", ".")
end, snippets)

put(paths)
