# mangathumb.yazi
Preview images inside `zip` files using `p7zip`

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:mangathumb
```

## Usage
Add this to your `yazi.toml`:
```toml
[plugin]
prepend_preloaders = [
    { mime = "application/zip", run = "mangathumb" },
]
prepend_previewers = [
    { mime = "application/zip", run = "mangathumb" },
]
```
