module mips_tb;
  
  
  reg clk, rst;
  wire pc_write, pc_write_con, IorD, ir_write, reg_write, alu_src_A, zero;
  wire [1:0] pc_src, alu_src_B, reg_wr_dst, reg_dst;
  wire [2:0] alu_op;
  wire [31:0] mem_read_data, mem_adr, mem_write_data, instruction;

  datapath dp(clk, rst, pc_write, pc_write_con, IorD, 
                mem_read_data, ir_write, reg_dst, reg_wr_dst, reg_write,
                alu_src_A, alu_src_B, alu_op, pc_src,
                zero, mem_adr, mem_write_data, instruction
                );

  mc_controller controller(clk, rst, instruction[31:26], instruction[5:0], 
                            alu_op, reg_dst, reg_wr_dst, reg_write, ir_write, IorD,
                            alu_src_A, alu_src_B, pc_src, pc_write, pc_write_con,
                            mem_read, mem_write
                            );

  mem Mem(mem_adr, mem_write_data, mem_read, mem_write, clk, mem_read_data);
  
  initial
  begin
    rst = 1'b1;
    clk = 1'b0;
    #20 rst = 1'b0;
    #9500 $stop;
  end
  
  always
  begin
    #8 clk = ~clk;
  end
  
endmodule
