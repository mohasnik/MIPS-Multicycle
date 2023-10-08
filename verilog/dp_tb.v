module db_tb();

    reg clk, rst, PCWrite, PCWriteCon, IorD, IR_write, RegDst, reg_write, ALUSrcA, mem_read, mem_write;
    reg [1:0] pc_src, ALUSrcB, RegWrDst;
    reg [2:0] alu_op;
    wire [31:0] mem_read_data;

    wire [31:0] mem_adr, mem_write_data;
    wire zero;

    datapath dp(clk, rst, PCWrite, PCWriteCon, IorD, 
                mem_read_data, IR_write, RegDst, RegWrDst, reg_write,
                ALUSrcA, ALUSrcB, alu_op, pc_src, zero, mem_adr, mem_write_data
                );
    mem Mem(mem_adr, mem_write_data, mem_read, mem_write, clk, mem_read_data);

    initial
    begin
        rst = 1'b1;
        clk = 1'b0;
        mem_read = 1'b1;
        ALUSrcA = 1'b0;
        IorD = 0;
        IR_write = 1'b1;
        ALUSrcB = 2'b01;
        alu_op = 2'b00;
        PCWrite = 1;
        pc_src = 2'b00;
        
        #16 rst = 1'b0;

        #2600 $stop;
    end

    always
    begin
        #8 clk = ~clk;
    end
endmodule