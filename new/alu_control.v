// ALU���ƣ�add, sub, or, slt, addi, ori, slti, sw, lw, lui, beq, jal
module alu_control (
    input [31:0] instruction,  // 32λָ��
    input [1:0] ALUop,         // 2λALU��������
    output reg [3:0] control_signal // 4λALU�����ź�
);

    always @(*) begin
        case (ALUop)
            // LUIָ��(��λ����������)��ֱ�����B���룬����ALU����
            // JALָ�PC+4���㣬ʵ����PCģ�鴦��
            2'b00: 
                control_signal = (instruction[6:0] == 7'b0110111) ? 4'b0111 : 4'b1001; 
                
            // ��ָ֧��(BEQ)
            2'b01: begin
                control_signal = 4'b0001; // �����Ƚ�
            end
            
            // I-typeָ��(����������)
            2'b10: begin
                case (instruction[14:12]) // funct3
                    3'b000: control_signal = 4'b0000; // ADDI, LW, SW �������ӷ�
                    3'b110: control_signal = 4'b0011; // ORI ��������λ��
                    3'b010: control_signal = 4'b0101; // SLTI �������з��űȽ�
                    default: control_signal = 4'b0000; // Ĭ�ϼӷ�
                endcase
            end
            
            // R-typeָ��(�Ĵ�������)
            2'b11: begin
                case ({instruction[30], instruction[14:12]}) 
                    4'b0_000: control_signal = 4'b0000; // ADD �ӷ�
                    4'b1_000: control_signal = 4'b0001; // SUB ����
                    4'b0_110: control_signal = 4'b0011; // OR ��λ��
                    4'b0_010: control_signal = 4'b0101; // SLT �з��űȽ�
                    default:  control_signal = 4'b0000; // Ĭ�ϼӷ�
                endcase
            end
            
            default: control_signal = 4'b0000; // Ĭ�ϼӷ�����
        endcase
    end
endmodule