# Project guide for agents

## Purpose

Build Rust firmware for a remote power switch using an ESP32-C3 Super Mini and a relay
module intended to switch a 110 V AC load.

## Current state

- Bare-metal Rust (`no_std`, `no_main`), edition 2024, stable toolchain.
- Target: `riscv32imc-unknown-none-elf`; HAL: `esp-hal` 1.2.2.
- Startup logging and a five-second heartbeat are implemented.
- Relay GPIO, Wi-Fi, and remote commands are not implemented.
- Formatting, Clippy, release build, and image generation passed during setup.
- Firmware has not been flashed or validated on the intended C3 hardware.

## Hardware context

The user confirmed the intended controller is an **ESP32-C3 Super Mini**, from
[Amazon listing B0GQM4SRS3](https://www.amazon.ca/dp/B0GQM4SRS3).
Use the nominal 22.52 × 18 mm SuperMini footprint for enclosure planning, based on
[Nologo's board reference](https://www.nologo.tech/product/esp32/esp32c3/esp32c3supermini/esp32C3SuperMini.html).
The exact Amazon variant's mechanical dimensions have not been verified. Header
installation, connector envelope, height, and retention method remain open.

On 2026-11-09, `espflash board-info` identified `/dev/ttyACM0` as an **ESP32-S3**
revision 0.2, with 4 MB flash and MAC `ac:27:6e:b0:10:68`.
This differs from the configured ESP32-C3 target. Re-query the device before
flashing; port names and attached boards can change. Do not flash the C3 image
to that S3 or change the project target solely because that board is connected.

The actuator web-control server previously held this port and was stopped at
the user's request. If connections fail, inspect port ownership before retrying.

Hardware details still to establish:

- Intended board model is confirmed: ESP32-C3 Super Mini. TODO: verify the
  purchased board's pinout and mechanical details before fixing GPIOs or mounts.
- Photo shows four SRD-12VDC-SL-C relays (12 V DC coils), on a board labeled
  for high/low-level triggering. Exact module model, supply wiring, and 3.3 V
  GPIO compatibility remain to be verified.
- TODO: relay GPIO and active-high/active-low polarity.
- TODO: external inactive-state bias during reset and power loss.
- TODO: load type, current/inrush, and suitable relay contact ratings.

## Repository map

- `src/main.rs`: firmware entry point and bring-up heartbeat.
- `Cargo.toml`, `Cargo.lock`: dependencies and build profiles.
- `.cargo/config.toml`: target, runner, and compiler flags.
- `rust-toolchain.toml`: toolchain and target installation requirements.
- `build.rs`: ESP linker script configuration.
- `README.md`: setup, build, flashing, and hardware notes.
- `hardware/enclosure/`: parametric OpenSCAD enclosure and fit-check STL files.
  Read its README before changing dimensions; hole offsets and controller fit
  are provisional, and this housing is not validated for powered mains use.
  User selected replacement inlet Amazon ASIN B0FFS5SBZZ and outlet B07WV7MTQH
  on 2026-11-20. Read `hardware/enclosure/selected-connectors.md`: it records the
  listing dimensions read on 2026-11-20. The inlet is a 42 × 27 mm, 50 mm hole
  pitch C14 module with a switch and no fuse. The outlet is a BESTTEN decorator
  wall-box receptacle (103 mm strap), which the current wall-mount layout cannot
  hold. A lid-mounted row in a 235 mm box now exists as an Onshape custom feature:
  `hardware/enclosure/onshape/` holds the FeatureScript source, document link and
  preview. The OpenSCAD/STL files have NOT been adapted and still describe the
  PREVIOUS reference geometry, as follows.
  Current revision is `socket-enclosure.scad` and `socket-*-fit-check.stl`:
  one SCHURTER 6100.3300 C14 inlet plus four Interpower 88261100 NEMA 5-15R
  outlets, two per front/rear wall. User explicitly selected standard Canadian/US
  three-prong outlets. Assembled dimensions 200 × 180 × 73 mm; fits P1S / H2C.
  Includes 4 mm walls/floor, 6 mm through-bolt mounting panels with side gussets,
  a continuous top rim, removable inner guard and connector
  fit coupon. Print and check coupon first. Controller retention, actual connector
  hardware, insulation, protection and wiring remain unresolved. The previous
  gland design is retained separately; do not mix its base/lid with socket parts.
  Keep the proposed Super Mini position aligned with its rear USB opening.


## Development and validation

Run from the project root after firmware changes:

```sh
cargo fmt --check
cargo clippy --locked -- -D warnings
cargo build --release --locked
```

Identify connected hardware without writing flash (the query may reset it):

```sh
espflash board-info --port /dev/ttyACM0 --non-interactive --skip-update-check --no-stub
```

`cargo run --release --locked` flashes hardware and opens the monitor; it is
not a build-only check. Use it when flashing is in scope and the target matches.
Keep the relay and AC load disconnected during initial board bring-up.
Report compile checks and hardware observations separately.

## Implementation guidance

- Keep changes focused; update the README when behavior or setup changes.
- Keep relay control unconfigured until the pin and electrical interface are known.
- Do not add relay toggling to a heartbeat or startup demonstration.
- Define OFF behavior for startup, reset, faults, and lost connectivity before
  introducing commands that energize the relay. Software alone cannot guarantee
  an inactive relay during reset or loss of power.
- Keep credentials out of source control and logs.
- TODO: choose Wi-Fi provisioning and an authenticated remote protocol.
- TODO: define command acknowledgements, state reporting, and reconnect behavior.
- Add meaningful tests as control logic develops; there is currently no host
  unit-test harness for the firmware binary.

## Next milestone

Confirm the intended hardware, then implement and verify relay OFF initialization
with a low-voltage test load before adding remote switching.
