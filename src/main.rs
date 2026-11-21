#![no_std]
#![no_main]

use esp_backtrace as _;
use esp_hal::{
    main,
    time::{Duration, Instant},
};
use esp_println::println;

esp_bootloader_esp_idf::esp_app_desc!();

#[main]
fn main() -> ! {
    // Do not configure a relay GPIO until the board pinout and relay's logic
    // voltage/polarity are confirmed. A floating input is NOT a guaranteed OFF
    // state: leave the relay disconnected during this initial USB-only test.
    let _peripherals = esp_hal::init(esp_hal::Config::default());

    println!("smart-switch: ESP32-C3 firmware started");
    println!("Bring-up mode: relay GPIO and remote control are not configured");

    loop {
        let started = Instant::now();
        while started.elapsed() < Duration::from_secs(5) {
            core::hint::spin_loop();
        }
        println!("smart-switch: alive (relay control disabled)");
    }
}
