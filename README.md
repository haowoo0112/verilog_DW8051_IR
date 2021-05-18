# verilog_DW8051_IR_LCM

1. 電源開機後液晶顯示器顯示為
    NTUST IR RX
    00-00-00-00
2. 每次按下紅外線遙控器後，將收到的紅外線解碼器資料顯示在液晶顯示器上


| MODULE        | DESCRIPTION                                        |
| ------------- | -------------------------------------------------- |
| edge_detect_neg.v | gives one-tick pulses on every signal falling edge |
| edge_detect_pos.v    | gives one-tick pulses on every signal rising edge                                          |
| DW8051_IR_tb.v | testbench
| chiptop.v |chiptop
| rom_mem.v | software rom memory
| int_mem.v |software ram memory
| rom.v | altera rom IP
| ram.v | altera ram IP
| sfr_mem_IR.v | sfr memory controller
| IR.v | IR receiver
| DW8051_core.v | DW8051_core

## IR
![](https://i.imgur.com/S2IYsOE.png)

![](https://i.imgur.com/fXrsRRB.png)

## sfr
![](https://i.imgur.com/RkjeLVg.png)
![](https://i.imgur.com/HVuK1iv.png)
