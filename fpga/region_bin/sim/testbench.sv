`timescale  1ns/1ns
module testbench;

//1280*720 分辨率时序参数
parameter  H_SYNC   =  11'd40;   //行同步
parameter  H_BACK   =  11'd220;  //行显示后沿
parameter  H_DISP   =  11'd1280; //行有效数据
parameter  H_FRONT  =  11'd110;  //行显示前沿
parameter  H_TOTAL  =  11'd1650; //行扫描周期

parameter  V_SYNC   =  11'd5;    //场同步
parameter  V_BACK   =  11'd20;   //场显示后沿
parameter  V_DISP   =  11'd720;  //场有效数据
parameter  V_FRONT  =  11'd5;    //场显示前沿
parameter  V_TOTAL  =  11'd750;  //场扫描周期 

/* parameter  H_SYNC   =  11'd1;   //行同步
parameter  H_BACK   =  11'd2;  //行显示后沿
parameter  H_DISP   =  11'd15; //行有效数据
parameter  H_FRONT  =  11'd3;  //行显示前沿
parameter  H_TOTAL  =  11'd20; //行扫描周期

parameter  V_SYNC   =  11'd1;    //场同步
parameter  V_BACK   =  11'd2;   //场显示后沿
parameter  V_DISP   =  11'd15;  //场有效数据
parameter  V_FRONT  =  11'd3;    //场显示前沿
parameter  V_TOTAL  =  11'd20;  //场扫描周期 */
parameter FILE_PATH_IN = "../../../../data/ikun.dat";
parameter FILE_PATH = "../../../../data/region_bin_ikun.dat";
integer fid;
//----------------------------------------------------------------------
//  clk & rst_n
reg                             clk;
reg                             rst_n;

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end
//----------------------------------------------------------------------
//  Image data prepred to be processed
reg                             pre_img_vsync;
reg                             pre_img_hsync;
reg                             pre_img_valid;
reg             [7:0]           pre_img_data;

    wire                                       post_img_vsync             ;
    wire                                       post_img_hsync             ;
    wire                                       post_img_valid             ;
    wire                      [  07:00]        post_img_data              ;

region_bin u_region_bin(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .pre_img_vsync                      (pre_img_vsync             ),
    .pre_img_hsync                      (pre_img_hsync             ),
    .pre_img_valid                      (pre_img_valid             ),
    .pre_img_data                       (pre_img_data              ),
    .post_img_vsync                     (post_img_vsync            ),
    .post_img_hsync                     (post_img_hsync            ),
    .post_img_valid                     (post_img_valid            ),
    .post_img_data                      (post_img_data             )
);




//----------------------------------------------------------------------
//  task and function
task image_input;
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       mem     [H_DISP*V_DISP-1:0];
    $readmemh(FILE_PATH_IN,mem);
    for(row_cnt = 0;row_cnt < V_TOTAL;row_cnt++)
    begin
        for(col_cnt = 0;col_cnt < H_TOTAL;col_cnt++)
        begin

          fork
          if(row_cnt < V_SYNC)begin
            pre_img_vsync = 1'b1;
          end
          else begin
            pre_img_vsync = 1'b0;
          end

          if(col_cnt < H_SYNC )begin
            pre_img_hsync = 1'b1;
          end
          else begin
            pre_img_hsync = 1'b0;
          end

          if(((col_cnt >= H_SYNC+H_BACK) && (col_cnt < H_SYNC+H_BACK+H_DISP))
                 &&((row_cnt >= V_SYNC+V_BACK) && (row_cnt < V_SYNC+V_BACK+V_DISP)))begin
                  pre_img_valid =1'b1;
                  pre_img_data  =mem[(row_cnt - V_SYNC-V_BACK)*H_DISP+(col_cnt - H_SYNC-H_BACK)];
                 end
          else begin
            pre_img_valid =0;
            pre_img_data  =    0;
          end
          join
          @(posedge clk); 
        end
    end
endtask : image_input




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

task  image_output; //任务名
  
  bit             [31:0]      row_cnt;
  bit             [31:0]      col_cnt;
  while(1)begin
      @(posedge clk);
        if(post_img_vsync_pos == 1'b1)begin
          row_cnt = 0;
          col_cnt = 0;
          fid = $fopen(FILE_PATH,"w");
          $display("======image_result_check begin=========");
        end
        if(post_img_valid == 1'b1)
        begin
        $fwrite(fid,"%.2h ",post_img_data);
        col_cnt = col_cnt + 1;
      end
      if(col_cnt == H_DISP)
            begin
              $fwrite(fid,"\n");
                col_cnt = 0;
                row_cnt = row_cnt + 1;
            end
      if(col_cnt == H_DISP-1 && row_cnt == V_DISP-1)
        begin
          $fwrite(fid,"%.2h ",post_img_data);
          $fclose(fid);
            $display("##############image result check end##############");
        end
    end
endtask  : image_output





initial
begin
    pre_img_vsync = 0;
    pre_img_hsync  = 0;
    pre_img_data  = 0;
    pre_img_valid = 0;
end

initial 
begin
    wait(rst_n);
    repeat(5) @(posedge clk); 
    fork
            image_input;
            image_output;
        //image_result_check;
    join
end 

endmodule