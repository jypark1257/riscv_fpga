`timescale 1ns / 1ps

module fpga_top(
    input sysclk_n,
    input sysclk_p,
    input i_rst_n,
    
    input i_serial_rx,
    output reg rst_led,
    output reg tx_led, 
    output reg rx_led,
    output o_serial_tx
    );    
    
    wire sysclk;
    wire cpu_tx, cpu_rx;

    (* IOB = "true" *) reg fpga_serial_tx_iob;
    (* IOB = "true" *) reg fpga_serial_rx_iob;

    always @(posedge sysclk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            rst_led <= 1'b0;
            tx_led <= 1'b0;
            rx_led <= 1'b0;
        end else begin
            rst_led <= 1'b1;
            tx_led <= ~fpga_serial_tx_iob;
            rx_led <= ~fpga_serial_rx_iob;
        end
    end
    

    clk_wiz_0 u_clk_wiz (
        .clk_out1(sysclk),
        .clk_in1_p(sysclk_p),
        .clk_in1_n(sysclk_n)
    );

    //RVCORE_TOP #(
    //.CPU_CLOCK_FREQ(30_000_000)
    //) u_core_top (
    //    .clk(sysclk),
    //    .rst(i_rst_n),
    //    
    //    .FPGA_SERIAL_RX(cpu_rx),
    //    .FPGA_SERIAL_TX(cpu_tx)
    //);

    core_top #(
    .CPU_CLOCK_FREQ(30_000_000)
    ) u_core_top (
        .i_clk(sysclk),
        .i_rst_n(i_rst_n),
        
        .i_serial_rx(cpu_rx),
        .o_serial_tx(cpu_tx)
    );
    assign o_serial_tx = fpga_serial_tx_iob;
    assign cpu_rx = fpga_serial_rx_iob;
    always @(posedge sysclk) begin
        fpga_serial_tx_iob <= cpu_tx;
        fpga_serial_rx_iob <= i_serial_rx;
    end

    //ila_0 (
    //    .clk(sysclk),
    //    .probe0(sysclk),
    //    .probe1(rst_n),
    //    .probe2(f_serial_rx),
    //    .probe3(f_serial_tx)
    //);
    
    
    
endmodule
