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
module m_axi_rd#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )
(
  input  wire                                      clk             ,
  input  wire                                      rst_n           ,
//锟矫伙拷锟接匡拷
  input  wire                                      rd_start        ,
  input  wire      [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr         ,
  output wire      [C_M_AXI_DATA_WIDTH-1: 0]       rd_data         ,
  input  wire      [  07:00]                       rd_len          ,
  output wire                                      rd_done         ,
  output wire                                      rd_vld          ,
  //AXI锟斤拷锟斤拷址通锟斤拷
  output wire      [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_arid        ,
  output reg       [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_araddr      ,
  output wire      [  07:00]                       axi_arlen       ,
  output wire      [  02:00]                       axi_arsize      ,
  output wire      [  01:00]                       axi_arburst     ,
  output wire                                      axi_arlock      ,
  output wire      [  03:00]                       axi_arcache     ,
  output wire      [  02:00]                       axi_arprot      ,
  output wire      [  03:00]                       axi_arqos       ,
  output wire      [C_M_AXI_AWUSER_WIDTH-1:00]     axi_aruser      ,
  output reg                                       axi_arvalid     ,
  input  wire                                      axi_arready     ,
//AXI锟斤拷锟斤拷锟斤拷通锟斤拷
  input  wire      [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_rid         ,
  input  wire      [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_rdata       ,
  input  wire      [C_M_AXI_DATA_WIDTH/8-1:00]     axi_rresp       ,
  input  wire                                      axi_rlast       ,
  input  wire      [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_ruser       ,
  input  wire                                      axi_rvalid      ,
  output reg                                       axi_rready       

);
  function integer clogb2 (input integer bit_depth);
  begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction
  assign                                             axi_arid       = 1'b0;
  assign                                             axi_arlen      = rd_len - 1;
  assign                                             axi_arsize     = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
  assign                                             axi_arburst    = 2'b01;
  assign                                             axi_arlock     = 1'b0;
  assign                                             axi_arcache    = 4'b0010;
  assign                                             axi_arprot     = 3'h0;
  assign                                             axi_arqos      = 4'h0;
  assign                                             axi_aruser     = 1'b1;
  assign                                             rd_done        = axi_rlast;
  parameter                                          IDLE           = 2'd0  ,
            R_ADDR  = 2'd1,
            R_DATA  = 2'd2;
  reg              [  01:00]                       state_c,state_n  ;
  reg              [  07:00]                       rd_index        ;

  wire                                             axi_ar_handok   ;
  wire                                             axi_r_handok    ;
  assign                                             axi_ar_handok  = axi_arvalid && axi_arready;
  assign                                             axi_r_handok   = axi_rvalid && axi_rready;

  always @(posedge clk ) begin
    if(!rst_n)begin
      state_c <= IDLE;
    end
    else begin
      state_c <= state_n;
    end
  end

  always @(*) begin
    case(state_c)
      IDLE   :begin
        if(rd_start)
          state_n = R_ADDR;
        else
          state_n = state_c;
      end
      R_ADDR :begin
        if(axi_ar_handok)
          state_n = R_DATA;
        else
          state_n = state_c;
      end
      R_DATA :begin
        if(rd_done)
          state_n = IDLE;
        else
          state_n = state_c;
      end
      default: state_n = IDLE;
    endcase
  end
  
  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_araddr <= {C_M_AXI_ADDR_WIDTH{1'b0}};
    end
    else if(rd_start)begin
      axi_araddr <= rd_addr;
    end
    else begin
      axi_araddr <= axi_araddr;
    end
  end                                                               //always end

  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_arvalid <= 1'b0;
    end
    else if (axi_ar_handok ) begin
      axi_arvalid <= 1'b0;
    end
    else if(!axi_arvalid && rd_start)begin
      axi_arvalid <= 1'b1;
    end
    else begin
      axi_arvalid <= axi_arvalid;
    end
  end                                                               //always end
  
  always @ (posedge clk  )begin
    if(!rst_n)begin
      axi_rready <= 1'b0;
    end
    else if(state_n == R_DATA)begin
      axi_rready <= 1'b1;
    end
    else begin
      axi_rready <= 1'b0;
    end
  end                                                               //always end
  
  
  always @ (posedge clk  )begin
    if(!rst_n)begin
      rd_index <= 8'd0;
    end
    else if(rd_start || rd_done)begin
      rd_index <= 8'd0;
    end
    else if((state_n == R_DATA ) &&axi_r_handok  )begin
      rd_index <= rd_index +1'd1;
    end
    else begin
      rd_index <= rd_index;
    end
  end                                                               //always end

  
  assign   rd_data = axi_r_handok ? axi_rdata : 32'h0;
  assign   rd_vld =  axi_r_handok ;
endmodule