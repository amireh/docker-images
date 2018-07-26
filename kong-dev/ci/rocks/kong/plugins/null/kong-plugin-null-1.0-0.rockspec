package = "kong-plugin-null"
version = "1.0-0"

source = { url = "nope" }

description = {
  summary = "",
  detailed = [[]],
  homepage = "https://github.com/amireh/docker",
  license = "MIT"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.null.handler"] = "handler.lua",
    ["kong.plugins.null.schema"] = "schema.lua",
  }
}