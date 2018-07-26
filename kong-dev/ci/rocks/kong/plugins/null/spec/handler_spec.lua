local helpers = require 'kong.spec_helpers'

describe("kong.plugins.null", function()
  setup(function()
    local api = assert(helpers.dao.apis:insert {
      name = "test",
      uris = { "/blah" },
      upstream_url = "http://localhost",
      preserve_host = true,
      strip_uri = false,
    })

    assert(helpers.dao.plugins:insert {
      name = "null",
      api_id = api.id,
      config = {}
    })

    assert(helpers.start_kong({ custom_plugins = "null" }))
  end)

  teardown(helpers.stop_kong)

  it("picks it up", function()
    local req = helpers.proxy_client():send {
      method = "GET",
      path   = "/blah",
      headers = {}
    }

    assert.equal(req:read_body(), '{"message":"Hello World!"}\n')
  end)
end)
