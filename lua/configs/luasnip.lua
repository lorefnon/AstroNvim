local M = {}

function M.config()
  require("luasnip.loaders.from_snipmate").lazy_load()
end

return M
