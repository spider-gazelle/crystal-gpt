# ChatGPT Plugin Template

The easiest way to build ChatGPT plugins.

1. Build your routes, example routes in `plugin_routes.cr`
2. Add comments to describe them to ChatGPT
3. Update `shard.yml` with your plugin name and description
4. Everything else is automatically generated

OpenAI allows you [test plugins locally](https://platform.openai.com/docs/plugins/getting-started/running-a-plugin)

## Why use this template?

You can [extend ChatGPTs abilities](https://openai.com/blog/chatgpt-plugins#third-party-plugins) via a web service - but you have to write extremely detailed documentation on how it works with comments describing what each function does

In this template there is a file under src/controllers called [plugin_routes.cr](https://github.com/spider-gazelle/crystal-gpt/blob/main/src/controllers/plugin_routes.cr) that implements the functions ChatGPT can use, in this case implementing a very basic todo application.

[Spider-Gazelle](https://spider-gazelle.net/), the web framework this template is built on, introspects itself and then outputs all the metadata ChatGPT needs to be able to use those functions.

Feel free to re-name `plugin_routes` to something more descriptive and you can add as many additional controllers as you require. Just remember to add comments to each route / function so ChatGPT can understand what they are used for.

## Testing

`crystal spec`

* to run in development mode `crystal ./src/app.cr`

## Compiling

`crystal build ./src/app.cr`

## Testing plugins

Firstly, you'll need to enable this [Permissions-Policy feature](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy/document-domain) in [your browser](https://caniuse.com/mdn-http_headers_permissions-policy_document-domain)

* Obtain a ChatGPT API key from either [OpenAI](https://platform.openai.com/account/api-keys) or [Azure](https://portal.azure.com/) (Azure AI services | Azure OpenAI)
* Install [Chat Copilot](https://learn.microsoft.com/en-us/semantic-kernel/chat-copilot/getting-started) for local development
  * Configure [plugins for testing](https://learn.microsoft.com/en-us/semantic-kernel/chat-copilot/testing-plugins-with-chat-copilot)

Alternatively you can use Plugin feature on [OpenAI ChatGPT web UI](https://chat.openai.com/?model=gpt-4-plugins)
