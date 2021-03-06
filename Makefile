SCRIPTS_TO_TEST := aliases apps bash_completions.bash common darwin-init devtools files gitshit install.sh nix paste server shell-init system wireguard setup/00-android_sdk.sh setup/01-adb_multi.sh setup/02-android_udev.sh setup/common.sh

test: format
	@for script in ${SCRIPTS_TO_TEST} ; do \
		echo "Checking $$script..."; \
		shellcheck -x $$script || exit 1; \
	done

autofix:
	@shellcheck -f diff ${SCRIPTS_TO_TEST} | git apply

format:
	@shfmt -w -s -i 2 -ci ${SCRIPTS_TO_TEST}
	@find . -type f -name '*.nix' -exec nixfmt {} \;

githook:
	@ln -sf $$(pwd)/pre-push-hook .git/hooks/pre-push

install:
	@./install.sh

home-check:
	nix-channel --update
	cp nixos/home-manager.nix ~/.config/nixpkgs/home.nix
	home-manager build --show-trace

home-switch:
	nix-channel --update
	cp nixos/home-manager.nix ~/.config/nixpkgs/home.nix
	home-manager switch

server-switch:
	nix-channel --update
	cp nixos/server-configuration.nix ~/.config/nixpkgs/home.nix
	home-manager switch

.PHONY: test
