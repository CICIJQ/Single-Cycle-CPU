// ALU模块，执行算术逻辑运算，支持12条RISC-V指令
module alu (
    input ALU_src,            // 操作数2选择信号 (0:寄存器 1:立即数)
    input [3:0] control_signal, // 4位ALU操作控制信号
    input [31:0] read_data1,   // 寄存器数据1 (rs1)
    input [31:0] read_data2,   // 寄存器数据2 (rs2)
    input [31:0] immediate,    // 符号扩展后的立即数
    output reg [31:0] ALU_result, // 32位ALU计算结果
    output reg ALU_zero         // 零标志，用于分支判断
);

    reg [31:0] ALU_data2;  // ALU的第二个操作数

    // 操作数2选择器
    always @(*) begin
        ALU_data2 = ALU_src ? immediate : read_data2;  // 根据ALU_src选择立即数或寄存器数据
    end

    // ALU核心运算
    always @(*) begin
        case (control_signal)
            // 基本算术运算
            4'b0000: ALU_result = read_data1 + ALU_data2;  // ADD/ADDI/LW/SW: 加法
            4'b0001: ALU_result = read_data1 - ALU_data2;  // SUB/BEQ: 减法
            4'b0010: ALU_result = read_data1 & ALU_data2;  // AND: 逻辑与
            4'b0011: ALU_result = read_data1 | ALU_data2;  // OR/ORI: 逻辑或
            
            // 比较运算
            4'b0101: begin  // SLT/SLTI: 有符号比较
                ALU_result = ($signed(read_data1) < $signed(ALU_data2)) ? 32'd1 : 32'd0;
            end
            
            // 特殊
            4'b0111: ALU_result = ALU_data2;  // LUI: 直接输出B操作数(立即数)
            4'b1001: ALU_result = 32'b0;      // JAL: 输出0(实际跳转由PC模块处理)
            
            default: ALU_result = 32'b0;      // 默认输出0
        endcase
    end

    // 零标志
    always @(*) begin
        case (control_signal)
            4'b0001: ALU_zero = (ALU_result == 32'b0);  // BEQ: 比较结果是否为0
            4'b1000: ALU_zero = (read_data1 == read_data2); // 备用比较
            default: ALU_zero = 1'b0;  // 其他指令零标志为0
        endcase
    end

endmodule