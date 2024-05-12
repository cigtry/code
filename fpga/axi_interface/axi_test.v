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
module axi_test#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input  wire                                      clk             ,//system clock 
  input  wire                                      rst_n           ,//reset, low valid

  input  wire                                      start           ,
  //AXIд��ַͨ��
  output wire      [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_awid        ,//д��ַͨ��id
  output wire      [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_awaddr      ,//д��ַ
  output wire      [  07:00]                       axi_awlen       ,//ͻ������
  output wire      [  02:00]                       axi_awsize      ,//ͻ���ߴ�
  output wire      [  01:00]                       axi_awburst     ,//ͻ������
  output wire                                      axi_awlock      ,//������
  output wire      [  03:00]                       axi_awcache     ,//��������
  output wire      [  02:00]                       axi_awprot      ,//��������
  output wire      [  03:00]                       axi_awqos       ,//Qos��ʶ��
  output wire      [C_M_AXI_AWUSER_WIDTH-1:00]     axi_awuser      ,//�û��Զ���
  output wire                                      axi_awvalid     ,//д��ַ��Ч
  input  wire                                      axi_awready     ,//�ӻ�׼���ý��յ�ַ
//AXIд����ͨ��
  output wire      [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_wdata       ,//д����
  output wire      [C_M_AXI_DATA_WIDTH/8-1:00]     axi_wstrb       ,//���ݶ���Ч
  output wire                                      axi_wlast       ,//ͻ����������һ��
  output wire      [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_wuser       ,//�û��Զ���
  output wire                                      axi_wvalid      ,//д������Ч
  input  wire                                      axi_wready      ,//�ӻ�׼���ý�������
//AXI��Ӧͨ��
  input  wire      [C_M_AXI_ID_WIDTH     -1 : 00]  axi_bid         ,//��ӦID
  input  wire      [  01:00]                       axi_bresp       ,//д��Ӧ
  input  wire      [C_M_AXI_BUSER_WIDTH - 1 : 00]  axi_buser       ,//�û��Զ���
  input  wire                                      axi_bvalid      ,//д��Ӧ��Ч
  output wire                                      axi_bready      ,//д��Ӧ��Ч�źţ���ʾ�����Ѿ�׼���ý���д��Ӧ�ź��ˣ�
//AXI����ַͨ��
  output wire      [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_arid        ,//����ַͨ��id
  output wire      [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_araddr      ,//����ַ
  output wire      [  07:00]                       axi_arlen       ,//ͻ������
  output wire      [  02:00]                       axi_arsize      ,//ͻ���ߴ�
  output wire      [  01:00]                       axi_arburst     ,//ͻ������
  output wire                                      axi_arlock      ,//������
  output wire      [  03:00]                       axi_arcache     ,//��������
  output wire      [  02:00]                       axi_arprot      ,//��������
  output wire      [  03:00]                       axi_arqos       ,//Qos��ʶ��
  output wire      [C_M_AXI_AWUSER_WIDTH-1:00]     axi_aruser      ,//�û��Զ���
  output wire                                      axi_arvalid     ,//����ַ��Ч
  input  wire                                      axi_arready     ,//�ӻ�׼���ý��յ�ַ
//AXI������ͨ��
  input  wire      [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_rid         ,//��ͨ��id
  input  wire      [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_rdata       ,//д����
  input  wire      [C_M_AXI_DATA_WIDTH/8-1:00]     axi_rresp       ,//���ݶ���Ч
  input  wire                                      axi_rlast       ,//ͻ����������һ��
  input  wire      [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_ruser       ,//�û��Զ���
  input  wire                                      axi_rvalid      ,//д������Ч
  output wire                                      axi_rready       //�ӻ�׼���ý�������

);
  reg                                              start_d         ;
  reg                                              rd_start        ;
  reg              [  31:00]                       rd_addr         ;
  wire             [  31:00]                       rd_data         ;
  wire             [  07:00]                       rd_len          ;
  wire                                             rd_done         ;
  wire                                             rd_vld          ;
  reg                                              wr_start        ;
  reg              [  31:00]                       wr_addr         ;
  reg              [  31:00]                       wr_data         ;
  wire             [  07:00]                       wr_len          ;
  wire                                             wr_ready        ;
  wire                                             wr_done         ;
  assign                                             wr_len         = 16;
  assign                                             rd_len         = 16;
    always @(posedge clk ) begin
      start_d <= start;
    end
  wire                                             pos_start       ;
  assign                                             pos_start      = start && !start_d;

  parameter                                          IDLE           = 2'd0  ;
  parameter                                          WRITE          = 2'd1  ;
  parameter                                          READ           = 2'd2  ;
  parameter                                          WAIT           = 2'd3  ;
  reg              [  01:00]                       state_c,state_n  ;
  


    always @ (posedge clk or negedge rst_n)begin
      if(!rst_n)begin
        state_c <= IDLE;
      end
      else begin
        state_c <= state_n;
      end
    end                                                             //always end

    always @(*) begin
      case(state_c)
        IDLE  : begin
          if(pos_start)
            state_n = WRITE;
          else
            state_n = state_c;
        end
        WRITE : begin
          if(wr_done)
            state_n = READ;
          else
            state_n = state_c;
        end
        READ  : begin
          if(rd_done)
            state_n = WAIT;
          else
            state_n = state_c;
        end
        WAIT : begin
          state_n = WRITE;
        end
      default : state_n = IDLE;
      endcase
    end
    
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      wr_start <= 'd0;
    end
    else if(pos_start)begin
       wr_start <= 'd1;
    end
    else begin
      wr_start <= 'd0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      wr_addr <= 32'h0;
    end
    else if(pos_start)begin
      wr_addr <= 32'h0100_0000;
    end
    else if(wr_done)begin
      wr_addr <= wr_addr + wr_len;
    end
    else begin
       wr_addr <= wr_addr;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      wr_data <= 32'b0;
    end
    else if((state_n ==WRITE) && wr_ready)begin
      wr_data <= wr_data +1'b1;
    end
    else begin
      wr_data <= wr_data;
    end
  end                                                               //always end
  
  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      rd_start <= 'd0;
    end
    else if(wr_done)begin
       rd_start <= 'd1;
    end
    else begin
      rd_start <= 'd0;
    end
  end                                                               //always end

  always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      rd_addr <= 32'h0;
    end
    else if(pos_start)begin
      rd_addr <= 32'h0100_0000;
    end
    else if(rd_done)begin
      rd_addr <= rd_addr + wr_len;
    end
    else begin
       rd_addr <= rd_addr;
    end
  end                                                               //always end
  
    
m_axi_ctrl#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
inst_m_axi_ctrl(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  //�û��ӿ�
  .rd_start                                          (rd_start       ),
  .rd_addr                                           (rd_addr        ),
  .rd_data                                           (rd_data        ),
  .rd_len                                            (rd_len         ),
  .rd_done                                           (rd_done        ),
  .rd_vld                                            (rd_vld         ),
  //�û��ӿ�
  .wr_start                                          (wr_start       ),
  .wr_addr                                           (wr_addr        ),
  .wr_len                                            (wr_len         ),
  .wr_data                                           (wr_data        ),
  .wr_ready                                          (wr_ready       ),
  .wr_done                                           (wr_done        ),
  //AXI����ַͨ��
  .axi_arid                                          (axi_arid       ),
  .axi_araddr                                        (axi_araddr     ),
  .axi_arlen                                         (axi_arlen      ),
  .axi_arsize                                        (axi_arsize     ),
  .axi_arburst                                       (axi_arburst    ),
  .axi_arlock                                        (axi_arlock     ),
  .axi_arcache                                       (axi_arcache    ),
  .axi_arprot                                        (axi_arprot     ),
  .axi_arqos                                         (axi_arqos      ),
  .axi_aruser                                        (axi_aruser     ),
  .axi_arvalid                                       (axi_arvalid    ),
  .axi_arready                                       (axi_arready    ),
//AXI������ͨ��
  .axi_rid                                           (axi_rid        ),
  .axi_rdata                                         (axi_rdata      ),
  .axi_rresp                                         (axi_rresp      ),
  .axi_rlast                                         (axi_rlast      ),
  .axi_ruser                                         (axi_ruser      ),
  .axi_rvalid                                        (axi_rvalid     ),
  .axi_rready                                        (axi_rready     ),
//AXIд��ַͨ��
  .axi_awid                                          (axi_awid       ),
  .axi_awaddr                                        (axi_awaddr     ),
  .axi_awlen                                         (axi_awlen      ),
  .axi_awsize                                        (axi_awsize     ),
  .axi_awburst                                       (axi_awburst    ),
  .axi_awlock                                        (axi_awlock     ),
  .axi_awcache                                       (axi_awcache    ),
  .axi_awprot                                        (axi_awprot     ),
  .axi_awqos                                         (axi_awqos      ),
  .axi_awuser                                        (axi_awuser     ),
  .axi_awvalid                                       (axi_awvalid    ),
  .axi_awready                                       (axi_awready    ),
//AXIд����ͨ��
  .axi_wdata                                         (axi_wdata      ),
  .axi_wstrb                                         (axi_wstrb      ),
  .axi_wlast                                         (axi_wlast      ),
  .axi_wuser                                         (axi_wuser      ),
  .axi_wvalid                                        (axi_wvalid     ),
  .axi_wready                                        (axi_wready     ),
//AXI��Ӧͨ��
  .axi_bid                                           (axi_bid        ),
  .axi_bresp                                         (axi_bresp      ),
  .axi_buser                                         (axi_buser      ),
  .axi_bvalid                                        (axi_bvalid     ),
  .axi_bready                                        (axi_bready     ) 
);


endmodule

