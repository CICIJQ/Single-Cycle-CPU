module top(
    input wire clk,  // ʱ���ź�
    input wire rst   // ��λ�ź�
    );
    
    // �ڲ��ź�����
    wire rst_n = ~rst;  // ��λ�źŷ���
    wire [31:0] instruct;  // ָ��洢����ȡ��ָ��
    wire [31:0] address;  // ��ǰָ��ĵ�ַ
    wire [4:0] rd_address;  // Ŀ��Ĵ����ĵ�ַ
    wire branch, memread, memwrite, ALUsrc, regwrite, jal;
    wire [1:0] memtoreg, ALUop;
    wire [31:0] write_data, read_data1, read_data2, immediate, ALU_result, q1;
    wire ALU_zero;  // ALU�������Ƿ�Ϊ0
    wire [3:0] control_signal;  // ���Կ��Ƶ�Ԫ�Ŀ����ź�
    
    wire [31:0] inst_addr_o;      // ָ��洢����ַ
    wire [31:0] data_addr_o;      // ���ݴ洢����ַ
    wire [31:0] data_o;           // д�����ݴ洢��������
    wire data_ce_o;               // ���ݴ洢��ʹ��
    wire data_we_o;               // ���ݴ洢��дʹ��

    
    // inst_mem
     wire [31:0] inst_i;
     wire inst_ce = 1'b1;  // ͳһʹ���ź�
     
     // data_mem
     wire [31:0] data_i;     
    
     // ��PC������ӵ�ָ��洢����ַ
    assign inst_addr_o = address;
    
    // �������ݴ洢�������ź�
    assign data_ce_o = memread | memwrite;
    assign data_we_o = memwrite;
    assign data_addr_o = ALU_result;  // ALU�����Ϊ���ݵ�ַ
    assign data_o = read_data2;       // �Ĵ������˿�2��Ϊд������
    
     
     // PC�Ĵ���
    PC_reg u_PC_reg (
        .clk(clk),
        .rst_n(rst_n),
        .PCout(address),
        .imm(immediate),
        .branch(branch),
        .ALU_zero(ALU_zero),
        .jal(jal)
    );
    
    // ָ��洢��
    assign instruct = inst_i;  // ָ��洢�������
    
    IM  instim(
	    .ce(inst_ce),
	    .addr(inst_addr_o),
	    .inst(inst_i)
    );
    
    // �Ĵ���
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
    
    // ���Ƶ�Ԫ
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
    
    // ALU���Ƶ�Ԫ
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
    
    // ������������
    immgen u_immgen (
        .instruct(instruct),
        .immediate(immediate)
    );
    
    // ���ݴ洢���ӿ�
    assign q1 = data_i;           
    
    // ���ݴ洢��
    DM DM_i (
        .clk(clk),
        .ce(data_ce_o),
        .we(data_we_o),
        .addr(data_addr_o),
        .data_i(data_o),
        .data_o(data_i)
    );
    
    // ��·ѡ����
    mux i8 (
        .memtoreg(memtoreg),
        .jal(jal),
        .out1(q1),              // memory output data
        .out2(ALU_result),
        .out3(address),
        .instruct(instruct),
        .writedata(write_data)
    );
    
    // ��ָ������ȡĿ��Ĵ����ĵ�ַ
    assign rd_address = instruct[11:7];

endmodule
