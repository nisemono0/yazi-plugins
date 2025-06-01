# audio-preview.yazi
Preview soundfiles as spectrogram using `sox`

## Installation
```sh
ya pkg add nisemono0/yazi-plugins:audio-preview
```

## Usage
Add this to your `yazi.toml`:
```toml
[plugin]
prepend_preloaders = [
    { mime = "audio/*", run = "audio-preview" },
]
prepend_previewers = [
    { mime = "audio/*", run = "audio-preview" },
]
```
