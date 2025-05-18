-- start screen ascii art, credit: https://www.asciiart.eu/animals/bisons
local bison_block = [[
            _.-````'-,_
     _,.,_ ,-'`           `'-.,_
  /)     (\                   '``-.
 ((      ) )                      `\
  \)    (_/                        )\
  |       /)           '    ,'    / \
  `\    ^'            '     (    /  ))
    |      _/\ ,     /    ,,`\   (  "`
     \Y,   |  \  \  | ````| / \_ \
       `)_/    \  \  )    ( >  ( >
                \( \(     |/   |/
              /_(/_(    /_(  /_(
]]


local shortcuts = {
  "",
  "",
  "",
  "     [f] Find File",
  "     [r] Recent Files",
  "     [q] Quit",
}

local function to_lines(block)
  local lines = {}
  for line in block:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  return lines
end

local function center_block(lines)
  local width = vim.api.nvim_get_option("columns")
  local longest = 0

  for _, line in ipairs(lines) do
    if #line > longest then
      longest = #line
    end
  end

  local padding = math.floor((width - longest) / 2)
  local centered = {}

  for _, line in ipairs(lines) do
    table.insert(centered, string.rep(" ", padding > 0 and padding or 0) .. line)
  end

  return centered
end

local top_padding = 5

local function show_start_screen()
  if vim.fn.argc() > 0 then return end

  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.wo.number = false
  vim.wo.relativenumber = false

  local lines = {}
  for _ = 1, top_padding do
    table.insert(lines, "")
  end

  vim.list_extend(lines, to_lines(bison_block))
  vim.list_extend(lines, shortcuts)

  local centered = center_block(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, centered)

  vim.cmd("setlocal nomodifiable")
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    show_start_screen()

    vim.keymap.set("n", "f", ":Telescope find_files<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "r", ":Telescope oldfiles<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
  end,
})

