`timescale 1ns / 1ps
`include "eth_net.v"
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
module udp
#(
    parameter   BOARD_MAC   = 48'H00_11_22_33_44_55,//开发板mac地址
                BOARD_IP    = {8'd192,8'd168,8'd1,8'd123},//开发板ip地址
                DES_MAC     = 48'hff_ff_ff_ff_ff_ff,//目标MAC地址
                DES_IP      = {8'd192,8'd168,8'd1,8'd102}//目标IP地址
)(
    input            eth_rx_clk    , //system clock 50MHz
    input             rst_n          , //reset, low valid
    input                   eth_rxdv        ,  //mii输入数据有效信号
    input       [`ETH_INPUT_WIDTH-1:0]       eth_rx_data     , //mii输入数据
    input                   tx_start_en     , //以太网开始发送信号
    input       [07:0]      tx_data         , //以太网待发送数据
    input       [15:0]      tx_byte_num     , //以太网发送的有效字节数 byte
    input                   eth_tx_clk      , //mii发送数据时钟
    output                  tx_done         , //以太网发送完成信号
    output                  tx_req          ,
    output                  rec_pkt_done    , //以太网单包数据接受完成
    output                  rec_en          , //以太网接受的数据使能信号
    output      [07:0]      rec_data        , //mii输出数据有效信号
    output      [15:0]      rec_byte_num    , //以太网接受的有效字节数
    output                  eth_tx_en       ,
    output      [`ETH_OUTPUT_WIDTH-1:0]       eth_tx_data     , //mii输出数据
    output                  eth_rst_n         //以太网芯片复位信号
);
//Internal wire/reg declarations
    wire            crc_en;
    wire            crc_clr;
    wire    [3:0]   crc_d4;

    wire    [31:0]  crc_data;//crc校验数据
    wire    [31:0]  crc_next;//crc下次校验完成数据
    reg     [3:0] cnt;
    assign  crc_d4 = eth_tx_data[((`ETH_INPUT_WIDTH-1)-4*cnt)-:4];
    assign  eth_rst_n = 1'b1;

//Module instantiations , self-build module
    always @(posedge eth_tx_clk or negedge rst_n)begin 
        if(!rst_n)begin  
            cnt<=1'b0;
        end  
        else if(cnt>=((`ETH_OUTPUT_WIDTH-4)/4))begin  
            cnt<=1'b0;
        end  
        else if(crc_en)begin  
            cnt<=cnt+1'b1;
        end  
    end //always end
    
  
//Logic Description
    ip_receive
    #(  .BOARD_MAC      (BOARD_MAC),
        .BOARD_IP       (BOARD_IP),
        .DES_MAC        (DES_MAC    )   ,
        .DES_IP         (DES_IP     )   
        )
    u_ip_receive(
        .clk            (eth_rx_clk    ),
        .rst_n          (rst_n        ),
        .eth_rxdv       (eth_rxdv      ),
        .eth_rx_data    (eth_rx_data   ),
        .rec_pkt_done   (rec_pkt_done  ),
        .rec_en         (rec_en        ),
        .rec_data       (rec_data      ),
        .rec_byte_num   (rec_byte_num )
    );

    ip_send
    #(  .BOARD_MAC      (BOARD_MAC),
        .BOARD_IP       (BOARD_IP),
        .DES_MAC        (DES_MAC    )   ,
        .DES_IP         (DES_IP     )   
        )
    u_ip_send(
        .clk            (eth_tx_clk  ),
        .rst_n          (rst_n       ),
        .tx_start_en    (tx_start_en ),
        .tx_data        (tx_data     ),
        .tx_byte_num    (tx_byte_num ),
        .crc_data       (crc_data    ),
        .tx_done        (tx_done     ),
        .tx_req         (tx_req),
        .eth_tx_en      (eth_tx_en   ),
        .eth_tx_data    (eth_tx_data ),
        .crc_en         (crc_en      ),
        .crc_clr        (crc_clr     )
    );
    // crc32_d4    u_crc32_d4(
    //     .clk       (eth_tx_clk ),           
    //     .rst_n     (rst_n   ),
    //     .data      (crc_d4  ),
    //     .crc_en    (crc_en  ),
    //     .crc_clr   (crc_clr ),    
    //     .crc_data  (crc_data)    
    // );
    crc32_d4 u_crc32_d4(
    .Clk             (eth_tx_clk), 
    .Rst_n           (rst_n), 
    .Data            (crc_d4), 
    .Enable          (crc_en), 
    .Initialize      (crc_clr), 
    .Crc             (), 
    .CrcError        (), 
    .Crc_eth         (crc_data)
    );
endmodule 