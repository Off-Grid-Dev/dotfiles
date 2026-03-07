local function update_config()
	local config_path = vim.fn.stdpath("config")

	-- 1. Safety Check: Ensure git is available
	if vim.fn.executable("git") == 0 then
		vim.notify("Git is not in yo PATH homey!!", vim.log.levels.ERROR)
		return
	end

	-- 2. Anoooother Safter Check: Ensure config is a git repo
	local git_check = vim.fn.system(string.format("git -C %s rev-parse --is-inside-work-tree", config_path))
	if vim.v.shell_error ~= 0 then
		vim.notify("Config dir is not in the git repo dipshit.", vim.log.levels.WARN)
		return
	end

	-- 3. What the fuck... Safety Check: Ensure no uncommitted changes (No Dirty Business)
	-- synchronously at first then get to work
	local status = vim.fn.system(string.format("git -C %s status --porcelain", config_path))
	if status ~= "" then
		vim.notify("Fix your shit! This place is a mess. Save or stash.", vim.log.levels.INFO)
		return
	end
end
