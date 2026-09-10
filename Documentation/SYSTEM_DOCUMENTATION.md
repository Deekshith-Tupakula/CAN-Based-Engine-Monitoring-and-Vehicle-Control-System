# 🚗 CAN-Based Engine Monitoring and Vehicle Control System
## Comprehensive System Engineering Documentation

---

### 1. Executive Summary
This project implements an automotive-grade distributed Electronic Control Unit (ECU) network using three **NXP LPC2129 (ARM7TDMI-S)** microcontrollers communicating over an ISO 11898 compliant **CAN 2.0B** bus at **250 kbps**.

The system features:
1. **Main Telemetry ECU (Main Node)**: Central 20×4 LCD digital instrument cluster, DS18B20 digital engine temperature monitoring with hysteresis, and driver input controls.
2. **Body Control ECU (Window Node)**: Power window bidirectional motor actuation with status telemetry feedback.
3. **ADAS / Parking Assist ECU (Reverse Node)**: Sharp GP2D12 infrared proximity sensing via 10-bit ADC with real-time zone detection and high-speed telemetry streaming.

---

### 2. High-Level System Architecture

```mermaid
graph TD
    subgraph "CAN Bus (250 kbps - Differential Pair CANH / CANL)"
        CB[CAN Physical Bus]
    end

    subgraph "Main Node (Master Dashboard ECU)"
        MN_MCU[LPC2129 ARM7]
        LCD[20x4 Alphanumeric LCD]
        DS18B20[DS18B20 Temp Sensor]
        SW1[Window UP Switch]
        SW2[Window DOWN Switch]
        SW3[Reverse Gear Switch]
        CAN_T1[MCP2551 / TJA1050 Transceiver]

        DS18B20 -->|1-Wire P0.19| MN_MCU
        SW1 & SW2 & SW3 -->|GPIO Inputs| MN_MCU
        MN_MCU -->|P0.12..P0.23| LCD
        MN_MCU <-->|TD1/RD1 P0.24/P0.25| CAN_T1
        CAN_T1 <--> CB
    end

    subgraph "Window Node (Body Control ECU)"
        WN_MCU[LPC2129 ARM7]
        L293D[L293D Motor Driver]
        MTR[DC Window Motor]
        CAN_T2[MCP2551 / TJA1050 Transceiver]

        CAN_T2 <--> CB
        WN_MCU <-->|TD1/RD1 P0.24/P0.25| CAN_T2
        WN_MCU -->|P0.10, P0.11, P0.12| L293D
        L293D --> MTR
    end

    subgraph "Reverse Node (Parking Assist ECU)"
        RN_MCU[LPC2129 ARM7]
        GP2D12[Sharp GP2D12 IR Sensor]
        CAN_T3[MCP2551 / TJA1050 Transceiver]

        GP2D12 -->|Analog Voltage AD0.1 / P0.28| RN_MCU
        RN_MCU <-->|TD1/RD1 P0.24/P0.25| CAN_T3
        CAN_T3 <--> CB
    end
```

---

### 3. CAN Communication Protocol Matrix

| CAN ID | Frame Type | DLC | Source Node | Destination | Data Byte 0 | Data Byte 1 | Description |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`0x101`** | Data Frame | 1 | Main Node | Window Node | `0x01`=UP / `0x02`=DN | - | Window Roll Up/Down Command |
| **`0x102`** | Data Frame | 1 | Main Node | Reverse Node | `0x01`=ON / `0x00`=OFF | - | Reverse Assist Enable/Disable |
| **`0x103`** | Data Frame | 2 | Reverse Node | Main Node | Distance ($10..150\text{ cm}$) | Zone ($1..4$) | High-speed Proximity Telemetry |
| **`0x201`** | Data Frame | 2 | Window Node | Main Node | Position ($0..100\%$) | Status (`0x01`=OK) | Window Actuation Acknowledgement |

---

### 4. Zone Classification Logic (Reverse Node)

| Zone Name | Zone Code | Distance Range | Action / Safety Response |
| :--- | :---: | :--- | :--- |
| **Safe Zone** | `0x01` | $\ge 80\text{ cm}$ | Full clear path; solid green bar on LCD |
| **Warning Zone** | `0x02` | $40\text{ cm} - 79\text{ cm}$ | Obstacle approaching; driver caution advised |
| **Danger Zone** | `0x03` | $20\text{ cm} - 39\text{ cm}$ | Close proximity; prepare to brake |
| **Critical Stop**| `0x04` | $< 20\text{ cm}$ | Immediate collision hazard; full stop screen alert |

---

### 5. Temperature Alert Logic with Hysteresis (Main Node)

* **Normal Operating Range**: $< 45.0^\circ\text{C}$ $\rightarrow$ Displays `[ OK ]`
* **Warming Range**: $45.0^\circ\text{C} - 60.0^\circ\text{C}$ $\rightarrow$ Displays `[WARM]` & triggers cooling fan indicator
* **High Warning Range**: $60.1^\circ\text{C} - 74.9^\circ\text{C}$ $\rightarrow$ Displays `[HIGH]` & warns driver
* **Critical Overheat Alarm**: $\ge 75.0^\circ\text{C}$ $\rightarrow$ Immediate flashing alarm screen; clears only when temp drops below $73.0^\circ\text{C}$ ($2^\circ\text{C}$ hysteresis window).
