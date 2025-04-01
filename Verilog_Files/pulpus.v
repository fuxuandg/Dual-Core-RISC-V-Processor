`timescale 1ns / 1ps

module pulpus(
    // BOARD SIGNALS
    input BOARD_CLK,
    input BOARD_RESN,
    input [3:0] BOARD_BUTTON,
    input [3:0] BOARD_SWITCH,
    input BOARD_UART_RX,
    output [3:0] BOARD_LED,
    output [2:0] BOARD_LED_RGB0,
    output [2:0] BOARD_LED_RGB1,
    output BOARD_VGA_HSYNC,
    output BOARD_VGA_VSYNC,
    output [3:0] BOARD_VGA_R,
    output [3:0] BOARD_VGA_G,
    output [3:0] BOARD_VGA_B,
    output BOARD_UART_TX,

    // CPU SIGNALS
    output CPU_CLK,
    output CPU_RES,
    output CACHE_RES,

    // Instruction memory interface
    input INSTR_REQ,
    output INSTR_GNT,
    output INSTR_RVALID,
    input [31:0] INSTR_ADDR,
    output [31:0] INSTR_RDATA,

    // Data memory interface
    input DATA_REQ,
    output DATA_GNT,
    output DATA_RVALID,
    input DATA_WE,
    input [3:0] DATA_BE,
    input [31:0] DATA_ADDR,
    input [31:0] DATA_WDATA,
    output [31:0] DATA_RDATA,

    // Interrupt outputs
    output IRQ,
    output [4:0] IRQ_ID,
    // Interrupt inputs
    input IRQ_ACK,
    input [4:0] IRQ_ACK_ID
);

// Internal logic
    reg [31:0] instr_mem [0:1023];
    reg [31:0] data_mem [0:1023];
    
    // Clock divider for simulation
    reg sim_clk;
    integer clk_div = 0;
    
    // Simulation control
    initial begin
        sim_clk = 0;
        forever #5 sim_clk = ~sim_clk;
    end
    
    // Instruction memory interface
    always @(posedge CPU_CLK) begin
        if (INSTR_REQ && INSTR_GNT) begin
            INSTR_RDATA <= instr_mem[INSTR_ADDR[11:2]];
            INSTR_RVALID <= 1;
        end else begin
            INSTR_RVALID <= 0;
        end
    end
    
    // Data memory interface
    always @(posedge CPU_CLK) begin
        if (DATA_REQ && DATA_GNT) begin
            if (DATA_WE) begin
                case (DATA_BE)
                    4'b0001: data_mem[DATA_ADDR[11:2]][7:0] <= DATA_WDATA[7:0];
                    4'b0010: data_mem[DATA_ADDR[11:2]][15:8] <= DATA_WDATA[15:8];
                    4'b0100: data_mem[DATA_ADDR[11:2]][23:16] <= DATA_WDATA[23:16];
                    4'b1000: data_mem[DATA_ADDR[11:2]][31:24] <= DATA_WDATA[31:24];
                    default: data_mem[DATA_ADDR[11:2]] <= DATA_WDATA;
                endcase
            end
            DATA_RDATA <= data_mem[DATA_ADDR[11:2]];
            DATA_RVALID <= 1;
        end else begin
            DATA_RVALID <= 0;
        end
    end
    
    // Peripheral simulation
    always @(posedge BOARD_CLK) begin
        BOARD_LED <= BOARD_SWITCH;
    end

endmodule