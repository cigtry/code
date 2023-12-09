////////////////////////////////////////////////////////////////
//Company				:		maccura	
//Engineer				:		FuXin	
//Creat Date			:		2023-01-01
//Design Name			:					
//Module Name			:					
//Project Name			:					
//Target Devices		:					
//Tool Version			:					
//Description			:					
//Revisoion			    :					
//Additional Comments	:					
//
//////////////////////////////////////////////////////////////
module uart_top (
    input           clk_50M,
    input           rst_n,
    /***********uart_rx****************/
    input           uart_rx,
    /***********uart_tx****************/
    output          uart_tx
);
    wire        [7:0]       rx_din;
    wire                    rx_vld;
    wire        [7:0]       tx_data;
    wire                    tx_req;
    wire                    tx_busy;
    wire                    wrreq;
    wire                    empty;
    wire                    full;
    wire        [7:0]       usedw;
    wire                    rdreq;

    
uart_rx     init_uart_rx
(
    .clk            (       clk_50M         ),
    .rst_n          (       rst_n           ),
    .uart_rx        (       uart_rx         ),
    .baud_sel       (       3'd4            ),//波特率选择0:9600 1:19200 2:38400 3:57600 4:115200 其他均为9600
    .rx_din         (       rx_din          ),//接收到的数据
    .rx_vld         (       rx_vld          )//接受到的数据有效信号
);
uart_tx     init_uart_tx
(
    .clk            (       clk_50M         ),
    .rst_n          (       rst_n           ),
    .uart_tx        (       uart_tx         ),
    .baud_sel       (       3'd4            ),//波特率选择0:9600 1:19200 2:38400 3:57600 4:115200 其他均为9600
    .tx_data        (       tx_data         ),//需要发送的数据
    .tx_req         (       rdreq           ),//发送请求
    .tx_busy        (       tx_busy         )//发送忙状态，为1时发送请求无效
);

fifo	fifo_inst (
	.aclr           (       !rst_n           ),
	.clock          (       clk_50M         ),
	.data           (       rx_din          ),
	.rdreq          (       rdreq           ),
	.wrreq          (       wrreq           ),
	.empty          (       empty           ),
	.full           (       full            ),
	.q              (       tx_data         ),
	.usedw          (       usedw           )
);

fifo    fifo (
  .clk    (clk_50M),      // input wire clk
  .srst   (!rst_n ),    // input wire srst
  .din    (rx_din),      // input wire [7 : 0] din
  .wr_en  (wrreq),  // input wire wr_en
  .rd_en  (rdreq),  // input wire rd_en
  .dout   (tx_data),    // output wire [7 : 0] dout
  .full   (full),    // output wire full
  .empty  (empty)  // output wire empty
);
assign wrreq = rx_vld & !full;//数据有效且fifo非满即可写入数据
assign rdreq = !empty&!tx_busy;//fifo非空且处于非忙状态可以读出数据
endmodule