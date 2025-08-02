// ����������,����ָ�����ʹ�32λָ������ȡ��������չ������
module immgen(
    input [31:0] instruct,    // 32λ����ָ��
    output reg [31:0] immediate // 32λ������չ������������
);

always @(*) begin
    case (instruct[6:0])  // ����opcode�ж�ָ������
        // I-typeָ�ADDI, ORI, SLTI, LW
        // I-type��������[31:20]��12λ��,������չ��12λ��������չΪ32λ
        7'b0010011,        // ADDI, ORI, SLTI
        7'b0000011: begin  // LW
            immediate = {{20{instruct[31]}}, instruct[31:20]};
        end
        
        // S-typeָ�SW
        // S-type��������[31:25]��[11:7],���Ϊ12λ��������������չ
        7'b0100011: begin 
            immediate = {{20{instruct[31]}}, instruct[31:25], instruct[11:7]};
        end
        
        // B-typeָ�BEQ
        // B-type������:[31], [7], [30:25], [11:8]��13λ�����λΪ0����
        7'b1100011: begin
            immediate = {{19{instruct[31]}}, instruct[31], instruct[7], 
                        instruct[30:25], instruct[11:8], 1'b0};
        end
        
        // J-typeָ�JAL
        // J-type��������[31], [19:12], [20], [30:21]��21λ�����λΪ0����
        7'b1101111: begin
            immediate = {{11{instruct[31]}}, instruct[31], instruct[19:12], 
                        instruct[20], instruct[30:21], 1'b0};
        end
        
        // U-typeָ�LUI
        // U-type��������ʽ��[31:12]��20λ��������������12λ��λ��0
        7'b0110111: begin
            immediate = {instruct[31:12], 12'b0};
        end
        
        // R-typeָ�ADD, SUB, OR, SLT������������
        7'b0110011: begin
            immediate = 32'b0;
        end
        
        // Ĭ�����
        default: begin
            immediate = 32'b0;
        end
    endcase
end

endmodule