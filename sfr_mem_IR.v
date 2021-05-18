`timescale 1ns / 10ps

module  sfr_mem_IR(
  input clk,
  input [7:0]addr,
  input [7:0]D_IN,
  output reg [7:0]D_OUT,
  input sfr_wr,
  input sfr_rd,
  input  [3:0]KEY,
  input ir_read,
  output reg LCD_BLON,
  output reg [7:0]LCD_DATA,
  output reg LCD_EN,
  output reg LCD_ON,
  output reg LCD_RS,
  output reg LCD_RW); 
  
  reg [7:0]state_0xD1;
  reg [7:0]state_0xD3;
  reg [4:0]en_count;
  reg [7:0]state_0xDC;
  wire [3:0]HEX0;
  wire [3:0]HEX1;
  wire [3:0]HEX2;
  wire [3:0]HEX3;
  wire [3:0]HEX4;
  wire [3:0]HEX5;
  wire [3:0]HEX6;
  wire [3:0]HEX7;
  wire rx_complete;
  
  IR u1(
    .clk(clk),
    .reset(KEY[0]),

    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .HEX6(HEX6),
    .HEX7(HEX7),
    .rx_complete(rx_complete),
    .ir_read(ir_read));

always @(negedge clk or negedge KEY[0])begin
  if(!KEY[0])begin
    state_0xDC<=8'h00;
    D_OUT        <=8'h00;
  end
  else begin
    if(sfr_wr&&addr==8'hDC)  state_0xDC<=D_IN;
    else if(sfr_rd&&addr==8'hDD)begin
      if(state_0xDC==8'd0)
        D_OUT<={HEX1,HEX0}; //Hex1=1 hex0=2
      if(state_0xDC==8'd1)
        D_OUT<={HEX3,HEX2};
      if(state_0xDC==8'd2)
        D_OUT<={HEX5,HEX4};
      if(state_0xDC==8'd3)
        D_OUT<={HEX7,HEX6};
    end
    else if(sfr_rd&&addr==8'hDB)begin
      if(rx_complete)
        D_OUT<=8'd2;
      else 
        D_OUT<=8'd0;
    end
  end
  

end

always @(negedge clk or negedge KEY[0])begin
  if(!KEY[0])begin
    state_0xD1<=8'h00;
    state_0xD3<=8'h00;
    LCD_DATA<=8'd0;
    LCD_EN<=1'b0;
    en_count<=5'd0;
  end
  else begin
    if(sfr_wr&&addr==8'hD1)  state_0xD1<=D_IN;
    else if(sfr_wr&&addr==8'hD3)begin
      state_0xD3<=D_IN;
      LCD_DATA<=D_IN;
      LCD_EN<=1'b1;
    end
    if(LCD_EN==1'b1)begin
      en_count<=en_count+1'b1;
      if(en_count==5'd31)begin
        LCD_EN<=1'b0;
      end
    end
  end

end

always @(negedge clk or negedge KEY[0])begin
  if(!KEY[0])begin
    LCD_BLON<=1'b0;
    LCD_ON<=1'b0;
    LCD_RW<=1'b0;
    LCD_RS<=1'b0;
    
  end
  else begin
    if(state_0xD1[4]) LCD_ON<=1'b1;
    else LCD_ON<=1'b0;
    if(state_0xD1[5]) LCD_BLON<=1'b1;
    else LCD_BLON<=1'b0;
    if(state_0xD1[1]) LCD_RS<=1'b1;
    else if(state_0xD1[0])LCD_RS<=1'b0;

  end


end

endmodule 