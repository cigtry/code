

`timescale 1ns/1ns     //仿真系统时间尺度定义

`define clk_period 20    //时钟周期参数定义  

module testbench; 
//激励信号定义  
  reg        clk    ; 
  reg        rst_n  ; 

  initial clk = 1'b0;                
  always #(`clk_period / 2) clk = ~clk;       

//产生激励   
  initial  begin   
    rst_n = 1'b0;   
    #(`clk_period * 10 + 3);   
    rst_n = 1'b1;   
    #(`clk_period * 10); 
  end   

  localparam image_width  = 500;
  localparam image_height = 500;

  reg                      pre_img_vsync  ;
  reg                      pre_img_hsync  ;
  reg      [07:00]         pre_img_gray   ;
  wire     [07:00]         pixel_level    ;
  wire     [20:00]         pixel_cnt_num  ;
  wire                     pixel_level_vld;
  wire                     post_img_vsync ;
  wire                     post_img_hsync ;
  wire    [07:00]          post_img_gray  ;
  hist_stat   u_hist_stat(
  .clk              ( clk             ), //system clock 50MHz
  .rst_n            ( rst_n           ), //reset, low valid

  .pre_img_vsync    ( pre_img_vsync   ),
  .pre_img_hsync    ( pre_img_hsync   ),
  .pre_img_gray     ( pre_img_gray    ),

  .pixel_level_data ( pixel_level     ),
  .pixel_cnt_num    ( pixel_cnt_num   ),
  .pixel_level_vld  ( pixel_level_vld ) 
  );

  histEQ_proc 
  #( 
    .Index  (27),
    .Multiplier  (136957)
  )
  u_histEQ_proc (
  .clk              (clk            ), //system clock 50MHz
  .rst_n            (rst_n          ), //reset, low valid

  .pre_img_vsync    (pre_img_vsync  ),
  .pre_img_hsync    (pre_img_hsync  ),
  .pre_img_gray     (pre_img_gray   ),

  .pixel_level      (pixel_level    ),
  .pixel_cnt_num    (pixel_cnt_num  ),
  .pixel_level_vld  (pixel_level_vld),
  .pixel_write_ok   (pixel_write_ok ),

  .post_img_vsync   (post_img_vsync ),
  .post_img_hsync   (post_img_hsync ),
  .post_img_gray    (post_img_gray  )
);
task image_input;
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       mem     [image_width*image_height-1:0];
    $readmemh("../../../data/img_Gray1.dat",mem);
    
    for(row_cnt = 0;row_cnt < image_height;row_cnt++)
    begin
        repeat(5) @(posedge clk);
        pre_img_vsync = 1'b1;
        repeat(5) @(posedge clk);
        for(col_cnt = 0;col_cnt < image_width;col_cnt++)
        begin
            pre_img_hsync  = 1'b1;
            pre_img_gray  = mem[row_cnt*image_width+col_cnt];
            @(posedge clk);
        end
        pre_img_hsync  = 1'b0;
    end
    pre_img_vsync = 1'b0;
    @(posedge clk);
    
endtask : image_input


reg                             post_img_vsync_r;


always @(posedge clk)
begin
    if(rst_n == 1'b0)
        post_img_vsync_r <= 1'b0;
    else
        post_img_vsync_r <= post_img_vsync;
end

wire                            post_img_vsync_pos;
wire                            post_img_vsync_neg;

assign post_img_vsync_pos = ~post_img_vsync_r &  post_img_vsync;
assign post_img_vsync_neg =  post_img_vsync_r & ~post_img_vsync;
task image_result_check;
    bit                         frame_flag;
    bit         [31:0]          row_cnt;
    bit         [31:0]          col_cnt;
    bit         [ 7:0]          mem     [image_width*image_height-1:0];
    
    frame_flag = 0;
    $readmemh("../../../data/img_Gray2.dat",mem);
    
    while(1)
    begin
        @(posedge clk);
        if(post_img_vsync_pos == 1'b1)
        begin
            frame_flag = 1;
            row_cnt = 0;
            col_cnt = 0;
            $display("##############image result check begin##############");
        end
        
        if(frame_flag == 1'b1)
        begin
            if(post_img_hsync == 1'b1)
            begin
                if(post_img_gray != mem[row_cnt*image_width+col_cnt])
                begin
                    $display("result error ---> row_num : %0d;col_num : %0d;pixel data : %h;reference data : %h",row_cnt+1,col_cnt+1,post_img_gray,mem[row_cnt*image_width+col_cnt]);
                end
                col_cnt = col_cnt + 1;
            end
            
            if(col_cnt == image_width)
            begin
                col_cnt = 0;
                row_cnt = row_cnt + 1;
            end
        end
        
        if(post_img_vsync_neg == 1'b1)
        begin
            frame_flag = 0;
            $display("##############image result check end##############");
        end
    end
endtask : image_result_check

initial
begin
    pre_img_hsync = 0;
    pre_img_vsync  = 0;
    pre_img_gray  = 0;
end

initial 
begin
    wait(rst_n);
    repeat(5) @(posedge clk); 
            image_input;
    fork
        begin 
            wait(pixel_write_ok);
            @(posedge clk);
            image_input;
        end 
        image_result_check;
    join
end

endmodule 