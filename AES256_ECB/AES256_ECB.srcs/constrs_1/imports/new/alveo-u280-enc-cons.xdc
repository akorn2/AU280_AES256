############################################################################
#  DISCLAIMER:
#  XILINX IS DISCLOSING THIS USER GUIDE, MANUAL, RELEASE NOTE,
#  SCHEMATIC, AND/OR SPECIFICATION (THE "DOCUMENTATION")TO YOU SOLELY
#  FOR USE IN THE DEVELOPMENT OF DESIGNS TO OPERATE WITH XILINX
#  HARDWARE DEVICES. YOU MAY NOT REPRODUCE, DISTRIBUTE, REPUBLISH,
#  DOWNLOAD, DISPLAY, POST, OR TRANSMIT THE DOCUMENTATION IN ANY FORM
#  OR BY ANY MEANS INCLUDING, BUT NOT LIMITED TO, ELECTRONIC,
#  MECHANICAL, PHOTOCOPYING, RECORDING, OR OTHERWISE, WITHOUT THE
#  PRIOR WRITTEN CONSENT OF XILINX. XILINX EXPRESSLY DISCLAIMS ANY
#  LIABILITY ARISING OUT OF YOUR USE OF THE DOCUMENTATION.
#  XILINX RESERVES THE RIGHT, AT ITS SOLE DISCRETION, TO CHANGE THE
#  DOCUMENTATION WITHOUT NOTICE AT ANY TIME. XILINX ASSUMES NO
#  OBLIGATION TO CORRECT ANY ERRORS CONTAINED IN THE DOCUMENTATION,
#  OR TO ADVISE YOU OF ANY CORRECTIONS OR UPDATES. XILINX EXPRESSLY
#  DISCLAIMS ANY LIABILITY IN CONNECTION WITH TECHNICAL SUPPORT OR
#  ASSISTANCETHAT MAY BE PROVIDED TO YOU IN CONNECTION WITH THE
#  DOCUMENTATION.
#  THE DOCUMENTATION IS DISCLOSED TO YOU "AS-IS" WITH NO WARRANTY OF
#  ANY OF THIRD-PARTY RIGHTS. IN NO EVENT WILL XILINXBE LIABLE FOR ANY
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
#  NONINFRINGEMENT STATUTORY, REGARDING THEDOCUMENTATION, INCLUDING
#  ANY WARRANTIES OF KIND.
#  XILINX MAKES NO OTHER WARRANTIES, WHETHER EXPRESS, IMPLIED, OR THE
#  DOCUMENTATION. INCLUDING ANY LOSS OF DATA OR LOST PROFITS, ARISING
#  FROM YOUR USE OF CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, OR
#  INCIDENTAL DAMAGES, INCLUDING ANY LOSS OF DATA OR LOST PROFITS,
#  ARISING FROM YOUR USE OF THE DOCUMENTATION.
#
#
#   AU280 HBM - Master XDC
#
#   Key Notes:
#       1) PCIe Clocks Support x16 and x8 Bifurcation with both synchronous or asynchronous operation
#       2) Power warning constraint set to warn user if design exceeds 160 Watts
#       3) Refer to XAPP1321 for DDR4 Self refresh and fast calibration.
#
#   Clock Trees
#
#    1) AB-557-03 - ABRACON AB-557-03-HCHC-F-L-C-T @ 100.000Mhz Dual Output PCIe MEMs Oscillator
#
#      - OUT0--> SYS_CLK5_P/SYS_CLK5_N @ 100.000Mhz - PCIe REFCLK1 for x16 and Bifurcated x8 Lanes 8-15 Asynchronous Clocking
#                PINS: MGTREFCLK1P_225_AP13/MGTREFCLK1N_225_AP12
#
#      - OUT1--> SYSCLK_P/SYSCLK_P @ 100.000Mhz 1-to-4 Clock buffer
#           |
#           |--> SI53340-B-GM --> OUT0  SYSCLK0_P/SYSCLK0_N 100.000Mhz - System Clock for first DDR4 MIG interface and HBM Interfaces.
#                             |   PINS: IO_L12P_T1U_N10_GC_A08_D24_65/IO_L12N_T1U_N11_GC_A09_D25_65
#                             |
#                             |-> OUT1  SYSCLK1_P/SYSCLK1_N 100.000Mhz - System Clock for second DDR4 MIG interface.
#                             |   PINS: IO_L13P_T2L_N0_GC_QBC_69/IO_L13N_T2L_N1_GC_QBC_69
#                             |
#                             |-> OUT2  SYSCLK2_P/SYSCLK2_N 100.000Mhz - PCIe REFCLK1 for Bifurcated x8 Lanes 0-7 Asynchronous Clocking
#                             |   PINS: MGTREFCLK1P_227_AK13/MGTREFCLK1N_227_AK12
#                             |
#                             |-> OUT3  SYSCLK3_P/SYSCLK3_N 100.000Mhz - BANK 75 100Mhz Input clock
#                                 PINS: IO_L11P_T1U_N8_GC_75/IO_L11N_T1U_N9_GC_75
#
#    2) SI570 - SiLabs 570BAB000544DG @ 156.250Mhz Programmable Oscillator (Re-programming I2C access ONLY possible via Satellite Controller)
#
#      - OUT---> SI570_OUTPUT_P/SI570_OUTPUT_N @ 156.250Mhz LVDS
#           |
#           |--> SI53340-B-GM --> OUT0  USER_SI570_CLOCK_P/USER_SI570_CLOCK_N 156.250Mhz - General Perpose System Clock.
#                             |   PINS: IO_L12P_T1U_N10_GC_75_G30/IO_L12N_T1U_N11_GC_75_F30
#                             |
#                             |-> OUT1  Not Connected
#                             |   PINS: NA
#                             |
#                             |-> OUT2  MGT_SI570_CLOCK0_C_P/MGT_SI570_CLOCK0_C_N 156.250Mhz - QSFP0 REFCLK0
#                             |   PINS: MGTREFCLK0P_134_T42/MGTREFCLK0N_134_T43
#                             |
#                             |-> OUT3  MGT_SI570_CLOCK1_C_P/MGT_SI570_CLOCK1_C_N 156.250Mhz - QSFP0 REFCLK1
#                                 PINS: MGTREFCLK0P_135_P42/MGTREFCLK0N_135_P43
#
#    3) SI546 - SiLabs 546BAB001028BBG Selectable output Oscillator 156.2500Mhz/161.1328125Mhz For QSFP0 REFCLK1
#
#      - OE_B <-- Active low input to SI546 to enable output frequency - Connected to
#                PINS: "QSFP0_OEB"  - IO_L9P_T1L_N4_AD12P_75_H32
#      - FS   <-- Clock Select Pin FS = 1 -> 161.132812 MHz 1.8V LVDS (default when FPGA pin Hi-Z or driven High)
#                                  FS = 0 -> 156.25 MHz 1.8V LVDS When driven low by FPGA
#                PINS: "QSFP0_FS"   - IO_L9N_T1L_N5_AD12N_75_G32
#
#      - OUT0--> QSFP0_CLOCK_P/QSFP0_CLOCK_N @ 161.1328125Mhz
#                PINS: MGTREFCLK1P_134_R40/MGTREFCLK1N_134_R41
#
#    4) SI546 - SiLabs 546BAB001028BBG Selectable output Oscillator 156.2500Mhz/161.1328125Mhz For QSFP1 REFCLK1
#
#      - OE_B <-- Active low input to SI546 to enable output frequency - Connected to
#                PINS: QSFP1_OEB    - IO_L8N_T1L_N3_AD5N_75_H30
#      - FS   <-- Clock Select Pin FS = 1 -> 161.132812 MHz 1.8V LVDS (default when FPGA pin Hi-Z or driven High)
#                                  FS = 0 -> 156.25 MHz 1.8V LVDS when driven low by FPGA
#                PINS: "QSFP1_FS"   - IO_L7N_T1L_N1_QBC_AD13N_75_G33
#
#      - OUT0--> QSFP1_CLOCK_P/QSFP1_CLOCK_N @ 161.1328125Mhz
#                PINS: MGTREFCLK1P_135_M42/MGTREFCLK1N_135_M43
#
#
#   5) PCIE Fingers PEX_REFCLK_P/PEX_REFCLK_P 100.000Mhz
#           |->  SI53322-B-GM --> OUT0  PCIE_CLK0_P/PCIE_CLK0_N 100.000Mhz - PCIe REFCLK0 for Bifurcated x8 Lanes 0-7 synchronous Clocking
#                             |   PINS: MGTREFCLK0P_227_AL15/MGTREFCLK0N_227_AL14
#                             |
#                             |-> OUT1  PCIE_CLK1_P/PCIE_CLK1_N 100.000Mhz - PCIe REFCLK0 for x16 and Bifurcated x8 Lanes 8-15 synchronous Clocking
#                                 PINS: MGTREFCLK0P_225_AR15/MGTREFCLK0N_225_AR14
#
#  Revision 1.00 - Intial Release for AU280 ES1
#  Revision 2.00 - Intial Release for Production Release AU280 (not for use on ES1 version cards )
#  Revision 2.01 - Fixed text typos.
#  Revision 2.02 - Corrected PN typos on clocks and DIFF_SSTL12_DCI on DDR4 clocks.
#  Revision 2.03 - Added Bitstream generation constraints.
#  Revision 2.04 - Added pulldown constraint to CATTRIP signal incase desing does not use it.
#
#################################################################################
#
# Power Constraint to warn User if Desing will possibly be over cards power limit, this assume the 2x4 PCIe AUX power is connectd to the board.
#
set_operating_conditions -design_power_budget 160
#
# Bitstream generation
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8 [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 85.0          [current_design]                 ;# Customer can try but may not be reliable over all conditions.
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
#
# LVDS Input SYSTEM CLOCKS for Memory Interfaces (1.2V banks 65 and 69)
#
#  <<<<NOTE>>>> No external BIAS on AC coupled LVDS clock inputs to 1.2V bank so this constraint is added to recenter LVDS signal on 1.2V IO standard.
#
#  <<<<NOTE>>>> No external BIAS on AC coupled LVDS clock inputs to 1.2V bank so this constraint is added to recenter LVDS signal on 1.2V IO standard.
#
# LVDS Input SYSTEM CLOCKS (1.8V bank 75) General Purpose and HBM Clock Sources
#
#
#
# MGT Clocks
#
# PCIe Clocks
#
# Input Clocks for Gen3 x16  or Dual x8 Bifurcation on Lane 8-15
# PCIE_CLK1 -> PCIe 100Mhz Host clock
# SYS_CLK5  -> PCIe 100Mhz Asynchrnous clock
#
# Input Clocks for Dual x8 Bifurcation on Lane 0-7
# PCIE_CLK0 -> PCIe 100Mhz Host clock
# SYS_CLK2  -> PCIe 100Mhz Asynchrnous clock
#
# Input Clocks and Controls for QSFP28 Port 0
#
# MGT_SI570_CLOCK0   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# QSFP0_CLOCK        -> MGT Ref Clock 1 User selectable by QSFP0_FS=0 161.132812 MHz and QSFP0_FS=1 156.250MHz; QSFP0_OEB must driven low to enable clock output
#
#set_property PACKAGE_PIN R40 [get_ports clk]
# QSFP0_CLOCK control signals
#set_property PACKAGE_PIN G32 [get_ports QSFP0_FS]
#set_property IOSTANDARD LVCMOS18 [get_ports QSFP0_FS]
#set_property PACKAGE_PIN H32 [get_ports QSFP0_OEB]
#set_property IOSTANDARD LVCMOS18 [get_ports QSFP0_OEB]
#
# Input Clocks and Controls for QSFP28 Port 1
#
# MGT_SI570_CLOCK1_N   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# QSFP1_CLOCK_N        -> MGT Ref Clock 1 User selectable by QSFP1_FS=0 161.132812 MHz and QSFP1_FS=1 156.250MHz; QSFP1_OEB must be low to enable clock output
#
#
# Create Clock Constraints
#
#
#  PCIe Connections   Bank 67 and Bank 75 (1.8V bank)
#    PCIE_PERSTN Active low input from PCIe Connector to Ultrascale+ Device to detect presence.
#    PEX_PWRBRKN Active low input from PCIe Connector Signaling PCIe card to shut down card power in Server failing condition.
#
#
#  Bank 75 Ultrascale+ Device SYSMON I2C Slave Interface to Sattelite Controller to monitor Ultrascale+ Device Temperatures and Voltages.
#    SYSMON_SCL   Slave I2C clock connection from Satellite Controller to Ultrascale+ Device
#    SYSMON_SDA   Slave I2C data connection from Satellite Controller to Ultrascale+ Device
#
#
# Bank 75 Ultrascale+ Device I2C Slave Interface to Sattelite Controller.
#    I2C_FPGA_SCL       Slave I2C clock connection from Satellite Controller to Ultrascale+ Device
#    I2C_FPGA_SDA       Slave I2C data connection from Satellite Controller to Ultrascale+ Device
#    I2C_MUX0_INTB_FPGA Slave I2C active low interrupt output from Ultrascale+ Device to Satellite Controller
#    I2C_MAIN_INT_B     Slave I2C active low system interrupt output from Ultrascale+ Device to Satellite Controller
#
#
# Bank 75  FPGA UART Interface to FTDI FT4232 Port 3 of 4 (User selectable Baud)
#    USB_UART_RX  Input from FT4232 UART to FPGA
#    USB_UART_TX  Output from FPGA to FT4232 UART
#
#
# Bank 75 Ultrascale+ Device to Satellite Controller CMS UART Interface (115200, No parity, 8 bits, 1 stop bit)
#    FPGA_RXD_MSP  Input from Satellite Controller UART to Ultrascale+ Device
#    FPGA_TXD_MSP  Output from Ultrascale+ Device to Satellite Controller UART
#    This interface is used for the CMS command path, refer to https://www.xilinx.com/products/intellectual-property/cms-subsystem.html and Xilinx PG348
#
#
# HBM Catastrophic Over temperature Output signal to Satellite Controller
#    HBM_CATTRIP Active high indicator to Satellite controller to indicate the HBM has exceeded its maximum allowable temperature.
#                This signal is not a dedicated Ultrascale+ Device output and is a derived signal in RTL. Making the signal Active will shut
#                the Ultrascale+ Device power rails off.
#
#
#  DDR4_RESET_GATE Active High Output from Ultrascale+ Device to hold all External DDR4 interfaces in Self refresh.
#                  This Output disconnects the Memory interface reset and holds it in active and pulls the Clock Enables signal on the Memory Interfaces.
#                  Refer to XAPP1321 for details on Self refresh mode.
#
#
#  GPIO_MSP0/1/2/3 General purpose IO interconnects between Ultrascale+ Device and Satellite Controller. Currently not used.
#
#set_property PACKAGE_PIN K28              [get_ports "GPIO_MSP0"]                          ;# Bank  75 VCCO - VCC1V8   - IO_T0U_N12_VRP_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "GPIO_MSP0"]                          ;# Bank  75 VCCO - VCC1V8   - IO_T0U_N12_VRP_75
#set_property PACKAGE_PIN J29              [get_ports "GPIO_MSP1"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "GPIO_MSP1"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_75
#set_property PACKAGE_PIN K29              [get_ports "GPIO_MSP2"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "GPIO_MSP2"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_75
#set_property PACKAGE_PIN J31              [get_ports "GPIO_MSP3"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "GPIO_MSP3"]                          ;# Bank  75 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_75
#
#  CPU_RESET_FPGA Connects to SW1 push button On the top edge of the PCB Assembly, also connects to Satellite Contoller
#                 Desinged to be a active low reset input to the FPGA.
#
#
# Test point unaccessable to user due to Haetsink.
#
#set_property PACKAGE_PIN L33              [get_ports "TESTCLK_OUT"]                        ;# Bank  75 VCCO - VCC1V8 Net TESTCLK_OUT   - IO_L1P_T0L_N0_DBC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "TESTCLK_OUT"]                        ;# Bank  75 VCCO - VCC1V8 Net TESTCLK_OUT   - IO_L1P_T0L_N0_DBC_75
#
# DDR4 RDIMM Controller 0, 72-bit Data Interface, x4 Componets, Single Rank
#     <<<NOTE>>> DQS Clock strobes have been swapped from JEDEC standard to match Xilinx MIG Clock order:
#                JEDEC Order   DQS ->  0  9  1 10  2 11  3 12  4 13  5 14  6 15  7 16  8 17
#                Xil MIG Order DQS ->  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
#
#set_property PACKAGE_PIN BG47               #N/A                                  ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T3U_N12_66
#set_property IOSTANDARD  LVCMOS18           #N/A                                  ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T3U_N12_66
#set_property PACKAGE_PIN BF53               #N/A                                  ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T2U_N12_66
#set_property IOSTANDARD  LVCMOS18           #N/A                                  ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T2U_N12_66
#set_property PACKAGE_PIN BL48              #N/A                                   ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_66
#set_property IOSTANDARD  LVCMOS18          #N/A                                   ;# Bank  66 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_66
#set_property PACKAGE_PIN BL50              #N/A                                   ;# Bank  66 VCCO - VCC1V2 Net "VRP_61"          - IO_T0U_N12_VRP_66
#set_property IOSTANDARD  LVCMOS18          #N/A                                   ;# Bank  66 VCCO - VCC1V2 Net "VRP_61"          - IO_T0U_N12_VRP_66
#
#  DDR4 RDIMM Control, Command and Address
#       The DIMM interfaces have connectivity to support UDIMM, RDIMM, LRDIMM and 3DS devices.
#       The below constraints are configured to support DDR4, Single Rank, RDIMMs with x4 Compnent Connectivity and the unused pins are commented out.
#       The System Clock for the MEMORY interface are comemented out and moved to the Clock section of the XDC file
#
#set_property PACKAGE_PIN BD42              [ get_ports  {c0_ddr4_cs_n[2]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B2"   - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_cs_n[2]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B2"   - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65
#set_property PACKAGE_PIN BC42              [ get_ports  {c0_ddr4_alert_n} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ALERT_B" - IO_L23P_T3U_N8_I2C_SCLK_65
#set_property IOSTANDARD  LVCMOS12          [ get_ports  {c0_ddr4_alert_n} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ALERT_B" - IO_L23P_T3U_N8_I2C_SCLK_65
#set_property PACKAGE_PIN BE46              [ get_ports  {c0_ddr4_odt[1]} ]         ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ODT1"    - IO_L22N_T3U_N7_DBC_AD0N_D05_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_odt[1]} ]         ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ODT1"    - IO_L22N_T3U_N7_DBC_AD0N_D05_65
#set_property PACKAGE_PIN BE45              [ get_ports  {c0_ddr4_cs_n[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B1"   - IO_L22P_T3U_N6_DBC_AD0P_D04_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_cs_n[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B1"   - IO_L22P_T3U_N6_DBC_AD0P_D04_65
#set_property PACKAGE_PIN BK41              [ get_ports  {c0_ddr4_ck_c[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CK_C1"   - IO_L15N_T2L_N5_AD11N_A03_D19_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_ck_c[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CK_C1"   - IO_L15N_T2L_N5_AD11N_A03_D19_65
#set_property PACKAGE_PIN BJ41              [ get_ports  {c0_ddr4_ck_t[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CK_T1"   - IO_L15P_T2L_N4_AD11P_A02_D18_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_ck_t[1]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CK_T1"   - IO_L15P_T2L_N4_AD11P_A02_D18_65
#set_property PACKAGE_PIN BJ42              [ get_ports  {c0_ddr4_cke[1]} ]         ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CKE1"    - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_cke[1]} ]         ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CKE1"    - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
# Clocks at top of XDC
#set_property PACKAGE_PIN BJ44              [ get_ports  {sys_clk0_n} ]             ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_N"       - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property IOSTANDARD  LVDS              [ get_ports  {sys_clk0_n} ]             ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_N"       - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property PACKAGE_PIN BJ43              [ get_ports  {sys_clk0_p} ]             ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_P"       - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property IOSTANDARD  LVDS              [ get_ports  {sys_clk0_p} ]             ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_P"       - IO_L12P_T1U_N10_GC_A08_D24_65
##  <<<<NOTE>>>> No external BIAS on AC coupled LVDS clock inputs to 1.2V bank so this constraint is added to recenter LVDS signal on 1.2V IO standard.
#set_property DQS_BIAS    TRUE              [ get_ports  {sys_clk0_p} ]             ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_P"       - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property PACKAGE_PIN BK44              #N/A                                    ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B3"   - IO_L11N_T1U_N9_GC_A11_D27_65
#set_property IOSTANDARD  LVCMOS18          #N/A                                    ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_CS_B3"   - IO_L11N_T1U_N9_GC_A11_D27_65
#set_property PACKAGE_PIN BL47              [ get_ports  {c0_ddr4_adr[17]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ADR17"   - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c0_ddr4_adr[17]} ]        ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_ADR17"   - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property PACKAGE_PIN BK29              [ get_ports  {c0_ddr4_event_n} ]        ;# Bank  64 VCCO - VCC1V2 Net "DDR4_C0_EVENT_B" - IO_T3U_N12_64
#set_property IOSTANDARD  LVCMOS12          [ get_ports  {c0_ddr4_event_n} ]        ;# Bank  64 VCCO - VCC1V2 Net "DDR4_C0_EVENT_B" - IO_T3U_N12_64
#set_property PACKAGE_PIN BP33              #N/A                                    ;# Bank  64 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_64
#set_property IOSTANDARD  LVCMOS12          #N/A                                    ;# Bank  64 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_64
#
# DDR4 RDIMM Controller 1, 72-bit Data Interface, x4 Componets, Single Rank
#     <<<NOTE>>> DQS Clock strobes have been swapped from JEDEC standard to match Xilinx MIG Clock order:
#                JEDEC Order   DQS ->  0  9  1 10  2 11  3 12  4 13  5 14  6 15  7 16  8 17
#                Xil MIG Order DQS ->  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
#
#set_property PACKAGE_PIN C13               #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T3U_N12_70
#set_property IOSTANDARD  LVCMOS12          #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T3U_N12_70
#set_property PACKAGE_PIN C14               #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T2U_N12_70
#set_property IOSTANDARD  LVCMOS12          #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T2U_N12_70
#set_property PACKAGE_PIN H9                #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_70
#set_property IOSTANDARD  LVCMOS18          #N/A                                    ;# Bank  70 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_70
#
#  DDR4 RDIMM Control, Command and Address
#       The DIMM interfaces have connectivity to support UDIMM, RDIMM, LRDIMM and 3DS devices.
#       The below constraints are configured to support DDR4, Single Rank, RDIMMs with x4 Compnent Connectivity and the unused pins are commented out.
#       The System Clock for the MEMORY interface are comemented out and moved to the Clock section of the XDC file
#
#set_property PACKAGE_PIN BF1               [ get_ports  {c1_ddr4_cke[1]} ]         ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CKE1"    - IO_L24N_T3U_N11_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_cke[1]} ]         ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CKE1"    - IO_L24N_T3U_N11_69
#set_property PACKAGE_PIN BG4               [ get_ports  {c1_ddr4_cs_n[3]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B3"   - IO_L19N_T3L_N1_DBC_AD9N_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_cs_n[3]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B3"   - IO_L19N_T3L_N1_DBC_AD9N_69
#set_property PACKAGE_PIN BG5               [ get_ports  {c1_ddr4_cs_n[2]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B2"   - IO_L19P_T3L_N0_DBC_AD9P_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_cs_n[2]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B2"   - IO_L19P_T3L_N0_DBC_AD9P_69
#set_property PACKAGE_PIN BJ7               [ get_ports  {c1_ddr4_ck_c[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CK_C1"   - IO_L16N_T2U_N7_QBC_AD3N_69
#set_property IOSTANDARD  DIFF_SSTL12_DCI   [ get_ports  {c1_ddr4_ck_c[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CK_C1"   - IO_L16N_T2U_N7_QBC_AD3N_69
#set_property PACKAGE_PIN BH7               [ get_ports  {c1_ddr4_ck_t[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CK_T1"   - IO_L16P_T2U_N6_QBC_AD3P_69
#set_property IOSTANDARD  DIFF_SSTL12_DCI   [ get_ports  {c1_ddr4_ck_t[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CK_T1"   - IO_L16P_T2U_N6_QBC_AD3P_69
#set_property PACKAGE_PIN BH4               [ get_ports  {c1_ddr4_odt[1]} ]         ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ODT1"    - IO_L14N_T2L_N3_GC_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_odt[1]} ]         ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ODT1"    - IO_L14N_T2L_N3_GC_69
#set_property PACKAGE_PIN BH5               [ get_ports  {c1_ddr4_cs_n[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B1"   - IO_L14P_T2L_N2_GC_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_cs_n[1]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_CS_B1"   - IO_L14P_T2L_N2_GC_69
# Clocks at top of XDC
#set_property PACKAGE_PIN BJ6               [ get_ports  {sys_clk1_n} ]             ;# Bank  69 VCCO - VCC1V2 Net "SYSCLK1_N"       - IO_L13N_T2L_N1_GC_QBC_69
#set_property IOSTANDARD  LVCMOS18          [ get_ports  {sys_clk1_n} ]             ;# Bank  69 VCCO - VCC1V2 Net "SYSCLK1_N"       - IO_L13N_T2L_N1_GC_QBC_69
#set_property PACKAGE_PIN BH6               [ get_ports  {sys_clk1_p} ]             ;# Bank  69 VCCO - VCC1V2 Net "SYSCLK1_P"       - IO_L13P_T2L_N0_GC_QBC_69
#set_property IOSTANDARD  LVCMOS18          [ get_ports  {sys_clk1_p} ]             ;# Bank  69 VCCO - VCC1V2 Net "SYSCLK1_P"       - IO_L13P_T2L_N0_GC_QBC_69
##  <<<<NOTE>>>> No external BIAS on AC coupled LVDS clock inputs to 1.2V bank so this constraint is added to recenter LVDS signal on 1.2V IO standard.
#set_property DQS_BIAS    TRUE              [ get_ports  {sys_clk1_p} ]             ;# Bank  69 VCCO - VCC1V2 Net "SYSCLK1_P"       - IO_L13P_T2L_N0_GC_QBC_69
#set_property PACKAGE_PIN BK3               [ get_ports  {c1_ddr4_alert_n} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ALERT_B" - IO_L11N_T1U_N9_GC_69
#set_property IOSTANDARD  LVCMOS12          [ get_ports  {c1_ddr4_alert_n} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ALERT_B" - IO_L11N_T1U_N9_GC_69
#set_property PACKAGE_PIN BK6               [ get_ports  {c1_ddr4_adr[17]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ADR17"   - IO_T1U_N12_69
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_adr[17]} ]        ;# Bank  69 VCCO - VCC1V2 Net "DDR4_C1_ADR17"   - IO_T1U_N12_69
#set_property PACKAGE_PIN BH11              [ get_ports  {c1_ddr4_event_n} ]        ;# Bank  68 VCCO - VCC1V2 Net "DDR4_C1_EVENT_B" - IO_T3U_N12_68
#set_property IOSTANDARD  SSTL12_DCI        [ get_ports  {c1_ddr4_event_n} ]        ;# Bank  68 VCCO - VCC1V2 Net "DDR4_C1_EVENT_B" - IO_T3U_N12_68
#set_property PACKAGE_PIN BL11              #N/A                                    ;# Bank  68 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_68
#set_property IOSTANDARD  LVCMOS18          #N/A                                    ;# Bank  68 VCCO - VCC1V2 Net "Not Connected"   - IO_T1U_N12_68
#
# MGTY Connections
#
# These are commented out because typical IPs have the pin location embedded  constraints in the IP
#
# QSFP28 MGTY Interface
#
#set_property PACKAGE_PIN T43              [get_ports "MGT_SI570_CLOCK0_C_N"]               ;# Bank 134 - MGTREFCLK0N_134
#set_property PACKAGE_PIN T42              [get_ports "MGT_SI570_CLOCK0_C_P"]               ;# Bank 134 - MGTREFCLK0P_134
#set_property PACKAGE_PIN R41              [get_ports "QSFP0_CLOCK_N"]                      ;# Bank 134 - MGTREFCLK1N_134
#set_property PACKAGE_PIN R40              [get_ports "QSFP0_CLOCK_P"]                      ;# Bank 134 - MGTREFCLK1P_134
#set_property PACKAGE_PIN P43              [get_ports "MGT_SI570_CLOCK1_C_N"]               ;# Bank 135 - MGTREFCLK0N_135
#set_property PACKAGE_PIN P42              [get_ports "MGT_SI570_CLOCK1_C_P"]               ;# Bank 135 - MGTREFCLK0P_135
#set_property PACKAGE_PIN M43              [get_ports "QSFP1_CLOCK_N"]                      ;# Bank 135 - MGTREFCLK1N_135
#set_property PACKAGE_PIN M42              [get_ports "QSFP1_CLOCK_P"]                      ;# Bank 135 - MGTREFCLK1P_135
#
# PCIe MGTY Interface
#
#set_property PACKAGE_PIN AR14             [get_ports "pcie_clk0_p" ]                       ;# Bank 225 - MGTREFCLK0N_225
#set_property PACKAGE_PIN AR15             [get_ports "pcie_clk0_p" ]                       ;# Bank 225 - MGTREFCLK0P_225
#set_property PACKAGE_PIN AP12             [get_ports "SYSCLK5_N"]                          ;# Bank 225 - MGTREFCLK1N_225
#set_property PACKAGE_PIN AP13             [get_ports "SYSCLK5_P"]                          ;# Bank 225 - MGTREFCLK1P_225
#set_property PACKAGE_PIN AL14             [get_ports {pcie_clk0_n} ]                       ;# Bank 227 - MGTREFCLK0N_227
#set_property PACKAGE_PIN AL15             [get_ports {pcie_clk0_n} ]                       ;# Bank 227 - MGTREFCLK0P_227
#set_property PACKAGE_PIN AK12             [get_ports {sys_clk2_n} ]                        ;# Bank 227 - MGTREFCLK1N_227
#set_property PACKAGE_PIN AK13             [get_ports {sys_clk2_n} ]                        ;# Bank 227 - MGTREFCLK1P_227
#
# UNCONNECTED or Grounded Pins
#
#set_property PACKAGE_PIN A29 [get_ports done]
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L23P_T3U_N8_75
#set_property PACKAGE_PIN A31              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_75
#set_property PACKAGE_PIN B30              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_75
#set_property PACKAGE_PIN A33              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_75
#set_property PACKAGE_PIN B32              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_75
#set_property PACKAGE_PIN C29              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_75
#set_property PACKAGE_PIN C28              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_75
#set_property PACKAGE_PIN D30              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_75
#set_property PACKAGE_PIN E33              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_75
#set_property PACKAGE_PIN F33              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_75
#set_property PACKAGE_PIN E29              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_75
#set_property PACKAGE_PIN F29              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_75
#set_property PACKAGE_PIN E32              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_75
#set_property PACKAGE_PIN E31              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_75
#set_property PACKAGE_PIN F28              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_75
#set_property PACKAGE_PIN G28              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_75
#set_property PACKAGE_PIN H28              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_T1U_N12_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_T1U_N12_75
#set_property PACKAGE_PIN H29              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_75
#set_property PACKAGE_PIN J30              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_75
#set_property PACKAGE_PIN L31              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_75
#set_property PACKAGE_PIN J32              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_75
#set_property PACKAGE_PIN K32              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_75
#set_property PACKAGE_PIN K31              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_75
#set_property PACKAGE_PIN L29              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L2P_T0L_N2_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L2P_T0L_N2_75
#set_property PACKAGE_PIN K33              [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_75
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  75 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_75
#set_property PACKAGE_PIN BF21             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L24N_T3U_N11_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L24N_T3U_N11_67
#set_property PACKAGE_PIN BF22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L24P_T3U_N10_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L24P_T3U_N10_67
#set_property PACKAGE_PIN BH22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L23N_T3U_N9_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L23N_T3U_N9_67
#set_property PACKAGE_PIN BG22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L23P_T3U_N8_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L23P_T3U_N8_67
#set_property PACKAGE_PIN BJ21             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property PACKAGE_PIN BH21             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_67
#set_property PACKAGE_PIN BK21             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_67
#set_property PACKAGE_PIN BJ22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_67
#set_property PACKAGE_PIN BK23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_67
#set_property PACKAGE_PIN BK24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_67
#set_property PACKAGE_PIN BL22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_67
#set_property PACKAGE_PIN BL23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_67
#set_property PACKAGE_PIN BG23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T3U_N12_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T3U_N12_67
#set_property PACKAGE_PIN BF23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T2U_N12_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T2U_N12_67
#set_property PACKAGE_PIN BH24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_67
#set_property PACKAGE_PIN BG24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_67
#set_property PACKAGE_PIN BG25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_67
#set_property PACKAGE_PIN BF25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_67
#set_property PACKAGE_PIN BF26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property PACKAGE_PIN BF27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property PACKAGE_PIN BG27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_67
#set_property PACKAGE_PIN BG28             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_67
#set_property PACKAGE_PIN BJ23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_67
#set_property PACKAGE_PIN BJ24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_67
#set_property PACKAGE_PIN BH25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_67
#set_property PACKAGE_PIN BJ27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_67
#set_property PACKAGE_PIN BH27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_67
#set_property PACKAGE_PIN BK25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_67
#set_property PACKAGE_PIN BJ26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_67
#set_property PACKAGE_PIN BL25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_67
#set_property PACKAGE_PIN BK26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_67
#set_property PACKAGE_PIN BK28             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_67
#set_property PACKAGE_PIN BJ28             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_67
#set_property PACKAGE_PIN BL26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_67
#set_property PACKAGE_PIN BL27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_67
#set_property PACKAGE_PIN BM27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_67
#set_property PACKAGE_PIN BL28             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_67
#set_property PACKAGE_PIN BN27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T1U_N12_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T1U_N12_67
#set_property PACKAGE_PIN BP27             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T0U_N12_VRP_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_T0U_N12_VRP_67
#set_property PACKAGE_PIN BN22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_67
#set_property PACKAGE_PIN BM22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_67
#set_property PACKAGE_PIN BM23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_67
#set_property PACKAGE_PIN BM24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_67
#set_property PACKAGE_PIN BN25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_67
#set_property PACKAGE_PIN BM25             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_67
#set_property PACKAGE_PIN BP24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_67
#set_property PACKAGE_PIN BN24             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_67
#set_property PACKAGE_PIN BP26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L2N_T0L_N3_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L2N_T0L_N3_67
#set_property PACKAGE_PIN BN26             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L2P_T0L_N2_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L2P_T0L_N2_67
#set_property PACKAGE_PIN BP22             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_67
#set_property PACKAGE_PIN BP23             [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_67
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  67 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_67
#set_property PACKAGE_PIN A16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L24N_T3U_N11_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L24N_T3U_N11_71
#set_property PACKAGE_PIN B16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L24P_T3U_N10_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L24P_T3U_N10_71
#set_property PACKAGE_PIN A18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L23N_T3U_N9_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L23N_T3U_N9_71
#set_property PACKAGE_PIN A19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L23P_T3U_N8_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L23P_T3U_N8_71
#set_property PACKAGE_PIN A20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_71
#set_property PACKAGE_PIN A21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_71
#set_property PACKAGE_PIN B17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_71
#set_property PACKAGE_PIN B18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_71
#set_property PACKAGE_PIN B20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_71
#set_property PACKAGE_PIN B21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_71
#set_property PACKAGE_PIN C17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_71
#set_property PACKAGE_PIN C18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_71
#set_property PACKAGE_PIN C19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T3U_N12_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T3U_N12_71
#set_property PACKAGE_PIN C20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T2U_N12_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T2U_N12_71
#set_property PACKAGE_PIN D19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_71
#set_property PACKAGE_PIN D20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_71
#set_property PACKAGE_PIN D16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_71
#set_property PACKAGE_PIN D17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_71
#set_property PACKAGE_PIN D21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_71
#set_property PACKAGE_PIN E21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_71
#set_property PACKAGE_PIN E16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_71
#set_property PACKAGE_PIN F16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_71
#set_property PACKAGE_PIN E18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L14N_T2L_N3_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L14N_T2L_N3_GC_71
#set_property PACKAGE_PIN E19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L14P_T2L_N2_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L14P_T2L_N2_GC_71
#set_property PACKAGE_PIN E17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_71
#set_property PACKAGE_PIN F18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_71
#set_property PACKAGE_PIN F19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L12N_T1U_N11_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L12N_T1U_N11_GC_71
#set_property PACKAGE_PIN F20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L12P_T1U_N10_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L12P_T1U_N10_GC_71
#set_property PACKAGE_PIN G17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L11N_T1U_N9_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L11N_T1U_N9_GC_71
#set_property PACKAGE_PIN G18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L11P_T1U_N8_GC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L11P_T1U_N8_GC_71
#set_property PACKAGE_PIN F21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_71
#set_property PACKAGE_PIN G21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_71
#set_property PACKAGE_PIN H18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_71
#set_property PACKAGE_PIN H19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_71
#set_property PACKAGE_PIN G20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_71
#set_property PACKAGE_PIN H20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_71
#set_property PACKAGE_PIN G16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_71
#set_property PACKAGE_PIN H17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_71
#set_property PACKAGE_PIN J16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T1U_N12_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T1U_N12_71
#set_property PACKAGE_PIN J17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T0U_N12_VRP_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_T0U_N12_VRP_71
#set_property PACKAGE_PIN J19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_71
#set_property PACKAGE_PIN J20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_71
#set_property PACKAGE_PIN J21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_71
#set_property PACKAGE_PIN K21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_71
#set_property PACKAGE_PIN K18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_71
#set_property PACKAGE_PIN K19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_71
#set_property PACKAGE_PIN L20              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_71
#set_property PACKAGE_PIN L21              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_71
#set_property PACKAGE_PIN L18              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L2N_T0L_N3_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L2N_T0L_N3_71
#set_property PACKAGE_PIN L19              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L2P_T0L_N2_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L2P_T0L_N2_71
#set_property PACKAGE_PIN K16              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L1N_T0L_N1_DBC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L1N_T0L_N1_DBC_71
#set_property PACKAGE_PIN K17              [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L1P_T0L_N0_DBC_71
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  71 VCCO - Grounded - IO_L1P_T0L_N0_DBC_71
#set_property PACKAGE_PIN A35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L24N_T3U_N11_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L24N_T3U_N11_74
#set_property PACKAGE_PIN A34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L24P_T3U_N10_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L24P_T3U_N10_74
#set_property PACKAGE_PIN A36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L23N_T3U_N9_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L23N_T3U_N9_74
#set_property PACKAGE_PIN B35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L23P_T3U_N8_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L23P_T3U_N8_74
#set_property PACKAGE_PIN A38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_74
#set_property PACKAGE_PIN B37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_74
#set_property PACKAGE_PIN B36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_74
#set_property PACKAGE_PIN C35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_74
#set_property PACKAGE_PIN B38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_74
#set_property PACKAGE_PIN C37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_74
#set_property PACKAGE_PIN C34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_74
#set_property PACKAGE_PIN D34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_74
#set_property PACKAGE_PIN C38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T3U_N12_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T3U_N12_74
#set_property PACKAGE_PIN C39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T2U_N12_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T2U_N12_74
#set_property PACKAGE_PIN D37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_74
#set_property PACKAGE_PIN E36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_74
#set_property PACKAGE_PIN E34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_74
#set_property PACKAGE_PIN F34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_74
#set_property PACKAGE_PIN D39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_74
#set_property PACKAGE_PIN E39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_74
#set_property PACKAGE_PIN D36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_74
#set_property PACKAGE_PIN D35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_74
#set_property PACKAGE_PIN E38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L14N_T2L_N3_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L14N_T2L_N3_GC_74
#set_property PACKAGE_PIN E37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L14P_T2L_N2_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L14P_T2L_N2_GC_74
#set_property PACKAGE_PIN F36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_74
#set_property PACKAGE_PIN F35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_74
#set_property PACKAGE_PIN F38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L12N_T1U_N11_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L12N_T1U_N11_GC_74
#set_property PACKAGE_PIN G37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L12P_T1U_N10_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L12P_T1U_N10_GC_74
#set_property PACKAGE_PIN G36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L11N_T1U_N9_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L11N_T1U_N9_GC_74
#set_property PACKAGE_PIN G35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L11P_T1U_N8_GC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L11P_T1U_N8_GC_74
#set_property PACKAGE_PIN F39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_74
#set_property PACKAGE_PIN G38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_74
#set_property PACKAGE_PIN H35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_74
#set_property PACKAGE_PIN H34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_74
#set_property PACKAGE_PIN H38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_74
#set_property PACKAGE_PIN H37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_74
#set_property PACKAGE_PIN H39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_74
#set_property PACKAGE_PIN J39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_74
#set_property PACKAGE_PIN J34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T1U_N12_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T1U_N12_74
#set_property PACKAGE_PIN J35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T0U_N12_VRP_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_T0U_N12_VRP_74
#set_property PACKAGE_PIN J37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_74
#set_property PACKAGE_PIN K37              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_74
#set_property PACKAGE_PIN K34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_74
#set_property PACKAGE_PIN L34              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_74
#set_property PACKAGE_PIN K38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_74
#set_property PACKAGE_PIN L38              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_74
#set_property PACKAGE_PIN J36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_74
#set_property PACKAGE_PIN K36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_74
#set_property PACKAGE_PIN K39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L2N_T0L_N3_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L2N_T0L_N3_74
#set_property PACKAGE_PIN L39              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L2P_T0L_N2_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L2P_T0L_N2_74
#set_property PACKAGE_PIN L36              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L1N_T0L_N1_DBC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L1N_T0L_N1_DBC_74
#set_property PACKAGE_PIN L35              [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L1P_T0L_N0_DBC_74
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  74 VCCO - Grounded - IO_L1P_T0L_N0_DBC_74
#set_property PACKAGE_PIN A40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L24N_T3U_N11_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L24N_T3U_N11_73
#set_property PACKAGE_PIN A39              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L24P_T3U_N10_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L24P_T3U_N10_73
#set_property PACKAGE_PIN B42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L23N_T3U_N9_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L23N_T3U_N9_73
#set_property PACKAGE_PIN B41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L23P_T3U_N8_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L23P_T3U_N8_73
#set_property PACKAGE_PIN A41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_73
#set_property PACKAGE_PIN B40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_73
#set_property PACKAGE_PIN D41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_73
#set_property PACKAGE_PIN E41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_73
#set_property PACKAGE_PIN C40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_73
#set_property PACKAGE_PIN D40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_73
#set_property PACKAGE_PIN F41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_73
#set_property PACKAGE_PIN F40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_73
#set_property PACKAGE_PIN C42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T3U_N12_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T3U_N12_73
#set_property PACKAGE_PIN B43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T2U_N12_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T2U_N12_73
#set_property PACKAGE_PIN A44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_73
#set_property PACKAGE_PIN A43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_73
#set_property PACKAGE_PIN B45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_73
#set_property PACKAGE_PIN C44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_73
#set_property PACKAGE_PIN A46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_73
#set_property PACKAGE_PIN A45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_73
#set_property PACKAGE_PIN B46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_73
#set_property PACKAGE_PIN C45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_73
#set_property PACKAGE_PIN C43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L14N_T2L_N3_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L14N_T2L_N3_GC_73
#set_property PACKAGE_PIN D42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L14P_T2L_N2_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L14P_T2L_N2_GC_73
#set_property PACKAGE_PIN E43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_73
#set_property PACKAGE_PIN E42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_73
#set_property PACKAGE_PIN D45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L12N_T1U_N11_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L12N_T1U_N11_GC_73
#set_property PACKAGE_PIN D44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L12P_T1U_N10_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L12P_T1U_N10_GC_73
#set_property PACKAGE_PIN E44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L11N_T1U_N9_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L11N_T1U_N9_GC_73
#set_property PACKAGE_PIN F44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L11P_T1U_N8_GC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L11P_T1U_N8_GC_73
#set_property PACKAGE_PIN D46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_73
#set_property PACKAGE_PIN E46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_73
#set_property PACKAGE_PIN G45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_73
#set_property PACKAGE_PIN H45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_73
#set_property PACKAGE_PIN F46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_73
#set_property PACKAGE_PIN F45              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_73
#set_property PACKAGE_PIN H44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_73
#set_property PACKAGE_PIN J44              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_73
#set_property PACKAGE_PIN G46              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T1U_N12_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T1U_N12_73
#set_property PACKAGE_PIN F43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T0U_N12_VRP_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_T0U_N12_VRP_73
#set_property PACKAGE_PIN G43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_73
#set_property PACKAGE_PIN H43              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_73
#set_property PACKAGE_PIN G42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_73
#set_property PACKAGE_PIN G41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_73
#set_property PACKAGE_PIN G40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_73
#set_property PACKAGE_PIN H40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_73
#set_property PACKAGE_PIN J41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_73
#set_property PACKAGE_PIN J40              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_73
#set_property PACKAGE_PIN H42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L2N_T0L_N3_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L2N_T0L_N3_73
#set_property PACKAGE_PIN J42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L2P_T0L_N2_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L2P_T0L_N2_73
#set_property PACKAGE_PIN K42              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L1N_T0L_N1_DBC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L1N_T0L_N1_DBC_73
#set_property PACKAGE_PIN K41              [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L1P_T0L_N0_DBC_73
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  73 VCCO - Grounded - IO_L1P_T0L_N0_DBC_73
#set_property PACKAGE_PIN A24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L24N_T3U_N11_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L24N_T3U_N11_72
#set_property PACKAGE_PIN A25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L24P_T3U_N10_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L24P_T3U_N10_72
#set_property PACKAGE_PIN A26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L23N_T3U_N9_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L23N_T3U_N9_72
#set_property PACKAGE_PIN B27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L23P_T3U_N8_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L23P_T3U_N8_72
#set_property PACKAGE_PIN A23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L22N_T3U_N7_DBC_AD0N_72
#set_property PACKAGE_PIN B23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L22P_T3U_N6_DBC_AD0P_72
#set_property PACKAGE_PIN B25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L21N_T3L_N5_AD8N_72
#set_property PACKAGE_PIN B26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L21P_T3L_N4_AD8P_72
#set_property PACKAGE_PIN C24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L20N_T3L_N3_AD1N_72
#set_property PACKAGE_PIN C25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L20P_T3L_N2_AD1P_72
#set_property PACKAGE_PIN B22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L19N_T3L_N1_DBC_AD9N_72
#set_property PACKAGE_PIN C23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L19P_T3L_N0_DBC_AD9P_72
#set_property PACKAGE_PIN C22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T3U_N12_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T3U_N12_72
#set_property PACKAGE_PIN C27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T2U_N12_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T2U_N12_72
#set_property PACKAGE_PIN D27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L18N_T2U_N11_AD2N_72
#set_property PACKAGE_PIN E27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L18P_T2U_N10_AD2P_72
#set_property PACKAGE_PIN D26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L17N_T2U_N9_AD10N_72
#set_property PACKAGE_PIN E26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L17P_T2U_N8_AD10P_72
#set_property PACKAGE_PIN D24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L16N_T2U_N7_QBC_AD3N_72
#set_property PACKAGE_PIN D25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L16P_T2U_N6_QBC_AD3P_72
#set_property PACKAGE_PIN D22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L15N_T2L_N5_AD11N_72
#set_property PACKAGE_PIN E22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L15P_T2L_N4_AD11P_72
#set_property PACKAGE_PIN F25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L14N_T2L_N3_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L14N_T2L_N3_GC_72
#set_property PACKAGE_PIN F26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L14P_T2L_N2_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L14P_T2L_N2_GC_72
#set_property PACKAGE_PIN E23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L13N_T2L_N1_GC_QBC_72
#set_property PACKAGE_PIN E24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L13P_T2L_N0_GC_QBC_72
#set_property PACKAGE_PIN G25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L12N_T1U_N11_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L12N_T1U_N11_GC_72
#set_property PACKAGE_PIN G26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L12P_T1U_N10_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L12P_T1U_N10_GC_72
#set_property PACKAGE_PIN F23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L11N_T1U_N9_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L11N_T1U_N9_GC_72
#set_property PACKAGE_PIN F24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L11P_T1U_N8_GC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L11P_T1U_N8_GC_72
#set_property PACKAGE_PIN G22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L10N_T1U_N7_QBC_AD4N_72
#set_property PACKAGE_PIN G23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L10P_T1U_N6_QBC_AD4P_72
#set_property PACKAGE_PIN G27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L9N_T1L_N5_AD12N_72
#set_property PACKAGE_PIN H27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L9P_T1L_N4_AD12P_72
#set_property PACKAGE_PIN H22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L8N_T1L_N3_AD5N_72
#set_property PACKAGE_PIN J22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L8P_T1L_N2_AD5P_72
#set_property PACKAGE_PIN H23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L7N_T1L_N1_QBC_AD13N_72
#set_property PACKAGE_PIN H24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L7P_T1L_N0_QBC_AD13P_72
#set_property PACKAGE_PIN H25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T1U_N12_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T1U_N12_72
#set_property PACKAGE_PIN J24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T0U_N12_VRP_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_T0U_N12_VRP_72
#set_property PACKAGE_PIN J25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L6N_T0U_N11_AD6N_72
#set_property PACKAGE_PIN J26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L6P_T0U_N10_AD6P_72
#set_property PACKAGE_PIN J27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L5N_T0U_N9_AD14N_72
#set_property PACKAGE_PIN K27              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L5P_T0U_N8_AD14P_72
#set_property PACKAGE_PIN K22              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L4N_T0U_N7_DBC_AD7N_72
#set_property PACKAGE_PIN L23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L4P_T0U_N6_DBC_AD7P_72
#set_property PACKAGE_PIN K23              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L3N_T0L_N5_AD15N_72
#set_property PACKAGE_PIN K24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L3P_T0L_N4_AD15P_72
#set_property PACKAGE_PIN K26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L2N_T0L_N3_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L2N_T0L_N3_72
#set_property PACKAGE_PIN L26              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L2P_T0L_N2_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L2P_T0L_N2_72
#set_property PACKAGE_PIN L24              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L1N_T0L_N1_DBC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L1N_T0L_N1_DBC_72
#set_property PACKAGE_PIN L25              [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L1P_T0L_N0_DBC_72
#set_property IOSTANDARD  LVCMOS18         [get_ports "Not Connected"]                      ;# Bank  72 VCCO - Grounded - IO_L1P_T0L_N0_DBC_72
#set_property PACKAGE_PIN AV43             [get_ports "Not Connected"]                      ;# Bank 124 - MGTREFCLK0N_124
#set_property PACKAGE_PIN AV42             [get_ports "Not Connected"]                      ;# Bank 124 - MGTREFCLK0P_124
#set_property PACKAGE_PIN AT43             [get_ports "Not Connected"]                      ;# Bank 124 - MGTREFCLK1N_124
#set_property PACKAGE_PIN AT42             [get_ports "Not Connected"]                      ;# Bank 124 - MGTREFCLK1P_124
#set_property PACKAGE_PIN BC54             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXN0_124
#set_property PACKAGE_PIN BB52             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXN1_124
#set_property PACKAGE_PIN BA54             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXN2_124
#set_property PACKAGE_PIN BA50             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXN3_124
#set_property PACKAGE_PIN BC53             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXP0_124
#set_property PACKAGE_PIN BB51             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXP1_124
#set_property PACKAGE_PIN BA53             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXP2_124
#set_property PACKAGE_PIN BA49             [get_ports "Grounded"]                           ;# Bank 124 - MGTYRXP3_124
#set_property PACKAGE_PIN BC49             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXN0_124
#set_property PACKAGE_PIN BC45             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXN1_124
#set_property PACKAGE_PIN BB47             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXN2_124
#set_property PACKAGE_PIN BA45             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXN3_124
#set_property PACKAGE_PIN BC48             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXP0_124
#set_property PACKAGE_PIN BC44             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXP1_124
#set_property PACKAGE_PIN BB46             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXP2_124
#set_property PACKAGE_PIN BA44             [get_ports "Not Connected"]                      ;# Bank 124 - MGTYTXP3_124
#set_property PACKAGE_PIN AR41             [get_ports "Not Connected"]                      ;# Bank 125 - MGTREFCLK0N_125
#set_property PACKAGE_PIN AR40             [get_ports "Not Connected"]                      ;# Bank 125 - MGTREFCLK0P_125
#set_property PACKAGE_PIN AP43             [get_ports "Not Connected"]                      ;# Bank 125 - MGTREFCLK1N_125
#set_property PACKAGE_PIN AP42             [get_ports "Not Connected"]                      ;# Bank 125 - MGTREFCLK1P_125
#set_property PACKAGE_PIN AU41             [get_ports "Grounded"]                           ;# Bank 125 - MGTRREF_LS
#set_property PACKAGE_PIN AY52             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXN0_125
#set_property PACKAGE_PIN AW54             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXN1_125
#set_property PACKAGE_PIN AW50             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXN2_125
#set_property PACKAGE_PIN AV52             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXN3_125
#set_property PACKAGE_PIN AY51             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXP0_125
#set_property PACKAGE_PIN AW53             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXP1_125
#set_property PACKAGE_PIN AW49             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXP2_125
#set_property PACKAGE_PIN AV51             [get_ports "Grounded"]                           ;# Bank 125 - MGTYRXP3_125
#set_property PACKAGE_PIN AY47             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXN0_125
#set_property PACKAGE_PIN AW45             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXN1_125
#set_property PACKAGE_PIN AV47             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXN2_125
#set_property PACKAGE_PIN AU45             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXN3_125
#set_property PACKAGE_PIN AY46             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXP0_125
#set_property PACKAGE_PIN AW44             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXP1_125
#set_property PACKAGE_PIN AV46             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXP2_125
#set_property PACKAGE_PIN AU44             [get_ports "Not Connected"]                      ;# Bank 125 - MGTYTXP3_125
#set_property PACKAGE_PIN AN41             [get_ports "Not Connected"]                      ;# Bank 126 - MGTREFCLK0N_126
#set_property PACKAGE_PIN AN40             [get_ports "Not Connected"]                      ;# Bank 126 - MGTREFCLK0P_126
#set_property PACKAGE_PIN AM43             [get_ports "Not Connected"]                      ;# Bank 126 - MGTREFCLK1N_126
#set_property PACKAGE_PIN AM42             [get_ports "Not Connected"]                      ;# Bank 126 - MGTREFCLK1P_126
#set_property PACKAGE_PIN AU54             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXN0_126
#set_property PACKAGE_PIN AT52             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXN1_126
#set_property PACKAGE_PIN AR54             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXN2_126
#set_property PACKAGE_PIN AP52             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXN3_126
#set_property PACKAGE_PIN AU53             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXP0_126
#set_property PACKAGE_PIN AT51             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXP1_126
#set_property PACKAGE_PIN AR53             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXP2_126
#set_property PACKAGE_PIN AP51             [get_ports "Grounded"]                           ;# Bank 126 - MGTYRXP3_126
#set_property PACKAGE_PIN AU49             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXN0_126
#set_property PACKAGE_PIN AT47             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXN1_126
#set_property PACKAGE_PIN AR49             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXN2_126
#set_property PACKAGE_PIN AR45             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXN3_126
#set_property PACKAGE_PIN AU48             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXP0_126
#set_property PACKAGE_PIN AT46             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXP1_126
#set_property PACKAGE_PIN AR48             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXP2_126
#set_property PACKAGE_PIN AR44             [get_ports "Not Connected"]                      ;# Bank 126 - MGTYTXP3_126
#set_property PACKAGE_PIN AL41             [get_ports "Not Connected"]                      ;# Bank 127 - MGTREFCLK0N_127
#set_property PACKAGE_PIN AL40             [get_ports "Not Connected"]                      ;# Bank 127 - MGTREFCLK0P_127
#set_property PACKAGE_PIN AK43             [get_ports "Not Connected"]                      ;# Bank 127 - MGTREFCLK1N_127
#set_property PACKAGE_PIN AK42             [get_ports "Not Connected"]                      ;# Bank 127 - MGTREFCLK1P_127
#set_property PACKAGE_PIN AN54             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXN0_127
#set_property PACKAGE_PIN AN50             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXN1_127
#set_property PACKAGE_PIN AM52             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXN2_127
#set_property PACKAGE_PIN AL54             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXN3_127
#set_property PACKAGE_PIN AN53             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXP0_127
#set_property PACKAGE_PIN AN49             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXP1_127
#set_property PACKAGE_PIN AM51             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXP2_127
#set_property PACKAGE_PIN AL53             [get_ports "Grounded"]                           ;# Bank 127 - MGTYRXP3_127
#set_property PACKAGE_PIN AP47             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXN0_127
#set_property PACKAGE_PIN AN45             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXN1_127
#set_property PACKAGE_PIN AM47             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXN2_127
#set_property PACKAGE_PIN AL45             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXN3_127
#set_property PACKAGE_PIN AP46             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXP0_127
#set_property PACKAGE_PIN AN44             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXP1_127
#set_property PACKAGE_PIN AM46             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXP2_127
#set_property PACKAGE_PIN AL44             [get_ports "Not Connected"]                      ;# Bank 127 - MGTYTXP3_127
#set_property PACKAGE_PIN AJ41             [get_ports "Not Connected"]                      ;# Bank 128 - MGTREFCLK0N_128
#set_property PACKAGE_PIN AJ40             [get_ports "Not Connected"]                      ;# Bank 128 - MGTREFCLK0P_128
#set_property PACKAGE_PIN AH43             [get_ports "Not Connected"]                      ;# Bank 128 - MGTREFCLK1N_128
#set_property PACKAGE_PIN AH42             [get_ports "Not Connected"]                      ;# Bank 128 - MGTREFCLK1P_128
#set_property PACKAGE_PIN AL50             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXN0_128
#set_property PACKAGE_PIN AK52             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXN1_128
#set_property PACKAGE_PIN AJ54             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXN2_128
#set_property PACKAGE_PIN AH52             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXN3_128
#set_property PACKAGE_PIN AL49             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXP0_128
#set_property PACKAGE_PIN AK51             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXP1_128
#set_property PACKAGE_PIN AJ53             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXP2_128
#set_property PACKAGE_PIN AH51             [get_ports "Grounded"]                           ;# Bank 128 - MGTYRXP3_128
#set_property PACKAGE_PIN AK47             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXN0_128
#set_property PACKAGE_PIN AJ49             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXN1_128
#set_property PACKAGE_PIN AJ45             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXN2_128
#set_property PACKAGE_PIN AH47             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXN3_128
#set_property PACKAGE_PIN AK46             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXP0_128
#set_property PACKAGE_PIN AJ48             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXP1_128
#set_property PACKAGE_PIN AJ44             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXP2_128
#set_property PACKAGE_PIN AH46             [get_ports "Not Connected"]                      ;# Bank 128 - MGTYTXP3_128
#set_property PACKAGE_PIN AG41             [get_ports "Not Connected"]                      ;# Bank 129 - MGTREFCLK0N_129
#set_property PACKAGE_PIN AG40             [get_ports "Not Connected"]                      ;# Bank 129 - MGTREFCLK0P_129
#set_property PACKAGE_PIN AF43             [get_ports "Not Connected"]                      ;# Bank 129 - MGTREFCLK1N_129
#set_property PACKAGE_PIN AF42             [get_ports "Not Connected"]                      ;# Bank 129 - MGTREFCLK1P_129
#set_property PACKAGE_PIN AE41             [get_ports "Grounded"]                           ;# Bank 129 - MGTRREF_LC
#set_property PACKAGE_PIN AG54             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXN0_129
#set_property PACKAGE_PIN AF52             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXN1_129
#set_property PACKAGE_PIN AE54             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXN2_129
#set_property PACKAGE_PIN AE50             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXN3_129
#set_property PACKAGE_PIN AG53             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXP0_129
#set_property PACKAGE_PIN AF51             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXP1_129
#set_property PACKAGE_PIN AE53             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXP2_129
#set_property PACKAGE_PIN AE49             [get_ports "Grounded"]                           ;# Bank 129 - MGTYRXP3_129
#set_property PACKAGE_PIN AG49             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXN0_129
#set_property PACKAGE_PIN AG45             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXN1_129
#set_property PACKAGE_PIN AF47             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXN2_129
#set_property PACKAGE_PIN AE45             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXN3_129
#set_property PACKAGE_PIN AG48             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXP0_129
#set_property PACKAGE_PIN AG44             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXP1_129
#set_property PACKAGE_PIN AF46             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXP2_129
#set_property PACKAGE_PIN AE44             [get_ports "Not Connected"]                      ;# Bank 129 - MGTYTXP3_129
#set_property PACKAGE_PIN AD43             [get_ports "Not Connected"]                      ;# Bank 130 - MGTREFCLK0N_130
#set_property PACKAGE_PIN AD42             [get_ports "Not Connected"]                      ;# Bank 130 - MGTREFCLK0P_130
#set_property PACKAGE_PIN AC41             [get_ports "Not Connected"]                      ;# Bank 130 - MGTREFCLK1N_130
#set_property PACKAGE_PIN AC40             [get_ports "Not Connected"]                      ;# Bank 130 - MGTREFCLK1P_130
#set_property PACKAGE_PIN AD52             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXN0_130
#set_property PACKAGE_PIN AC54             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXN1_130
#set_property PACKAGE_PIN AC50             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXN2_130
#set_property PACKAGE_PIN AB52             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXN3_130
#set_property PACKAGE_PIN AD51             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXP0_130
#set_property PACKAGE_PIN AC53             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXP1_130
#set_property PACKAGE_PIN AC49             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXP2_130
#set_property PACKAGE_PIN AB51             [get_ports "Grounded"]                           ;# Bank 130 - MGTYRXP3_130
#set_property PACKAGE_PIN AD47             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXN0_130
#set_property PACKAGE_PIN AC45             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXN1_130
#set_property PACKAGE_PIN AB47             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXN2_130
#set_property PACKAGE_PIN AA49             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXN3_130
#set_property PACKAGE_PIN AD46             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXP0_130
#set_property PACKAGE_PIN AC44             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXP1_130
#set_property PACKAGE_PIN AB46             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXP2_130
#set_property PACKAGE_PIN AA48             [get_ports "Not Connected"]                      ;# Bank 130 - MGTYTXP3_130
#set_property PACKAGE_PIN AB43             [get_ports "Not Connected"]                      ;# Bank 131 - MGTREFCLK0N_131
#set_property PACKAGE_PIN AB42             [get_ports "Not Connected"]                      ;# Bank 131 - MGTREFCLK0P_131
#set_property PACKAGE_PIN AA41             [get_ports "Not Connected"]                      ;# Bank 131 - MGTREFCLK1N_131
#set_property PACKAGE_PIN AA40             [get_ports "Not Connected"]                      ;# Bank 131 - MGTREFCLK1P_131
#set_property PACKAGE_PIN AA54             [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXN0_131
#set_property PACKAGE_PIN Y52              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXN1_131
#set_property PACKAGE_PIN W54              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXN2_131
#set_property PACKAGE_PIN V52              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXN3_131
#set_property PACKAGE_PIN AA53             [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXP0_131
#set_property PACKAGE_PIN Y51              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXP1_131
#set_property PACKAGE_PIN W53              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXP2_131
#set_property PACKAGE_PIN V51              [get_ports "Grounded"]                           ;# Bank 131 - MGTYRXP3_131
#set_property PACKAGE_PIN AA45             [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXN0_131
#set_property PACKAGE_PIN Y47              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXN1_131
#set_property PACKAGE_PIN W49              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXN2_131
#set_property PACKAGE_PIN W45              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXN3_131
#set_property PACKAGE_PIN AA44             [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXP0_131
#set_property PACKAGE_PIN Y46              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXP1_131
#set_property PACKAGE_PIN W48              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXP2_131
#set_property PACKAGE_PIN W44              [get_ports "Not Connected"]                      ;# Bank 131 - MGTYTXP3_131
#set_property PACKAGE_PIN Y43              [get_ports "Not Connected"]                      ;# Bank 132 - MGTREFCLK0N_132
#set_property PACKAGE_PIN Y42              [get_ports "Not Connected"]                      ;# Bank 132 - MGTREFCLK0P_132
#set_property PACKAGE_PIN W41              [get_ports "Not Connected"]                      ;# Bank 132 - MGTREFCLK1N_132
#set_property PACKAGE_PIN W40              [get_ports "Not Connected"]                      ;# Bank 132 - MGTREFCLK1P_132
#set_property PACKAGE_PIN U54              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXN0_132
#set_property PACKAGE_PIN U50              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXN1_132
#set_property PACKAGE_PIN T52              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXN2_132
#set_property PACKAGE_PIN R54              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXN3_132
#set_property PACKAGE_PIN U53              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXP0_132
#set_property PACKAGE_PIN U49              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXP1_132
#set_property PACKAGE_PIN T51              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXP2_132
#set_property PACKAGE_PIN R53              [get_ports "Grounded"]                           ;# Bank 132 - MGTYRXP3_132
#set_property PACKAGE_PIN V47              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXN0_132
#set_property PACKAGE_PIN U45              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXN1_132
#set_property PACKAGE_PIN T47              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXN2_132
#set_property PACKAGE_PIN R45              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXN3_132
#set_property PACKAGE_PIN V46              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXP0_132
#set_property PACKAGE_PIN U44              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXP1_132
#set_property PACKAGE_PIN T46              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXP2_132
#set_property PACKAGE_PIN R44              [get_ports "Not Connected"]                      ;# Bank 132 - MGTYTXP3_132
#set_property PACKAGE_PIN V43              [get_ports "Not Connected"]                      ;# Bank 133 - MGTREFCLK0N_133
#set_property PACKAGE_PIN V42              [get_ports "Not Connected"]                      ;# Bank 133 - MGTREFCLK0P_133
#set_property PACKAGE_PIN U41              [get_ports "Not Connected"]                      ;# Bank 133 - MGTREFCLK1N_133
#set_property PACKAGE_PIN U40              [get_ports "Not Connected"]                      ;# Bank 133 - MGTREFCLK1P_133
#set_property PACKAGE_PIN N41              [get_ports "N38370065"]                          ;# Bank 133 - MGTRREF_LN
#set_property PACKAGE_PIN R50              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXN0_133
#set_property PACKAGE_PIN P52              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXN1_133
#set_property PACKAGE_PIN N54              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXN2_133
#set_property PACKAGE_PIN M52              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXN3_133
#set_property PACKAGE_PIN R49              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXP0_133
#set_property PACKAGE_PIN P51              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXP1_133
#set_property PACKAGE_PIN N53              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXP2_133
#set_property PACKAGE_PIN M51              [get_ports "Grounded"]                           ;# Bank 133 - MGTYRXP3_133
#set_property PACKAGE_PIN P47              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXN0_133
#set_property PACKAGE_PIN N49              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXN1_133
#set_property PACKAGE_PIN N45              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXN2_133
#set_property PACKAGE_PIN M47              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXN3_133
#set_property PACKAGE_PIN P46              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXP0_133
#set_property PACKAGE_PIN N48              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXP1_133
#set_property PACKAGE_PIN N44              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXP2_133
#set_property PACKAGE_PIN M46              [get_ports "Not Connected"]                      ;# Bank 133 - MGTYTXP3_133
#set_property PACKAGE_PIN AV12             [get_ports "Not Connected"]                      ;# Bank 224 - MGTREFCLK0N_224
#set_property PACKAGE_PIN AV13             [get_ports "Not Connected"]                      ;# Bank 224 - MGTREFCLK0P_224
#set_property PACKAGE_PIN AT12             [get_ports "Not Connected"]                      ;# Bank 224 - MGTREFCLK1N_224
#set_property PACKAGE_PIN AT13             [get_ports "Not Connected"]                      ;# Bank 224 - MGTREFCLK1P_224
#set_property PACKAGE_PIN AN14             [get_ports "Not Connected"]                      ;# Bank 226 - MGTREFCLK0N_226
#set_property PACKAGE_PIN AN15             [get_ports "Not Connected"]                      ;# Bank 226 - MGTREFCLK0P_226
#set_property PACKAGE_PIN AM12             [get_ports "Not Connected"]                      ;# Bank 226 - MGTREFCLK1N_226
#set_property PACKAGE_PIN AM13             [get_ports "Not Connected"]                      ;# Bank 226 - MGTREFCLK1P_226
#set_property PACKAGE_PIN AJ14             [get_ports "Not Connected"]                      ;# Bank 228 - MGTREFCLK0N_228
#set_property PACKAGE_PIN AJ15             [get_ports "Not Connected"]                      ;# Bank 228 - MGTREFCLK0P_228
#set_property PACKAGE_PIN AH12             [get_ports "Not Connected"]                      ;# Bank 228 - MGTREFCLK1N_228
#set_property PACKAGE_PIN AH13             [get_ports "Not Connected"]                      ;# Bank 228 - MGTREFCLK1P_228
#set_property PACKAGE_PIN AL5              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXN0_228
#set_property PACKAGE_PIN AK3              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXN1_228
#set_property PACKAGE_PIN AJ1              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXN2_228
#set_property PACKAGE_PIN AH3              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXN3_228
#set_property PACKAGE_PIN AL6              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXP0_228
#set_property PACKAGE_PIN AK4              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXP1_228
#set_property PACKAGE_PIN AJ2              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXP2_228
#set_property PACKAGE_PIN AH4              [get_ports "Grounded"]                           ;# Bank 228 - MGTYRXP3_228
#set_property PACKAGE_PIN AK8              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXN0_228
#set_property PACKAGE_PIN AJ6              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXN1_228
#set_property PACKAGE_PIN AJ10             [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXN2_228
#set_property PACKAGE_PIN AH8              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXN3_228
#set_property PACKAGE_PIN AK9              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXP0_228
#set_property PACKAGE_PIN AJ7              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXP1_228
#set_property PACKAGE_PIN AJ11             [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXP2_228
#set_property PACKAGE_PIN AH9              [get_ports "Not Connected"]                      ;# Bank 228 - MGTYTXP3_228
#set_property PACKAGE_PIN AG14             [get_ports "Not Connected"]                      ;# Bank 229 - MGTREFCLK0N_229
#set_property PACKAGE_PIN AG15             [get_ports "Not Connected"]                      ;# Bank 229 - MGTREFCLK0P_229
#set_property PACKAGE_PIN AF12             [get_ports "Not Connected"]                      ;# Bank 229 - MGTREFCLK1N_229
#set_property PACKAGE_PIN AF13             [get_ports "Not Connected"]                      ;# Bank 229 - MGTREFCLK1P_229
#set_property PACKAGE_PIN AE14             [get_ports "Grounded"]                           ;# Bank 229 - MGTRREF_RC
#set_property PACKAGE_PIN AG1              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXN0_229
#set_property PACKAGE_PIN AF3              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXN1_229
#set_property PACKAGE_PIN AE1              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXN2_229
#set_property PACKAGE_PIN AE5              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXN3_229
#set_property PACKAGE_PIN AG2              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXP0_229
#set_property PACKAGE_PIN AF4              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXP1_229
#set_property PACKAGE_PIN AE2              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXP2_229
#set_property PACKAGE_PIN AE6              [get_ports "Grounded"]                           ;# Bank 229 - MGTYRXP3_229
#set_property PACKAGE_PIN AG6              [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXN0_229
#set_property PACKAGE_PIN AG10             [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXN1_229
#set_property PACKAGE_PIN AF8              [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXN2_229
#set_property PACKAGE_PIN AE10             [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXN3_229
#set_property PACKAGE_PIN AG7              [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXP0_229
#set_property PACKAGE_PIN AG11             [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXP1_229
#set_property PACKAGE_PIN AF9              [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXP2_229
#set_property PACKAGE_PIN AE11             [get_ports "Not Connected"]                      ;# Bank 229 - MGTYTXP3_229
#set_property PACKAGE_PIN AD12             [get_ports "Not Connected"]                      ;# Bank 230 - MGTREFCLK0N_230
#set_property PACKAGE_PIN AD13             [get_ports "Not Connected"]                      ;# Bank 230 - MGTREFCLK0P_230
#set_property PACKAGE_PIN AC14             [get_ports "Not Connected"]                      ;# Bank 230 - MGTREFCLK1N_230
#set_property PACKAGE_PIN AC15             [get_ports "Not Connected"]                      ;# Bank 230 - MGTREFCLK1P_230
#set_property PACKAGE_PIN AD3              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXN0_230
#set_property PACKAGE_PIN AC1              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXN1_230
#set_property PACKAGE_PIN AC5              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXN2_230
#set_property PACKAGE_PIN AB3              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXN3_230
#set_property PACKAGE_PIN AD4              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXP0_230
#set_property PACKAGE_PIN AC2              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXP1_230
#set_property PACKAGE_PIN AC6              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXP2_230
#set_property PACKAGE_PIN AB4              [get_ports "Grounded"]                           ;# Bank 230 - MGTYRXP3_230
#set_property PACKAGE_PIN AD8              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXN0_230
#set_property PACKAGE_PIN AC10             [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXN1_230
#set_property PACKAGE_PIN AB8              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXN2_230
#set_property PACKAGE_PIN AA6              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXN3_230
#set_property PACKAGE_PIN AD9              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXP0_230
#set_property PACKAGE_PIN AC11             [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXP1_230
#set_property PACKAGE_PIN AB9              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXP2_230
#set_property PACKAGE_PIN AA7              [get_ports "Not Connected"]                      ;# Bank 230 - MGTYTXP3_230
#set_property PACKAGE_PIN AB12             [get_ports "Not Connected"]                      ;# Bank 231 - MGTREFCLK0N_231
#set_property PACKAGE_PIN AB13             [get_ports "Not Connected"]                      ;# Bank 231 - MGTREFCLK0P_231
#set_property PACKAGE_PIN AA14             [get_ports "Not Connected"]                      ;# Bank 231 - MGTREFCLK1N_231
#set_property PACKAGE_PIN AA15             [get_ports "Not Connected"]                      ;# Bank 231 - MGTREFCLK1P_231
#set_property PACKAGE_PIN AA1              [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXN0_231
#set_property PACKAGE_PIN Y3               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXN1_231
#set_property PACKAGE_PIN W1               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXN2_231
#set_property PACKAGE_PIN V3               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXN3_231
#set_property PACKAGE_PIN AA2              [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXP0_231
#set_property PACKAGE_PIN Y4               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXP1_231
#set_property PACKAGE_PIN W2               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXP2_231
#set_property PACKAGE_PIN V4               [get_ports "Grounded"]                           ;# Bank 231 - MGTYRXP3_231
#set_property PACKAGE_PIN AA10             [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXN0_231
#set_property PACKAGE_PIN Y8               [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXN1_231
#set_property PACKAGE_PIN W6               [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXN2_231
#set_property PACKAGE_PIN W10              [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXN3_231
#set_property PACKAGE_PIN AA11             [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXP0_231
#set_property PACKAGE_PIN Y9               [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXP1_231
#set_property PACKAGE_PIN W7               [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXP2_231
#set_property PACKAGE_PIN W11              [get_ports "Not Connected"]                      ;# Bank 231 - MGTYTXP3_231
#set_property PACKAGE_PIN Y12              [get_ports "Not Connected"]                      ;# Bank 232 - MGTREFCLK0N_232
#set_property PACKAGE_PIN Y13              [get_ports "Not Connected"]                      ;# Bank 232 - MGTREFCLK0P_232
#set_property PACKAGE_PIN W14              [get_ports "Not Connected"]                      ;# Bank 232 - MGTREFCLK1N_232
#set_property PACKAGE_PIN W15              [get_ports "Not Connected"]                      ;# Bank 232 - MGTREFCLK1P_232
#set_property PACKAGE_PIN U1               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXN0_232
#set_property PACKAGE_PIN U5               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXN1_232
#set_property PACKAGE_PIN T3               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXN2_232
#set_property PACKAGE_PIN R1               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXN3_232
#set_property PACKAGE_PIN U2               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXP0_232
#set_property PACKAGE_PIN U6               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXP1_232
#set_property PACKAGE_PIN T4               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXP2_232
#set_property PACKAGE_PIN R2               [get_ports "Grounded"]                           ;# Bank 232 - MGTYRXP3_232
#set_property PACKAGE_PIN V8               [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXN0_232
#set_property PACKAGE_PIN U10              [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXN1_232
#set_property PACKAGE_PIN T8               [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXN2_232
#set_property PACKAGE_PIN R10              [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXN3_232
#set_property PACKAGE_PIN V9               [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXP0_232
#set_property PACKAGE_PIN U11              [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXP1_232
#set_property PACKAGE_PIN T9               [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXP2_232
#set_property PACKAGE_PIN R11              [get_ports "Not Connected"]                      ;# Bank 232 - MGTYTXP3_232
#set_property PACKAGE_PIN V12              [get_ports "Not Connected"]                      ;# Bank 233 - MGTREFCLK0N_233
#set_property PACKAGE_PIN V13              [get_ports "Not Connected"]                      ;# Bank 233 - MGTREFCLK0P_233
#set_property PACKAGE_PIN U14              [get_ports "Not Connected"]                      ;# Bank 233 - MGTREFCLK1N_233
#set_property PACKAGE_PIN U15              [get_ports "Not Connected"]                      ;# Bank 233 - MGTREFCLK1P_233
#set_property PACKAGE_PIN N14              [get_ports "Grounded"]                           ;# Bank 233 - MGTRREF_RN
#set_property PACKAGE_PIN R5               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXN0_233
#set_property PACKAGE_PIN P3               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXN1_233
#set_property PACKAGE_PIN N1               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXN2_233
#set_property PACKAGE_PIN M3               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXN3_233
#set_property PACKAGE_PIN R6               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXP0_233
#set_property PACKAGE_PIN P4               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXP1_233
#set_property PACKAGE_PIN N2               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXP2_233
#set_property PACKAGE_PIN M4               [get_ports "Grounded"]                           ;# Bank 233 - MGTYRXP3_233
#set_property PACKAGE_PIN P8               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXN0_233
#set_property PACKAGE_PIN N6               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXN1_233
#set_property PACKAGE_PIN N10              [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXN2_233
#set_property PACKAGE_PIN M8               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXN3_233
#set_property PACKAGE_PIN P9               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXP0_233
#set_property PACKAGE_PIN N7               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXP1_233
#set_property PACKAGE_PIN N11              [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXP2_233
#set_property PACKAGE_PIN M9               [get_ports "Not Connected"]                      ;# Bank 233 - MGTYTXP3_233
#set_property PACKAGE_PIN T12              [get_ports "Not Connected"]                      ;# Bank 234 - MGTREFCLK0N_234
#set_property PACKAGE_PIN T13              [get_ports "Not Connected"]                      ;# Bank 234 - MGTREFCLK0P_234
#set_property PACKAGE_PIN R14              [get_ports "Not Connected"]                      ;# Bank 234 - MGTREFCLK1N_234
#set_property PACKAGE_PIN R15              [get_ports "Not Connected"]                      ;# Bank 234 - MGTREFCLK1P_234
#set_property PACKAGE_PIN L1               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXN0_234
#set_property PACKAGE_PIN K3               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXN1_234
#set_property PACKAGE_PIN J1               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXN2_234
#set_property PACKAGE_PIN H3               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXN3_234
#set_property PACKAGE_PIN L2               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXP0_234
#set_property PACKAGE_PIN K4               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXP1_234
#set_property PACKAGE_PIN J2               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXP2_234
#set_property PACKAGE_PIN H4               [get_ports "Grounded"]                           ;# Bank 234 - MGTYRXP3_234
#set_property PACKAGE_PIN L6               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXN0_234
#set_property PACKAGE_PIN L10              [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXN1_234
#set_property PACKAGE_PIN K8               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXN2_234
#set_property PACKAGE_PIN J6               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXN3_234
#set_property PACKAGE_PIN L7               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXP0_234
#set_property PACKAGE_PIN L11              [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXP1_234
#set_property PACKAGE_PIN K9               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXP2_234
#set_property PACKAGE_PIN J7               [get_ports "Not Connected"]                      ;# Bank 234 - MGTYTXP3_234
#set_property PACKAGE_PIN P12              [get_ports "Not Connected"]                      ;# Bank 235 - MGTREFCLK0N_235
#set_property PACKAGE_PIN P13              [get_ports "Not Connected"]                      ;# Bank 235 - MGTREFCLK0P_235
#set_property PACKAGE_PIN M12              [get_ports "Not Connected"]                      ;# Bank 235 - MGTREFCLK1N_235
#set_property PACKAGE_PIN M13              [get_ports "Not Connected"]                      ;# Bank 235 - MGTREFCLK1P_235
#set_property PACKAGE_PIN G1               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXN0_235
#set_property PACKAGE_PIN F3               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXN1_235
#set_property PACKAGE_PIN E1               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXN2_235
#set_property PACKAGE_PIN D3               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXN3_235
#set_property PACKAGE_PIN G2               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXP0_235
#set_property PACKAGE_PIN F4               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXP1_235
#set_property PACKAGE_PIN E2               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXP2_235
#set_property PACKAGE_PIN D4               [get_ports "Grounded"]                           ;# Bank 235 - MGTYRXP3_235
#set_property PACKAGE_PIN G6               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXN0_235
#set_property PACKAGE_PIN E6               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXN1_235
#set_property PACKAGE_PIN C6               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXN2_235
#set_property PACKAGE_PIN A5               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXN3_235
#set_property PACKAGE_PIN G7               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXP0_235
#set_property PACKAGE_PIN E7               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXP1_235
#set_property PACKAGE_PIN C7               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXP2_235
#set_property PACKAGE_PIN A6               [get_ports "Not Connected"]                      ;# Bank 235 - MGTYTXP3_235

