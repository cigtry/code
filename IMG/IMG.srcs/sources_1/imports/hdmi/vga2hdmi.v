/* ================================================ *\
          Filename �? VGA转HDMI接口
            Author �? fffff
      Description  �? 
         Called by �? 
Revision History  �? 2022/12/16
                      Revision 1.0
              Email�? 17602369756@163.com
            Company�? 
\* ================================================ */
`define  yuanyu//直接调用vivado提供的串并转换的原语,注释掉的话是使用quartus，但是需要添加ddio的IP�?

module vga2hdmi(
    input                   clk_1x        , //system clock 74.25MHz
    input                   clk_5x        ,
    input                   rst_n         , //reset, low valid
    input                   hsync         ,
    input                   vsync         ,
    input                   rgb_vlaid     ,
    input       [23:00]     rgb_data      ,
    output                  tmds_clk_p    ,
    output                  tmds_clk_n    ,
    output      [02:00]     tmds_data_p   ,
    output      [02:00]     tmds_data_n   
);
//Internal wire/reg declarations
wire  [9:0] red_out;
wire  [9:0] blue_out;
wire  [9:0] green_out;
wire        red_p,green_p,blue_p;
wire        red_n,green_n,blue_n;
wire        clk_n,clk_p;
assign      tmds_clk_p = clk_p;
assign      tmds_clk_n = clk_n;
assign tmds_data_p = {red_p,green_p,blue_p};
assign tmds_data_n = {red_n,green_n,blue_n};
//Module instantiations , self-build module

/*==================================encode================================================================*/
//red--------------------------------------------------------------------------------------------
  encode   inst_encode_red(
    .clkin      (clk_1x),
    .rstin      (!rst_n),
    
    .din        (rgb_data[23:16]),
    .c0         (1'b0),
    .c1         (1'b0),
    .de         (rgb_vlaid),
    .dout       (red_out)
    ) ;


//blue--------------------------------------------------------------------------------------------
  encode   inst_encode_blue(
    .clkin      (clk_1x),
    .rstin      (!rst_n),
    
    .din        (rgb_data[15:8]),
    .c0         (hsync),
    .c1         (vsync),
    .de         (rgb_vlaid),
    .dout       (blue_out)
    ) ;


//green--------------------------------------------------------------------------------------------
  encode   inst_encode_green(
  .clkin        (clk_1x),
    .rstin      (!rst_n),
    
    .din        (rgb_data[7:0]),
    .c0         (1'b0 ),
    .c1         (1'b0 ),
    .de         (rgb_vlaid),
    .dout       (green_out)
    ) ;
  

`ifdef yuanyu
/*==================================并转�?================================================================*/
/*===========================使用原语===============================*/
serializer inst_serializer_red(
   /*input                */.clk_5x    (clk_5x  ),
   /*input                */.clk_1x    (clk_1x  ), //system clock 50MHz
   /*input                 */.rst_n    (rst_n  ), //reset, low valid
   /*input     [9:0]      */.din      (red_out    ),
   /*output               */.dout_n   (red_n ),
   /*output               */.dout_p   (red_p )
);

serializer inst_serializer_blue(
   /*input                */.clk_5x    (clk_5x  ),
   /*input                */.clk_1x    (clk_1x  ), //system clock 50MHz
   /*input                 */.rst_n    (rst_n  ), //reset, low valid
   /*input     [9:0]      */.din      (blue_out    ),
   /*output               */.dout_n   (blue_n ),
   /*output               */.dout_p   (blue_p )
);


serializer inst_serializer_green(
   /*input                */.clk_5x    (clk_5x  ),
   /*input                */.clk_1x    (clk_1x  ), //system clock 50MHz
   /*input                 */.rst_n    (rst_n  ), //reset, low valid
   /*input     [9:0]      */.din      (green_out    ),
   /*output               */.dout_n   (green_n ),
   /*output               */.dout_p   (green_p )
);

serializer inst_serializer_clk(
   /*input                */.clk_5x    (clk_5x  ),
   /*input                */.clk_1x    (clk_1x  ), //system clock 50MHz
   /*input                 */.rst_n    (rst_n  ), //reset, low valid
   /*input     [9:0]      */.din      (10'b11111_00000    ),
   /*output               */.dout_n   (clk_n ),
   /*output               */.dout_p   (clk_p )
);


`else
//clk--------------------------------------------------------------------------------------------
  par2ser inst_par2ser_clk(
      /*input              */.clk        (clk_5x), // clock 125MHz
      /*input    [9:0]    */.data_in        (10'b11111_00000),
      /*output            */.ser_p          (clk_p),
      /*output            */.ser_n          (clk_n)
  );
  par2ser inst_par2ser_red(
      /*input              */.clk        (clk_5x), // clock 125MHz
      /*input    [9:0]    */.data_in        (red_out),
      /*output            */.ser_p          (red_p),
      /*output            */.ser_n          (red_n)
  );
  par2ser inst_par2ser_blue(
      /*input              */.clk        (clk_5x), // clock 125MHz
      /*input    [9:0]    */.data_in        (blue_out),
      /*output            */.ser_p          (blue_p),
      /*output            */.ser_n          (blue_n)
  );
    par2ser inst_par2ser_green(
      /*input              */.clk        (clk_5x), // clock 125MHz
      /*input    [9:0]    */.data_in        (green_out),
      /*output            */.ser_p          (green_p),
      /*output            */.ser_n          (green_n)
  );
`endif

endmodule 