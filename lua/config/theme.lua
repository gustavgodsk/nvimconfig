-- ~/.config/nvim/lua/config/theme.lua
--
-- Persist the active colorscheme across sessions.
--
-- `<leader>th` opens Telescope's colorscheme picker, which applies a scheme via
-- `:colorscheme`. On its own that choice is forgotten on the next launch. Here we
-- save the scheme whenever it changes and re-apply it on startup.

local M = {}

-- Small text file in the state dir (runtime data, not config). Neovim creates
-- the state dir for us, so we can write into it directly.
local theme_file = vim.fn.stdpath("state") .. "/last_theme.txt"

-- Avoid re-writing the same value: Telescope's preview fires ColorScheme once
-- per scheme as you scroll, so dedup consecutive identical saves.
local last_saved = nil

---Persist a colorscheme name.
---@param name string|nil
function M.save(name)
  if not name or name == "" or name == last_saved then
    return
  end
  last_saved = name
  local f = io.open(theme_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

---Read the persisted colorscheme name, or nil if none/empty.
---@return string|nil
function M.load()
  local f = io.open(theme_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l") -- first line only
  f:close()
  if not name or name == "" then
    return nil
  end
  return name
end

---Apply the persisted colorscheme, falling back to `default` if there is none
---saved or the saved one fails to load (e.g. its plugin was removed).
---@param default string
function M.apply_saved(default)
  local name = M.load() or default
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok and name ~= default then
    pcall(vim.cmd.colorscheme, default)
  end
end

---Register the autocmd that persists the scheme whenever it changes.
function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("PersistColorScheme", { clear = true }),
    callback = function(args)
      M.save(args.match) -- `match` is the colorscheme name for this event
    end,
  })
end

return M
