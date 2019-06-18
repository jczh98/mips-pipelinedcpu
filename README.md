# Mips CPU with Pipeline

Verilog Code to simulate `MIPS CPU` with pipeline.

Developed as the expriment project for Computer Architecture in UESTC

## Instructions

- add
- and
- or
- xor
- srl
- sll
- addi
- andi
- ori
- xori
- load
- store
- beq
- bne
- jump

## Implementation

- [x] Data hazard
- [x] Control hazard

## How to Run

1. Clone this repo

   ```
   https://github.com/neverfelly/mips-pipelinedcpu.git
   cd mips-pipelindcpu
   ```

2. Compile all files

   ```
   iverilog -o main *.v
   ```

3. Run the compiled binary

   ```
   vvp -n main -lxt2
   ```

4. Verify wave graph

   ```
   gtkwave ppcpu.vcd
   ```


## Requriments

- iverilog in [http://iverilog.icarus.com](http://iverilog.icarus.com)
- gtkwave