# ==========================================
# Git stuff
# ==========================================
alias gac="git add . && git commit -m"
alias gp="git pull"

# ==========================================
# Android simulator
# ==========================================
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home

# ==========================================
# Ollama & Local MCP Workflow Aliases
# ==========================================

# Daemon Management (On-Demand Control)
alias llm-start="brew services start ollama"
alias llm-stop="brew services stop ollama"
alias llm-restart="brew services restart ollama"

# VRAM & Memory Management
alias llm-ps="ollama ps"                                                # Check currently loaded models & VRAM usage
alias llm-free="ollama stop ornith-1.5:9b; ollama stop gemma4:12b"      # Instantly purge models from Unified Memory

# Direct Model Testing CLI
alias llm-ornith="ollama run ornith-1.5:9b"
alias llm-gemma="ollama run gemma4:12b"

# Local MCP Server Dev Shortcut
alias mcp-inspector="cd ~/mcp_servers && source .mcp_servers/bin/activate && fastmcp dev inspector local_mcp_server.py"

# Codebase Analysis Helper (iOS, Android, Web)
llm-analyze() {
  local target_dir="${1:-.}"
  local prompt="${2:-Analyze this codebase and suggest 5 key architectural, performance, or code quality improvements.}"

  # Ignore list covering iOS, Android, Web/Node, and build artifacts
  local ignore_list="build/**,.gradle/**,.cxx/**,DerivedData/**,.build/**,Pods/**,Carthage/Build/**,node_modules/**,vendor/**,dist/**,out/**,.next/**,.nuxt/**,.svelte-kit/**,coverage/**,.cache/**,.git/**,package-lock.json,yarn.lock,pnpm-lock.yaml,bun.lockb,*.apk,*.aab,*.ipa,*.app,*.xcarchive,.DS_Store"

  echo "Packing codebase at '$target_dir' and sending to Gemma 4 12B..."
  npx --yes repomix "$target_dir" --ignore "$ignore_list" --stdout | ollama run gemma4:12b "$prompt"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
