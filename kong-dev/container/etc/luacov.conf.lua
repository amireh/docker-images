local os = require 'os'
local outdir = os.getenv('KONG_DEV_LUACOV_OUTDIR')
local rocks_dir = os.getenv('KONG_DEV_ROCKS_DIR')

return {
  statsfile = outdir .. '/luacov.stats.out',
  reportfile = outdir .. '/luacov.report.out',

  runreport = false,

  deletestats = false,

  tick = false,
  -- savestepsize = 3,

  include = {
    rocks_dir .. '/.+'
  },

  exclude = {
    'coverage'
  }
}