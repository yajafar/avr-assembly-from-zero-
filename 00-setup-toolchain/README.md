# 00 - Toolchain Setup

This section sets up the toolchain used throughout the project.

The goal is to write AVR assembly, build it into a HEX file, upload it to an Arduino Nano / ATmega328P, and inspect the final disassembly.

The main workflow is:

```text
.S assembly source
        ↓
.elf executable file
        ↓
.hex uploadable file
        ↓
Arduino Nano flash memory
```

## Tools used

This project uses:

- `avr-gcc` - builds AVR programs
- `avr-objcopy` - converts ELF files into HEX files
- `avr-objdump` - shows disassembly
- `avrdude` - uploads the HEX file to the Arduino Nano
- `make` - automates the build/upload commands

## Linux setup

On Debian/Ubuntu-based systems:

```bash
sudo apt update
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

## Windows setup

There are two realistic options on Windows.

### Option 1: WSL, recommended

The simplest and cleanest option is to use WSL with Ubuntu.

Inside WSL:

```bash
sudo apt update
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

This gives you a Linux-like workflow, which matches the rest of this project.

One thing to keep in mind: uploading to the Arduino from WSL may require extra USB/serial setup depending on your Windows configuration.

If USB/serial access becomes annoying, you can still build the `.hex` file in WSL and upload it from Windows using AVRDUDE or another upload tool.

### Option 2: MSYS2, native Windows

If you want a native Windows setup, MSYS2 is another option.

Install MSYS2, open the **MINGW64** terminal, then install AVR tools with `pacman`.

Package names may change over time, but the general idea is:

```bash
pacman -S mingw-w64-x86_64-avr-gcc
pacman -S mingw-w64-x86_64-avrdude
pacman -S make
```

Then use the same project commands:

```bash
make
make upload
make disasm
make clean
```

On Windows, the serial port will usually look like:

```text
COM3
COM4
COM5
```

So upload may look like:

```bash
make upload PORT=COM3
```

## macOS setup

On macOS, use Homebrew.

Install the AVR toolchain and AVRDUDE:

```bash
brew tap osx-cross/avr
brew install avr-gcc
brew install avrdude
brew install make
```

Depending on your macOS setup, `make` may already be available through the Xcode Command Line Tools.

You can install those with:

```bash
xcode-select --install
```

The Arduino Nano serial port on macOS usually looks like:

```text
/dev/cu.usbserial-XXXX
/dev/cu.usbmodemXXXX
```

So upload may look like:

```bash
make upload PORT=/dev/cu.usbserial-XXXX
```

## Finding the Arduino port

### Linux

Plug in the Arduino Nano and run:

```bash
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null
```

Common ports:

```text
/dev/ttyUSB0
/dev/ttyACM0
```

If you get permission errors, add your user to the `dialout` group:

```bash
sudo usermod -aG dialout $USER
```

Then log out and log back in.

### macOS

Run:

```bash
ls /dev/cu.*
```

Look for something like:

```text
/dev/cu.usbserial-XXXX
/dev/cu.usbmodemXXXX
```

### Windows

Check Device Manager under:

```text
Ports (COM & LPT)
```

Look for the Arduino Nano port, usually something like:

```text
COM3
COM4
COM5
```

## Arduino Nano upload settings

Most newer Nano bootloaders use:

```make
BAUD = 115200
```

Some older Nano bootloaders use:

```make
BAUD = 57600
```

If upload fails, try changing the baud rate.

Example:

```bash
make upload BAUD=57600
```

## Typical commands

Build the project:

```bash
make
```

Upload to the Arduino Nano:

```bash
make upload
```

Show the disassembly:

```bash
make disasm
```

Clean generated files:

```bash
make clean
```

## Overriding Makefile settings

You can override settings directly from the terminal.

Example: different serial port

```bash
make upload PORT=/dev/ttyACM0
```

Example: old Nano bootloader

```bash
make upload BAUD=57600
```

Example: different source file

```bash
make upload TARGET=buttonblink
```

If `TARGET=buttonblink`, the Makefile expects the source file to be named:

```text
buttonblink.S
```

## Notes

This project is mainly developed and tested on Linux.

Windows and macOS should work too, but port names, permissions, and upload behavior may differ slightly depending on the board, USB chip, driver, and bootloader.