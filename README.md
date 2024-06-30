# vim-imagegen

vim-imagegen is a Dockerfile generator, for minimum reproducible Vim environment.

## Usage

```bash
curl -sSLO https://github.com/sevenc-nanashi/vim-imagegen/releases/download/latest/vim-imagegen
chmod +x vim-imagegen

./vim-imagegen
```

## Options

```yml
Usage: vim-imagegen [options] <manifest>
    $GH_TOKEN, $GITHUB_TOKEN         GitHub Personal Access Token to use for API requests
    -o, --output [OUTPUT]            Output file
    -r, --run                        Whether to run Dockerfile
    -y, --yes                        Run Dockerfile without asking for confirmation
```

## Manifest

Please refer `manifest.schema.yml` for the schema, and `manifest.example.yml` for the example.

## License

This script is released under the MIT License.
