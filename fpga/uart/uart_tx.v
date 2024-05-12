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
////////////////////////////////////////////////////////////////+
module uart_tx#(
    parameter   BAUD_9600   =   5208,
                BAUD_19200  =   2604,
                BAUD_38400  =   1302,
                BAUD_57600  =   868,
                BAUD_115200 =   434
)(
    input  					clk		, //system clock 50MHz
    input  			 		rst_n	, //reset, low valid
    input     [2:0]         baud_sel,
    input     [7:0]         tx_data,
    input                   tx_req,
    output   reg            tx_busy,
    output   reg            uart_tx,
    output                  uart_tx_end     
);
    reg     [12:0]      baud;
    reg     [12:0]      cnt_baud;
    wire                add_cnt_baud;
    wire                end_cnt_baud;

    reg     [3:0]       cnt_bit;
    wire                add_cnt_bit;
    wire                end_cnt_bit;


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

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            tx_busy <= 1'b0;
        end  
        else if(tx_req && !tx_busy)begin  
            tx_busy <= 1'b1;
        end  
        else if(end_cnt_bit)begin  
            tx_busy <= 1'b0;
        end
        else
            tx_busy <= tx_busy;  
    end //always end
    

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
    assign  add_cnt_baud = tx_busy;
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
    assign  add_cnt_bit = tx_busy & end_cnt_baud;
    assign  end_cnt_bit = add_cnt_bit & cnt_bit >= 9;
    
    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            uart_tx <= 1'b1;
        end  
        else if(tx_busy)begin  
            case(cnt_bit)
                0 : uart_tx <= 1'b0;
                1 : uart_tx <= tx_data[0];
                2 : uart_tx <= tx_data[1];
                3 : uart_tx <= tx_data[2];
                4 : uart_tx <= tx_data[3];
                5 : uart_tx <= tx_data[4];
                6 : uart_tx <= tx_data[5];
                7 : uart_tx <= tx_data[6];
                8 : uart_tx <= tx_data[7];
                9 : uart_tx <= 1'b1;
                default:uart_tx <= uart_tx;
            endcase
        end  
        else begin  
            uart_tx <= 1'b1;
        end  
    end //always end
    assign uart_tx_end = end_cnt_bit;

endmodule 