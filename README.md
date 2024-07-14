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
    -s, --silent                     Do not print Dockerfile
    -r, --run                        Whether to run Dockerfile
    -i, --include-manifest           Whether to include the manifest in the Dockerfile
    -y, --yes                        Run Dockerfile without asking for confirmation
```

## Manifest

Please refer `manifest.schema.yml` for the schema, and `manifest.example.yml` for the example.

```yml
vim:
  # Vim? Neovim?
  vim: neovim

# List of plugins to install.
plugins:
  # You can specify the repository...
  - hrsh7th/vim-eft

  - repo: neoclide/coc.nvim
    # and the ref (branch, tag, commit)
    ref: release

  # or path to local directory. 
  # (To make the Dockerfile portable, it generates a tarball, encode with base64, and decode it in the Dockerfile.
  #  This makes the Dockerfile larger, so it is recommended to use the repository if possible.)
  - path: .

  - vim-denops/denops.vim
  - vim-denops/denops-helloworld.vim

# Some plugins want external dependencies. You can specify them here.
external:
  - name: node
    version: "20"

  - name: deno

configs:
  # These files be placed under ~/.vim or ~/.config/nvim.
  # (Expect .vimrc, .vimrc will be placed on ~/.vimrc)
  init.vim: |
    nmap ; <Plug>(eft-repeat)
    # ...
```

## License

This script is released under the MIT License.
