local call = vim.fn
local cmd = vim.api.nvim_command
local opt = vim.opt
local w = vim.w
local function execute_if_writable_buffer(procedure)
  local buftype = opt.buftype:get()
  if ((buftype == "") or (buftype == "acwrite")) then
    return procedure()
  else
    return nil
  end
end
local function highlight_lines_excess()
  if not vim.b.Snitch_disable_lines_excess then
    if (w.lines_excess_match_id ~= nil) then
      local function _2_()
        return call.matchdelete(w.lines_excess_match_id)
      end
      pcall(_2_)
    else
    end
    local textwidth = opt.textwidth:get()
    local regex = string.format("\\%%>%iv.\\+", textwidth)
    if (textwidth > 0) then
      local function _4_()
        w.lines_excess_match_id = call.matchadd("ColorColumn", regex, -1)
        return nil
      end
      return execute_if_writable_buffer(_4_)
    else
      return nil
    end
  else
    return nil
  end
end
local trailing_whitespace_regex = string.format("[%s]\\+\\%%#\\@<!$", call.join({"\\u0009", "\\u0020", "\\u00a0", "\\u1680", "\\u2000", "\\u2001", "\\u2002", "\\u2003", "\\u2004", "\\u2005", "\\u2006", "\\u2007", "\\u2008", "\\u2009", "\\u200a", "\\u202f", "\\u205f", "\\u3000", "\\u180e", "\\u200b", "\\u200c", "\\u200d", "\\u2060", "\\ufeff"}, ""))
local function highlight_trailing_whitespace()
  if not vim.b.Snitch_disable_trailing_whitespace then
    if (w.trailing_whitespace_match_id ~= nil) then
      local function _7_()
        return call.matchdelete(w.trailing_whitespace_match_id)
      end
      pcall(_7_)
    else
    end
    local function _9_()
      w.trailing_whitespace_match_id = call.matchadd("ColorColumn", trailing_whitespace_regex)
      return nil
    end
    return execute_if_writable_buffer(_9_)
  else
    return nil
  end
end
local spaces_indentation = "^\\ \\ *"
local tabs_indentation = "^\\t\\t*"
local either_indentation = (spaces_indentation .. "\\|" .. tabs_indentation .. "\\zs\\ \\+")
local function highlight_wrong_indentation()
  if not vim.b.Snitch_disable_wrong_indentation then
    if (w.wrong_indentation_match_id ~= nil) then
      local function _11_()
        return call.matchdelete(w.wrong_indentation_match_id)
      end
      pcall(_11_)
    else
    end
    local et = opt.expandtab:get()
    local sts = opt.softtabstop:get()
    local ts = opt.tabstop:get()
    local wrong_indentation
    if et then
      wrong_indentation = tabs_indentation
    elseif ((sts == 0) or (sts == ts)) then
      wrong_indentation = either_indentation
    else
      wrong_indentation = spaces_indentation
    end
    local function _14_()
      w.wrong_indentation_match_id = call.matchadd("ColorColumn", wrong_indentation)
      return nil
    end
    return execute_if_writable_buffer(_14_)
  else
    return nil
  end
end
Snitch = {}
Snitch.highlight_lines_excess = highlight_lines_excess
Snitch.highlight_trailing_whitespace = highlight_trailing_whitespace
Snitch.highlight_wrong_indentation = highlight_wrong_indentation
cmd("augroup SnitchSetup")
cmd("autocmd!")
cmd("autocmd BufEnter,BufRead,TermOpen * lua Snitch.highlight_lines_excess() Snitch.highlight_trailing_whitespace() Snitch.highlight_wrong_indentation()")
cmd("autocmd OptionSet * silent! lua Snitch.highlight_lines_excess() Snitch.highlight_wrong_indentation()")
return cmd("augroup END")
