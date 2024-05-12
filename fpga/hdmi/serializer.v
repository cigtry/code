/* ================================================ *\
        Filename ﹕ 
         Author ﹕ fffff
     Description  ﹕ 
       Called by ﹕ 
Revision History  ﹕ 2022/-/-
                 Revision 1.0
           Email﹕ 17602369756@163.com
         Company﹕ 
\* ================================================ */
module serializer(
   input                clk_5x ,
   input  					clk_1x, //system clock 50MHz
   input  			 		rst_n	, //!rst_n, low valid
   input     [9:0]      din   ,
   output               dout_n,
   output               dout_p
);
//wire define
wire        dout;
wire		cascade1;     //用于两个OSERDESE2级联的信号
wire		cascade2;
  
  //reg define
reg reset_1;
reg reset_2;

wire syn_reset ;
//*****************************************************
//**                    main code
//***************************************************** 
assign syn_reset  = reset_2;
    
//对异步复位信号进行同步释放，并转换成高有效在使用OSERDESE2原语时必须将异步的复位信号转换到其时域内，否则OQ 输出为1'hx
always @ (posedge clk_1x or negedge rst_n) begin
    if(!rst_n) begin
        reset_1 <= 1'b1;
        reset_2 <= 1'b1;
    end
    else begin
        reset_1 <= 1'b0;
        reset_2 <= reset_1;
    end
end
//*****************************************************
//**                    main code
//***************************************************** 
    
//例化OSERDESE2原语，实现并串转换,Master模式
OSERDESE2 #(
    .DATA_RATE_OQ   ("DDR"),       // 设置双倍数据速率
    .DATA_RATE_TQ   ("SDR"),       // DDR, BUF, SDR
    .DATA_WIDTH     (10),           // 输入的并行数据宽度为10bit
    .SERDES_MODE    ("MASTER"),    // 设置为Master，用于10bit宽度扩展
    .TBYTE_CTL      ("FALSE"),     // Enable tristate byte operation (FALSE, TRUE)
    .TBYTE_SRC      ("FALSE"),     // Tristate byte source (FALSE, TRUE)
    .TRISTATE_WIDTH (1)             // 3-state converter width (1,4)
)
OSERDESE2_Master (
    .CLK        (clk_5x),    // 串行数据时钟,5倍时钟频率
    .CLKDIV     (clk_1x),     // 并行数据时钟
    .RST        (syn_reset),            // 1-bit input: !rst_n
    .OCE        (1'b1),             // 1-bit input: Output data clock enable
    
    .OQ         (dout),  // 串行输出数据
    
    .D1         (din[0]), // D1 - D8: 并行数据输入
    .D2         (din[1]),
    .D3         (din[2]),
    .D4         (din[3]),
    .D5         (din[4]),
    .D6         (din[5]),
    .D7         (din[6]),
    .D8         (din[7]),
   
    .SHIFTIN1   (cascade1),         // SHIFTIN1 用于位宽扩展
    .SHIFTIN2   (cascade2),         // SHIFTIN2
    .SHIFTOUT1  (),                 // SHIFTOUT1: 用于位宽扩展
    .SHIFTOUT2  (),                 // SHIFTOUT2
        
    .OFB        (),                 // 以下是未使用信号
    .T1         (1'b0),             
    .T2         (1'b0),
    .T3         (1'b0),
    .T4         (1'b0),
    .TBYTEIN    (1'b0),             
    .TCE        (1'b0),             
    .TBYTEOUT   (),                 
    .TFB        (),                 
    .TQ         ()                  
);
   
//例化OSERDESE2原语，实现并串转换,Slave模式
OSERDESE2 #(
    .DATA_RATE_OQ   ("DDR"),       // 设置双倍数据速率
    .DATA_RATE_TQ   ("SDR"),       // DDR, BUF, SDR
    .DATA_WIDTH     (10),           // 输入的并行数据宽度为10bit
    .SERDES_MODE    ("SLAVE"),     // 设置为Slave，用于10bit宽度扩展
    .TBYTE_CTL      ("FALSE"),     // Enable tristate byte operation (FALSE, TRUE)
    .TBYTE_SRC      ("FALSE"),     // Tristate byte source (FALSE, TRUE)
    .TRISTATE_WIDTH (1)             // 3-state converter width (1,4)
)
OSERDESE2_Slave (
    .CLK        (clk_5x),    // 串行数据时钟,5倍时钟频率
    .CLKDIV     (clk_1x),     // 并行数据时钟
    .RST        (syn_reset),            // 1-bit input: !rst_n
    .OCE        (1'b1),             // 1-bit input: Output data clock enable
    
    .OQ         (),                 // 串行输出数据
    
    .D1         (1'b0),             // D1 - D8: 并行数据输入
    .D2         (1'b0),
    .D3         (din[8]),
    .D4         (din[9]),
    .D5         (1'b0),
    .D6         (1'b0),
    .D7         (1'b0),
    .D8         (1'b0),
   
    .SHIFTIN1   (),                 // SHIFTIN1 用于位宽扩展
    .SHIFTIN2   (),                 // SHIFTIN2
    .SHIFTOUT1  (cascade1),         // SHIFTOUT1: 用于位宽扩展
    .SHIFTOUT2  (cascade2),         // SHIFTOUT2
        
    .OFB        (),                 // 以下是未使用信号
    .T1         (1'b0),             
    .T2         (1'b0),
    .T3         (1'b0),
    .T4         (1'b0),
    .TBYTEIN    (1'b0),             
    .TCE        (1'b0),             
    .TBYTEOUT   (),                 
    .TFB        (),                 
    .TQ         ()                  
);  
        
   // End of OSERDESE2_inst instantiation
   OBUFDS #(
    .IOSTANDARD         ("TMDS_33")    // I/O电平标准为TMDS
) TMDS0 (
    .I                  (dout),
    .O                  (dout_p),
    .OB                 (dout_n) 
);

endmodule 

