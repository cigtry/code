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
//Revisoion			:					
//Additional Comments	:					
//
////////////////////////////////////////////////////////////////
module uart_rx#(
    parameter   BAUD_9600   =   5208,
                BAUD_19200  =   2604,
                BAUD_38400  =   1302,
                BAUD_57600  =   868,
                BAUD_115200 =   434
)(
    input               clk,
    input               rst_n,
    input               uart_rx,
    input   [2:0]       baud_sel,
    output  [7:0]       rx_din,
    output              rx_vld   
);
    reg                 rx_r1,rx_r2;//打两拍，检测rx的下降沿
    wire                rx_neg;
    
    reg     [12:0]      baud;
    reg     [12:0]      cnt_baud;
    wire                add_cnt_baud;
    wire                end_cnt_baud;

    reg     [3:0]       cnt_bit;
    wire                add_cnt_bit;
    wire                end_cnt_bit;

    reg                 rx_busy;//检测到下降沿后进入接收阶段
    reg     [7:0]       rx_data;

//  
    
    always @(posedge clk or negedge rst_n)begin //打两拍，检测下降沿
        if(!rst_n)begin  
            rx_r1 <= 1'b0;
            rx_r2 <= 1'b0;    
        end    
        else begin  
            rx_r1 <= uart_rx;
            rx_r2 <= rx_r1;
        end  
    end
    assign rx_neg = ~rx_r1 & rx_r2;

    always @(*)begin //选择波特率
        case(baud_sel)
        0 : baud = BAUD_9600;
        1 : baud = BAUD_19200;
        2 : baud = BAUD_38400;
        3 : baud = BAUD_57600;
        4 : baud = BAUD_115200;
        default: baud = BAUD_9600;
        endcase
    end
    
    always @(posedge clk or negedge rst_n)begin//检测到下降沿后进入接受数据的状态 
        if(!rst_n)begin  
            rx_busy <= 1'b0;    
        end  
        else if(rx_neg)begin  
            rx_busy <=1'b1;    
        end  
        else if(rx_vld)begin  
            rx_busy <=1'b0;
        end
    end 

    always @(posedge clk or negedge rst_n)begin //波特率计数
        if(!rst_n)begin  
            cnt_baud <=13'd0;        
        end  
        else if(add_cnt_baud)begin  
            if(end_cnt_baud)
                cnt_baud <= 13'd0;
            else
                cnt_baud <= cnt_baud + 1'b1;
        end  
        else begin  
            cnt_baud <= cnt_baud;
        end  
    end
    assign  add_cnt_baud = rx_busy;
    assign  end_cnt_baud = add_cnt_baud & cnt_baud >= baud -1'd1;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
        cnt_bit <= 4'b0;    
        end  
        else if(add_cnt_bit)begin  
            if(end_cnt_bit)
                cnt_bit <= 4'b0;
            else
                cnt_bit <= cnt_bit + 1'b1;
        end  
        else begin  
            cnt_bit <= cnt_bit;
        end  
    end 
    assign  add_cnt_bit = rx_busy & end_cnt_baud;
    assign  end_cnt_bit = add_cnt_bit & cnt_bit >= 9;
    
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            rx_data <=8'b0;
        end  
        else begin  
            case(cnt_bit)
                1:if(cnt_baud==baud>>1) rx_data[0] <= uart_rx;//在1/2处采样
                2:if(cnt_baud==baud>>1) rx_data[1] <= uart_rx;
                3:if(cnt_baud==baud>>1) rx_data[2] <= uart_rx;
                4:if(cnt_baud==baud>>1) rx_data[3] <= uart_rx;
                5:if(cnt_baud==baud>>1) rx_data[4] <= uart_rx;
                6:if(cnt_baud==baud>>1) rx_data[5] <= uart_rx;
                7:if(cnt_baud==baud>>1) rx_data[6] <= uart_rx;
                8:if(cnt_baud==baud>>1) rx_data[7] <= uart_rx;
                default: rx_data <= rx_data;
            endcase
        end  
    end 
    
    assign rx_din = end_cnt_bit?rx_data:rx_din;
    assign rx_vld = end_cnt_bit;

endmodule