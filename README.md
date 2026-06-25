# OpenSCAD Gear Generator

A parametric spur gear generator script for OpenSCAD built with the BOSL2 library. It allows you to quickly generate functional mechanical gears with custom tooth specs, integrated hubs, and pre-configured industrial motor shaft profiles.

## Features

- **Parametric Gear Control**: Adjust module, teeth count, pressure angle, thickness, and backlash directly via the OpenSCAD Customizer.
- **Integrated Hub/Boss**: Extrude a custom boss on top of the main gear for fastening options.
- **Built-in Motor Shaft Library**: Automatically cuts out proper shaft shapes including:
  - `NEMA17` (D-shaft)
  - `BO_MOTOR` (Dual flat hobby motor)
  - `KEYED_8MM` (Industrial keyed shaft)
  - `DUAL_FLAT_6MM`
  - `HEX_12MM`
  - `SQUARE_10MM`
  - `SERVO_MG996R` (Spline cavity profile)
  - `ROUND_5MM` / `ROUND_6MM`
- **Fasteners**: Built-in support for radial set-screws (single or dual at 90°) with optional hex nut traps.

## Prerequisites

- **OpenSCAD** (v2021.01 or newer recommended)
- **BOSL2 Library** (Belfry OpenSCAD Library v2)

### System Validation & Dependencies Installation
Ensure your system paths recognize BOSL2. On Ubuntu 24.04, you can install OpenSCAD and map the library via your local configuration directory:

```bash
# 1. Install OpenSCAD
sudo apt update && sudo apt install openscad -y

# 2. Clone BOSL2 into your OpenSCAD library folder
mkdir -p ~/.local/share/OpenSCAD/libraries
git clone [https://github.com/BelfrySCAD/BOSL2.git](https://github.com/BelfrySCAD/BOSL2.git) ~/.local/share/OpenSCAD/libraries/BOSL2
