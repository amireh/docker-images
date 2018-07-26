rocks_trees = {
  {
    name = [[external]],
    root = os_getenv('KONG_DEV_ROCKS_DIR'),
    lua_dir = os_getenv('KONG_DEV_ROCKS_DIR'),
    lib_dir = os_getenv('KONG_DEV_ROCKS_DIR') .. '/lib',
    bin_dir = os_getenv('KONG_DEV_ROCKS_DIR') .. '/bin',
  },
  { name = [[user]], root = home..[[/.luarocks]] },
  { name = [[system]], root = [[/usr/local]] }
}
