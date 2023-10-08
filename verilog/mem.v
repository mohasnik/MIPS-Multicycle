module mem (adr, d_in, mrd, mwr, clk, d_out);
  input [31:0] adr;
  input [31:0] d_in;
  input mrd, mwr, clk;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];

  integer i;
  integer fd;

  initial begin
    $readmemb("instData.mem", mem, 0);
    $readmemb("memData.mem", mem, 1000);
  end

  initial begin
    fd = $fopen("final.mem");
    for(i=0; i < 65535; i = i+4) begin
      $fdisplay(fd, "%d : %b %b %b %b",i ,mem[i], mem[i+1], mem[i+2], mem[i+3]);
    end
    $fclose(fd);

    #9200 $display("Mem[%d] (minimum element) = %d", 12'd2000, mem[2000]);
          $display("Mem[%d] (index) = %d", 12'd2004, mem[2004]/4);
  end
  
  always @(posedge clk)
    if (mwr==1'b1)
      {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;

  assign d_out = (mrd==1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
  
endmodule
