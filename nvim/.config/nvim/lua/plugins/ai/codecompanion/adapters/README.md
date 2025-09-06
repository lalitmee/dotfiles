# CodeCompanion Custom Adapters

This directory contains custom adapters for CodeCompanion that extend the default functionality.

## Claude Code Adapter

The Claude Code adapter provides enhanced Claude functionality by extending CodeCompanion's built-in Anthropic adapter. This ensures full compatibility with all CodeCompanion extensions while providing optimized Claude models and settings.

### Features

- **Full Compatibility**: Works with all CodeCompanion extensions (history, tools, etc.)
- **Vision Support**: Can process images and visual content
- **Latest Models**: Defaults to Claude 3.5 Sonnet (latest version)
- **Code-Focused**: Optimized settings for programming tasks

### Installation

1. **Set your API key**:

   ```bash
   export ANTHROPIC_API_KEY='your-api-key-here'
   ```

   Add this to your shell profile (`.bashrc`, `.zshrc`, etc.) to make it permanent.

2. **Verify installation**:
   ```vim
   :CodeCompanionCheckHealth
   ```

### Configuration

The Claude Code adapter is configured in:

- **Provider Config**: `plugins/ai/codecompanion/config.lua`
- **Adapter Definition**: `plugins/ai/codecompanion/adapters/claude_code.lua`

### Usage

Once installed and configured, you can use Claude Code in CodeCompanion:

```vim
:CodeCompanion          " Start inline chat with Claude Code
:CodeCompanionChat      " Open chat buffer with Claude Code
:CodeCompanionActions   " Access Claude Code actions
```

### Troubleshooting

1. **API key issues**: Verify `ANTHROPIC_API_KEY` is set correctly
2. **Model not available**: Check if you have access to the Claude models in your Anthropic account
3. **Rate limits**: Anthropic API has rate limits - check your usage if requests fail

### Technical Details

- **Type**: HTTP adapter extending built-in Anthropic adapter
- **API**: Uses Anthropic's official REST API
- **Models**: Claude 3.5 Sonnet, Claude 3.5 Haiku, Claude 3 Opus
- **Compatibility**: Full compatibility with all CodeCompanion extensions
- **Features**: Vision support, streaming responses, proper error handling

For more information about ACP adapters, see the [CodeCompanion documentation](https://github.com/olimorris/codecompanion.nvim).
