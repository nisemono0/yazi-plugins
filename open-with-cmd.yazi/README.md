# open-with-cmd.yazi
Open file(s) with specified command

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:open-with-cmd
```

## Usage
Add this to your `keymap.toml`:
```toml
[mgr]
prepend_keymap = [
    { on = "<A-o>", run = "plugin open-with-cmd", desc = "Open with command in the terminal" },
    { on = "<A-O>", run = "plugin open-with-cmd block", desc = "Open with command in the terminal (block)" },
]
```


