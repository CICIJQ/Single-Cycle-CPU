// ���Ƶ�Ԫ�����������ָ����������ɿ����ź�
module control(
    input [6:0] instruction,  // 7λָ�������
    output reg branch,    // ��ָ֧���־
    output reg memread,   // �洢����ʹ��
    output reg [1:0] memtoreg, // д�ؼĴ�����������Դ(00:ALU���, 01:�洢������, 10:PC+4, 11:������)
    output reg [1:0] ALUop,    // ALUִ�еĲ�������(00:Ĭ��, 01:��֧�Ƚ�, 10:I-type, 11:R-type)
    output reg memwrite,  // �洢��дʹ��
    output reg ALUsrc,    // ALU����B����Դ(0:�Ĵ���, 1:������)
    output reg regwrite,  // �Ĵ���дʹ��
    output reg jal        // ��ת������ָ��
);

always @(*) begin
    case(instruction[6:0])
        // R-typeָ�� (�Ĵ���-�Ĵ���)
        7'b0110011: begin 
            branch   <= 1'b0;  // �Ƿ�ָ֧��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b00; // д��ALU���
            ALUop    <= 2'b11; // R-type����
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b0;  // ALU����B���ԼĴ���
            regwrite <= 1'b1;  // д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // I-typeָ�� (������)
        7'b0010011: begin 
            branch   <= 1'b0;  // �Ƿ�ָ֧��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b00; // д��ALU���
            ALUop    <= 2'b10; // I-type����
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b1;  // ALU����B����������������ַ������������ƫ��
            regwrite <= 1'b1;  // д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // Loadָ�� (�Ӵ洢����ȡ)
        7'b0000011: begin 
            branch   <= 1'b0;  // �Ƿ�ָ֧��
            memread  <= 1'b1;  // ��ȡ�洢��
            memtoreg <= 2'b01; // д�ش洢������
            ALUop    <= 2'b10; // I-type����
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b1;  // ALU����B����������
            regwrite <= 1'b1;  // д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // Storeָ�� (д��洢��)
        7'b0100011: begin 
            branch   <= 1'b0;  // �Ƿ�ָ֧��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b00; // ��д��
            ALUop    <= 2'b10; // I-type����
            memwrite <= 1'b1;  // д��洢��
            ALUsrc   <= 1'b1;  // ��ַ����ʹ��������ƫ��
            regwrite <= 1'b0;  // ��д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // ������ָ֧��
        7'b1100011: begin 
            branch   <= 1'b1;  // ��ָ֧��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b00; // ��д��
            ALUop    <= 2'b01; // ��֧�Ƚϲ���
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b0;  // �Ƚ������Ĵ���ֵ
            regwrite <= 1'b0;  // ��д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // LUIָ�� (���ظ�λ������)
        7'b0110111: begin 
            branch   <= 1'b0;  // �Ƿ�ָ֧��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b11; // д��������
            ALUop    <= 2'b00; // Ĭ�ϲ���
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b0;  // ��ʹ��ALU
            regwrite <= 1'b1;  // д��Ĵ���
            jal      <= 1'b0;  // ����תָ��
        end
        
        // JALָ�� (��ת������)
        7'b1101111: begin 
            branch   <= 1'b1;  // ��תָ��
            memread  <= 1'b0;  // ����ȡ�洢��
            memtoreg <= 2'b10; // д��PC+4
            ALUop    <= 2'b00; // Ĭ�ϲ���
            memwrite <= 1'b0;  // ��д��洢��
            ALUsrc   <= 1'b0;  // ��ʹ��ALU
            regwrite <= 1'b1;  // д�뷵�ص�ַ���Ĵ���
            jal      <= 1'b1;  // ��ת������
        end
        
        // Ĭ�����(δ����ָ��ʱ)
        default: begin 
            branch   <= 1'b0;
            memread  <= 1'b0;
            memtoreg <= 2'b00;
            ALUop    <= 2'b00;
            memwrite <= 1'b0;
            ALUsrc   <= 1'b0;
            regwrite <= 1'b0;
            jal      <= 1'b0;
        end
    endcase
end

endmodule