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
module ip_send#( parameter  BOARD_MAC   = 48'H00_11_22_33_44_55,//开发板mac地址
                BOARD_IP    = {8'd192,8'd168,8'd1,8'd123},//开发板ip地址
                DES_MAC     = 48'hff_ff_ff_ff_ff_ff,//目标MAC地址
                DES_IP      = {8'd192,8'd168,8'd1,8'd102}//目标IP地址
        )(
        input                   clk           ,
        input                   rst_n         ,
        input                   tx_start_en   ,
        input   [7:0]           tx_data       ,
        input   [15:0]          tx_byte_num   ,
        input   [31:0]          crc_data      ,
        output                  tx_done       ,
        output                  tx_req          ,
        output reg              eth_tx_en     ,
        output     [`ETH_OUTPUT_WIDTH-1:0]          eth_tx_data   ,
        output                  crc_en        ,
        output                  crc_clr       
    );
//
    parameter   data_total_len = 16'd22;//实际数据是它的一半
    wire    [15:0]      ip_total_len;
    wire    [15:0]      udp_total_len;
    assign  ip_total_len = data_total_len + 16'd28;
    assign  udp_total_len = data_total_len + 16'd8;

    localparam  PREAMBLE= 64'h55_55_55_55_55_55_55_d5;
    localparam  ETH_HEAD = {DES_MAC,BOARD_MAC,16'h0800};
    
    parameter   ST_IDLE      = 8'b0000_0001,
                ST_CHECK_SUM = 8'b0000_0010,
                ST_PREAMBLE  = 8'b0000_0100,
                ST_ETH_HEAD  = 8'b0000_1000,
                ST_IP_HEAD   = 8'b0001_0000,
                ST_UDP_HEAD  = 8'b0010_0000,
                ST_TX_DATA   = 8'b0100_0000,
                ST_CRC       = 8'b1000_0000;
    reg     [7:0]   state_c , state_n;
    wire            st_idle2st_check_sum        ;
    wire            st_check2st_preamble        ;
    wire            st_preamble2st_eth_head     ;
    wire            st_eth2st_ip_head           ;
    wire            st_ip_head2st_udp_head      ;
    wire            st_udp_head2st_tx_data      ;
    wire            st_tx_data2st_crc           ;
    wire            st_crc2st_idle              ;

    
    reg     [159:0]  ip_head ;
    reg     [63:0]   udp_head;
    reg              start_0,start_1;
    wire             start_pos;
    reg    [31:0]    sum;
    reg    [15:0]    check_sum;

    reg     [15:0]   byte_num;
    reg     [15:0]   byte_cnt;
    reg     [15:0]   tx_byte_cnt;
    reg [`ETH_OUTPUT_WIDTH-1:0]      eth_dout   ;

    
//Logic Description
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
    ip_head <= 120'h0;
    udp_head <= 64'h0;
    end 
    else begin
       ip_head <= {4'h4,4'h5,8'h0,
                ip_total_len,16'h0,16'h0,8'h04,8'h11,check_sum,BOARD_IP,DES_IP};
    udp_head <= {16'h5000,16'h6000,udp_total_len}; 
    end
end //always end

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            sum <= 32'h0;
        end    
        else if(start_pos)begin  
            sum <= 16'h4500 + 16'h0032 + 16'h0000 + {3'h2,13'h000}+ 16'h4011;
        end  
        else
            sum <= sum;
            
    end //always end
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            check_sum <= 16'h00;
        end  
        else if(state_c==ST_PREAMBLE)begin  
            check_sum <= ~(sum[31:16] + sum[15:0]);
        end  
        else begin  
            check_sum <= check_sum;
        end  
    end //always end
    
    
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            start_0 <= 1'b0;
            start_1 <= 1'b0;        
        end  
        else begin  
            start_0 <= tx_start_en;
            start_1 <= start_0;
        end  
    end //always end
    assign start_pos = start_0&&!start_1;
    
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            state_c <= ST_IDLE;
        end  
        else begin  
            state_c <= state_n;
        end  
    end //always end
    
    always @(*)begin 
        case(state_c)
            ST_IDLE      :begin
                if(st_idle2st_check_sum)
                    state_n = ST_CHECK_SUM;
                else
                    state_n = state_c;
            end
            ST_CHECK_SUM :begin
                if(st_check2st_preamble)
                    state_n = ST_PREAMBLE;
                else
                    state_n = state_c;
            end
            ST_PREAMBLE  :begin
                if(st_preamble2st_eth_head)
                    state_n = ST_ETH_HEAD;
                else
                    state_n = state_c;
            end
            ST_ETH_HEAD  :begin
                if(st_eth2st_ip_head)
                    state_n =ST_IP_HEAD ;
                else
                    state_n = state_c;
            end
            ST_IP_HEAD   :begin
                if(st_ip_head2st_udp_head)
                    state_n = ST_UDP_HEAD;
                else
                    state_n = state_c;
            end
            ST_UDP_HEAD :begin 
                if(st_udp_head2st_tx_data)
                    state_n=ST_TX_DATA;
                else
                    state_n=state_c;
            end
            ST_TX_DATA   :begin
                if(st_tx_data2st_crc)
                    state_n = ST_CRC;
                else
                    state_n = state_c;
            end
            ST_CRC       :begin
                if(st_crc2st_idle)
                    state_n = ST_IDLE;
                else
                    state_n = state_c;
            end
            default:state_n = ST_IDLE;
        endcase
    end //always end
   assign st_idle2st_check_sum     = state_c==ST_IDLE       &&  start_pos;
   assign st_check2st_preamble     = state_c==ST_CHECK_SUM  &&  (byte_cnt >= byte_num);
   assign st_preamble2st_eth_head  = state_c==ST_PREAMBLE   &&  (byte_cnt >= byte_num) ;
   assign st_eth2st_ip_head        = state_c==ST_ETH_HEAD   &&  (byte_cnt >= byte_num) ;
   assign st_ip_head2st_udp_head   = state_c==ST_IP_HEAD    &&  (byte_cnt >= byte_num) ;
   assign st_udp_head2st_tx_data   = state_c== ST_UDP_HEAD  &&  (byte_cnt >= byte_num) ;
   assign st_tx_data2st_crc        = state_c==ST_TX_DATA    &&  (tx_byte_cnt>=tx_byte_num-2)&&(byte_cnt >=byte_num );
   assign st_crc2st_idle           = state_c==ST_CRC        &&  (byte_cnt >= byte_num);
///////////////////////////////////////////////////////////////////
`ifdef MII
        always @(posedge clk or negedge rst_n)begin 
            if(!rst_n)begin  
                byte_num <= 16'd0;
            end  
            else if(state_n== ST_CHECK_SUM)begin  
                byte_num <= 16'd1;
            end  
            else if(state_n==ST_PREAMBLE||state_n==ST_UDP_HEAD)begin  
                byte_num <= 16'd15;
            end  
            else if(state_n==ST_ETH_HEAD )begin  
                byte_num <= 16'd27;
            end  
            else if(state_n==ST_IP_HEAD )begin  
                byte_num <= 16'd39;
            end 
            else if(state_n==ST_TX_DATA )begin  
                byte_num <= 16'd1;
            end 
            else if(state_n==ST_CRC )
                byte_num <= 16'd8;  
        end //always end
`else
    always @(posedge clk or negedge rst_n)begin 
            if(!rst_n)begin  
                byte_num <= 16'd0;
            end  
            else if(state_n== ST_CHECK_SUM)begin  
                byte_num <= 16'd1;
            end  
            else if(state_n==ST_PREAMBLE||state_n==ST_UDP_HEAD)begin  
                byte_num <= 16'd7;
            end  
            else if(state_n==ST_ETH_HEAD )begin  
                byte_num <= 16'd13;
            end  
            else if(state_n==ST_IP_HEAD )begin  
                byte_num <= 16'd19;
            end 
            else if(state_n==ST_TX_DATA )begin  
                byte_num <= 16'd0;
            end
            else if(state_n==ST_CRC )
                byte_num <= 16'd4;    
        end //always end
`endif
////////////////////////////////////////////////////////////////////////////////////  
        
        
        always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            byte_cnt <=16'd0;
        end 
        else if(byte_cnt>=byte_num||state_c==ST_IDLE||st_tx_data2st_crc)begin  
             byte_cnt <=16'd0;
        end  
        else begin  
             byte_cnt <= byte_cnt + 1'd1;
        end 
    end //always end
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            tx_byte_cnt <= 16'd0;
        end  
        else if(state_c==ST_TX_DATA&&byte_cnt>=byte_num)begin  
            tx_byte_cnt <= tx_byte_cnt +1'd1;
        end  
        else
            tx_byte_cnt <= tx_byte_cnt ;
    end //always end
    

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            eth_dout <= {`ETH_OUTPUT_WIDTH{1'b0}};
        end   
        else if(state_c==ST_PREAMBLE)begin
                eth_dout <= PREAMBLE[63 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end
        else if(state_c==ST_ETH_HEAD)begin
                eth_dout <= ETH_HEAD[111 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end        
        else if(state_c==ST_IP_HEAD)begin
                eth_dout <= ip_head[159 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end 
        else if(state_c==ST_UDP_HEAD)begin
                eth_dout <= udp_head[63 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end
        else if(state_c==ST_TX_DATA)begin
                eth_dout <= tx_data[7 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end
        else if(state_c==ST_CRC)begin
                eth_dout <= crc_data[31 - (`ETH_OUTPUT_WIDTH*byte_cnt)-:`ETH_OUTPUT_WIDTH];
        end

    end //always end
    always@(posedge clk or negedge  rst_n )begin
        if(!rst_n )
            eth_tx_en <=1'b0;
        else if(state_c ==ST_PREAMBLE )
            eth_tx_en <= 1'b1;
        else if(tx_done)
            eth_tx_en <=1'b0;
    end
    assign tx_done = st_crc2st_idle;
    
    assign crc_en=(state_c==ST_ETH_HEAD||state_c==ST_IP_HEAD||state_c==ST_UDP_HEAD)?1'b1:1'b0;
    assign crc_clr = (state_c==ST_IDLE)?1'b1:1'b0;
    assign tx_req = (state_n==ST_TX_DATA)&&tx_byte_cnt>=0&&byte_cnt>=byte_num;
    assign eth_tx_data  = eth_tx_en ?eth_dout : 1'hz;
endmodule 