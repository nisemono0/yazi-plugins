# confirm-quit.yazi
Comfirm when quitting multiple tabs

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:confirm-quit
```

## Usage
Add this to your `keymap.toml`:
```toml
[mgr]
prepend_keymap = [
    { on = "Q", run = "plugin confirm-quit", desc = "Quit the process (close all open tabs)" },
]
```
