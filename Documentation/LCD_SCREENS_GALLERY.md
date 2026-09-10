# 🖥️ 20×4 LCD Visual Screen Gallery & State Transitions

This document provides a visual guide for all screens displayed on the **20×4 Alphanumeric LCD** during each operating and fault state.

---

### 1. 🚀 System Boot / Splash Screen
* **Trigger**: System Power-ON / Reset.
* **Duration**: 2 seconds.

```text
+--------------------+
|====================| Line 1 (0x80)
|  SMART VEHICLE ECU | Line 2 (0xC0)
| ENGINE & SAFETY OS | Line 3 (0x94)
|====================| Line 4 (0xD4)
+--------------------+
```

---

### 2. 🌡️ Engine Temperature Dashboard Telemetry

#### State 2A: Normal Operating Temperature ($\le 45^\circ\text{C}$) & All ECUs Healthy
```text
+--------------------+
|--- VEHICLE DASH ---| Line 1: Header
|TEMP  : 32.5°C [ OK ]| Line 2: Live Temp & Status Tag
|STATUS: ALL ECUS OK | Line 3: System Health
|WIN: 50%    REV: OFF| Line 4: Live Window & Reverse State
+--------------------+
```

#### State 2B: ECU Disconnection Warning Tag on Dashboard
```text
+--------------------+
|--- VEHICLE DASH ---| Line 1: Header
|TEMP  : 32.5°C [ OK ]| Line 2: Live Temp
|! WARN: ECU OFFLINE | Line 3: Persistent Fault Warning
|WIN: 50%    REV: OFF| Line 4: Live Window & Reverse State
+--------------------+
```

#### State 2C: Temperature Sensor Disconnection / 1-Wire Fault
```text
+--------------------+
|--- VEHICLE DASH ---| Line 1: Header
|TEMP  : SENSOR ERR  | Line 2: Sensor Fault Tag
|STATUS: CHECK 1-WIRE| Line 3: Hardware Prompt
|WIN: 50%    REV: OFF| Line 4: Live Window & Reverse State
+--------------------+
```

#### State 2D: Critical Overheat Alarm ($> 75^\circ\text{C}$)
```text
+--------------------+
|********************| Line 1: Warning Border
|! CRITICAL OVERHEAT!| Line 2: Emergency Alert
|TEMP  : 85.0°C[STOP]| Line 3: Critical Reading
|STOP VEHICLE SAFELY!| Line 4: Immediate Action Directive
+--------------------+
```

---

### 3. 🚨 Dedicated CAN Node Disconnection Error Screens

#### Screen 3A: Window Module Disconnection / Timeout Error
```text
+--------------------+
|! CAN BUS WARNING ! | Line 1: Warning Header
|NODE: WINDOW MODULE | Line 2: Affected Module Name
|ERROR: NO RESPONSE  | Line 3: Root Cause (Timeout)
|STATUS: OFFLINE /ERR| Line 4: Fault Classification
+--------------------+
```

#### Screen 3B: Reverse Radar Node Disconnection / Signal Lost Error
```text
+--------------------+
|! CAN BUS WARNING ! | Line 1: Warning Header
|NODE: REVERSE RADAR | Line 2: Affected Module Name
|ERROR: NO RESPONSE  | Line 3: Root Cause (Signal Lost)
|STATUS: OFFLINE /ERR| Line 4: Fault Classification
+--------------------+
```

---

### 4. 🪟 Power Window 8-Level Single/Continuous Stepping Display

#### Level 4 ($50\%$ - 4 LEDs Active)
```text
+--------------------+
|=== POWER WINDOW ===|
|MOTION: ROLLING UP ▲|
|GLASS: [||||....]50%|
|STATUS: LEVEL 4 OF 8|
+--------------------+
```

#### Level 8 ($100\%$ - Window Fully Closed / 8 LEDs Active)
```text
+--------------------+
|=== POWER WINDOW ===|
|LIMIT : FULLY CLOSED|
|GLASS:[||||||||]100%|
|STATUS: FULLY CLOSED|
+--------------------+
```

---

### 5. 🚧 Reverse Obstacle Radar (16-Sample Filtered Stream)

#### Safe Zone ($> 80\text{ cm}$)
```text
+--------------------+
|<<  REVERSE RADAR >>| Line 1: ADAS Mode Banner
|DIST  : 110 cm[SAFE]| Line 2: Real-time Distance
|ZONE  : GREEN / OK  | Line 3: Proximity Category
|BAR   :[||||||||||||]| Line 4: Full Solid Distance Bar
+--------------------+
```

#### Critical Proximity Emergency Stop ($< 20\text{ cm}$)
```text
+--------------------+
|********************| Line 1: Alarm Border
|<<  REVERSE RADAR >>| Line 2: ADAS Banner
|! STOP: 10 cm DIST !| Line 3: Immediate Proximity Alert
|********************| Line 4: Alarm Border
+--------------------+
```
