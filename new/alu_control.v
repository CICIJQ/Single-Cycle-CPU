// ALU控制：add, sub, or, slt, addi, ori, slti, sw, lw, lui, beq, jal
module alu_control (
    input [31:0] instruction,  // 32位指令
    input [1:0] ALUop,         // 2位ALU操作类型
    output reg [3:0] control_signal // 4位ALU控制信号
);

    always @(*) begin
        case (ALUop)
            // LUI指令(高位立即数加载)，直接输出B输入，无需ALU操作
            // JAL指令，PC+4计算，实际由PC模块处理
            2'b00: 
                control_signal = (instruction[6:0] == 7'b0110111) ? 4'b0111 : 4'b1001; 
                
            // 分支指令(BEQ)
            2'b01: begin
                control_signal = 4'b0001; // 减法比较
            end
            
            // I-type指令(立即数操作)
            2'b10: begin
                case (instruction[14:12]) // funct3
                    3'b000: control_signal = 4'b0000; // ADDI, LW, SW 立即数加法
                    3'b110: control_signal = 4'b0011; // ORI 立即数按位或
                    3'b010: control_signal = 4'b0101; // SLTI 立即数有符号比较
                    default: control_signal = 4'b0000; // 默认加法
                endcase
            end
            
            // R-type指令(寄存器操作)
            2'b11: begin
                case ({instruction[30], instruction[14:12]}) 
                    4'b0_000: control_signal = 4'b0000; // ADD 加法
                    4'b1_000: control_signal = 4'b0001; // SUB 减法
                    4'b0_110: control_signal = 4'b0011; // OR 按位或
                    4'b0_010: control_signal = 4'b0101; // SLT 有符号比较
                    default:  control_signal = 4'b0000; // 默认加法
                endcase
            end
            
            default: control_signal = 4'b0000; // 默认加法操作
        endcase
    end
endmodule