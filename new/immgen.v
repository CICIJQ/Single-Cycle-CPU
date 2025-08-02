// 立即数生成,根据指令类型从32位指令中提取并符号扩展立即数
module immgen(
    input [31:0] instruct,    // 32位输入指令
    output reg [31:0] immediate // 32位符号扩展后的立即数输出
);

always @(*) begin
    case (instruct[6:0])  // 根据opcode判断指令类型
        // I-type指令：ADDI, ORI, SLTI, LW
        // I-type立即数：[31:20]（12位）,符号扩展将12位立即数扩展为32位
        7'b0010011,        // ADDI, ORI, SLTI
        7'b0000011: begin  // LW
            immediate = {{20{instruct[31]}}, instruct[31:20]};
        end
        
        // S-type指令：SW
        // S-type立即数：[31:25]和[11:7],组合为12位立即数并符号扩展
        7'b0100011: begin 
            immediate = {{20{instruct[31]}}, instruct[31:25], instruct[11:7]};
        end
        
        // B-type指令：BEQ
        // B-type立即数:[31], [7], [30:25], [11:8]（13位，最低位为0）：
        7'b1100011: begin
            immediate = {{19{instruct[31]}}, instruct[31], instruct[7], 
                        instruct[30:25], instruct[11:8], 1'b0};
        end
        
        // J-type指令：JAL
        // J-type立即数：[31], [19:12], [20], [30:21]（21位，最低位为0）：
        7'b1101111: begin
            immediate = {{11{instruct[31]}}, instruct[31], instruct[19:12], 
                        instruct[20], instruct[30:21], 1'b0};
        end
        
        // U-type指令：LUI
        // U-type立即数格式：[31:12]（20位立即数），左移12位低位补0
        7'b0110111: begin
            immediate = {instruct[31:12], 12'b0};
        end
        
        // R-type指令：ADD, SUB, OR, SLT（无立即数）
        7'b0110011: begin
            immediate = 32'b0;
        end
        
        // 默认情况
        default: begin
            immediate = 32'b0;
        end
    endcase
end

endmodule