# Breakout Game - FPGA & Verilog Implementation

This repository contains a digital implementation of the classic arcade game **Breakout**, developed using **Verilog** on a **Spartan-3E FPGA** board with VGA display support.

## Overview

The project demonstrates:
- Digital system design and FPGA programming using Verilog.
- Implementation of VGA protocol for visual output.
- Real-time interaction and game logic execution.

## Game Description

In **Breakout**, the player controls a paddle at the bottom of the screen, bouncing a ball towards blocks at the top of the screen. The objective is to destroy all blocks. The game features multiple levels with increasing ball speed and complexity.

## Technical Highlights

- Implemented VGA at 640x480 pixels resolution (60 Hz refresh rate).
- Used shift registers and counters for efficient handling of game dynamics.
- Integrated debouncing circuits to improve button response.
- Implemented collision detection and level progression logic.

## Files Included
- `Breakout_Verilog.pdf`: Comprehensive documentation and explanation of implementation.
- Verilog source files (to be added)

## Challenges and Solutions
- Adjusted FPGA's clock frequency from 50 MHz to 25 MHz to comply with VGA timing.
- Reduced block count to improve FPGA synthesis and performance.
- Implemented debouncing to resolve paddle movement responsiveness issues.

## Possible Future Improvements
- Increasing the number of blocks and levels.
- Introducing multiple-hit blocks and multiplayer mode.
- Enhanced ball physics and collision response mechanics.

## Authors
- **Jelena Matić**
- **Bruno Grbavac**
