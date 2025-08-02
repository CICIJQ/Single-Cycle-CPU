// ָ��洢������������ĵ�ַ���32λָ��
module IM(
    input wire ce,    // Ƭѡ�źţ��͵�ƽ��Ч
    input wire [31:0] addr,  // 32λ��ַ����
    output reg [31:0] inst   // 32λָ�����
);

    // 32λ�洢��Ԫ��ָ��洢����256�ֽ�
    reg [31:0] inst_memory[0:63];

    // ��ʼ��ָ��洢������
    initial begin
        for (integer i=0; i<64; i=i+1) begin
            inst_memory[i] = 32'b0;
        end
        // ��������ʮ�����Ʊ�ʾ�Ļ���ָ��
        inst_memory[0]  = 32'h000002b7;  // lui x5,0x00000
        inst_memory[1]  = 32'h00528293;  // addi x5,x5,0x05
        inst_memory[2]  = 32'h0052a313;  // slti x6,x5,0x5
        inst_memory[3]  = 32'h01900513;  // addi x10, x0, 25
        inst_memory[4]  = 32'h00030463;  // beq x6,x0,test1
        inst_memory[5]  = 32'h03c0006f;  // jal x0,end
        inst_memory[6]  = 32'h05c06313;  // ori x6,x0,0x5c
        inst_memory[7]  = 32'h00a363b3;  // or x7, x6,x10
        inst_memory[8]  = 32'h40638433;  // sub x8,x7,x6
        inst_memory[9]  = 32'h008024b3;  // slt x9,x0,x8
        inst_memory[10] = 32'h01950513;  // addi x10, x10, 25
        inst_memory[11] = 32'hfe0484e3;  // beq x9,x0,test0 
        inst_memory[12] = 32'h03200313;  // addi x6,x0,50
        inst_memory[13] = 32'h006504b3;  // add x9,x10,x6
        inst_memory[14] = 32'h00328293;  // addi x5,x5,3
        inst_memory[15] = 32'h0092a023;  // sw x9,0(x5)
        inst_memory[16] = 32'h00400313;  // addi x6,x0,4
        inst_memory[17] = 32'h406282b3;  // sub x5,x5,x6
        inst_memory[18] = 32'h0042a503;  // lw x10,4(x5)
        inst_memory[19] = 32'hfc0004e3;  // beq x0,x0,test0
        inst_memory[20] = 32'h0000006f;  // jal x0,end 
    end 

    // ָ���ȡ
    always @(*) begin
        if (ce == 1'b0 || addr[31:8] != 24'b0) begin
            // Ƭѡ�ź���Чʱ���ȫΪ0
            inst <= 32'b0;
        end else begin
            // ����2λ�õ��ֵ�ַ
            inst <= inst_memory[addr[7:2]];
        end
    end

endmodule