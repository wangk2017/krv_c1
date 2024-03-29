
//Play a trick to let the simulation run faster

initial
begin
#5;
$display ("=========================================================================== \n");
$display ("Here is a trick to force the baud rate higher to make the simulation faster \n");
$display ("you can turn off the trick in tb/zephyr_phil_debug.v by comment the force \n");
$display ("=========================================================================== \n");
force DUT.u_uart.baud_val = 13'h4;
end



wire test_end1;
assign test_end1 = dec_pc == 32'h00001ae4;

integer fp_z;

initial
begin
	$display ("=============================================\n");
	$display ("running Zephyr OS application philosopher\n");
	$display ("=============================================\n");

	fp_z =$fopen ("./out/uart_tx_data_phil.txt","w");
@(posedge test_end1)
begin
@(posedge DUT.cpu_clk);
	$fclose(fp_z);
	$display ("=============================================\n");
	$display ("TEST_END\n");
	$display ("The application Print data is stored in \n");
	$display ("out/uart_tx_data_phil.txt\n");
	$display ("=============================================\n");
	$stop;
end
end

always @(posedge DUT.cpu_clk)
begin
	if(uart_tx_wr)
		begin
			$fwrite(fp_z, "%s", uart_tx_data);
			$display ("UART Transmitt DATA is %s ",uart_tx_data);
			$display ("\n");
		end

end
parameter MAIN 			= 32'h00000604;
parameter SWAP			= 32'h00000228;
parameter BG_THREAD_MAIN	= 32'h000021c0;
parameter PHIL			= 32'h000003c8;


//application process trace during simulation
always @(posedge DUT.cpu_clk)
begin
		case (dec_pc)
		MAIN:	//main
		begin
			$display ("Main Start");
			$display ("@time %t  !",$time);
			$display ("\n");
		end
		SWAP:// <__swap>
		begin
			$display ("swap Start");
			$display ("@time %t  !",$time);
			$display ("\n");
		end
		BG_THREAD_MAIN: //<bg_thread_main>
		begin
			$display ("bg_thread_main Start");
			$display ("@time %t  !",$time);
			$display ("\n");
		end
		PHIL:
		begin
			$display ("phil Start");
			$display ("@time %t  !",$time);
			$display ("\n");
		end

	endcase
end

wire [31:0] mem_addr = DUT.u_core.u_dmem_ctrl.mem_addr_mem;
wire [31:0] mem_wr_data = DUT.u_core.u_dmem_ctrl.store_data_mem;
wire mem_wr = DUT.u_core.u_dmem_ctrl.store_mem;
always @(posedge DUT.cpu_clk)
begin
	if(mem_wr && (mem_addr == 32'h412fc))
		begin
			$display ("write 412fc");
			$display ("@time %t  !",$time);
			$display ("\n");
		end
end

always @(posedge DUT.cpu_clk)
begin
	if(mem_wr && (mem_addr == 32'h4131c))
		begin
			$display ("write 4131c");
			$display ("@time %t  !",$time);
			$display ("\n");
		end
end

wire wb_valid = DUT.u_core.u_dec.wr_valid_wb;
wire[5:0] wb_rd = DUT.u_core.u_dec.rd_wb;
wire [31:0] wb_data = DUT.u_core.u_dec.wr_data_wb;


integer fp_t;

initial
begin

	fp_t =$fopen ("./out/GRPS1.txt","w");
@(posedge test_end1)
begin
@(posedge DUT.cpu_clk);
	$fclose(fp_t);
end
end


always @(posedge DUT.cpu_clk)
begin
	if(wb_valid && (wb_rd == 1))
		begin
			$fwrite(fp_t, "@time %t, write gprs1 = %h \n", $time, wb_data);
		end

end

