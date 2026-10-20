# Dotfiles — santos-404

Fish, Ghostty, tmux, Fastfetch and a small development-session helper, shared
between macOS and Linux. Neovim lives in [init.lua](https://github.com/santos-404/init.lua).

## Fresh Fedora KDE installation

These instructions target conventional **Fedora KDE Plasma Desktop**, not the
Atomic/Kinoite edition. Run commands as your normal user; package installation
asks for sudo when needed.

```bash
sudo dnf install -y git
git clone https://github.com/santos-404/dotfiles "$HOME/dotfiles"
cd "$HOME/dotfiles"
bash packages.sh --with-ghostty
bash install.sh
```

`--with-ghostty` explicitly
enables the community `scottames/ghostty` COPR listed in
[Ghostty's installation documentation](https://ghostty.org/docs/install/binary#fedora).
DNF asks before enabling the repository. Omit that flag to install the other
tools and continue using Konsole.

The package script installs Fish, tmux, Fastfetch, fzf, zoxide, Neovim, ripgrep,
fd, jq, build tools, Go, Node/npm, Tree-sitter CLI, fonts and Wayland/X11 clipboard
helpers. It does not install Hyprland, Waybar, Wofi or replace KDE's panel/launcher.
Language-specific SDKs, AI provider CLIs, Steam and graphics drivers are separate.
`opencode`, `claude` and `lazygit` aliases require those tools to be installed;
the `dev` helper leaves its AI window as a shell when OpenCode is unavailable.

### Neovim

```bash
git clone https://github.com/santos-404/init.lua "$HOME/.config/nvim"
cd "$HOME/.config/nvim"
bash setup.sh
```

Back up any existing Neovim directory before cloning. The Neovim repo documents
its minimum version, plugin bootstrap and language-server installation.

### Make Fish the login shell (optional)

```bash
chsh -s "$(command -v fish)"
```

Log out and back in afterwards. Fish is not forced as the login shell by the
installer. Ghostty's `shell-integration = fish` enables integration; it does not
select the shell executable. In Fish, `zoxide` supplies the enhanced `cd` alias
when installed. Startup still works without zoxide or fzf.

## Linking, backups and updates

`install.sh` links these repository files under `${XDG_CONFIG_HOME:-$HOME/.config}`:

- `fish/config.fish`
- `ghostty/config` and the selected `ghostty/config.platform`
- `tmux/tmux.conf`
- `fastfetch/config.jsonc`
- `opencode/opencode.jsonc` (an optional app; no credentials or app install)

Scripts are linked under `~/.local/bin`. Existing conflicting files or links
are moved into the config directory's `dotfiles/backups/<timestamp>-<pid>/`;
correct links are left alone. Existing tmux-resurrect checkouts are reused,
otherwise the installer clones the plugin. Use `bash install.sh --skip-plugins`
for offline linking. The installer does not change your login shell or KDE settings.

On a machine already using these links, edits are edits to the checkout. Before
pulling, inspect `git status` and commit your intended changes. Then:

```bash
cd "$HOME/dotfiles"
git pull --ff-only
bash install.sh
```

`bash unlink.sh` removes only links still pointing into this checkout, including
the actual tmux config path. It retains backups and private overrides. Restore a
backup manually if you want to return to a previous config.

## Private and machine-specific settings

Never put tokens or credentials in the shared Fish config. Put them in
`~/.config/fish/config.local.fish` (or the corresponding XDG config directory)
and restrict permissions with `chmod 600`. It is sourced on every Fish startup.
`fish_variables`, shell history and authentication files are not managed by this
repository. Copy private settings separately when moving machines.

Ghostty loads the installed platform profile and optional
`~/.config/ghostty/config.local` overrides. Re-run `install.sh` after cloning on a
different OS so it selects the right platform file.

## Fedora KDE appearance and shortcuts

The current Ghostty theme is `0x96f`, with 90% opacity and background blur. KDE
Plasma supports blur; enable **Blur** in System Settings → Desktop Effects if
needed. Ghostty quick terminal uses **Ctrl+Alt+S** on Linux and **Cmd+Ctrl+T** on
macOS. Accept Ghostty's global-shortcut request when Plasma presents it. KDE may
already use some Alt/arrow shortcuts; adjust conflicts in System Settings.

The tmux prefix is **Ctrl+S**; reload with prefix then `q`. Save/restore sessions
with prefix then `S` / `U` using tmux-resurrect. Alt+1…9 switches tmux windows.
Ghostty uses its bundled font by default, including icon glyphs.

These repos configure developer applications. They do not contain a complete
KDE global theme, wallpaper collection, or Omarchy/Hyprland desktop configuration.

## Other systems

`packages.sh` also has macOS/Homebrew, Arch, Debian/Ubuntu and openSUSE branches.
The Fedora branch is the primary migration target; package versions and
availability on other distributions vary. On Debian, check the Neovim repo's
minimum version before using the distribution package. Ghostty installation on
Debian/older Ubuntu is manual; the script links to upstream instructions.

`make packages` installs core tools, `make link` links configs, and `make all`
installs packages before linking. Use `bash packages.sh --with-ghostty` to request
Ghostty explicitly.
