// 控制单元，根据输入的指令操作码生成控制信号
module control(
    input [6:0] instruction,  // 7位指令操作码
    output reg branch,    // 分支指令标志
    output reg memread,   // 存储器读使能
    output reg [1:0] memtoreg, // 写回寄存器的数据来源(00:ALU结果, 01:存储器数据, 10:PC+4, 11:立即数)
    output reg [1:0] ALUop,    // ALU执行的操作类型(00:默认, 01:分支比较, 10:I-type, 11:R-type)
    output reg memwrite,  // 存储器写使能
    output reg ALUsrc,    // ALU输入B的来源(0:寄存器, 1:立即数)
    output reg regwrite,  // 寄存器写使能
    output reg jal        // 跳转并链接指令
);

always @(*) begin
    case(instruction[6:0])
        // R-type指令 (寄存器-寄存器)
        7'b0110011: begin 
            branch   <= 1'b0;  // 非分支指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b00; // 写回ALU结果
            ALUop    <= 2'b11; // R-type操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b0;  // ALU输入B来自寄存器
            regwrite <= 1'b1;  // 写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // I-type指令 (立即数)
        7'b0010011: begin 
            branch   <= 1'b0;  // 非分支指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b00; // 写回ALU结果
            ALUop    <= 2'b10; // I-type操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b1;  // ALU输入B来自立即数，即地址计算用立即数偏移
            regwrite <= 1'b1;  // 写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // Load指令 (从存储器读取)
        7'b0000011: begin 
            branch   <= 1'b0;  // 非分支指令
            memread  <= 1'b1;  // 读取存储器
            memtoreg <= 2'b01; // 写回存储器数据
            ALUop    <= 2'b10; // I-type操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b1;  // ALU输入B来自立即数
            regwrite <= 1'b1;  // 写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // Store指令 (写入存储器)
        7'b0100011: begin 
            branch   <= 1'b0;  // 非分支指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b00; // 无写回
            ALUop    <= 2'b10; // I-type操作
            memwrite <= 1'b1;  // 写入存储器
            ALUsrc   <= 1'b1;  // 地址计算使用立即数偏移
            regwrite <= 1'b0;  // 不写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // 条件分支指令
        7'b1100011: begin 
            branch   <= 1'b1;  // 分支指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b00; // 无写回
            ALUop    <= 2'b01; // 分支比较操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b0;  // 比较两个寄存器值
            regwrite <= 1'b0;  // 不写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // LUI指令 (加载高位立即数)
        7'b0110111: begin 
            branch   <= 1'b0;  // 非分支指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b11; // 写回立即数
            ALUop    <= 2'b00; // 默认操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b0;  // 不使用ALU
            regwrite <= 1'b1;  // 写入寄存器
            jal      <= 1'b0;  // 非跳转指令
        end
        
        // JAL指令 (跳转并链接)
        7'b1101111: begin 
            branch   <= 1'b1;  // 跳转指令
            memread  <= 1'b0;  // 不读取存储器
            memtoreg <= 2'b10; // 写回PC+4
            ALUop    <= 2'b00; // 默认操作
            memwrite <= 1'b0;  // 不写入存储器
            ALUsrc   <= 1'b0;  // 不使用ALU
            regwrite <= 1'b1;  // 写入返回地址到寄存器
            jal      <= 1'b1;  // 跳转并链接
        end
        
        // 默认情况(未定义指令时)
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