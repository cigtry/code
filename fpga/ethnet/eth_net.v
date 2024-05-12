`timescale 1ns / 1ps
`define ETH_INPUT_WIDTH 4
`define ETH_OUTPUT_WIDTH 4
// `define  MII
////////////////////////////////////////////////////////////////
//Company        :    maccura  
//Engineer        :    FuXin  
//Creat Date      :    2023-01-01
//Design Name      :          
//Module Name      :          
//Project Name      :          
//Target Devices    :          
//Tool Version      :          
//Description      :          
//Revisoion      :          
//Additional Comments  :          
//
////////////////////////////////////////////////////////////////
module eth_net#(
    parameter   BOARD_MAC   = 48'H00_11_22_33_44_55,//开发板mac地址
                BOARD_IP    = {8'd192,8'd168,8'd1,8'd123},//开发板ip地址
                DES_MAC     = 48'hff_ff_ff_ff_ff_ff,//目标MAC地址
                DES_IP      = {8'd192,8'd168,8'd1,8'd102}//目标IP地址
)(
    // input            clk    , //system clock 50MHz
    input             sys_rst_n  , //reset, low valid
    input                   eth_rx_clk  ,
    input                   eth_rxdv    ,
    input       [`ETH_INPUT_WIDTH:0]       eth_rx_data ,
    input                   eth_tx_clk  ,
    output                  eth_tx_en   ,
    output      [`ETH_OUTPUT_WIDTH:0]       eth_tx_data ,
    output                  eth_rst_n
    
);
//wire define
    wire rec_pkt_done       ; //以太网单包数据接收完成信号
    wire rec_en             ; //以太网接收的数据使能信号
    wire [31:0] rec_data    ; //以太网接收的数据
    wire [15:0] rec_byte_num; //以太网接收的有效字节数 单位:byte
    wire tx_done            ; //以太网发送完成信号
    wire tx_req;
    wire tx_start_en        ; //以太网开始发送信号
    wire [31:0] tx_data     ; //以太网待发送数据

udp
#(
    .BOARD_MAC    (48'H00_11_22_33_44_55      )   ,//开发板mac地址
    .BOARD_IP     ({8'd192,8'd168,8'd1,8'd123})   ,//开发板ip地址
    .DES_MAC      (48'hff_ff_ff_ff_ff_ff      )   ,//目标MAC地址
    .DES_IP       ({8'd192,8'd168,8'd1,8'd102})   //目标IP地址
)
inst_udp(
    /*input          */  .eth_rx_clk     (eth_rx_clk     ), //system clock 50MHz
    /*input           */  .rst_n         (sys_rst_n         ), //reset, low valid
    /*input                 */  .eth_rxdv      (eth_rxdv      ) ,  //mii输入数据有效信号
    /*input       [3:0]     */  .eth_rx_data   (eth_rx_data   ) , //mii输入数据
    /*input                 */  .tx_start_en   (tx_start_en   ) , //以太网开始发送信号
    /*input       [31:0]    */  .tx_data       (tx_data      ) , //以太网待发送数据
    /*input       [15:0]    */  .tx_byte_num   (rec_byte_num  ) , //以太网发送的有效字节数 byte
    /*input                 */  .eth_tx_clk    (eth_tx_clk    ) , //mii发送数据时钟
    /*output                */  .tx_done       (tx_done       ) , //以太网发送完成信号
    /************************/  .tx_req        (tx_req),
    /*output                */  .rec_pkt_done  (rec_pkt_done  ) , //以太网单包数据接受完成
    /*output                */  .rec_en        (rec_en        ) , //以太网接受的数据使能信号
    /*output      [31:0]    */  .rec_data      (rec_data      ) , //mii输出数据有效信号
    /*output      [15:0]    */  .rec_byte_num  (rec_byte_num  ) , //以太网接受的有效字节数
    /*output                */  .eth_tx_data   (eth_tx_data   ) , //mii输出数据
    /*output      [3:0]     */  .eth_rst_n     (eth_rst_n     )   //以太网芯片复位信号
);

    pulse_sync_pro u_pulse_sync_pro(
    .clk_a      (eth_rx_clk),
    .rst_n      (sys_rst_n),
    .pulse_a    (rec_pkt_done),
    .clk_b      (eth_tx_clk),
    .pulse_b    (tx_start_en)
     );

     fifo_generator_0 fifo (
        .rst          (~sys_rst_n),        // input wire rst
        .wr_clk       (eth_tx_clk),  // input wire wr_clk
        .rd_clk       (eth_rx_clk),  // input wire rd_clk
        .din          (rec_data),        // input wire [31 : 0] din
        .wr_en        (rec_en),    // input wire wr_en
        .rd_en        (tx_req),    // input wire rd_en
        .dout         (tx_data),      // output wire [31 : 0] dout
        .full         (),      // output wire full
        .empty        ()    // output wire empty
);


endmodule 