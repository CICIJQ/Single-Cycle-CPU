`timescale 1ns/100ps

module tb;
    reg clk;  // 存储时钟信号
    reg rst;  // 存储复位信号
    
    // 每2纳秒时钟信号翻转一次，生成一个周期为4纳秒的时钟信号
    always #2 clk = ~clk;  
    
    // 初始化块
    initial begin
        clk = 1'b0;  // 初始化为低电平
        rst = 1'b1;  // 初始化为高电平
        #10 rst = 1'b0;
        #100 $stop;
    end
    
    // 实例top模块并命名为inst
    top inst (
        .clk(clk),
        .rst(rst)
    );
endmodule
