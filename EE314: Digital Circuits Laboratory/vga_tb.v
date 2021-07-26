// vga_tb.v


module vga_tb();


reg CLK;

wire VGA_HS_O;      
wire VGA_VS_O;       
wire [7:0] VGA_R;    
wire [7:0] VGA_G;   
wire [7:0] VGA_B;    
wire VGA_CLK;

vga dut ( .CLK(CLK), .VGA_HS_O(VGA_HS_O),.VGA_VS_O(VGA_VS_O), .VGA_R(VGA_R),
							  .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_CLK(VGA_CLK)) ;
							  
initial begin
CLK = 0;
end
							  
							  
// Clock setup							  
always begin
 CLK <= 0; #0.00000002 ;  CLK <= 1; #0.00000002 ;
end

endmodule 
