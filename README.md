# 🚗 CAN-Based Engine Monitoring and Vehicle Control System

A high-reliability distributed automotive embedded system built with **NXP LPC2129 (ARM7TDMI-S)** microcontrollers, **Embedded C**, and the **CAN 2.0B** protocol.

---

## 🌟 Key Highlights & Modifications
* **Distributed 3-Node Architecture**: Main Telemetry Cluster, Window Control Body ECU, and Reverse Radar ADAS ECU.
* **Revamped 20×4 LCD Display Interface**:
  - Automotive boot splash screen.
  - Multi-tier engine telemetry with hysteresis.
  - 4-step glass height percentage and directional arrow animation (`▲ / ▼`).
  - Real-time obstacle proximity radar with dynamic distance bars.
* **Clean & Streamlined CAN Flow**: Removed node failure countdown blocks for smooth, uninterrupted operation.
* **Custom CGRAM Characters**: Hardware degree glyphs (`°`), directional arrows (`▲`, `▼`), and solid progress blocks (`█`).

---

## 📂 Repository Structure

```
CAN-Based-Engine-Monitoring-and-Vehicle-Control-System/
│
├── Main_Node/                         # Master Instrument Cluster ECU
│   ├── CAN.c / CAN.h                  # LPC2129 CAN1 Driver (250 kbps)
│   ├── CAN_defines.h                  # Protocol Message IDs & Commands
│   ├── dashboard.c / dashboard.h      # 20x4 LCD Telemetry Display Logic
│   ├── delays.c / delays.h            # Calibrated 60MHz Hardware Delays
│   ├── DS18B20.c / DS18B20.h          # 1-Wire Digital Temperature Driver
│   ├── EINT.c / EINT.h                # Debounced Switch & Interrupt Handlers
│   ├── LCD_functions.c / LCD.h        # 20x4 HD44780 Driver + Custom CGRAM
│   ├── MAIN_NODE.c                    # Main ECU Execution Loop
│   ├── project_functions.c / .h       # Non-blocking CAN Handlers
│   ├── Startup.s                      # ARM7TDMI Assembly Vector Table
│   └── types.h                        # Standard Typedefs
│
├── Window_glass_control_Node/         # Body Control Power Window ECU
│   ├── CAN.c / CAN.h / CAN_Defines.h  # CAN Message Interface (ID 0x101, 0x201)
│   ├── delays.c / delays.h            # Timing Routines
│   ├── window_control.c / .h          # L293D H-Bridge Motor Driver
│   ├── MAIN_WINDOW_NODE.c             # Window Listener Loop
│   ├── Startup.s                      # Startup Vector Table
│   └── types.h                        # Standard Typedefs
│
├── Reverse_alert_node/                # Parking Assist / ADAS ECU
│   ├── adc.c / adc.h / adc_defines.h  # 10-bit Successive Approx ADC Driver
│   ├── CAN.c / CAN.h / CAN_Defines.h  # CAN Telemetry Interface (ID 0x102, 0x103)
│   ├── delays.c / delays.h            # Timing Routines
│   ├── distance_sensor.c / .h         # Sharp GP2D12 Linearization & Zone Logic
│   ├── MAIN_REVERSE_ALERT_NODE.c      # ADAS Sensor Loop
│   ├── Startup.s                      # Startup Vector Table
│   └── types.h                        # Standard Typedefs
│
├── Documentation/
│   ├── SYSTEM_DOCUMENTATION.md        # Architecture, Flowcharts & CAN Matrix
│   ├── PINOUT_AND_WIRING.md           # Pin-by-pin Hardware Connections
│   └── LCD_SCREENS_GALLERY.md         # Visual UI Renders for all 20x4 States
│
└── README.md                          # Project Overview
```

---

## 🛠️ Build & Simulation Guide

### 1. Keil uVision Setup
1. Create a new Keil project for each node (e.g. `Main_Node.uvproj`, `Window_Node.uvproj`, `Reverse_Node.uvproj`).
2. Select Target: **NXP $\rightarrow$ LPC2129**.
3. Add the respective C source files and `Startup.s` to the Source Group.
4. Set Target Clock: **12.0 MHz** (PLL $\times 5$ for 60 MHz CCLK).
5. Under **Options for Target $\rightarrow$ Output**, check **Create HEX File**.
6. Click **Build Target (F7)**.

### 2. Proteus Simulation Setup
1. Place 3 $\times$ **LPC2129** microcontrollers and 3 $\times$ **MCP2551** CAN transceivers.
2. Connect `CANH` and `CANL` across all three transceivers in parallel with two $120\,\Omega$ termination resistors.
3. Load the corresponding compiled `.hex` files into each LPC2129 model.
4. Attach the **LM044L (20×4 LCD)**, **DS18B20**, and **GP2D12 (Potentiometer / Analog source)** as per [PINOUT_AND_WIRING.md](Documentation/PINOUT_AND_WIRING.md).
5. Start the interactive simulation.
