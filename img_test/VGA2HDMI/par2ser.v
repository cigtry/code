/* ================================================ *\
          Filename ﹕ 并转串 quartus上使用需要添加ddio这个ip
            Author ﹕ fffff
      Description  ﹕ 
         Called by ﹕ 
Revision History  ﹕ 2022/12/16
                      Revision 1.0
              Email﹕ 17602369756@163.com
            Company﹕ 
\* ================================================ */
module par2ser(
    input  					    clk		  , // clock 125MHz
    input    [9:0]      data_in ,
    output              ser_p   ,
    output              ser_n   
);
//Parameter Declarations
wire       [4:0]     data_rise = {data_in[8],data_in[6],data_in[4],data_in[2],data_in[0]};
wire       [4:0]     data_fall = {data_in[9],data_in[7],data_in[5],data_in[3],data_in[1]};
reg       [4:0]     data_rise_s = 0;
reg       [4:0]     data_fall_s = 0;
reg       [2:0]     cnt = 0;
//Internal wire/reg declarations
always @(posedge clk )begin 
  cnt <=(cnt[2]== 1'b1) ? 3'b0 : (cnt+1);
  data_rise_s <=(cnt[2]== 1'b1) ? data_rise : data_rise_s[4:1];
  data_fall_s <=(cnt[2]== 1'b1) ? data_fall : data_fall_s[4:1];
end //always end


//Module instantiations , self-build module
ddio_out    ddio_out_inst(
  .datain_h (data_rise_s[0]),
  .datain_l (data_fall_s[0]),
  .outclock (~clk),
  .dataout  (ser_p)
);
ddio_out    ddio_out_inst2(
  .datain_h (~data_rise_s[0]),
  .datain_l (~data_fall_s[0]),
  .outclock (~clk),
  .dataout  (ser_p)
);    
//Logic Description
 

endmodule 