return {
  {
    name = "001-test-migrations-in-kong-dev",
    up = [[
      CREATE TABLE IF NOT EXISTS null_plugin_migration_test (
          id uuid PRIMARY KEY
      );
    ]],
    down = [[
      DROP TABLE null_plugin_migration_test;
    ]]
  }
}