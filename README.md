# PacMan in VHDL

## Table of Contents

+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)

## About <a name = "about"></a>

VHDL implementation of retro game Pacman clone developed with VHDL on Basys 3 development board.
The game is displayed through VGA port with 640x480 resolution at 30 FPS with 4-bit colours,
and it is played with onboard push buttons. Player's highest and current score is displayed
on the seven segment display.

Project is developed with Vivado design suite for Bilkent University course EEE 102 Introduction
to Digital Circuit Design term project in fall semester of 2018. Projects goals were to reimplement
Pacman in a resource constrained environment using VHDL while using different ports,
and onboard hardware.

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your FPGA for development
and testing purposes.

### Prerequisites

+ Basys 3 board, or any other board with 4 seven segment displays, 4 pushbuttons, and VGA port
can be used by editing constraints to match that particular board.
+ Vivado design tool

## Usage <a name = "usage"></a>

After cloning the repository, import [project file](../pacman.xpr) located in root of the repository
as an existing project. Then, your game should be ready to synthesized and uploaded to the board.
