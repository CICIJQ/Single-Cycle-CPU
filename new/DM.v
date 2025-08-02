// 数据存储器,支持字节寻址的读写操作
module DM(
    input wire clk,     // 时钟信号
    input wire ce,      // 片选信号，低电平有效
    input wire we,      // 写使能信号，高电平有效
    input wire [31:0] addr,    // 32位地址输入（字节寻址）
    input wire [31:0] data_i,  // 32位写入数据
    output reg [31:0] data_o  // 32位读取数据
);

    reg [7:0] data_mem [0:255]; 
    
     // 初始化数据存储器内容
    initial begin
        for (integer i = 0; i < 256; i = i + 1)
            data_mem[i] = 8'b0;
    end
   
    // 写操作（同步，时钟上升沿触发，小端序）
    always @(posedge clk) begin
       if (ce && we && addr[31:8] == 24'b0) begin
            // 小端序存储
            data_mem[addr[7:0]]   <= data_i[7:0];    // 字节0 (最低地址)
            data_mem[addr[7:0]+1] <= data_i[15:8];   // 字节1
            data_mem[addr[7:0]+2] <= data_i[23:16];  // 字节2
            data_mem[addr[7:0]+3] <= data_i[31:24];  // 字节3 (最高地址)
        end
    end
    
    // 读操作（异步，小端序）
    always @(*) begin
        if (ce && addr[31:8] == 24'b0) begin
            data_o <= {
                data_mem[addr[7:0]+3],  // 字节3 (最高位)
                data_mem[addr[7:0]+2],  // 字节2
                data_mem[addr[7:0]+1],  // 字节1
                data_mem[addr[7:0]]     // 字节0 (最低位)
            };
        end else begin
            data_o <= 32'b0;
        end
    end
endmodule