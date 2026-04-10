## How it works

This project implements a real-time VGA graphics demo using a tunnel (warp) effect generated entirely in hardware using Verilog.

A VGA timing generator produces horizontal and vertical synchronization signals along with pixel coordinates (x, y). These coordinates are used to compute a procedural visual effect without any external memory.

The tunnel effect is created using:
- Distance approximation from the screen center to form concentric rings
- Bitwise operations to approximate angular variation
- A time-based counter to animate motion

The combination of these produces a dynamic illusion of moving through a 3D tunnel. The design uses only simple arithmetic and logic operations, making it efficient and suitable for implementation within a single Tiny Tapeout tile.

RGB outputs are generated using 2-bit color channels, providing multiple color variations based on depth and pattern.


## How to test

1. Connect the Tiny Tapeout VGA PMOD to a compatible VGA display.
2. Power on the board and enable the design using the Tiny Tapeout control interface.
3. Reset the design.
4. The demo will automatically start running.

You should observe a continuously animated tunnel-like visual effect on the screen, giving the impression of forward motion.

No user input is required.


## External hardware

- VGA PMOD (required for video output)
- VGA-compatible display

No other external hardware is used.
