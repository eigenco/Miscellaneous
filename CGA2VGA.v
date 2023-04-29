module CGA(
	input            CLK50M,
	output reg [2:0] LED,
	input            CGA_R,
	input            CGA_G,
	input            CGA_B,
	input            CGA_I,
	input            CGA_H,
	input            CGA_V,
	output     [1:0] ANALOG_R,
	output     [1:0] ANALOG_G,
	output     [1:0] ANALOG_B,
	output           ANALOG_CSYNC
);

reg [31:0] cnt;
reg [31:0] Hcnt;
reg [31:0] Vcnt;
reg  [7:0] VSV;
reg  [7:0] HSV;
reg        VBL;
reg        HBL;

// some demos such as area 5150 cause pvms to display colors incorrectly
// this is due to missing blanking (even though syncs are there)
// we fix this by injecting our own blanking
always @(posedge CLK50M)
begin
	cnt <= cnt + 1;
	LED <= cnt[24:22];
	
	VSV <= {VSV[6:0], CGA_V};
	HSV <= {HSV[6:0], CGA_H};

	if(VSV[7:6]==2'b00 && VSV[1:0]==2'b11) Vcnt <= 0;
	else Vcnt <= Vcnt + 1;

	if(Vcnt<89700 || Vcnt>790000) VBL <= 0;
	else VBL <= 1;
	
	if(HSV[7:6]==2'b00 && HSV[1:0]==2'b11) Hcnt <= 0;
	else Hcnt <= Hcnt + 1;
	
	if(Hcnt<550 || Hcnt>2950) HBL <= 0;
	else HBL <= 1;
end

assign ANALOG_R[1:0] = HBL*VBL*(1*CGA_R+2*CGA_I);
assign ANALOG_G[1:0] = HBL*VBL*(((~CGA_I) & CGA_R & CGA_G & (~CGA_B)) ? 2 : 1*CGA_G+2*CGA_I); // brown instead of dark-yellow
assign ANALOG_B[1:0] = HBL*VBL*(1*CGA_B+2*CGA_I);
assign ANALOG_CSYNC = ~(CGA_H^CGA_V);

endmodule