// 写回数据选择，根据控制信号选择正确的数据写回寄存器
module mux(
    input wire [1:0] memtoreg,  // 2位写回数据选择控制信号（00: ALU结果，01: 存储器数据，10: PC+4，11: 立即数）
    input wire jal,             // 跳转并链接控制信号
    input wire [31:0] instruct, // 32位指令输入(用于LUI的立即数)
    input wire [31:0] out1,     // 输入存储器读取的数据
    input wire [31:0] out2,     // 输入ALU运算结果
    input wire [9:0] out3,      // 输入PC+4值
    output reg [31:0] writedata // 输出选择后的32位写回数据
);

    always @(*) begin
        if (jal) begin
            // JAL指令：写回PC+4(存储在寄存器中作为返回地址)，10位PC+4零扩展到32位
            writedata = {22'b0, out3};  
        end else begin
            case (memtoreg)
                // 从存储器加载数据(LW指令)
                2'b01: writedata = out1;  // 直接使用存储器输出   
                // LUI指令(加载高位立即数)，取指令高20位(instruct[31:12])，低12位置0
                2'b11: begin
                    writedata = {instruct[31:12], 12'b0};
                end
                
                // 默认：用ALU运算结果
                default: writedata = out2;
            endcase
        end
    end

endmodule