module datapath( clk, rst, pc_write, pc_write_con, IorD, 
                mem_read_data, ir_write, reg_dst, reg_wr_dst, reg_write,
                alu_src_A, alu_src_B, alu_op, pc_src, zero, mem_adr, mem_write_data, instruction
                );
    input clk, rst, pc_write, pc_write_con, IorD, ir_write, reg_write, alu_src_A;
    input [1:0] pc_src;
    input [1:0] reg_dst;
    input [1:0] alu_src_B;
    input [1:0] reg_wr_dst;
    input [2:0] alu_op;
    input [31:0] mem_read_data;

    output [31:0] mem_adr;
    output [31:0] mem_write_data;
    output [31:0] instruction;
    output zero;
    
    wire pc_load;

    wire [31:0] pc_out;
    wire [31:0] IR_out;     //IR_out = instruction data
    wire [31:0] MDR_out;    //MDR_out = memory read data
    wire [31:0] regAlu_out;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire[31:0] SE_out;
    wire [31:0] S1_out;
    wire [31:0] S2_out;
    wire [31:0] alu_out;
    wire[31:0] reg_d1_out;
    wire[31:0] reg_d2_out;

    wire [31:0] mux1_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;
    wire [31:0] mux5_out;
    wire [31:0] mux6_out;
    wire [4:0] mux2_out;
    

    reg_32b PC(mux6_out, rst, pc_load, clk, pc_out); //pc_load assignment!
    
    
    
    mux2to1_32b mux1(pc_out, regAlu_out, IorD, mux1_out);
    
    reg_32b IR(mem_read_data, rst, ir_write, clk, IR_out);

    reg_32b MDR(mem_read_data, rst, 1'b1, clk, MDR_out);

    mux4to1_5b mux2(IR_out[20:16], IR_out[15:11], 5'd31, , reg_dst, mux2_out);

    mux4to1_32b mux3(regAlu_out, MDR_out, pc_out, , reg_wr_dst, mux3_out);

    reg_file RF(mux3_out, IR_out[25:21], IR_out[20:16], mux2_out, reg_write, rst, clk, read_data1, read_data2);

    sign_ext SE(IR_out[15:0], SE_out);

    shl2 S1(SE_out, S1_out);

    reg_32b regD1(read_data1, rst, 1'b1, clk, reg_d1_out);

    reg_32b regD2(read_data2, rst, 1'b1, clk, reg_d2_out);

    mux2to1_32b mux4(pc_out, reg_d1_out, alu_src_A, mux4_out);

    mux4to1_32b mux5(reg_d2_out, 32'd4, SE_out, S1_out, alu_src_B, mux5_out);

    alu ALU(mux4_out, mux5_out, alu_op, alu_out, zero);     // ctrl ???

    shl2 S2({6'd0, IR_out[25:0]}, S2_out);

    reg_32b regAlu(alu_out, rst, 1'b1, clk, regAlu_out);

    mux4to1_32b mux6(alu_out, {pc_out[31:28], S2_out[27:0]}, regAlu_out, read_data1, pc_src, mux6_out);


    assign pc_load = pc_write | (pc_write_con & zero);
    assign mem_adr = mux1_out;
    assign mem_write_data = reg_d2_out;
    assign instruction = IR_out;

endmodule