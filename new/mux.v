// д������ѡ�񣬸��ݿ����ź�ѡ����ȷ������д�ؼĴ���
module mux(
    input wire [1:0] memtoreg,  // 2λд������ѡ������źţ�00: ALU�����01: �洢�����ݣ�10: PC+4��11: ��������
    input wire jal,             // ��ת�����ӿ����ź�
    input wire [31:0] instruct, // 32λָ������(����LUI��������)
    input wire [31:0] out1,     // ����洢����ȡ������
    input wire [31:0] out2,     // ����ALU������
    input wire [9:0] out3,      // ����PC+4ֵ
    output reg [31:0] writedata // ���ѡ����32λд������
);

    always @(*) begin
        if (jal) begin
            // JALָ�д��PC+4(�洢�ڼĴ�������Ϊ���ص�ַ)��10λPC+4����չ��32λ
            writedata = {22'b0, out3};  
        end else begin
            case (memtoreg)
                // �Ӵ洢����������(LWָ��)
                2'b01: writedata = out1;  // ֱ��ʹ�ô洢�����   
                // LUIָ��(���ظ�λ������)��ȡָ���20λ(instruct[31:12])����12λ��0
                2'b11: begin
                    writedata = {instruct[31:12], 12'b0};
                end
                
                // Ĭ�ϣ���ALU������
                default: writedata = out2;
            endcase
        end
    end

endmodule