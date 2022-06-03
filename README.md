# Zig PortScan

Simple port scanning CLI tool made with Zig.

# Dependencies

* `zig >= 0.10.0`
* `MasterQ32/zig-args == 1ff417ac`

Project dependencies are managed with ad-hoc Nix flake (for now hardcoded for x86_64 Linux).
Usage:

```sh
nix develop
nix-install-dependencies # alternatively: nix build -o external .#dependencies
```

# Usage

CLI options:
```
zig-portscan [OPTION...] PORTRANGES...

-a, --address=127.0.0.1		Address to scan
-t, --timeout=200		Timeout in miliseconds for connection attempt

PORTRANGES may be listed as seperate ports or specified as range in format FROM-TO.
Example:
    zig-portscan 22 80
    zig-portscan 22-100
```
