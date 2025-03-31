`timescale 1ns/1ps

module proc_tb;

    // 输入信号
    reg clk;
    reg res;
    reg [31:0] instr_read_in;
    reg instr_gnt;
    reg instr_r_valid;
    reg [31:0] data_read;
    reg data_gnt;
    reg data_r_valid;
    reg irq;
    reg [4:0] irq_id;

    // 输出信号
    wire [31:0] instr_adr;
    wire instr_req;
    wire [31:0] data_write;
    wire [31:0] data_adr;
    wire data_req;
    wire data_write_enable;
    wire irq_ack;
    wire [4:0] irq_ack_id;

    // 实例化待测模块
    proc #(.CORE_ID(0)) uut (
        .clk(clk),
        .res(res),
        .instr_read_in(instr_read_in),
        .instr_gnt(instr_gnt),
        .instr_r_valid(instr_r_valid),
        .data_read(data_read),
        .data_gnt(data_gnt),
        .data_r_valid(data_r_valid),
        .irq(irq),
        .irq_id(irq_id),
        .instr_adr(instr_adr),
        .instr_req(instr_req),
        .data_write(data_write),
        .data_adr(data_adr),
        .data_req(data_req),
        .data_write_enable(data_write_enable),
        .irq_ack(irq_ack),
        .irq_ack_id(irq_ack_id)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz时钟
    end

    // 测试过程
    initial begin
        // 初始化
        res = 1;
        instr_read_in = 32'h0;
        instr_gnt = 0;
        instr_r_valid = 0;
        data_read = 32'h0;
        data_gnt = 0;
        data_r_valid = 0;
        irq = 0;
        irq_id = 5'h0;

        // 复位
        #20;
        res = 0;

        // 测试指令读取
        #10;
        instr_read_in = 32'h00000013; // NOP指令
        instr_gnt = 1;
        instr_r_valid = 1;
        #10;
        instr_gnt = 0;
        instr_r_valid = 0;

        // 测试数据读取
        #20;
        data_read = 32'h12345678;
        data_gnt = 1;
        data_r_valid = 1;
        #10;
        data_gnt = 0;
        data_r_valid = 0;

        // 测试中断
        #30;
        irq = 1;
        irq_id = 5'h1;
        #10;
        irq = 0;

        // 结束仿真
        #100;
        $stop;
    end

    // 波形记录
    initial begin
        $dumpfile("proc_tb.vcd");
        $dumpvars(0, proc_tb);
    end

endmodule