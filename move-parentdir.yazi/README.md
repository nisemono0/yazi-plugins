# move-parentdir.yazi
Move to next/previous parent directory

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:move-parentdir
```

## Usage
Add this to your `keymap.toml`:
```toml
[mgr]
prepend_keymap = [
    { on = "[", run = "plugin move-parentdir prev", desc = "Enter previous parent directory" },
    { on = "]", run = "plugin move-parentdir next", desc = "Enter next parent directory" },
]
```
