// 寄存器，可以同步写、异步读
module register (
    input        clk,    // 时钟信号
    input        rst_n,  // 异步低电平复位信号
    input        regwrite,        // 写使能信号，高电平有效
    input [4:0]  write_register,  // 写入寄存器地址（5位，可寻址32个寄存器）
    input [31:0] write_data,      // 写入数据（32位）
    input [4:0]  read_register1,  // 第一个读端口寄存器地址
    output [31:0] read_data1,     // 第一个读端口输出数据
    input [4:0]  read_register2,  // 第二个读端口寄存器地址
    output [31:0] read_data2      // 第二个读端口输出数据
);

    reg [31:0] register [0:31];  // 32个32位寄存器

    // 寄存器写操作（时钟上升沿触发）
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < 32; i = i + 1)
                register[i] <= 32'd0;
        end
        else if (regwrite && write_register != 5'd0) begin  // X0不能写入
            register[write_register] <= write_data;
        end
    end

    // 读端口1
    assign read_data1 = (read_register1 == 5'd0) ? 32'd0 : register[read_register1];
    // 读端口2
    assign read_data2 = (read_register2 == 5'd0) ? 32'd0 : register[read_register2];

endmodule
