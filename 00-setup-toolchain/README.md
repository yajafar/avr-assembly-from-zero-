# 00 - Toolchain Setup

This section explains the basic toolchain needed to build and upload AVR assembly programs for the Arduino Nano / ATmega328P.

This project is mainly developed and tested on Linux. I included short Windows and macOS notes as a starting point, but they may need small changes depending on your system, board clone, USB driver, and bootloader.

The basic workflow is:

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
- `make` - automates the build and upload commands

## Linux setup

On Debian/Ubuntu-based systems:

```bash
sudo apt update
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

This is the setup I use for the project.

## Windows setup

The simplest Windows option is probably **WSL with Ubuntu**, because it gives you a Linux-like terminal and lets you use nearly the same commands as this project.

Inside WSL Ubuntu:

```bash
sudo apt update
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

One thing to keep in mind: uploading to the Arduino from WSL may require extra USB or serial-port setup.

If that becomes annoying, another option is to build the `.hex` file in WSL and upload it using a Windows AVRDUDE setup.

On Windows, the Arduino port usually looks like:

```text
COM3
COM4
COM5
```

So the upload command may look like:

```bash
make upload PORT=COM3
```

I have not tested every Windows setup, so treat this as a starting point rather than a complete Windows guide.

## macOS setup

On macOS, the usual approach is to use Homebrew.

A typical setup may look like:

```bash
brew install avrdude
brew install make
```

For the AVR GCC toolchain, macOS setups can vary. Some people install it through Homebrew taps, while others use packaged AVR toolchains.

The Arduino port on macOS usually looks like:

```text
/dev/cu.usbserial-XXXX
/dev/cu.usbmodemXXXX
```

So the upload command may look like:

```bash
make upload PORT=/dev/cu.usbserial-XXXX
```

I have not fully tested this project on macOS yet, so this section is intentionally minimal.

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

### Windows

Check Device Manager under:

```text
Ports (COM & LPT)
```

Look for something like:

```text
COM3
COM4
COM5
```

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

## Arduino Nano upload settings

Most newer Nano bootloaders use:

```make
BAUD = 115200
```

Some older Nano bootloaders use:

```make
BAUD = 57600
```

If upload fails, try changing the baud rate:

```bash
make upload BAUD=57600
```

## Common commands

Build:

```bash
make
```

Upload:

```bash
make upload
```

Show disassembly:

```bash
make disasm
```

Clean generated files:

```bash
make clean
```

## Overriding Makefile settings

You can override Makefile variables from the terminal.

Different port:

```bash
make upload PORT=/dev/ttyACM0
```

Old Nano bootloader:

```bash
make upload BAUD=57600
```

Different source file:

```bash
make upload TARGET=buttonblink
```

If `TARGET=buttonblink`, the Makefile expects the source file to be named:

```text
buttonblink.S
```

## Notes

This is not meant to be a complete cross-platform AVR toolchain guide.

It is just the minimum setup needed to follow this project. Linux is the main tested environment, while Windows and macOS notes are included to help people get started if they are not using Linux.
