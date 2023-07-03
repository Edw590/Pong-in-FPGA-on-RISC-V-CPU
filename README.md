# Pong in FPGA on RISC-V CPU
Pong game with NES controller clones for the Digilent FPGA Dev Board Basys 3, coded in Verilog and C with IOb-SoC as base

## Pictures
<img src="Pictures/Game picture.jpg" width="500"><img src="Pictures/Full set.jpg" width="500">

## Introduction
This was a project for the Integrator Project course in the Electrical and Computer Engineering degree, coded in 2023.

It's the Pong arcade game, but coded in C and with Verilog helping interface the software with (and controlling) the hardware and with the [IOb-SoC](https://github.com/IObundle/iob-soc) platform/System-On-Chip template as base. The game is fully programmed in C, but the VGA interface controller and the Nintendo Entertainment System (NES) controllers interface are in Verilog (had to be - hardware stuff). It's not as complete as it could be, but it still got to a cool point!

## How the game works
- The ball starts in a random direction (except the first time - it uses the internal clock of the board, which is always the same when the game starts, and then gets random because of human interaction). As supposed whenever it hits the paddles, it's reflected - though only in 45º up, 180º back or 45º down (no complete angles, only these 3).
- The paddles also have 2 speeds, and if they hit the ball when in high speed and their direction is the same as the ball's, the ball speed will also increase.
- If the ball hits one of the lateral sides of the screen, it gets the color of the player who scored the point, the whole game (includes the paddles) pauses for a second, and the ball is reset randomly.

## How it was done
As a start [IOb-SoC](https://github.com/IObundle/iob-soc) (by [IObundle](https://github.com/IObundle)) was used to be the base of the project, with many very useful things already in place (like a CPU or hardware/software interaction or other infinite internal stuff) - without it, infinite work would have to be done and it provided a stable base. Then the [iob-vga](https://github.com/IObundle/iob-vga) project (by [DanielProanoGuevara](https://github.com/DanielProanoGuevara) and [pedrogsfaria](https://github.com/pedrogsfaria)) was used to be the VGA interface (to give time to take care of the controllers and whatever else instead of making something already made). And also [iob-timer](https://github.com/IObundle/iob-timer) (by [IObundle](https://github.com/IObundle)) was used to slow down the game (else it would run at full CPU speed).

After this, a module was created to control the VGA interface to give it the information it needed to print things to the screen, the PMEM module - "Pseudo-Memory". It's not a memory, it calculates in real-time what color to give to each coordinate that the VGA interface requires (since it's always scanning the screen and asking for every coordinate). So no memory was needed. At most 3 registers to store positions and colors and macros to tell the height and width of the 3 objects.

The NES controllers interface also had to be created, to send and receive data to/from them - the NESCTRL module (NES controllers). Was the most interesting part to make of the whole project (involved checking the datasheet of a component (HEF4021B - the one used inside the clones) and using the oscilloscope). Note: the first 6 commits to this module are in [this repository](https://github.com/Edw590/iob-nesctrl).

And with all this, the rest was done in software, while interfacing with the hardware to give (to the VGA interface controller) and retrieve (from the NESCTRL) information - begins in the firmware.c file (with other .c/.h files in the mix too).

## Developer note
Don't use `make all` - that command exists *only* (in this project specifically) for CLion to detect and understand *part* of the project and doesn't do anything useful I think (maybe compile the firmware? I don't remember. But it's not supposed to be used at all) - VS Code was used as main editor. CLion only to check if there were mistakes in the code (it couldn't understand the project decently to have it as main IDE, and VS Code could). Use the other Makefile commands. `make all`, at most edit to add new files to it, but not to compile the project.

## License
This project is licensed under the MIT License.
