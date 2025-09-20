# simple-mediainfo.yazi
Preview media files using `mediainfo`. Has no image preview.

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:simple-mediainfo
```

## Usage
Add this to your `yazi.toml`:
```toml
[plugin]
prepend_previewers = [
    { mime = "{audio,video,image}/*", run = "simple-mediainfo" },
]
```
