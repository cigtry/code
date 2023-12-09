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
module iic#(
  parameter IIC_PERIOD = 250,
  parameter IIC_ADDR_BYTE = 2//（寄存器地址有两个字节）
)(
  input   wire                   clk    , //system clock 50MHz
  input   wire                   rst_n  , //reset, low valid
  
  output  reg                    iic_scl,
  inout   wire                   iic_sda,

  input   wire     [6:0]         iic_slave_addr,//从机地址
  input   wire     [(8*IIC_ADDR_BYTE) - 1:0]  wr_address,//寄存器地址（分为多字节地址和单字节地址）
  
  input   wire                   write,
  input   wire     [7:0]         wr_data,
  output  wire                   wr_done,

  input   wire                   read,
  output  reg      [7:0]         rd_data,
  output  wire                   rd_done

);
//Parameter Declarations
  parameter   IDLE    = 8'b0000_0001,
              STRAT   = 8'b0000_0010,
              CONTRL  = 8'b0000_0100,
              ADDRESS = 8'b0000_1000,
              WRITE   = 8'b0001_0000,
              READ    = 8'b0010_0000,
              ACK     = 8'b0100_0000,
              STOP    = 8'b1000_0000;

//Internal wire/reg declarations
  reg      [7:0]   state_c,state_n;


  reg              sda_en,sda_out;

  reg      [15:0]  cnt_scl;
  reg      [3:0]   cnt_bit;
  reg      [1:0]   cnt_byte;
  reg              read_flag;
  reg              write_flag;
  reg      [7:0]   contrl_byte;
//Module instantiations , self-build module


//Logic Description

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      contrl_byte<=1'b0;
    else if(read_flag)
      contrl_byte <= {iic_slave_addr,1'b1};
    else 
      contrl_byte <= {iic_slave_addr,1'b0};
  end


  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      state_c <= IDLE;
    else
      state_c <= state_n;
  end

  always @(*) begin
    case(state_c)
      IDLE    :begin
        if(write||read)
          state_n = STRAT;
        else  
          state_n = state_c;
      end
      STRAT   :begin
        if(cnt_scl==(IIC_PERIOD-1'b1))
          state_n = CONTRL;
        else
          state_n = state_c;
      end
      CONTRL:begin
        if((cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1)))
            state_n = ACK;
          else
            state_n = state_c;
        end
      ADDRESS :begin
        if((cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1)))
          state_n = ACK;
        else  
          state_n = state_c;
      end
      WRITE   :begin
        if((cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1)))
          state_n = ACK;
        else  
          state_n = state_c;
      end
      READ    :begin
        if((cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1)))
          state_n = ACK;
        else  
          state_n = state_c;
      end
      ACK     :begin
        if(((cnt_scl==(IIC_PERIOD-1'b1))&&(write_flag||!(write | read)))/* ||(iic_sda) */)
          state_n = STOP;
        else if((cnt_byte==IIC_ADDR_BYTE )&&(cnt_scl==(IIC_PERIOD-1'b1))&&write/* &&(!iic_sda) */)
          state_n = WRITE;
        else if((cnt_byte==IIC_ADDR_BYTE )&&(cnt_scl==(IIC_PERIOD-1'b1))&&read&&(!read_flag)/* &&(!iic_sda) */)
          state_n = CONTRL;
        else if((cnt_scl==(IIC_PERIOD-1'b1))&&read_flag)
          state_n = READ;
        else if(cnt_scl==(IIC_PERIOD-1'b1)/* &&(!iic_sda) */)
          state_n = ADDRESS;
        else
          state_n = state_c;
      end
      STOP    :begin
        if((cnt_scl==(IIC_PERIOD-1'b1)))
          state_n = IDLE;
        else
          state_n = state_c;
      end
      default: state_n = IDLE;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      cnt_scl <= 16'd0;
    else if(state_c[0])begin
      cnt_scl <= 16'd0;
    end
    else if(cnt_scl==(IIC_PERIOD-1'b1))begin
      cnt_scl <= 16'd0;
    end
    else
      cnt_scl <= cnt_scl + 1'b1;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      cnt_bit <= 4'd0;
    else if(state_n!=state_c)
      cnt_bit <= 4'd0;
    else if(cnt_scl==(IIC_PERIOD-1'b1))
      cnt_bit <= cnt_bit + 1'b1;
    else
      cnt_bit <= cnt_bit;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      cnt_byte <= 2'd0;
    else if(state_c[0])
      cnt_byte <= 2'd0;
    else if((state_c[3])&&(cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1)))
      cnt_byte <= cnt_byte + 1'b1;
    else
      cnt_byte <= cnt_byte;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      read_flag <= 1'b0;
    else if(state_c[7])
      read_flag <= 1'b0;
    else if((cnt_byte==IIC_ADDR_BYTE - 1'b1)&&(cnt_bit==4'd7)&&(cnt_scl==(IIC_PERIOD-1'b1))&&read)
      read_flag <= 1'b1;
    else
      read_flag<=read_flag;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      write_flag <= 1'b0;
    else if(state_c[1])
      write_flag <= 1'b0;
    else if(state_c[4]&&(cnt_bit==4'd7)&&((cnt_scl==(IIC_PERIOD-1'b1))))
      write_flag <= 1'b1;
    else
      write_flag<=write_flag;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      iic_scl <= 1'b1;
    else if(state_c[0])
      iic_scl <= 1'b1;
    else if(state_c[1])begin
      if(cnt_scl<=((IIC_PERIOD>>1) + (IIC_PERIOD>>2) -1'b1))
        iic_scl <= 1'b1;
      else begin
        iic_scl <= 1'b0;
      end
    end
    else if(state_c[7])begin
       if(cnt_scl<=((IIC_PERIOD>>2) -1'b1))
        iic_scl <= 1'b0;
      else begin
        iic_scl <= 1'b1;
      end
    end
    else begin
      if((cnt_scl<=((IIC_PERIOD>>2)-'b1)) || (cnt_scl>=((IIC_PERIOD>>1) + (IIC_PERIOD>>2)-1'b1)))
        iic_scl <= 1'b0;
      else begin
        iic_scl <= 1'b1;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      sda_en <=1'b0;
      sda_out<=1'b1;
    end
    else begin
      case (state_n)
        IDLE    :begin
          sda_en <=1'b0;
          sda_out<=1'b1;
        end
        STRAT   :begin
          sda_en<=1'b1;
          if(cnt_scl == 1'b0)
            sda_out <= 1'b1;
          else if(cnt_scl == (IIC_PERIOD >> 1) )
            sda_out <=1'b0;
          else
            sda_out <= sda_out;
        end
        CONTRL  :begin
          sda_en<=1'b1;
          if(cnt_scl == 1'b0)
            sda_out <= contrl_byte[(7-cnt_bit)];
          else
            sda_out <= sda_out;
        end
        ADDRESS :begin
          sda_en<=1'b1;
          if(IIC_ADDR_BYTE==2)begin
            if(cnt_scl == 1'b0)begin
              if(cnt_byte==1'b0)
              sda_out <= wr_address[(8*IIC_ADDR_BYTE-1)-cnt_bit];
              else begin
                sda_out <= wr_address[7-cnt_bit];
              end
            end
            else
              sda_out <= sda_out;
            end
          else begin
               sda_out <= wr_address[7-cnt_bit];
          end
        end
        WRITE   :begin
          sda_en<=1'b1;
          if(cnt_scl == 1'b0)
            sda_out <= wr_data[7-cnt_bit];
          else
            sda_out <= sda_out;
        end
        READ    :begin
          sda_en <=1'b0;
          sda_out<=1'b0;
        end
        ACK     :begin
          if(write)begin
          sda_en <=1'b0;
          sda_out<=1'b0;
          end
          else if (read_flag) begin
            sda_en <=1'b1;
            sda_out<=1'b0;
          end
        end
        STOP     :begin
          sda_en <= 1'b1;
          if(cnt_scl==(IIC_PERIOD>>1))
            sda_out<= 1'b1;
          else
            sda_out <= sda_out;
        end
        default: begin
          sda_en <=1'b0;
          sda_out<=1'b1;
        end
      endcase
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      rd_data <= 8'h00;
    else if(state_c[5]&&(cnt_scl==IIC_PERIOD>>1))begin
      rd_data[7-cnt_bit] <= iic_sda;
    end
    else begin
      rd_data <=rd_data;
    end
  end
  assign    iic_sda = sda_en?sda_out:1'hz;
  assign    wr_done = state_c[7] &&write_flag&&(cnt_scl==(IIC_PERIOD-1'b1)) ;
  assign    rd_done = state_c[6] &&read_flag && (cnt_scl==(IIC_PERIOD-1'b1)) ;

endmodule 