module synchronous_fifo #(parameter DEPTH=16, DATA_WIDTH=8) (
  input clk, rstn,
  input wr_en, rd_en,
  input [DATA_WIDTH-1:0] data_in,
  input cs,
  output reg [DATA_WIDTH-1:0] data_out,
  output full, empty
);
  // Memory Array
  reg [DATA_WIDTH-1:0] fifo [0:DEPTH-1];
   // Extra bit added to distinguish full from empty
 reg [$clog2(DEPTH):0] wr_pntr, rd_pntr;
      
      assign full = (wr_pntr[$clog2(DEPTH)]    != rd_pntr[$clog2(DEPTH)]) &&
               (wr_pntr[$clog2(DEPTH)-1:0] == rd_pntr[$clog2(DEPTH)-1:0]);
      assign empty = (wr_pntr==rd_pntr)?1:0;
      
      
      always@(posedge clk) begin
        if(!rstn)begin
          wr_pntr<=0;
          
        end else
          if (cs&&wr_en && !full)begin 
          fifo[wr_pntr[$clog2(DEPTH)-1:0]]<=data_in;
          wr_pntr<= wr_pntr+1;
        end 
      end
      
      always @(posedge clk)begin 
        if(!rstn)begin
          {data_out,rd_pntr}<=0;
        end else if(cs && rd_en && !empty)begin 
         data_out<=fifo[rd_pntr[$clog2(DEPTH)-1:0]];
          rd_pntr<= rd_pntr+1;
        end 
        end 
      
      
        endmodule
          