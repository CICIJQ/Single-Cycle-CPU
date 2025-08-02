// 程序计数器PC寄存器，可以复位、顺序执行和条件跳转
module PC_reg(
    input clk,    // 时钟信号
    input rst_n,  // 异步低电平复位信号
    output reg [31:0] PCout, // 当前PC值
    
    // 分支控制
    input [31:0] imm,  // 立即数偏移量
    input branch,   // 分支指令标志
    input ALU_zero,  // ALU零标志
    input jal
);

// 内部PC寄存器
reg [31:0] PC;

// 时钟上升沿触发
always @(posedge clk or negedge rst_n) begin
    // 异步低电平复位
    if (!rst_n) begin
        PC <= 32'd0;  // PC清零
    end 
    else begin
        if (jal) begin
            PC <= PC + imm;  // JAL指令跳转
        end
        else if (branch & ALU_zero) begin
            PC <= PC + imm;  // 条件分支跳转
        end
        else begin
            PC <= PC + 32'd4;  // 普通指令PC+4
        end
    end
end

// PC输出
always @(*) begin
    PCout <= PC;  // 将内部PC值赋给输出
end

endmodule