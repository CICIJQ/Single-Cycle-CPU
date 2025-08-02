module top(
    input wire clk,  // 时钟信号
    input wire rst   // 复位信号
    );
    
    // 内部信号声明
    wire rst_n = ~rst;  // 复位信号反相
    wire [31:0] instruct;  // 指令存储器读取的指令
    wire [31:0] address;  // 当前指令的地址
    wire [4:0] rd_address;  // 目标寄存器的地址
    wire branch, memread, memwrite, ALUsrc, regwrite, jal;
    wire [1:0] memtoreg, ALUop;
    wire [31:0] write_data, read_data1, read_data2, immediate, ALU_result, q1;
    wire ALU_zero;  // ALU计算结果是否为0
    wire [3:0] control_signal;  // 来自控制单元的控制信号
    
    wire [31:0] inst_addr_o;      // 指令存储器地址
    wire [31:0] data_addr_o;      // 数据存储器地址
    wire [31:0] data_o;           // 写入数据存储器的数据
    wire data_ce_o;               // 数据存储器使能
    wire data_we_o;               // 数据存储器写使能

    
    // inst_mem
     wire [31:0] inst_i;
     wire inst_ce = 1'b1;  // 统一使能信号
     
     // data_mem
     wire [31:0] data_i;     
    
     // 将PC输出连接到指令存储器地址
    assign inst_addr_o = address;
    
    // 激活数据存储器控制信号
    assign data_ce_o = memread | memwrite;
    assign data_we_o = memwrite;
    assign data_addr_o = ALU_result;  // ALU结果作为数据地址
    assign data_o = read_data2;       // 寄存器读端口2作为写入数据
    
     
     // PC寄存器
    PC_reg u_PC_reg (
        .clk(clk),
        .rst_n(rst_n),
        .PCout(address),
        .imm(immediate),
        .branch(branch),
        .ALU_zero(ALU_zero),
        .jal(jal)
    );
    
    // 指令存储器
    assign instruct = inst_i;  // 指令存储器的输出
    
    IM  instim(
	    .ce(inst_ce),
	    .addr(inst_addr_o),
	    .inst(inst_i)
    );
    
    // 寄存器
    register u_register (
        .clk(clk),
        .rst_n(rst_n),
        .read_register1(instruct[19:15]),
        .read_register2(instruct[24:20]),
        .write_register(instruct[11:7]),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .regwrite(regwrite)
    );
    
    // 控制单元
    control u_control (
        .instruction(instruct[6:0]),
        .branch(branch),
        .memread(memread),
        .memtoreg(memtoreg),
        .ALUop(ALUop),
        .memwrite(memwrite),
        .ALUsrc(ALUsrc),
        .regwrite(regwrite),
        .jal(jal)
    );
    
    // ALU控制单元
    alu_control u_ALUcontrol (
        .ALUop(ALUop),
        .instruction(instruct),
        .control_signal(control_signal)
    );
    
    // ALU
    alu u_ALU (
        .control_signal(control_signal),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate),
        .ALU_src(ALUsrc),
        .ALU_result(ALU_result),
        .ALU_zero(ALU_zero)
    );
    
    // 立即数生成器
    immgen u_immgen (
        .instruct(instruct),
        .immediate(immediate)
    );
    
    // 数据存储器接口
    assign q1 = data_i;           
    
    // 数据存储器
    DM DM_i (
        .clk(clk),
        .ce(data_ce_o),
        .we(data_we_o),
        .addr(data_addr_o),
        .data_i(data_o),
        .data_o(data_i)
    );
    
    // 多路选择器
    mux i8 (
        .memtoreg(memtoreg),
        .jal(jal),
        .out1(q1),              // memory output data
        .out2(ALU_result),
        .out3(address),
        .instruct(instruct),
        .writedata(write_data)
    );
    
    // 从指令中提取目标寄存器的地址
    assign rd_address = instruct[11:7];

endmodule
