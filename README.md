# Dev Container Features

Custom [dev container Features](https://containers.dev/implementors/features/) hosted on GitHub Container Registry (GHCR).

## Features

### `neovim-tools`

Installs [neovim](https://github.com/neovim/neovim), [ripgrep](https://github.com/BurntSushi/ripgrep), and [fzf](https://github.com/junegunn/fzf) from GitHub releases.

#### Usage

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/TechnicallyJoe/features/neovim-tools:1": {}
    }
}
```

#### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `neovimVersion` | string | `latest` | Version of neovim (e.g. `v0.10.4` or `latest`) |
| `ripgrepVersion` | string | `latest` | Version of ripgrep (e.g. `14.1.1` or `latest`) |
| `fzfVersion` | string | `latest` | Version of fzf (e.g. `v0.62.0` or `latest`) |

#### Example with pinned versions

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/TechnicallyJoe/features/neovim-tools:1": {
            "neovimVersion": "v0.10.4",
            "ripgrepVersion": "14.1.1",
            "fzfVersion": "v0.62.0"
        }
    }
}
```

## Repo Structure

```
├── src
│   └── neovim-tools
│       ├── devcontainer-feature.json
│       └── install.sh
├── test
│   └── neovim-tools
│       ├── test.sh
│       ├── scenarios.json
│       └── pinned_versions.sh
```

## Publishing

Features are published to GHCR automatically on push to `master` via the [release workflow](.github/workflows/release.yaml). Each feature is versioned by the `version` field in its `devcontainer-feature.json`.

Note: GHCR packages are private by default. To use them freely, mark them as public in the package settings.
