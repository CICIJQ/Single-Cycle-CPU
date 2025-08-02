// ���ݴ洢��,֧���ֽ�Ѱַ�Ķ�д����
module DM(
    input wire clk,     // ʱ���ź�
    input wire ce,      // Ƭѡ�źţ��͵�ƽ��Ч
    input wire we,      // дʹ���źţ��ߵ�ƽ��Ч
    input wire [31:0] addr,    // 32λ��ַ���루�ֽ�Ѱַ��
    input wire [31:0] data_i,  // 32λд������
    output reg [31:0] data_o  // 32λ��ȡ����
);

    reg [7:0] data_mem [0:255]; 
    
     // ��ʼ�����ݴ洢������
    initial begin
        for (integer i = 0; i < 256; i = i + 1)
            data_mem[i] = 8'b0;
    end
   
    // д������ͬ����ʱ�������ش�����С����
    always @(posedge clk) begin
       if (ce && we && addr[31:8] == 24'b0) begin
            // С����洢
            data_mem[addr[7:0]]   <= data_i[7:0];    // �ֽ�0 (��͵�ַ)
            data_mem[addr[7:0]+1] <= data_i[15:8];   // �ֽ�1
            data_mem[addr[7:0]+2] <= data_i[23:16];  // �ֽ�2
            data_mem[addr[7:0]+3] <= data_i[31:24];  // �ֽ�3 (��ߵ�ַ)
        end
    end
    
    // ���������첽��С����
    always @(*) begin
        if (ce && addr[31:8] == 24'b0) begin
            data_o <= {
                data_mem[addr[7:0]+3],  // �ֽ�3 (���λ)
                data_mem[addr[7:0]+2],  // �ֽ�2
                data_mem[addr[7:0]+1],  // �ֽ�1
                data_mem[addr[7:0]]     // �ֽ�0 (���λ)
            };
        end else begin
            data_o <= 32'b0;
        end
    end
endmodule