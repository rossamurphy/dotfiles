# primedots

git operations

# leader g t --> neotree git status
once there you can g a to add
g r to revert
g c to commit
g g to push changes

# leader g s --> opens vim fugitive
git status, basically..

# leader f g b --> opens branch picker
pressing enter will switch to the branch in attached mode (see picker args in telescope)
https://github.com/nvim-telescope/telescope.nvim/issues/1932

# leader f g c --> opens git commit browser for this branch
use ctrl U and ctrl D to scroll in the window

# leader g d
to open git diff vs remote

# if there is a merge conflict you can sort it out in a 3 way diff using leader g d
when in the conflict (in the middle, jump between conflicts by doings [x and ]x
when on a conflict, do leader c o to choose ours (on the left), or leader c t to choose theirs (on the right)

if you messed up during the merge and some changes are staged, just do git stash -u and start again

https://github.com/sindrets/diffview.nvim?tab=readme-ov-file
skip through individual hunks doing [c and ]c. you choose from left or right just do 2do or 3do.

more in the CONFIG here
https://github.com/sindrets/diffview.nvim?tab=readme-ov-file

# to look at all the changes through previous commits do leader g h d
# to look only at the changes for a specific file do leader g h f

to do a diff between particular branches do:
:DiffviewOpen BRANCH1...BRANCH2

for more on ... vs .. see:
https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md

once in that mode, go the right hand side (your one).

whichever diffs you want, just do "do" (diff obtain)
undo and re-do etc work as expected.

note you can also do this from the LHS with "dp" (diffput)
but then undo is a little annoying as you have to move to the right window (where the changes are) to undo.
