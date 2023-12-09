`timescale 1ns / 1ps
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
module pulse_sync_pro(
    input            clk    , //system clock 50MHz
    input             rst_n  , //reset, low valid
    
    input                   pulse_a ,
    input                   clk_b,
    output                  pulse_b
);
    reg         pulse_inv;
    reg         pulse_inv_d0;
    reg         pulse_inv_d1;
    reg         pulse_inv_d2;

    assign  pulse_b = pulse_inv_d1^pulse_inv_d2;

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)begin  
            pulse_inv <= 1'b0;
        end  
        else if(pulse_a)begin  
            pulse_inv <= !pulse_inv;
        end  
        else begin  
            pulse_inv <= pulse_inv;
        end  
    end //always end

    always @(posedge clk_b or negedge rst_n)begin 
        if(!rst_n)begin  
            pulse_inv_d0 <= 1'd0;
            pulse_inv_d1 <= 1'd0;
            pulse_inv_d2 <= 1'd0;
        end  
        else begin  
            pulse_inv_d0 <= pulse_inv; 
            pulse_inv_d1 <= pulse_inv_d0;
            pulse_inv_d2 <= pulse_inv_d1;
        end  
    end //always end
    
    


endmodule 