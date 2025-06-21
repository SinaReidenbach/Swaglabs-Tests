# 1) Rebase current branch onto origin/master
# git config --global alias.rebase-from-master '!git fetch origin && git rebase origin/master'
# git rebase-from-master
function Rebase-FromMaster {
    git fetch origin
    git rebase origin/master
}

Set-Alias rebase-from-master Rebase-FromMaster

# 2) Hard reset to remote branch + clean working directory like a fresh checkout
# git config --global alias.hard-clean-reset '!git fetch origin && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD) && git clean -xfd'
# git hard-clean-reset
function Hard-CleanReset {
    $branch = git symbolic-ref --short HEAD 2>$null
    if (-not $branch) {
        Write-Error "❌ Du befindest dich auf keinem Branch (HEAD ist detached)."
        exit 1
    }
    git fetch origin
    git reset --hard "origin/$branch"
    git clean -xfd
}

Set-Alias hard-clean-reset Hard-CleanReset
