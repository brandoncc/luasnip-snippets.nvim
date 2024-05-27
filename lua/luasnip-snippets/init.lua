M = {}

local function all_snippets()
  local init_path = debug.getinfo(2, "S").source:sub(2):gsub("/init.lua$", "")

  if not vim.fn.isdirectory(table.concat({ init_path, "snippets" }, "/")) then
    error("Unable to find snippets directory")
  end

  local snippets_directory = table.concat({ init_path, "snippets" }, "/")
  local snippets = vim.fn.globpath(snippets_directory, "**/*.lua", true, true)

  local paths = vim.tbl_map(function(file)
    return file:gsub(vim.pesc(snippets_directory) .. "/", ""):gsub(".lua$", ""):gsub(vim.pesc("/"), ".")
  end, snippets)

  return paths
end

function M.setup(opts)
  opts = opts or {}
  opts["exclude"] = opts["exclude"] or {}

  local snippets_to_require = vim.fn.filter(all_snippets(), function(snippet)
    return not vim.tbl_contains(opts["exclude"], snippet)
  end)

  for _, snippet in ipairs(snippets_to_require) do
    local is_loaded, _ = pcall(require, "luasnip-snippets.snippets." .. snippet)

    if not is_loaded then
      error("Unable to load snippet: " .. snippet)
    end
  end
end

return M
