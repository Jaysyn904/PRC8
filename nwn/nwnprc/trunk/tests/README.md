# PRC8 Automated In-Engine Test Suite

This directory contains the automated NWScript test harness (`x3_mod_def_enter.nss`) and modular feature test suites (`test_*.nss`) for PRC8.

## How `make test` Works

Running `make test` from `nwn/nwnprc/trunk/` (or `sh ./build.sh test` inside `nwn/nwnprc/trunk/tests/`) performs two steps:

1. **Compile (`scripts` target)**:
   - Filters `tests/*.nss` for entry-point scripts containing `main` (`x3_mod_def_enter.nss`) while treating modular suite files (`test_binder_nui.nss`, etc.) as `#include` headers.
   - Tracks all `*.nss` files in `tests/` as prerequisites (`INCLUDES = $(wildcard *.nss)`) so modifying any suite header triggers recompilation of `x3_mod_def_enter.ncs`.
2. **Execute (`run` target)**:
   - Temporarily stages `x3_mod_def_enter.ncs` into `$NWN_USER_DIR/override/` (and removes it on exit via a shell trap so `override/` stays clean).
   - Launches NWN:EE (`nwmain-linux +TestNewModule PRC8_Tester`, wrapped in `xvfb-run -a` when running headless).
   - Monitors `$NWN_USER_DIR/logs/nwclientLog1.txt` until `EndGame("")` writes `[HARNESS] SUMMARY: PASS=<N> FAIL=<M>`, prints all `[HARNESS]`, `[PASS]`, and `[FAIL]` lines to stdout, and exits with status `0` if `FAIL=0` (or `1` on any failure or timeout).

## Required Binaries & Environment Variables

| Variable | Default / Auto-Detection | Purpose |
| :--- | :--- | :--- |
| `NSSCOMPILER` | Auto-detects `nwn_script_comp` in `PATH` or `../config.mk` | NWScript compiler used to build `.ncs` files |
| `NWN_BIN` | Auto-detects `nwmain-linux` in `PATH` or `$NWN_DIR/bin/linux-x86/nwmain-linux` | NWN:EE game binary used to run `+TestNewModule` |
| `NWN_USER_DIR` | `$HOME/.local/share/Neverwinter Nights` | NWN user directory containing `modules/`, `hak/`, `tlk/`, `override/`, and `logs/` |
| `TEST_MODULE` | `PRC8_Tester` | Module name in `$NWN_USER_DIR/modules/` whose `OnClientEnter` chains through `prc_onenter` to `x3_mod_def_enter` |
| `COMPILE_ONLY` | `0` | Set `COMPILE_ONLY=1` (`make test COMPILE_ONLY=1`) to compile test `.nss` files without launching `nwmain-linux` |

## Common Commands

```sh
# Compile and run the full automated test suite in headless NWN:EE
make test

# Compile-check all test scripts without launching NWN:EE
make test COMPILE_ONLY=1

# Remove compiled .ncs and .ndb artifacts
make clean
```
