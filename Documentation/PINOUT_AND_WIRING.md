# 🔌 Hardware Pinout & Wiring Specification (Exact Hardware Mapping)
## LPC2129 Multi-Node Automotive Network

---

### 1. Main Node (Master Instrument Cluster ECU)

| LPC2129 Port / Pin | Connected Peripheral | Peripheral Pin / Function | Notes & Circuit Specifications |
| :--- | :--- | :--- | :--- |
| **`P0.0 – P0.7`** | **20×4 LCD Display** | **D0 – D7 (Data Lines)** | 8-Bit Parallel Bus (`0xFF` Data Mask) |
| **`P0.8`** | **20×4 LCD Display** | **EN (Enable Strobe)** | Active High Strobe Pulse |
| **`P0.9`** | **20×4 LCD Display** | **RS (Register Select)** | `0` = Command, `1` = Data |
| **`P0.10`** | **20×4 LCD Display** | **RW (Read / Write)** | `0` = Write (Tied to Low / Ground) |
| **`P0.22`** | **DS18B20 Temp Sensor** | **DQ (1-Wire Data)** | Requires $4.7\text{ k}\Omega$ Pull-up to $+5\text{V}$ |
| **`P0.16`** (`EINT0`) | **Window UP Switch** | Pushbutton Input | Active LOW (Triggered on Press) |
| **`P0.14`** (`EINT1`) | **Window DOWN Switch** | Pushbutton Input | Active LOW (Triggered on Press) |
| **`P0.15`** (`EINT2`) | **Reverse Mode Switch** | Toggle Switch Input | Active LOW Reverse Gear Switch |
| **`P0.24`** (`TD1`) | **CAN Transceiver (MCP2551)** | **TXD (Pin 1)** | CAN Controller 1 Transmit Line |
| **`P0.25`** (`RD1`) | **CAN Transceiver (MCP2551)** | **RXD (Pin 4)** | CAN Controller 1 Receive Line |
| **Power Rails** | Power Supply | $+3.3\text{V} / +5\text{V} / \text{GND}$ | Standard decoupling capacitors |

---

### 2. Window Node (Body Control ECU)

| LPC2129 Port / Pin | Connected Peripheral | Peripheral Pin / Function | Notes |
| :--- | :--- | :--- | :--- |
| **`P0.0 – P0.7`** | **Window Actuator / LED Bar** | **Position Indicators / Driver** | Active LOW / High 8-bit position bar |
| **`P0.24`** (`TD1`) | **CAN Transceiver (MCP2551)** | **TXD (Pin 1)** | CAN Controller 1 Transmit Line |
| **`P0.25`** (`RD1`) | **CAN Transceiver (MCP2551)** | **RXD (Pin 4)** | CAN Controller 1 Receive Line |
| **Power Rails** | Power Supply | $+5\text{V} / \text{GND}$ | Shared Common Ground |

---

### 3. Reverse Alert Node (Parking Assist ADAS ECU)

| LPC2129 Port / Pin | Connected Peripheral | Peripheral Pin / Function | Notes |
| :--- | :--- | :--- | :--- |
| **`P0.27`** (`AD0.0` / `AIN0`) | **Sharp GP2D12 IR Sensor** | **Analog Vo (Output)** | 10-bit On-Chip ADC ($0.4\text{V} - 3.0\text{V}$) |
| **`P0.24`** (`TD1`) | **CAN Transceiver (MCP2551)** | **TXD (Pin 1)** | CAN Controller 1 Transmit Line |
| **`P0.25`** (`RD1`) | **CAN Transceiver (MCP2551)** | **RXD (Pin 4)** | CAN Controller 1 Receive Line |
| **Power Rails** | Power Supply | $+5\text{V} / \text{GND}$ | Standard supply rail |

---

### 4. Physical CAN Bus Wiring

* **Bus Lines**: Differential pair `CANH` and `CANL` connected across all three nodes in parallel.
* **Termination Resistors**: $120\,\Omega$ ($1/4\text{W}$) resistors installed at the two ends between `CANH` and `CANL`.
