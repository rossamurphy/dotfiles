# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


alias vi="nvim"
alias viminit="nvim ~/.config/nvim/init.vim"
# alias python="python3"

# NOTE, it may not always be the case that when you type
# iPython in a shell, that it will load an interactive python 
# using the venv you have pointed it to!
# if you have not already pip installed ipython into THAT particular
# python venv, then, it will actually default to using a DIFFERENT env!
# a way to get around this, is to call ipy instead, aliased below
# this will make sure it tries to call ipython from the CURRENT environment
# if it doesn't work, it's because ipython is not installed in that
# environment. But, it's better for it to jank out and let you know this
# in advance, instead of just defaulting.
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias chrome="open -a 'Google Chrome'"
alias chat="open -a whatsapp"


# export PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}" 
#export PATH="/usr/local/bin/python3.9:${PATH}" 

#export PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

cheat(){curl cheat.sh/$1}
coin(){curl rate.sx/$1}
weather(){curl wttr.in/$1}
meteo(){finger $1@graph.no}
moon(){curl wttr.in/moon}
source ~/GitHub/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
