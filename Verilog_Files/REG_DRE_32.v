module REG_DRE_32(
    input [31:0] D,       // 数据输入
    output reg [31:0] Q,  // 数据输出
    input CLK,            // 时钟信号
    input RES,            // 复位信号，高电平有效
    input ENABLE          // 使能信号，高电平有效
);

    always @(posedge CLK or posedge RES) begin
        if (RES) begin
            Q <= 32'd0;  // 复位时输出清零
        end else if (ENABLE) begin
            Q <= D;      // 使能时在时钟上升沿保存输入数据
        end
    end

endmodule
