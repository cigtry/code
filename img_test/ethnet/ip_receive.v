
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

module ip_receive #( parameter  BOARD_MAC   = 48'h00_11_22_33_44_55,//开发板mac地址
                BOARD_IP    = {8'd192,8'd168,8'd1,8'd123},//开发板ip地址
                DES_MAC     = 48'hff_ff_ff_ff_ff_ff,//目标MAC地址
                DES_IP      = {8'd192,8'd168,8'd1,8'd102}//目标IP地址
        )
    (
        input           clk            ,
        input           rst_n          ,
        input           eth_rxdv       ,
        input   [`ETH_INPUT_WIDTH-1:0]   eth_rx_data    ,
        output          rec_pkt_done   ,
        output          rec_en         ,
        output  [7:0]  rec_data       ,
        output  [15:0]  rec_byte_num  
    );
//Parameter Declarations
    parameter       ST_IDLE     =7'b000_0001,
                    ST_PREAMBLE =7'b000_0010,
                    ST_ETH_HEAD =7'b000_0100,
                    ST_IP_HEAD  =7'b000_1000,
                    ST_UDP_HEAD =7'b001_0000,
                    ST_RX_DATA  =7'b010_0000,
                    ST_RX_END   =7'b100_0000;
    reg     [6:0]   state_c,state_n; 
    wire            st_idle2sr_preamble     ;
    wire            st_preamble2st_eth_head ;
    wire            st_eth2st_ip_head       ;
    wire            st_ip_head2st_udp_head  ;
    wire            st_udp_head2st_rx_data  ;
    wire            st_rx_data2st_rx_end    ;
    wire            st_rx_end2st_idle       ;

    parameter   data_total_len = 16'd22;//实际数据是它的一半 mii 3:0   gmii 7:0 如果是gmii就是16'd11 
    wire    [15:0]      ip_total_len;
    wire    [15:0]      udp_total_len;
    assign  ip_total_len = data_total_len + 16'd28;
    assign  udp_total_len = data_total_len + 16'd8;

    localparam  PREAMBLE= 64'h55_55_55_55_55_55_55_d5;
    localparam  ETH_HEAD = {DES_MAC,BOARD_MAC,16'h0800};
    reg [111:0] IP_HEAD ;//{4'h4,4'h5,8'h0,ip_total_len,16'h0,16'h0,8'h04,8'h11,16'h0689,BOARD_IP,DES_IP};
    reg [63:0] UDP_HEAD ;
    

    reg                 error_en;
    reg     [63:0]      preamble;
    reg     [111:0]     eth_head;
    reg     [159:0]     ip_head ;
    reg     [63:0]      udp_head;
    reg     [7:0]      rx_data ;
    reg     [15:0]      byte_cnt; 
    reg     [15:0]      byte_num;
    reg     [3:0]       data;
    reg     [15:0]      rec_byte_cnt;
    reg                 rx_valid;

    


//Logic Description
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            rx_valid <= 1'b0;
        end    
        else begin  
            rx_valid <= eth_rxdv;
        end  
    end //always end
    
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin  
        data <= 4'h0;
    end  
    else begin  
        data <= eth_rx_data;
    end  
end //always end
   always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            error_en  <= 1'b0;
        else if((state_c== ST_ETH_HEAD&&preamble!=PREAMBLE) ||(state_c== ST_IP_HEAD&&eth_head!=ETH_HEAD) ||(state_c== ST_UDP_HEAD&&ip_head!= IP_HEAD ) )
            error_en  <= 1'b1;
    end
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            IP_HEAD <=120'h0;
            UDP_HEAD <= 64'h0;
        end
        else begin
            IP_HEAD <= {4'h4,4'h5,8'h0,ip_total_len,
            16'h0,16'h0,8'h04,8'h11,16'h0689,BOARD_IP,DES_IP};
            UDP_HEAD <= {16'h5000,16'h6000,udp_total_len};
        end   
    end //always end
    
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
            ST_IDLE     :begin 
                if(st_idle2sr_preamble)
                    state_n=ST_PREAMBLE;
                else
                    state_n=state_c;
            end
            ST_PREAMBLE :begin 
                if(st_preamble2st_eth_head)
                    state_n=ST_ETH_HEAD;
                else if(error_en)
                    state_n=ST_RX_END;
                else
                    state_n=state_c;
            end
            ST_ETH_HEAD :begin 
                if(st_eth2st_ip_head)
                    state_n=ST_IP_HEAD;
                else if(error_en)
                    state_n=ST_RX_END;
                else
                    state_n=state_c;
            end
            ST_IP_HEAD  :begin 
                if(st_ip_head2st_udp_head)
                    state_n=ST_UDP_HEAD;
                else if(error_en)
                    state_n=ST_RX_END;
                else
                    state_n=state_c;
            end
            ST_UDP_HEAD :begin 
                if(st_udp_head2st_rx_data)
                    state_n=ST_RX_DATA;
                else
                    state_n=state_c;
            end
            ST_RX_DATA  :begin 
                if(st_rx_data2st_rx_end)
                    state_n=ST_RX_END;
                else
                    state_n=state_c;
            end
            ST_RX_END   :begin 
                if(st_rx_end2st_idle)
                    state_n=ST_IDLE;
                else
                    state_n=state_c;
            end
            default:state_n=ST_IDLE;  
        endcase
    end //always end
    assign      st_idle2sr_preamble     = state_c== ST_IDLE     && eth_rx_data==4'h5;
    assign      st_preamble2st_eth_head = state_c== ST_PREAMBLE && (byte_cnt>=byte_num/*&&preamble==PREAMBLE*/);
    assign      st_eth2st_ip_head       = state_c== ST_ETH_HEAD && (byte_cnt>=byte_num/*&&eth_head==ETH_HEAD*/);
    assign      st_ip_head2st_udp_head  = state_c== ST_IP_HEAD  && (byte_cnt>=byte_num/*&&ip_head== IP_HEAD*/);
    assign      st_udp_head2st_rx_data  = state_c== ST_UDP_HEAD && (byte_cnt>=byte_num/*&&udp_head== UDP_HEAD*/);
    assign      st_rx_data2st_rx_end    = state_c== ST_RX_DATA  && (byte_cnt>=byte_num)&&(rec_byte_cnt>=rec_byte_num);
    assign      st_rx_end2st_idle       = state_c== ST_RX_END   && (!eth_rxdv);
///////////////////////////////////////////////////////////////////
`ifdef MII
        always @(posedge clk or negedge rst_n)begin 
            if(!rst_n)begin  
                byte_num <= 16'd256;
            end  
            else if(state_n==ST_PREAMBLE)begin  
                byte_num <= 16'd15;
            end  
            else if(state_n==ST_ETH_HEAD )begin  
                byte_num <= 16'd27;
            end  
            else if(state_n==ST_IP_HEAD )begin  
                byte_num <= 16'd39;
            end 
            else if(state_n==ST_UDP_HEAD )begin  
                byte_num <= 16'd15;
            end  
            else if(state_n==ST_RX_DATA )begin  
                byte_num <= 16'd1;
            end 
        end //always end
`else
    always @(posedge clk or negedge rst_n)begin 
            if(!rst_n)begin  
                byte_num <= 16'd256;
            end  
            else if(state_n==ST_PREAMBLE)begin  
                byte_num <= 16'd8;
            end  
            else if(state_n==ST_ETH_HEAD )begin  
                byte_num <= 16'd13;
            end  
            else if(state_n==ST_IP_HEAD )begin  
                byte_num <= 16'd19;
            end 
            else if(state_n==ST_UDP_HEAD )begin  
                byte_num <= 16'd7;
            end
            else if(state_n==byte_num )begin  
                byte_num <= 16'd0;
            end 
        end //always end
`endif
////////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            byte_cnt <=16'd0;
        end  
        else if(state_c==ST_IDLE||(byte_cnt>=byte_num))begin  
             byte_cnt <=16'd0;
        end  
        else if(rx_valid)begin  
             byte_cnt <= byte_cnt + 1'd1;
        end 
        else
            byte_cnt <= byte_cnt; 
    end //always end
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            rec_byte_cnt<=16'd0;
        end  
        else if((rec_byte_cnt>=rec_byte_num)&&(byte_cnt>=byte_num))begin  
            rec_byte_cnt<=16'd0;
        end  
        else if(state_n==ST_RX_DATA&&(byte_cnt>=byte_num))begin  
            rec_byte_cnt<=rec_byte_cnt + 1'd1;
        end  
    end //always end
    

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            preamble<= 64'h0;
            eth_head<= 112'h0;
            ip_head <= 160'h0;
            udp_head<= 64'h0;
            rx_data <= 32'h0;
        end   
        else begin  
            case(state_c)
                ST_IDLE     :begin
                end
                ST_PREAMBLE :begin
                    preamble[(63-((`ETH_INPUT_WIDTH)*byte_cnt))-:(`ETH_INPUT_WIDTH)] <= data;
                end
                ST_ETH_HEAD :begin
                    eth_head[(111-((`ETH_INPUT_WIDTH)*byte_cnt))-:(`ETH_INPUT_WIDTH)] <= data;
                end
                ST_IP_HEAD  :begin
                    ip_head[(159-((`ETH_INPUT_WIDTH)*byte_cnt))-:(`ETH_INPUT_WIDTH)] <= data;
                end
                ST_UDP_HEAD :begin
                    udp_head[(63-((`ETH_INPUT_WIDTH)*byte_cnt))-:(`ETH_INPUT_WIDTH)] <= data;
                end
                ST_RX_DATA  :begin
                    rx_data[(7-((`ETH_INPUT_WIDTH)*byte_cnt))-:(`ETH_INPUT_WIDTH)] <= data;
                end
                ST_RX_END   :begin
                    preamble<= 64'h0;
                    eth_head<= 112'h0;
                    ip_head <= 160'h0;
                    udp_head<= 64'h0;
                    rx_data <= 32'h0;
                end
                default:;
            endcase
        end  
    end //always end
    
    assign rec_data   = ((state_c==ST_RX_DATA) &&(rec_byte_cnt >1)&&(byte_cnt==0))?rx_data:rec_data;
    assign rec_byte_num  =state_c ==ST_UDP_HEAD ?(ip_head[143:128]-16'd28+1'd1):rec_byte_num;
    assign rec_pkt_done =st_rx_end2st_idle;
    assign rec_en = ((state_c==ST_RX_DATA)&&(rec_byte_cnt >1)&&(byte_cnt==0));

endmodule 