# Smart Switch

Rust firmware foundation for a remote power switch using an ESP32-C3 Super Mini board
and a relay module intended to switch a 110 V AC load.

Selected controller: [ESP32-C3 Super Mini, Amazon B0GQM4SRS3](https://www.amazon.ca/dp/B0GQM4SRS3).
The intended C3 is distinct from the ESP32-S3 previously identified on
`/dev/ttyACM0`; verify the attached chip before flashing.

## Current behavior

The firmware initializes the ESP32-C3, prints a startup message, and reports a
heartbeat every five seconds. It does not configure any relay GPIO or connect to
Wi-Fi yet. This is a USB-only board bring-up milestone.

The project uses bare-metal `no_std` Rust with `esp-hal` and the
`riscv32imc-unknown-none-elf` target. The C3 uses the standard Rust toolchain;
an Xtensa toolchain or ESP-IDF SDK installation is not required. Dependency
versions follow the official [esp-generate template](https://github.com/esp-rs/esp-generate/tree/main/template).
`esp-bootloader-esp-idf` provides application metadata compatible with the
bootloader used by `espflash`; it does not make this an ESP-IDF application.

## Setup

Install Rust through [rustup](https://rustup.rs/) if needed, then run:

```sh
rustup toolchain install stable --profile minimal
rustup component add rustfmt clippy --toolchain stable
rustup target add riscv32imc-unknown-none-elf --toolchain stable
cargo install espflash --locked
```

Rust 1.95 or newer is required. `rust-toolchain.toml` selects stable and declares
the target and components. `Cargo.lock` pins the application dependencies.

## Build and check

Run these commands from this project directory:

```sh
cargo fmt --check
cargo clippy --locked -- -D warnings
cargo build --release --locked
```

Firmware ELF: `target/riscv32imc-unknown-none-elf/release/smart-switch`.
This is a hardware firmware binary, so it has no host unit-test harness.

## Flash and monitor

Connect only the ESP32-C3 board over a USB data cable, leaving the relay and AC
load disconnected. Flashing replaces the firmware already on the selected board.

```sh
cargo run --release --locked
```

Cargo invokes `espflash flash --monitor --chip esp32c3`. To choose a port explicitly:

```sh
cargo run --release --locked -- --port /dev/ttyACM0
```

If automatic flashing fails and the board has BOOT and RESET buttons, hold BOOT,
tap RESET, release BOOT, and retry. The exact procedure and port depend on the
board revision. Exit the serial monitor with Ctrl+C.

## Hardware details to establish before relay control

- Purchased ESP32-C3 Super Mini revision and pinout.
- Relay module model, supply voltage, input logic voltage, and active-high or
  active-low trigger. “110 V” describes neither its control supply nor its GPIO
  compatibility; confirm what that marking means on this particular module.
- A suitable relay GPIO and an external circuit that holds the relay inactive
  during reset, boot, and loss of MCU power. Firmware alone cannot guarantee this.
- Relay contact ratings suitable for the actual load and its inrush current.

Do not connect mains to any ESP32 pin or breadboard. Mains testing requires a
properly isolated supply/interface, suitable enclosure and protection, and
qualified electrical assembly. Verify initial switching using a low-voltage load.

## Next milestones

A [3D-printable enclosure fit prototype](hardware/enclosure/README.md) is available.
The current `socket-` version mounts one C14 computer-cord inlet and four standard
Canadian/US NEMA 5-15R outlets. It includes an inner guard and a connector test
panel to print first on a Bambu Lab P1S or H2C. Reinforcement includes 4 mm
walls/floor, 6 mm mounting panels, side gussets and a continuous top rim; physical
push/pull strength has not been validated. Use the specified commercial
connectors; controller retention and electrical construction remain unfinished.
The original gland version is retained separately.
The newly selected Amazon inlet/outlet modules are recorded in
[connector selection](hardware/enclosure/selected-connectors.md); mounting dimensions
are pending, so existing socket STLs still use the earlier reference parts.

1. Add a relay driver with an explicit OFF startup level after confirming the
   control interface; verify reset and brownout behavior with a low-voltage load.
2. Add Wi-Fi and an authenticated remote command interface (for example MQTT).
3. Define disconnect behavior, command acknowledgements, and state reporting.
4. Validate hardware fault behavior before integrating a mains load.

See the [Rust on ESP book](https://docs.espressif.com/projects/rust/book/) for
Espressif's Rust setup and development guidance.
