# Terminal Use (Neovim + Tmux)

## Run shell commands without leaving Neovim

- `:! <command>` — run a single shell command from Neovim.
  - Example: `:! tmux display -p "#{pane_tty} #{pane_current_command}"`

## Open a terminal inside Neovim

1) `:terminal` — open an embedded terminal buffer.
2) Run commands as usual.
3) Exit the shell with `exit` or `Ctrl-d`.
4) Return to Normal mode: `Ctrl-\` then `Ctrl-n`.
5) Close the terminal window: `:q` (or `:bd!` to wipe the buffer).

## Temporarily leave Neovim (job control)

- `Ctrl-z` — suspend Neovim and return to the shell.
- `fg` — resume Neovim in the foreground.

