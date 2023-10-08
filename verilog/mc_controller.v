`define S0  4'd0
`define S1  4'd1
`define S2  4'd2
`define S3  4'd3
`define S4  4'd4
`define S5  4'd5
`define S6  4'd6
`define S7  4'd7
`define S8  4'd8
`define S9  4'd9
`define S10 4'd10
`define S11 4'd11
`define S12 4'd12
`define S13 4'd13
`define S14 4'd14

`define OP_ADD 3'b010
`define OP_SUB 3'b110
`define OP_AND 3'b000
`define OP_OR  3'b001
`define OP_SLT 3'b111

module mc_controller(clk,rst,opcode,func,alu_op,reg_dst,reg_wdst,reg_write,ir_write,l_or_d,alusrcA,alusrcB,pc_src,pc_write,pc_write_cond,mem_read,mem_write);
  input clk,rst;
  input[5:0] opcode,func;
  output reg[1:0] reg_dst,reg_wdst;
  output reg reg_write,ir_write,l_or_d,alusrcA;
  output reg [1:0] alusrcB;
  output reg [2:0] alu_op;
  output reg [1:0] pc_src;
  output reg pc_write,pc_write_cond;
  output reg mem_read,mem_write;

  reg [3:0] ps,ns;

  always @(posedge clk) begin
    if (rst)
      ps = `S0;
    else
      ps = ns;
  end

  always @(ps or func or opcode) begin
    case(ps)
      `S0: ns = `S1;
      `S1: case(opcode)
             6'b001010: ns = `S13;	//slti
             6'b001001: ns = `S12;	//addi
             6'b000010: ns = `S9;	//j
             6'b000011: ns = `S10;	//jal
             6'b000110: ns = `S11; 	//jr
             6'b000000: ns = `S6;	//rtype
             6'b100011: ns = `S2;	//lw
             6'b101011: ns = `S2;	//sw
             6'b000100: ns = `S8;	//beq	
           endcase
      `S2: case(opcode)
             6'b100011: ns = `S3;	//lw
             6'b101011: ns = `S5;	//sw
           endcase
      `S3:  ns = `S4;
      `S4:  ns = `S0;
      `S5:  ns = `S0;
      `S6:  ns = `S7;
      `S7:  ns = `S0;
      `S8:  ns = `S0;
      `S9:  ns = `S0;
      `S10: ns = `S0;
      `S11: ns = `S0;
      `S12: ns = `S14;
      `S13: ns = `S14;
      `S14: ns = `S0;
    endcase
  end

  always @(ps) begin
    {reg_dst,reg_wdst,reg_write,ir_write,l_or_d,alusrcA,alusrcB,alu_op,pc_src,pc_write,pc_write_cond,mem_read,mem_write} = '0;
    case(ps)
      `S0:  {mem_read,ir_write,alusrcB,pc_write,pc_src} = {1'b1,1'b1,2'b01,1'b1,2'b00};
      `S1:  {alusrcB} = {2'b11};
      `S2:  {alusrcA,alusrcB} = {1'b1,2'b10};
      `S3:  {mem_read,l_or_d} = {1'b1,1'b1};
      `S4:  {reg_dst,reg_write,reg_wdst} = {2'b00,1'b1,2'b01};
      `S5:  {mem_write,l_or_d} = {1'b1,1'b1};
      `S6:  {alusrcA,alusrcB} = {1'b1,2'b00};
      `S7:  {reg_dst,reg_write,reg_wdst} = {2'b01,1'b1,2'b00};
      `S8:  {alusrcA,alusrcB,pc_write_cond,pc_src} = {1'b1,2'b00,1'b1,2'b10};
      `S9:  {pc_write,pc_src} = {1'b1,2'b01};
      `S10: {reg_dst,reg_wdst,reg_write,pc_write,pc_src} = {2'b10,2'b10,1'b1,1'b1,2'b10};
      `S11: {pc_write,pc_src} = {1'b1,2'b11};
      `S12: {alusrcA,alusrcB} = {1'b1,2'b10};
      `S13: {alusrcA,alusrcB} = {1'b1,2'b10};
      `S14: {reg_dst,reg_write,reg_wdst} = {2'b00,1'b1,2'b00};
    endcase         
  end

  always @(ps or func) begin
    case(ps)
      `S0: alu_op = `OP_ADD;
      `S1: alu_op = `OP_ADD;
      `S2: alu_op = `OP_ADD;
      `S6: case(func)
             6'b100000: alu_op = `OP_ADD;
             6'b100011: alu_op = `OP_SUB;
             6'b100100: alu_op = `OP_AND;
             6'b100101: alu_op = `OP_OR;
             6'b101010: alu_op = `OP_SLT;
             default:   alu_op = `OP_AND;
           endcase
      `S8:  alu_op = `OP_SUB;
      `S12: alu_op = `OP_ADD;
      `S13: alu_op = `OP_SLT;
      default: alu_op = `OP_AND;
    endcase
  end

endmodule
