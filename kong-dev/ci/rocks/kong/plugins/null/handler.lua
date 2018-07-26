local BasePlugin = require 'kong.plugins.base_plugin'
local KongPlugin = BasePlugin:extend()
local responses = require 'kong.tools.responses'

function KongPlugin:new()
  KongPlugin.super.new(self, "null")
end

function KongPlugin:access(--[[ config ]])
  KongPlugin.super.access(self)
  responses.send_HTTP_OK('Hello World!')
end

return KongPlugin
