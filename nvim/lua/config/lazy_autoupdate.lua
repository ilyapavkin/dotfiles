local M = {}

local UPDATE_INTERVAL = 24 * 60 * 60
local COMMIT_MESSAGE = "chore(nvim): update plugins"

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO, { title = "Lazy autoupdate" })
  end)
end

local function run(command, opts, callback)
  vim.system(command, opts or { text = true }, function(result)
    vim.schedule(function()
      callback(result.code == 0, result.stdout or "", result.stderr or "")
    end)
  end)
end

local function read_number(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  local lines = vim.fn.readfile(path)
  return tonumber(lines[1])
end

local function write_number(path, value)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile({ tostring(value) }, path)
end

local function semver_update_is_safe(plugin)
  local update = plugin._.updates
  if not update or not plugin.version or not update.to.version then
    return false
  end

  local Git = require("lazy.manage.git")
  local current = Git.info(plugin.dir, true)
  return current
    and current.version
    and current.version.major == update.to.version.major
end

local function validate(config_root, lockfile, backup, callback)
  local nvim = vim.v.progpath
  run({ nvim, "--headless", "-u", vim.fn.stdpath("config") .. "/init.lua", "+qa" }, {
    cwd = config_root,
    env = { NVIM_LAZY_AUTOUPDATE = "1" },
    text = true,
  }, function(ok, stdout, stderr)
    if ok then
      vim.fn.delete(backup)
      callback(true)
      return
    end

    vim.fn.writefile(vim.fn.readfile(backup), lockfile)
    require("lazy").restore({ wait = true, show = false })
    vim.fn.delete(backup)
    notify("startup validation failed; plugin update was rolled back\n" .. (stderr ~= "" and stderr or stdout), vim.log.levels.ERROR)
    callback(false)
  end)
end

local function commit_and_push(config_root, lockfile, relative_lockfile)
  run({ "git", "-C", config_root, "add", "--", relative_lockfile }, { text = true }, function(added, _, add_error)
    if not added then
      notify("could not stage " .. relative_lockfile .. "\n" .. add_error, vim.log.levels.ERROR)
      return
    end

    run({
      "git",
      "-C",
      config_root,
      "commit",
      "--only",
      "-m",
      COMMIT_MESSAGE,
      "--",
      relative_lockfile,
    }, { text = true }, function(committed, commit_output, commit_error)
      if not committed then
        notify("plugin update was staged but not committed\n" .. (commit_error ~= "" and commit_error or commit_output), vim.log.levels.ERROR)
        return
      end

      run({ "git", "-C", config_root, "push", "origin", "HEAD" }, { text = true }, function(pushed, push_output, push_error)
        if not pushed then
          notify("plugin update committed locally, but push failed\n" .. (push_error ~= "" and push_error or push_output), vim.log.levels.ERROR)
          return
        end
        notify("plugins updated, committed, and pushed")
      end)
    end)
  end)
end

local function update(config_root, lockfile, relative_lockfile, statefile)
  local Manage = require("lazy.manage")
  Manage.check({ clear = false, show = false }):wait(function()
    local safe = {}
    local held = {}

    for _, plugin in pairs(require("lazy.core.config").plugins) do
      if plugin._.updates then
        if semver_update_is_safe(plugin) then
          table.insert(safe, plugin.name)
        else
          table.insert(held, plugin.name)
        end
      end
    end

    if #held > 0 then
      notify("held unclassified or major updates: " .. table.concat(held, ", "), vim.log.levels.WARN)
    end

    if #safe == 0 then
      write_number(statefile, os.time())
      return
    end

    local backup = vim.fn.tempname()
    vim.fn.writefile(vim.fn.readfile(lockfile), backup)
    Manage.update({ plugins = safe, show = false }):wait(function()
      run({ "git", "-C", config_root, "status", "--porcelain", "--", relative_lockfile }, { text = true }, function(status_ok, status)
        if not status_ok then
          vim.fn.delete(backup)
          notify("could not inspect the updated lockfile", vim.log.levels.ERROR)
          return
        end
        if vim.trim(status) == "" then
          vim.fn.delete(backup)
          write_number(statefile, os.time())
          notify("safe plugin updates produced no lockfile changes")
          return
        end

        validate(config_root, lockfile, backup, function(ok)
          if ok then
            write_number(statefile, os.time())
            commit_and_push(config_root, lockfile, relative_lockfile)
          end
        end)
      end)
    end)
  end)
end

function M.start()
  if vim.env.NVIM_LAZY_AUTOUPDATE == "1" then
    return
  end

  local config_root = vim.fn.fnamemodify(vim.fn.stdpath("config"), ":p:h")
  local lockfile = config_root .. "/lazy-lock.json"
  local statefile = vim.fn.stdpath("state") .. "/lazy-autoupdate.last"
  local relative_lockfile

  run({ "git", "-C", config_root, "rev-parse", "--show-toplevel" }, { text = true }, function(ok, root)
    if not ok then
      return
    end
    root = vim.trim(root)
    relative_lockfile = lockfile:sub(#root + 2)

    local last = read_number(statefile)
    if last and os.time() - last < UPDATE_INTERVAL then
      return
    end

    run({ "git", "-C", root, "status", "--porcelain", "--", relative_lockfile }, { text = true }, function(clean, status)
      if not clean or vim.trim(status) ~= "" then
        notify("skipped: " .. relative_lockfile .. " already has changes", vim.log.levels.WARN)
        return
      end

      update(root, lockfile, relative_lockfile, statefile)
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    once = true,
    callback = function()
      vim.defer_fn(M.start, 2000)
    end,
  })
end

return M
