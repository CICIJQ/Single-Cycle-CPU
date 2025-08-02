`timescale 1ns/100ps

module tb;
    reg clk;  // �洢ʱ���ź�
    reg rst;  // �洢��λ�ź�
    
    // ÿ2����ʱ���źŷ�תһ�Σ�����һ������Ϊ4�����ʱ���ź�
    always #2 clk = ~clk;  
    
    // ��ʼ����
    initial begin
        clk = 1'b0;  // ��ʼ��Ϊ�͵�ƽ
        rst = 1'b1;  // ��ʼ��Ϊ�ߵ�ƽ
        #10 rst = 1'b0;
        #100 $stop;
    end
    
    // ʵ��topģ�鲢����Ϊinst
    top inst (
        .clk(clk),
        .rst(rst)
    );
endmodule
