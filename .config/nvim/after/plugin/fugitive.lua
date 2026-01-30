local function focus_fugitive_status()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fugitive" then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end
  return false
end

vim.keymap.set("n", "<leader>gs", function()
  vim.cmd.Git()
  focus_fugitive_status()
end)

vim.keymap.set("n", "<leader>gu", function()
  vim.cmd.Git()
  focus_fugitive_status()
  vim.cmd.normal("gU")
end)

vim.keymap.set("n", "<leader>gc", function()
  local msg = vim.fn.input("Commit message: ")
  if msg == nil or msg == "" then
    return
  end
  vim.cmd.Git("add %")
  vim.cmd("Git commit -m " .. vim.fn.shellescape(msg))
end)

vim.keymap.set("n", "<leader>gp", function()
  vim.cmd.Git("push")
  local has_upstream = vim.fn.systemlist("git rev-parse --abbrev-ref --symbolic-full-name @{u}")[1]
  if vim.v.shell_error ~= 0 or has_upstream == nil or has_upstream == "" then
    local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
    if vim.v.shell_error ~= 0 or branch == nil or branch == "" then
      return
    end
    vim.cmd("Git push -u origin " .. branch)
  end
end)
