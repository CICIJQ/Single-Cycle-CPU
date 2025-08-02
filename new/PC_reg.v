// ���������PC�Ĵ��������Ը�λ��˳��ִ�к�������ת
module PC_reg(
    input clk,    // ʱ���ź�
    input rst_n,  // �첽�͵�ƽ��λ�ź�
    output reg [31:0] PCout, // ��ǰPCֵ
    
    // ��֧����
    input [31:0] imm,  // ������ƫ����
    input branch,   // ��ָ֧���־
    input ALU_zero,  // ALU���־
    input jal
);

// �ڲ�PC�Ĵ���
reg [31:0] PC;

// ʱ�������ش���
always @(posedge clk or negedge rst_n) begin
    // �첽�͵�ƽ��λ
    if (!rst_n) begin
        PC <= 32'd0;  // PC����
    end 
    else begin
        if (jal) begin
            PC <= PC + imm;  // JALָ����ת
        end
        else if (branch & ALU_zero) begin
            PC <= PC + imm;  // ������֧��ת
        end
        else begin
            PC <= PC + 32'd4;  // ��ָͨ��PC+4
        end
    end
end

// PC���
always @(*) begin
    PCout <= PC;  // ���ڲ�PCֵ�������
end

endmodule