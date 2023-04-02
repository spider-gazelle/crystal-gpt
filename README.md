# ChatGPT Plugin Template

The easiest way to build ChatGPT plugins.

1. Build your routes, example routes in `plugin_routes.cr`
2. Add comments to describe them to ChatGPT
3. Update `shard.yml` with your plugin name and description
4. Everything else is automatically generated

OpenAI allows you test plugins locally
https://platform.openai.com/docs/plugins/getting-started/running-a-plugin

## Testing

`crystal spec`

* to run in development mode `crystal ./src/app.cr`

## Compiling

`crystal build ./src/app.cr`
