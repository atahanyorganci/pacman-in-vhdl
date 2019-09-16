# PacMan in VHDL

## Table of Contents

+ [About](#about)
+ [Release History](#release_history)
+ [Getting Started](#getting_started)
+ [Usage](#usage)

## About <a name = "about"></a>

VHDL implementation of retro game Pacman clone developed with VHDL on Basys 3 development board.
The game is displayed through VGA port with 800x600 @60Hz resolution with 4-bit colours.
It is played using serial terminal with standard WASD controls. Player's highest and current score
is displayed on the seven segment display.

Project is initially developed for Bilkent University course EEE 102 Introduction to Digital
Circuit Design term project in fall semester of 2018 which is called version 1.0.
Projects goals were to reimplement Pacman in a resource constrained environment using VHDL while
using different ports, and onboard hardware. Then, version 2.0 was developed as a case study for
mandatory summer internship in 2019-2020 summer semester, which improved resolution, user I/O,
and using BRAM IPs from Xilinx optimized how entities are rendered.

## Release History <a name = "release_history"></a>

+ v2.0
  + Increase resolution from 600x400 @ 30Hz to 800x600 @60Hz
  + Change user control from pushbuttons to serial communication
  + Add BRAM components for crossing clock domains
  + Embed ghost, player, food sprites into ROMs for better performance
  + Switch to Xilinx's clock wizard IP for generating VGA clocks
  + Refactor the source files, and implement naming scheme for signals, ports, etc.

+ v1.0 Initial Release
  + Seven segment display displays player's current and highest score
  + Push buttons are used to control player's entity
  + Display resolution is resolution from 600x400 @ 30Hz

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your FPGA for development
and testing purposes.

### Prerequisites

+ Basys 3 board, or any other board with 4 seven segment displays, RS-232 USB interface, and VGA port
can be used by editing constraints to match that particular board.
+ Vivado design tool

## Usage <a name = "usage"></a>

The board can be programmed with either precompiled bit files from one of the releases or building
the project with Vivado from a local copy. To build the project clone the repository, then import
[project file](../pacman.xpr) located in root of the repository as an existing project. Then,
generate bitstream with the local copy. If you have downloaded the project's precompiled binary file
connect your board and using Hardware Manager program your board.

### How to Play

After the board is programmed connect to the serial port used by the port. Programs such as
[Putty](https://putty.org/), and [Docklight](https://docklight.de/) can be used to communicate with
the board. After connecting to the serial port using ASCII codes of lower case WASD characters the
player can move up, right, down, and left respectively.
