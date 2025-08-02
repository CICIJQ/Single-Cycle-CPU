// ALUģ�飬ִ�������߼����㣬֧��12��RISC-Vָ��
module alu (
    input ALU_src,            // ������2ѡ���ź� (0:�Ĵ��� 1:������)
    input [3:0] control_signal, // 4λALU���������ź�
    input [31:0] read_data1,   // �Ĵ�������1 (rs1)
    input [31:0] read_data2,   // �Ĵ�������2 (rs2)
    input [31:0] immediate,    // ������չ���������
    output reg [31:0] ALU_result, // 32λALU������
    output reg ALU_zero         // ���־�����ڷ�֧�ж�
);

    reg [31:0] ALU_data2;  // ALU�ĵڶ���������

    // ������2ѡ����
    always @(*) begin
        ALU_data2 = ALU_src ? immediate : read_data2;  // ����ALU_srcѡ����������Ĵ�������
    end

    // ALU��������
    always @(*) begin
        case (control_signal)
            // ������������
            4'b0000: ALU_result = read_data1 + ALU_data2;  // ADD/ADDI/LW/SW: �ӷ�
            4'b0001: ALU_result = read_data1 - ALU_data2;  // SUB/BEQ: ����
            4'b0010: ALU_result = read_data1 & ALU_data2;  // AND: �߼���
            4'b0011: ALU_result = read_data1 | ALU_data2;  // OR/ORI: �߼���
            
            // �Ƚ�����
            4'b0101: begin  // SLT/SLTI: �з��űȽ�
                ALU_result = ($signed(read_data1) < $signed(ALU_data2)) ? 32'd1 : 32'd0;
            end
            
            // ����
            4'b0111: ALU_result = ALU_data2;  // LUI: ֱ�����B������(������)
            4'b1001: ALU_result = 32'b0;      // JAL: ���0(ʵ����ת��PCģ�鴦��)
            
            default: ALU_result = 32'b0;      // Ĭ�����0
        endcase
    end

    // ���־
    always @(*) begin
        case (control_signal)
            4'b0001: ALU_zero = (ALU_result == 32'b0);  // BEQ: �ȽϽ���Ƿ�Ϊ0
            4'b1000: ALU_zero = (read_data1 == read_data2); // ���ñȽ�
            default: ALU_zero = 1'b0;  // ����ָ�����־Ϊ0
        endcase
    end

endmodule