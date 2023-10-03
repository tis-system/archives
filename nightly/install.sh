#!/bin/sh

set -e

case $(uname -sm) in
"Darwin x86_64") target="darwin_amd64" ;;
"Darwin arm64") target="darwin_arm64" ;;
*) target="linux_amd64" ;;
esac


tis_url="https://tis.tetrate.io/archives/nightly/cli_nightly_${target}.tar.gz"

tis_install="${TIS_INSTALL:-$HOME/.tis}"
bin_dir="$tis_install/bin"
exe="$bin_dir/tis"

if [ ! -d "$bin_dir" ]; then
	mkdir -p "$bin_dir"
fi

curl --fail --location --progress-bar --output "$exe.tar.gz" "$tis_url"
tar xvf "$exe.tar.gz" -C "$bin_dir"
chmod +x "$exe"
rm "$exe.tar.gz"

echo "tis CLI was installed successfully to $exe"
if command -v tis >/dev/null; then
	echo "Run 'tis --help' to get started"
else
	case $SHELL in
	/bin/zsh) shell_profile=".zshrc" ;;
	*) shell_profile=".bash_profile" ;;
	esac
	echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
	echo "  export PATH=\"$bin_dir:\$PATH\""
	echo "Run '$exe --help' to get started"
fi
