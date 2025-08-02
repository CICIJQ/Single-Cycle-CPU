// �Ĵ���������ͬ��д���첽��
module register (
    input        clk,    // ʱ���ź�
    input        rst_n,  // �첽�͵�ƽ��λ�ź�
    input        regwrite,        // дʹ���źţ��ߵ�ƽ��Ч
    input [4:0]  write_register,  // д��Ĵ�����ַ��5λ����Ѱַ32���Ĵ�����
    input [31:0] write_data,      // д�����ݣ�32λ��
    input [4:0]  read_register1,  // ��һ�����˿ڼĴ�����ַ
    output [31:0] read_data1,     // ��һ�����˿��������
    input [4:0]  read_register2,  // �ڶ������˿ڼĴ�����ַ
    output [31:0] read_data2      // �ڶ������˿��������
);

    reg [31:0] register [0:31];  // 32��32λ�Ĵ���

    // �Ĵ���д������ʱ�������ش�����
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < 32; i = i + 1)
                register[i] <= 32'd0;
        end
        else if (regwrite && write_register != 5'd0) begin  // X0����д��
            register[write_register] <= write_data;
        end
    end

    // ���˿�1
    assign read_data1 = (read_register1 == 5'd0) ? 32'd0 : register[read_register1];
    // ���˿�2
    assign read_data2 = (read_register2 == 5'd0) ? 32'd0 : register[read_register2];

endmodule
