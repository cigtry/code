/* ================================================ *\
      Filename ﹕ 
      Author ﹕ fffff
    Description  ﹕ 
     Called by ﹕ 
Revision History  ﹕ 2022/-/-
              Revision 1.0
          Email﹕ 17602369756@163.com
      Company﹕ 
\* ================================================ */

`timescale 1ns/1ns 		//仿真系统时间尺度定义

`define clk_period 10  	//时钟周期参数定义	

module testbench(); 
//激励信号定义  
  reg				clk		; 
  reg				rst_n	; 
//响应信号定义	  
reg                             per_img_vsync;
reg                             per_img_href;
reg             [7:0]           per_img_red;
reg             [7:0]           per_img_green;
reg             [7:0]           per_img_blue;

wire                            post_img_vsync;
wire                            post_img_href;
wire            [7:0]           post_img_Y;
wire            [7:0]           post_img_Cb;
wire            [7:0]           post_img_Cr;

//实例化
localparam image_width  = 640;
localparam image_height = 480;

//产生时钟							       		 
  initial clk = 1'b0;		       		 
  always #(`clk_period / 2) clk = ~clk;  		 

  task  img_input; //任务名
      bit     [31:0]   row_cnt;
      bit     [31:0]   col_cnt;
      bit     [7:0]    mem    [image_width*image_height*3-1:0];
      $readmemh("../../../data/img_rgb.dat",mem);

      for (row_cnt = 0 ;row_cnt< image_height ; row_cnt++) begin
        repeat(5)@(posedge clk);
        per_img_vsync = 1'b1;
        repeat(5)@(posedge clk);
        for (col_cnt = 0;col_cnt< image_width ;col_cnt++ ) begin
          per_img_href  = 1'b1;
          per_img_red   = mem[(row_cnt*image_width+col_cnt)*3+0];
          per_img_green = mem[(row_cnt*image_width+col_cnt)*3+1];
          per_img_blue  = mem[(row_cnt*image_width+col_cnt)*3+2];
          @(posedge clk);
        end
         per_img_href  = 1'b0;
      end
      per_img_vsync = 1'b0;
      @(posedge clk);
  endtask : img_input

  reg             post_img_vsync_r;

  always @(posedge clk) begin
    if(!rst_n)
      post_img_vsync_r <= 1'b0;
    else
      post_img_vsync_r <= post_img_vsync;
  end

  wire                    post_img_vsync_pos,post_img_vsync_neg;
  assign    post_img_vsync_pos =  post_img_vsync& ~post_img_vsync_r;
  assign    post_img_vsync_neg =  ~post_img_vsync&post_img_vsync_r;

  task img_result_check;
    bit                     frame_flag;
    bit      [31:0]         row_cnt;
    bit      [31:0]         col_cnt;
    bit      [7:0]          mem   [image_height*image_width*3-1:0];

    frame_flag = 0;
    $readmemh("../../../data/img_ycbcr.dat",mem);

    while(1)begin
      @(posedge clk);
      if(post_img_vsync_pos == 1'b1)begin
        frame_flag = 1;
        row_cnt = 0;
        col_cnt = 0;
        $display("======image_result_check begin=========");
      end
      if(frame_flag==1'b1)begin
        if(post_img_href == 1'b1)
        begin
        if((post_img_Y != mem[((row_cnt*image_width+col_cnt)*3)+0])||(post_img_Cb != mem[((row_cnt*image_width+col_cnt)*3)+1])||(post_img_Cr != mem[((row_cnt*image_width+col_cnt)*3)+2]))begin
          $display("ERROR----> row_num:%0d;col_num :%0d;pixel data(y cb cr) : (%h %h %h);reference data(y cb cr) : (%h %h %h )",row_cnt+1,col_cnt+1,post_img_Y,post_img_Cb,post_img_Cr,mem[((row_cnt*image_width+col_cnt)*3)+0],mem[((row_cnt*image_width+col_cnt)*3)+1],mem[((row_cnt*image_width+col_cnt)*3)+2]);
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
  endtask : img_result_check


rgb2ycbcr   inst_rgb2ycbcr(
  .clk		(clk), //system clock 50MHz
  .rst_n	(rst_n), //reset, low valid
  
  .per_img_vsync   (per_img_vsync),
  .per_img_herf    (per_img_href),
  .per_img_red     (per_img_red),
  .per_img_green   (per_img_green),
  .per_img_blue    (per_img_blue),
  
  .post_img_vsync  (post_img_vsync),
  .post_img_herf   (post_img_href),
  .post_img_Y      (post_img_Y),
  .post_img_Cb     (post_img_Cb),
  .post_img_Cr     (post_img_Cr)
);


initial begin
    per_img_vsync = 0;
    per_img_href  = 0;
    per_img_red   = 0;
    per_img_green = 0;
    per_img_blue  = 0;
end
//产生激励	 
  initial  begin	 
    rst_n = 1'b0;	 
    #(`clk_period * 10 + 3);	 
    rst_n = 1'b1;	 
    #(`clk_period * 10); 
    wait(rst_n);
    fork
      begin
        repeat(5) @(posedge clk );
        img_input;
      end
      img_result_check;
      if(post_img_vsync_neg == 1'b1)begin
      $stop(2);
      end
    join
    
  end	 

endmodule 