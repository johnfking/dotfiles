# Function to get current Git branch and state
parse_git_branch() {
    # Get the current branch name or commit hash
    local branch_name
    branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ -z "$branch_name" ]; then
        return
    fi

    # Check for changes
    local git_status
    git_status=$(git status 2>/dev/null)

    # Initialize status symbols
    local dirty_symbol='*'
    local clean_symbol='✔'
    local untracked_symbol='…'
    local ahead_symbol='↑'
    local behind_symbol='↓'

    # Check for dirty state (changes to commit)
    if [[ $git_status =~ "working tree clean" ]]; then
        branch_state="$clean_symbol"
    else
        branch_state="$dirty_symbol"
    fi

    # Check for untracked files
    if [[ $git_status =~ "Untracked files" ]]; then
        branch_state+="$untracked_symbol"
    fi

    # Check for commits ahead/behind
    local remote_branch_info
    remote_branch_info=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    if [ -n "$remote_branch_info" ]; then
        local ahead_count
        local behind_count
        IFS=$'\t' read -r ahead_count behind_count <<< "$remote_branch_info"
        if (( ahead_count > 0 )); then
            branch_state+="$ahead_symbol$ahead_count"
        fi
        if (( behind_count > 0 )); then
            branch_state+="$behind_symbol$behind_count"
        fi
    fi

    echo " ($branch_name$branch_state)"
}

# Customize PS1 to include the Git branch
export PS1="\u@\h \w\[\033[32m\]\$(parse_git_branch)\[\033[00m\]$ "

# Extend path for Code-Server and Set Alias for code
PATH="/tmp/code-server/bin:$PATH"
alias code="code-server"

# Sets the default AWS Region for CLI
export AWS_DEFAULT_REGION=us-east-1

# Let everyone know we're done
echo "Completed .bashrc file." 
