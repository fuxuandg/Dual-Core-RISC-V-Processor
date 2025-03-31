module MUX_2x1_32(
    input [31:0] I0,  // 输入0
    input [31:0] I1,  // 输入1
    input S,          // 选择信号
    output [31:0] Y   // 输出
);
    assign Y = S ? I1 : I0;  // 当S为1时选择I1，否则选择I0
endmodule
