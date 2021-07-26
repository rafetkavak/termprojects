module quidditch(CLK,RST_BTN,up1,down1,right1,left1,up2,down2,right2,left2,VGA_HS_O,VGA_VS_O,VGA_R,VGA_G,VGA_B,VGA_CLK);

input wire CLK;             
input wire RST_BTN;         
input wire up1;
input wire down1;
input wire right1;
input wire left1;
input wire up2;
input wire down2;
input wire right2;
input wire left2;

output reg VGA_HS_O;      
output reg VGA_VS_O;       
output reg [7:0] VGA_R;    
output reg [7:0] VGA_G;   
output reg [7:0] VGA_B;    
output reg VGA_CLK;


reg [9:0] H_CNT, V_CNT,i;
reg [3:0] minute,firstsecond,lastsecond,score_blue,score_red,r1_inactive,r2_inactive,b1_inactive,b2_inactive,inactivation;


//Main Ball
reg [9:0] mainx;
reg [8:0] mainy;
integer  mainx_state;
integer  mainy_state;

//Bludger
reg [9:0] bludgerx;
reg [8:0] bludgery;
integer  bludgery_state;
integer  bludgerx_state;

//Red&Blue Balls
reg [9:0] b1x;
reg [8:0] b1y;
reg [9:0] b2x;
reg [8:0] b2y;
reg [9:0] r1x;
reg [8:0] r1y;
reg [9:0] r2x;
reg [8:0] r2y;

//Circles
reg [9:0] cb1x;
reg [8:0] cb1y;
reg [9:0] cb2x;
reg [8:0] cb2y;
reg [9:0] cb3x;
reg [8:0] cb3y;
reg [9:0] cr1x;
reg [8:0] cr1y;
reg [9:0] cr2x;
reg [8:0] cr2y;
reg [9:0] cr3x;
reg [8:0] cr3y;

//Squares
reg [9:0] bsqx;
reg [9:0] bsqy;
reg [9:0] rsqx;
reg [9:0] rsqy;

//Red&Blue Ball symbols
reg [9:0] b1sx;
reg [8:0] b1sy;
reg [9:0] b2sx;
reg [8:0] b2sy;
reg [9:0] r1sx;
reg [8:0] r1sy;
reg [9:0] r2sx;
reg [8:0] r2sy;


integer counter_clk,r1_counter, r2_counter, b1_counter, b2_counter,counter_clk2,j;
reg b1u,b1d,b2r,b2l,r1u,r1d,r2l,r2r,clk_en,clk_en2,the_end,red_win,blue_win,draw,the_end2;
wire cb1,cb2,cb3,cr1,cr2,cr3,border,ball,bludger,Ball,R1,R2,B1,B2,RED,GREEN,BLUE,R_light,G_light,B_light,blue_square,red_square,line,colon,R1_symbol,R2_symbol,B1_symbol,B2_symbol;
reg r1,r2,r3,r4,r5,r6,r7,b1,b2,b3,b4,b5,b6,b7,s1,s2,s3,s4,s5,s6,s7,ss1,ss2,ss3,ss4,ss5,ss6,ss7,m1,m2,m3,m4,m5,m6,m7;
reg r11,r12,r13,r14,r15,r16,r17,b11,b12,b13,b14,b15,b16,b17,r21,r22,r23,r24,r25,r26,r27,b21,b22,b23,b24,b25,b26,b27;
assign RED=border||cb1||cb2||cb3||cr1||cr2||cr3||R1||Ball||bludger||red_square||line||colon||r1||r2||r3||r4||r5||r6||r7||b1||b2||b3||b4||b5||b6||b7||s1||s2||s3||s4||s5||s6||s7||ss1||ss2||ss3||ss4||ss5||ss6||ss7||m1||m2||m3||m4||m5||m6||m7||R1_symbol||r11||r12||r13||r14||r15||r16||r17||b11||b12||b13||b14||b15||b16||b17||r21||r22||r23||r24||r25||r26||r27||b21||b22||b23||b24||b25||b26||b27||red_win;
assign GREEN=border||cb1||cb2||cb3||cr1||cr2||cr3||Ball||line||colon||r1||r2||r3||r4||r5||r6||r7||b1||b2||b3||b4||b5||b6||b7||s1||s2||s3||s4||s5||s6||s7||ss1||ss2||ss3||ss4||ss5||ss6||ss7||m1||m2||m3||m4||m5||m6||m7||r11||r12||r13||r14||r15||r16||r17||b11||b12||b13||b14||b15||b16||b17||r21||r22||r23||r24||r25||r26||r27||b21||b22||b23||b24||b25||b26||b27;
assign BLUE=border||cb1||cb2||cb3||cr1||cr2||cr3||B1||blue_square||line||colon||r1||r2||r3||r4||r5||r6||r7||b1||b2||b3||b4||b5||b6||b7||s1||s2||s3||s4||s5||s6||s7||ss1||ss2||ss3||ss4||ss5||ss6||ss7||m1||m2||m3||m4||m5||m6||m7||B1_symbol||r11||r12||r13||r14||r15||r16||r17||b11||b12||b13||b14||b15||b16||b17||r21||r22||r23||r24||r25||r26||r27||b21||b22||b23||b24||b25||b26||b27||blue_win;
assign R_light=R2||R2_symbol||red_win||draw;
assign G_light=bludger||draw;
assign B_light=B2||B2_symbol||blue_win||draw;


assign blue_square=(H_CNT<=35)&(H_CNT>=5)&(V_CNT<=35)&(V_CNT>=5);
assign red_square=(H_CNT<=160)&(H_CNT>=130)&(V_CNT<=35)&(V_CNT>=5);
assign line=(H_CNT<=90)&(H_CNT>=75)&(V_CNT<=21)&(V_CNT>=19);
assign colon=((H_CNT<=565)&(H_CNT>=563)&(V_CNT<=24)&(V_CNT>=22))||((H_CNT<=565)&(H_CNT>=563)&(V_CNT<=18)&(V_CNT>=16));
assign R1_symbol=((((H_CNT-r1sx)**2+(V_CNT-r1sy)**2)<=225));
assign R2_symbol=((((H_CNT-r2sx)**2+(V_CNT-r2sy)**2)<=225));
assign B1_symbol=((((H_CNT-b1sx)**2+(V_CNT-b1sy)**2)<=225));
assign B2_symbol=((((H_CNT-b2sx)**2+(V_CNT-b2sy)**2)<=225));

assign cb1 = ((((H_CNT-cb1x)*(H_CNT-cb1x)+(V_CNT-cb1y)*(V_CNT-cb1y))<=900)-(((H_CNT-cb1x)*(H_CNT-cb1x)+(V_CNT-cb1y)*(V_CNT-cb1y))<=750));
assign cb2 = ((((H_CNT-cb2x)*(H_CNT-cb2x)+(V_CNT-cb2y)*(V_CNT-cb2y))<=900)-(((H_CNT-cb2x)*(H_CNT-cb2x)+(V_CNT-cb2y)*(V_CNT-cb2y))<=750));
assign cb3 = ((((H_CNT-cb3x)*(H_CNT-cb3x)+(V_CNT-cb3y)*(V_CNT-cb3y))<=900)-(((H_CNT-cb3x)*(H_CNT-cb3x)+(V_CNT-cb3y)*(V_CNT-cb3y))<=750));
assign cr1 = ((((H_CNT-cr1x)*(H_CNT-cr1x)+(V_CNT-cr1y)*(V_CNT-cr1y))<=900)-(((H_CNT-cr1x)*(H_CNT-cr1x)+(V_CNT-cr1y)*(V_CNT-cr1y))<=750));
assign cr2 = ((((H_CNT-cr2x)*(H_CNT-cr2x)+(V_CNT-cr2y)*(V_CNT-cr2y))<=900)-(((H_CNT-cr2x)*(H_CNT-cr2x)+(V_CNT-cr2y)*(V_CNT-cr2y))<=750));
assign cr3 = ((((H_CNT-cr3x)*(H_CNT-cr3x)+(V_CNT-cr3y)*(V_CNT-cr3y))<=900)-(((H_CNT-cr3x)*(H_CNT-cr3x)+(V_CNT-cr3y)*(V_CNT-cr3y))<=750));
assign border = (V_CNT==0)||(V_CNT==39)||(V_CNT==259)||(V_CNT==479)||(H_CNT==0)||(H_CNT==639);

assign bludger=((((H_CNT-bludgerx)*(H_CNT-bludgerx)+(V_CNT-bludgery)*(V_CNT-bludgery))<= 121));
assign Ball=((((H_CNT-mainx)**2+(V_CNT-mainy)**2)<= 225));
assign R1=((((H_CNT-r1x)**2+(V_CNT-r1y)**2)<=900));
assign R2=((((H_CNT-r2x)**2+(V_CNT-r2y)**2)<=900));
assign B1=((((H_CNT-b1x)**2+(V_CNT-b1y)**2)<=900));
assign B2=((((H_CNT-b2x)**2+(V_CNT-b2y)**2)<=900));





//INITIAL CONDITIONS
initial begin
	VGA_CLK=0;
	VGA_HS_O=0;
	VGA_VS_O=0;
	VGA_R=0;
	VGA_G=0;
	VGA_B=0;
	H_CNT=0;
	V_CNT=0;
	counter_clk = 0;
	clk_en=0;
	r1_counter=0;
	r2_counter=0;
	b1_counter=0;
	b2_counter=0;
	counter_clk2 = 0;
	clk_en2=0;
	
	score_blue=0;
	score_red=0;
	minute=3;
	firstsecond=0;
	lastsecond=0;
	the_end=0;
	the_end2=0;
	r1_inactive=0;
	r2_inactive=0;
	b1_inactive=0;
	b2_inactive=0;
	j=0;
	
	bsqx=20;
	bsqy=20;
	rsqx=115;
	rsqy=20;
	
	mainx_state=2; //2: up ,1:down
	mainy_state=2; //2: left , 1:right
	bludgerx_state=1; 
   bludgery_state=1;
	
	mainx=275;
	mainy=230;
	bludgerx=365; 
   bludgery=290;
	
   b1x=100;
	b1y=210;
	b2x=540;
	b2y=220;
   r1x=100;
	r1y=310;
	r2x=540;
	r2y=300;
	
	b1sx=195;
	b1sy=20;
	b2sx=275;
	b2sy=20;
   r1sx=355;
	r1sy=20;
	r2sx=435;
	r2sy=20;
	
	b1u=0;
	b1d=0;
	b2l=0;
	b2r=0;
	r1u=0;
	r1d=0;
	r2l=0;
	r2r=0;
	
	cb1x=230; 
	cb1y=80;
	cb2x=320;
	cb2y=100;
	cb3x=410;
	cb3y=80;
	cr1x=230;
	cr1y=440;
	cr2x=320;
	cr2y=420;
	cr3x=410;
	cr3y=440;
end




//CLOCK DIVIDER
always @ (posedge CLK) begin
	VGA_CLK <= ~VGA_CLK;
end

//VGA MODULE 
always @ (posedge VGA_CLK) begin
	if (H_CNT<799)
		H_CNT=H_CNT+1;
	else
		begin
			H_CNT=0;
			if (V_CNT< 520)
			V_CNT=V_CNT+1;
			else
			V_CNT=0;
		end
	if (H_CNT>655 & H_CNT<751)
			VGA_HS_O = 0;
		else
			VGA_HS_O = 1;
	if (V_CNT>489 & V_CNT<491)
			VGA_VS_O = 0;
		else
			VGA_VS_O = 1;
end


//ASSIGNING INPUTS TO REGISTERS
always @ (posedge CLK) begin
	b1u<=up1;
	b1d<=down1;
	b2l<=left1;
	b2r<=right1;
	r1u<=up2;
	r1d<=down2;
	r2l<=left2;
	r2r<=right2;
end
//CREATING CLOCK ENABLE SIGNAL
always @ (posedge CLK) begin
	if(counter_clk == 'd399999) begin
			counter_clk <= 'd0;
			clk_en = 1;
		end 
	else begin
			counter_clk <= counter_clk +1;
			clk_en <= 0;
		end
end
//CREATING REAL CLOCK
always @ (posedge CLK) begin
	if(counter_clk2 == 'd49999999) begin
			counter_clk2 <= 'd0;
			clk_en2 = 1;
		end 
	else begin
			counter_clk2 <= counter_clk2 +1;
			clk_en2 <= 0;
		end
end

//PLAYER MOVEMENTS
always @ (posedge CLK) begin
	if(RST_BTN==0) begin
		b1x=100;
		b1y=210;
		b2x=540;
		b2y=220;
		r1x=100;
		r1y=310;
		r2x=540;
		r2y=300;
	end else begin
	if (clk_en==1) begin
// Red player 1 movements
		if ((b1u==1)&(b1y>70)) begin b1y<=b1y-1; end // goes up
		if ((b1d==1)&(b1y<230)) begin b1y<=b1y+1; end // goes down
// Red player 2 movements		
		if ((b2l==1)&(b2x>90)) begin b2x<=b2x-1; end // goes left
		if ((b2r==1)&(b2x<610)) begin b2x<=b2x+1; end // goes right
// Blue player 1 movements
		if ((r1u==1)&(r1y>290)) begin r1y<=r1y-1; end // goes up
		if ((r1d==1)&(r1y<450)) begin r1y<=r1y+1; end // goes down
// Blue player 2 movements
		if ((r2l==1)&(r2x>90)) begin r2x<=r2x-1; end // goes left
		if ((r2r==1)&(r2x<610)) begin r2x<=r2x+1; end // goes right
	end
	end
end


//BALL&BLUDGER MOVEMENTS
always @ (posedge CLK) begin
	if(RST_BTN==0) begin
//		mainx_state=2; //2: up ,1:down
//		mainy_state=2; //2: left , 1:right
//		bludgerx_state=1; 
//		bludgery_state=1;
		
		mainx=275;
		mainy=230;
		bludgerx=365; 
		bludgery=290;
	end else begin
	if (clk_en==1) begin
		if(j<=2) begin j<=j+1; end //IMPPPP
		else j<=0;
// BALL MOVEMENT IN Y
		if (mainy_state==3) begin mainy<=230+mainy-1; end // initial state
		if (mainy_state==2) begin mainy<=mainy-1;  end // goes up
		if (mainy_state==1) begin mainy<=mainy+1; end // goes down
		if (mainy_state==0) begin mainy<=mainy; end // no change
// BALL MOVEMENT IN X
		if (mainx_state==3) begin mainx<=275+mainx-1; end // initial state
		if (mainx_state==2) begin mainx<= mainx-1; end // goes left
		if (mainx_state==1) begin mainx<= mainx+1; end // goes right
		if (mainx_state==0) begin mainx<= mainx; end // no change
// BLUDGER MOVEMENT IN Y
		if (bludgery_state==3) begin bludgery<=290+bludgery+1; end // initial state
		if (bludgery_state==2) begin bludgery<=bludgery-1;  end // goes up
		if (bludgery_state==1) begin bludgery<=bludgery+1; end // goes down
		if (bludgery_state==0) begin bludgery<=bludgery; end // no change
// BLUDGER MOVEMENT IN X
		if (bludgerx_state==3) begin bludgerx<=365+bludgerx+1; end // initial state
		if (bludgerx_state==2) begin bludgerx<= bludgerx-1; end // goes left
		if (bludgerx_state==1) begin bludgerx<= bludgerx+1; end // goes right
		if (bludgerx_state==0) begin bludgerx<= bludgerx; end // no change
	end
	end
end


//INTERACTIONS & END & COUNTDOWN & GOAL
always @ (posedge CLK) begin
	if(RST_BTN==0) begin
		score_blue=0;
		score_red=0;
		minute=3;
		firstsecond=0;
		lastsecond=0;
		the_end=0;
		the_end2=0;
	end else begin
	if (clk_en==1) begin		
	
//BORDER INTERACTIONS
//Bludger
		if ((bludgery >= 466)&(bludgery <= 470)&(bludgerx<640)&(bludgerx>0)&(bludgery_state==1) ) // bottom border interaction 1
		begin bludgery_state <= 2 ; bludgerx_state <= j; end
		else if ((bludgery >= 49)&(bludgery <= 53)&(bludgerx<640)&(bludgerx>0)&(bludgery_state==2) ) // top border interaction 1
		begin bludgery_state <= 1 ; bludgerx_state <= j; end
		else if ((bludgerx >= 9)&(bludgerx <= 13)&(bludgery<480)&(bludgery>40)&(bludgerx_state==2)) // left border interaction 1
		begin bludgery_state <= j ; bludgerx_state <= 1; end
		else if ((bludgerx >= 626)&(bludgerx <= 630)&(bludgery<480)&(bludgery>40)&(bludgerx_state==1) ) // right border interaction 1
		begin bludgery_state <= j ; bludgerx_state <= 2; end

//Main Ball
		else if ((mainy == 465)&(mainy_state==1) ) // bottom border interaction
		begin mainy_state <= 2 ; mainx_state <= mainx_state; end
		else if ((mainy == 55)&(mainy_state==2) ) // top border interaction
		begin mainy_state <= 1 ;mainx_state <= mainx_state; end
		else if ((mainx == 15)&(mainx_state==2) ) // left border interaction
		begin mainx_state <= 1 ; mainy_state<=mainy_state; end
		else if ((mainx == 625)&(mainx_state==1) ) // right border interaction
		begin mainx_state <= 2 ; mainy_state<=mainy_state; end

//PLAYER&BALL INTERACTIONS
	
		//FOR RED PLAYER 1 & BALL
		else if((r1y-mainy==45)&((r1x-mainx<=12)||(mainx-r1x<=12))) //1
		begin mainx_state<=0; mainy_state<=2; end
		else if((mainx-r1x==45)&((r1y-mainy<=12)||(mainy-r1y<=12))) //2
		begin mainx_state<=1; mainy_state<=0; end
		else if((mainy-r1y==45)&((r1x-mainx<=12)||(mainx-r1x<=12))) //3
		begin mainx_state<=0; mainy_state<=1; end
		else if((r1x-mainx==45)&((r1y-mainy<=12)||(mainy-r1y<=12))) //4
		begin mainx_state<=2; mainy_state<=0; end
		else if ((mainx-r1x<=45)&(mainx-r1x>=12)&(r1y-mainy<=45)&(r1y-mainy>=12)) //5
		begin mainx_state<=1; mainy_state<=2; end
		else if ((mainx-r1x<=45)&(mainx-r1x>=12)&(mainy-r1y<=45)&(mainy-r1y>=12)) //6
		begin mainx_state<=1; mainy_state<=1; end
		else if ((r1x-mainx<=45)&(r1x-mainx>=12)&(mainy-r1y<=45)&(mainy-r1y>=12)) //7
		begin mainx_state<=2; mainy_state<=1; end
		else if ((r1x-mainx<=45)&(r1x-mainx>=12)&(r1y-mainy<=45)&(r1y-mainy>=12)) //8
		begin mainx_state<=2; mainy_state<=2; end
		
		//FOR RED PLAYER 2 & BALL
		else if((r2y-mainy==45)&((r2x-mainx<=12)||(mainx-r2x<=12))) //1
		begin mainx_state<=0; mainy_state<=2; end
		else if((mainx-r2x==45)&((r2y-mainy<=12)||(mainy-r2y<=12))) //2
		begin mainx_state<=1; mainy_state<=0; end
		else if((mainy-r2y==45)&((r2x-mainx<=12)||(mainx-r2x<=12))) //3
		begin mainx_state<=0; mainy_state<=1; end
		else if((r2x-mainx==45)&((r2y-mainy<=12)||(mainy-r2y<=12))) //4
		begin mainx_state<=2; mainy_state<=0; end
		else if ((mainx-r2x<=45)&(mainx-r2x>=12)&(r2y-mainy<=45)&(r2y-mainy>=12)) //5
		begin mainx_state<=1; mainy_state<=2; end
		else if ((mainx-r2x<=45)&(mainx-r2x>=12)&(mainy-r2y<=45)&(mainy-r2y>=12)) //6
		begin mainx_state<=1; mainy_state<=1; end
		else if ((r2x-mainx<=45)&(r2x-mainx>=12)&(mainy-r2y<=45)&(mainy-r2y>=12)) //7
		begin mainx_state<=2; mainy_state<=1; end
		else if ((r2x-mainx<=45)&(r2x-mainx>=12)&(r2y-mainy<=45)&(r2y-mainy>=12)) //8
		begin mainx_state<=2; mainy_state<=2; end
		
		//FOR BLUE PLAYER 1 & BALL
		else if((b1y-mainy==45)&((b1x-mainx<=12)||(mainx-b1x<=12))) //1
		begin mainx_state<=0; mainy_state<=2; end
		else if((mainx-b1x==45)&((b1y-mainy<=12)||(mainy-b1y<=12))) //2
		begin mainx_state<=1; mainy_state<=0; end
		else if((mainy-b1y==45)&((b1x-mainx<=12)||(mainx-b1x<=12))) //3
		begin mainx_state<=0; mainy_state<=1; end
		else if((b1x-mainx==45)&((b1y-mainy<=12)||(mainy-b1y<=12))) //4
		begin mainx_state<=2; mainy_state<=0; end
		else if ((mainx-b1x<=45)&(mainx-b1x>=12)&(b1y-mainy<=45)&(b1y-mainy>=12)) //5
		begin mainx_state<=1; mainy_state<=2; end
		else if ((mainx-b1x<=45)&(mainx-b1x>=12)&(mainy-b1y<=45)&(mainy-b1y>=12)) //6
		begin mainx_state<=1; mainy_state<=1; end
		else if ((b1x-mainx<=45)&(b1x-mainx>=12)&(mainy-b1y<=45)&(mainy-b1y>=12)) //7
		begin mainx_state<=2; mainy_state<=1; end
		else if ((b1x-mainx<=45)&(b1x-mainx>=12)&(b1y-mainy<=45)&(b1y-mainy>=12)) //8
		begin mainx_state<=2; mainy_state<=2; end
	
		//FOR BLUE PLAYER 2 & BALL
		else if((b2y-mainy==45)&((b2x-mainx<=12)||(mainx-b2x<=12))) //1
		begin mainx_state<=0; mainy_state<=2; end
		else if((mainx-b2x==45)&((b2y-mainy<=12)||(mainy-b2y<=12))) //2
		begin mainx_state<=1; mainy_state<=0; end
		else if((mainy-b2y==45)&((b2x-mainx<=12)||(mainx-b2x<=12))) //3
		begin mainx_state<=0; mainy_state<=1; end
		else if((b2x-mainx==45)&((b2y-mainy<=12)||(mainy-b2y<=12))) //4
		begin mainx_state<=2; mainy_state<=0; end
		else if ((mainx-b2x<=45)&(mainx-b2x>=12)&(b2y-mainy<=45)&(b2y-mainy>=12)) //5
		begin mainx_state<=1; mainy_state<=2; end
		else if ((mainx-b2x<=45)&(mainx-b2x>=12)&(mainy-b2y<=45)&(mainy-b2y>=12)) //6
		begin mainx_state<=1; mainy_state<=1; end
		else if ((b2x-mainx<=45)&(b2x-mainx>=12)&(mainy-b2y<=45)&(mainy-b2y>=12)) //7
		begin mainx_state<=2; mainy_state<=1; end
		else if ((b2x-mainx<=45)&(b2x-mainx>=12)&(b2y-mainy<=45)&(b2y-mainy>=12)) //8
		begin mainx_state<=2; mainy_state<=2; end

//PLAYER&BLUDGER INTERACTIONS
	
		//FOR RED PLAYER 1 & BLUDGER
		else if((r1y-bludgery==41)&((r1x-bludgerx<=12)&(bludgerx-r1x<=12))) //1
		begin	bludgerx_state<=0;bludgery_state<=2; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if((bludgerx-r1x==41)&((r1y-bludgery<=12)||(bludgery-r1y<=12))) //2
		begin bludgerx_state<=1; bludgery_state<=0; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if((bludgery-r1y==41)&((r1x-bludgerx<=12)||(bludgerx-r1x<=12))) //3
		begin bludgerx_state<=0; bludgery_state<=1; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if((r1x-bludgerx==41)&((r1y-bludgery<=12)||(bludgery-r1y<=12))) //4
		begin bludgerx_state<=2; bludgery_state<=0; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if ((bludgerx-r1x<=41)&(bludgerx-r1x>=12)&(r1y-bludgery<=45)&(r1y-bludgery>=12)) //5
		begin bludgerx_state<=1; bludgery_state<=2; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if ((bludgerx-r1x<=41)&(bludgerx-r1x>=12)&(bludgery-r1y<=45)&(bludgery-r1y>=12)) //6
		begin bludgerx_state<=1; bludgery_state<=1; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if ((r1x-bludgerx<=41)&(r1x-bludgerx>=12)&(bludgery-r1y<=45)&(bludgery-r1y>=12)) //7
		begin bludgerx_state<=2; bludgery_state<=1; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		else if ((r1x-bludgerx<=41)&(r1x-bludgerx>=12)&(r1y-bludgery<=45)&(r1y-bludgery>=12)) //8
		begin bludgerx_state<=2; bludgery_state<=2; r1x<=r1x;r1y<=r1y; inactivation<=0; end
		
		//FOR RED PLAYER 2 & BLUDGER
		else if((r2y-bludgery==41)&((r2x-bludgerx<=12)||(bludgerx-r2x<=12))) //1
		begin bludgerx_state<=0; bludgery_state<=2; end
		else if((bludgerx-r2x==41)&((r2y-bludgery<=12)||(bludgery-r2y<=12))) //2
		begin bludgerx_state<=1; bludgery_state<=0; end
		else if((bludgery-r2y==41)&((r2x-bludgerx<=12)||(bludgerx-r2x<=12))) //3
		begin bludgerx_state<=0; bludgery_state<=1; end
		else if((r2x-bludgerx==41)&((r2y-bludgery<=12)||(bludgery-r2y<=12))) //4
		begin bludgerx_state<=2; bludgery_state<=0; end
		else if ((bludgerx-r2x<=41)&(bludgerx-r2x>=12)&(r2y-bludgery<=45)&(r2y-bludgery>=12)) //5
		begin bludgerx_state<=1; bludgery_state<=2; end
		else if ((bludgerx-r2x<=41)&(bludgerx-r2x>=12)&(bludgery-r2y<=45)&(bludgery-r2y>=12)) //6
		begin bludgerx_state<=1; bludgery_state<=1; end
		else if ((r2x-bludgerx<=41)&(r2x-bludgerx>=12)&(bludgery-r2y<=45)&(bludgery-r2y>=12)) //7
		begin bludgerx_state<=2; bludgery_state<=1; end
		else if ((r2x-bludgerx<=41)&(r2x-bludgerx>=12)&(r2y-bludgery<=45)&(r2y-bludgery>=12)) //8
		begin bludgerx_state<=2; bludgery_state<=2; end
		
		//FOR BLUE PLAYER 1 & BLUDGER
		else if((b1y-bludgery==41)&((b1x-bludgerx<=12)||(bludgerx-b1x<=12))) //1
		begin bludgerx_state<=0; bludgery_state<=2; end
		else if((bludgerx-b1x==41)&((b1y-bludgery<=12)||(bludgery-b1y<=12))) //2
		begin bludgerx_state<=1; bludgery_state<=0; end
		else if((bludgery-b1y==41)&((b1x-bludgerx<=12)||(bludgerx-b1x<=12))) //3
		begin bludgerx_state<=0; bludgery_state<=1; end
		else if((b1x-bludgerx==41)&((b1y-bludgery<=12)||(bludgery-b1y<=12))) //4
		begin bludgerx_state<=2; bludgery_state<=0; end
		else if ((bludgerx-b1x<=41)&(bludgerx-b1x>=12)&(b1y-bludgery<=45)&(b1y-bludgery>=12)) //5
		begin bludgerx_state<=1; bludgery_state<=2; end
		else if ((bludgerx-b1x<=41)&(bludgerx-b1x>=12)&(bludgery-b1y<=45)&(bludgery-b1y>=12)) //6
		begin bludgerx_state<=1; bludgery_state<=1; end
		else if ((b1x-bludgerx<=41)&(b1x-bludgerx>=12)&(bludgery-b1y<=45)&(bludgery-b1y>=12)) //7
		begin bludgerx_state<=2; bludgery_state<=1; end
		else if ((b1x-bludgerx<=41)&(b1x-bludgerx>=12)&(b1y-bludgery<=45)&(b1y-bludgery>=12)) //8
		begin bludgerx_state<=2; bludgery_state<=2; end
	
		//FOR BLUE PLAYER 2 & BLUDGER
		else if((b2y-bludgery==41)&((b2x-bludgerx<=12)||(bludgerx-b2x<=12))) //1
		begin bludgerx_state<=0; bludgery_state<=2; end
		else if((bludgerx-b2x==41)&((b2y-bludgery<=12)||(bludgery-b2y<=12))) //2
		begin bludgerx_state<=1; bludgery_state<=0; end
		else if((bludgery-b2y==41)&((b2x-bludgerx<=12)||(bludgerx-b2x<=12))) //3
		begin bludgerx_state<=0; bludgery_state<=1; end
		else if((b2x-bludgerx==41)&((b2y-bludgery<=12)||(bludgery-b2y<=12))) //4
		begin bludgerx_state<=2; bludgery_state<=0; end
		else if ((bludgerx-b2x<=41)&(bludgerx-b2x>=12)&(b2y-bludgery<=45)&(b2y-bludgery>=12)) //5
		begin bludgerx_state<=1; bludgery_state<=2; end
		else if ((bludgerx-b2x<=41)&(bludgerx-b2x>=12)&(bludgery-b2y<=45)&(bludgery-b2y>=12)) //6
		begin bludgerx_state<=1; bludgery_state<=1; end
		else if ((b2x-bludgerx<=41)&(b2x-bludgerx>=12)&(bludgery-b2y<=45)&(bludgery-b2y>=12)) //7
		begin bludgerx_state<=2; bludgery_state<=1; end
		else if ((b2x-bludgerx<=41)&(b2x-bludgerx>=12)&(b2y-bludgery<=45)&(b2y-bludgery>=12)) //8
		begin bludgerx_state<=2; bludgery_state<=2; end
	

		
//GOAL CONDITIONS
		else if ((cb1x-mainx)**2+(cb1y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3; mainx_state<=3; mainy_state<=3; score_red<=score_red+1; end
		else if ((cb2x-mainx)**2+(cb2y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3; mainx_state<=3; mainy_state<=3; score_red<=score_red+1; end
		else if ((cb3x-mainx)**2+(cb3y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3;  mainx_state<=3; mainy_state<=3; score_red<=score_red+1; end
		else if ((cr1x-mainx)**2+(cr1y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3;  mainx_state<=3; mainy_state<=3; score_blue<=score_blue+1; end
		else if ((cr2x-mainx)**2+(cr2y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3;  mainx_state<=3; mainy_state<=3; score_blue<=score_blue+1; end
		else if ((cr3x-mainx)**2+(cr3y-mainy)**2<=225)
		begin bludgerx_state<=3; bludgery_state<=3;  mainx_state<=3; mainy_state<=3; score_blue<=score_blue+1; end
	end
	
//END	 
		if((lastsecond==0)&(firstsecond==0)&(minute==0))
			begin 
					the_end<=1;
					if (the_end==1 & score_blue>score_red)
						begin blue_win <= (V_CNT>0)&(V_CNT<40)& (H_CNT>0) &(H_CNT<639); mainx<=mainx;mainy<=mainy; bludgerx<=bludgerx; bludgery<=bludgery;end 
					if (the_end==1 & score_blue<score_red)
						begin red_win <= (V_CNT>0)&(V_CNT<40)& (H_CNT>0) &(H_CNT<639); mainx<=mainx;mainy<=mainy; bludgerx<=bludgerx; bludgery<=bludgery;end 
					if (the_end==1 & score_blue==score_red)
						begin draw <= (V_CNT>0)&(V_CNT<40)& (H_CNT>0) &(H_CNT<639); mainx<=mainx;mainy<=mainy; bludgerx<=bludgerx; bludgery<=bludgery;end 
			end
		
//COUNTDOWN	
		if (clk_en2==1&the_end==0) begin
			if ((lastsecond!=0)&(the_end==0))
				begin lastsecond<=lastsecond-1; end
			else if((lastsecond==0)&(firstsecond!=0)&(the_end==0))
				begin lastsecond<=9; firstsecond<=firstsecond-1; end
			else if ((lastsecond==0)&(firstsecond==0)&(the_end==0))
				begin lastsecond<=9; firstsecond<=5; end
		if ((firstsecond==0)&(minute!=0)&(lastsecond==0)&(the_end==0))
			begin firstsecond<=5; minute<=minute-1; end
		else if ((firstsecond==0)&(lastsecond==0)&(minute==0)&(the_end==0))
			begin firstsecond<=5; minute<=0; end
		end
	end
end



////always @(posedge CLK) begin
//
////
////always @(posedge CLK) begin
//// if((inactivation==0)&(r1_inactive==0))
////	begin inactivation<=4; end
////end
//
//
//////BLUDGER CASE
////always @(posedge CLK) begin
////	case(inactivation)
////		0:begin
////			r1_inactive<=9;
////			if ((clk_en2==1)&(the_end2==0)&(r1_inactive!=0))
////				begin	r1_inactive<=r1_inactive-1; end
////			else if (r1_inactive==0) 
////				begin the_end2<=1; end		
////			end
////			
////			
////		1: begin
////			
////				 r2_inactive<=9;
////					if(r2_inactive!=0) 
////						begin r2_inactive<=r2_inactive-1;  end
////						
////						
////			end
////		2: begin
////			
////				  b1_inactive<=9;
////					if(b1_inactive!=0) 
////						begin b1_inactive<=b1_inactive-1;  end
////						
////						
////			end
////		3: begin
////			
////				  b2_inactive<=9;
////					if(b2_inactive!=0) 
////						begin b2_inactive<=b2_inactive-1;  end
////						
////						
////			end
////		4: begin
////			if (clk_en2==1)
////				 begin r1_inactive<=0; r2_inactive<=0; b1_inactive<=0; b2_inactive<=0; end
////						
////			end
////	endcase
////end	
//


//SCORE & TIME
always @(posedge CLK) begin
	case(minute)
		0: begin
			m1=(V_CNT==5)&((H_CNT>=528)&(H_CNT<=558));
			m2=(H_CNT==558)&((V_CNT>=5)&(V_CNT<=20));
			m3=(H_CNT==558)&((V_CNT>=20)&(V_CNT<=35));
			m4=(V_CNT==35)&((H_CNT>=528)&(H_CNT<=558));
			m5=(H_CNT==528)&((V_CNT>=20)&(V_CNT<=35));
			m6=(H_CNT==528)&((V_CNT>=5)&(V_CNT<=20));
			m7=0;
			end
		1: begin
		   m1=0;
			m2=(H_CNT==558)&((V_CNT>=5)&(V_CNT<=20));
			m3=(H_CNT==558)&((V_CNT>=20)&(V_CNT<=35));
			m4=0;
			m5=0;
			m6=0;
			m7=0;
			end
		2: begin
			m1=(V_CNT==5)&((H_CNT>=528)&(H_CNT<=558));
			m2=(H_CNT==558)&((V_CNT>=5)&(V_CNT<=20));
			m3=0;
			m4=(V_CNT==35)&((H_CNT>=528)&(H_CNT<=558));
			m5=(H_CNT==528)&((V_CNT>=20)&(V_CNT<=35));
			m6=0;
			m7=(V_CNT==20)&((H_CNT>=528)&(H_CNT<=558));
			end
		3: begin
			m1=(V_CNT==5)&((H_CNT>=528)&(H_CNT<=558));
			m2=(H_CNT==558)&((V_CNT>=5)&(V_CNT<=20));
			m3=(H_CNT==558)&((V_CNT>=20)&(V_CNT<=35));
			m4=(V_CNT==35)&((H_CNT>=528)&(H_CNT<=558));
			m5=0;
			m6=0;
			m7=(V_CNT==20)&((H_CNT>=528)&(H_CNT<=558));
			end
	endcase
end


always @(posedge CLK) begin
	case(lastsecond)
		0: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=(H_CNT==605)&((V_CNT>=20)&(V_CNT<=35));
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=0;
			end
		1: begin
		   s1=0;
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=0;
			s5=0;
			s6=0;
			s7=0;
			end
		2: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=0;
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=(H_CNT==605)&((V_CNT>=20)&(V_CNT<=35));
			s6=0;
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		3: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=0;
			s6=0;
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		4: begin
			s1=0;
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=0;
			s5=0;
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		5: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=0;
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=0;
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		6: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=0;
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=(H_CNT==605)&((V_CNT>=20)&(V_CNT<=35));
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		7: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=0;
			s5=0;
			s6=0;
			s7=0;
			end
		8: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=(H_CNT==605)&((V_CNT>=20)&(V_CNT<=35));
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
		9: begin
			s1=(V_CNT==5)&((H_CNT>=605)&(H_CNT<=635));
			s2=(H_CNT==635)&((V_CNT>=5)&(V_CNT<=20));
			s3=(H_CNT==635)&((V_CNT>=20)&(V_CNT<=35));
			s4=(V_CNT==35)&((H_CNT>=605)&(H_CNT<=635));
			s5=0;
			s6=(H_CNT==605)&((V_CNT>=5)&(V_CNT<=20));
			s7=(V_CNT==20)&((H_CNT>=605)&(H_CNT<=635));
			end
	endcase
end


always @(posedge CLK) begin
	case(firstsecond)
		0: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=(H_CNT==570)&((V_CNT>=20)&(V_CNT<=35));
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=0;
			end
		1: begin
		   ss1=0;
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=0;
			ss5=0;
			ss6=0;
			ss7=0;
			end
		2: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=0;
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=(H_CNT==570)&((V_CNT>=20)&(V_CNT<=35));
			ss6=0;
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		3: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=0;
			ss6=0;
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		4: begin
			ss1=0;
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=0;
			ss5=0;
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		5: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=0;
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=0;
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		6: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=0;
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=(H_CNT==570)&((V_CNT>=20)&(V_CNT<=35));
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		7: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=0;
			ss5=0;
			ss6=0;
			ss7=0;
			end
		8: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=(H_CNT==570)&((V_CNT>=20)&(V_CNT<=35));
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
		9: begin
			ss1=(V_CNT==5)&((H_CNT>=570)&(H_CNT<=600));
			ss2=(H_CNT==600)&((V_CNT>=5)&(V_CNT<=20));
			ss3=(H_CNT==600)&((V_CNT>=20)&(V_CNT<=35));
			ss4=(V_CNT==35)&((H_CNT>=570)&(H_CNT<=600));
			ss5=0;
			ss6=(H_CNT==570)&((V_CNT>=5)&(V_CNT<=20));
			ss7=(V_CNT==20)&((H_CNT>=570)&(H_CNT<=600));
			end
	endcase
end
	
	
always @(posedge CLK) begin
	case(score_blue)
		0: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=(H_CNT==40)&((V_CNT>=20)&(V_CNT<=35));
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=0;
			end
		1: begin
		   b1=0;
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=0;
			b5=0;
			b6=0;
			b7=0;
			end
		2: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=0;
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=(H_CNT==40)&((V_CNT>=20)&(V_CNT<=35));
			b6=0;
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		3: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=0;
			b6=0;
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		4: begin
			b1=0;
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=0;
			b5=0;
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		5: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=0;
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=0;
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		6: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=0;
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=(H_CNT==40)&((V_CNT>=20)&(V_CNT<=35));
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		7: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=0;
			b5=0;
			b6=0;
			b7=0;
			end
		8: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=(H_CNT==40)&((V_CNT>=20)&(V_CNT<=35));
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
		9: begin
			b1=(V_CNT==5)&((H_CNT>=40)&(H_CNT<=70));
			b2=(H_CNT==70)&((V_CNT>=5)&(V_CNT<=20));
			b3=(H_CNT==70)&((V_CNT>=20)&(V_CNT<=35));
			b4=(V_CNT==35)&((H_CNT>=40)&(H_CNT<=70));
			b5=0;
			b6=(H_CNT==40)&((V_CNT>=5)&(V_CNT<=20));
			b7=(V_CNT==20)&((H_CNT>=40)&(H_CNT<=70));
			end
	endcase
end

always @(posedge CLK) begin
	case(score_red)
			0: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=(H_CNT==95)&((V_CNT>=20)&(V_CNT<=35));
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=0;
			end
		1: begin
		   r1=0;
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=0;
			r5=0;
			r6=0;
			r7=0;
			end
		2: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=0;
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=(H_CNT==95)&((V_CNT>=20)&(V_CNT<=35));
			r6=0;
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		3: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=0;
			r6=0;
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		4: begin
			r1=0;
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=0;
			r5=0;
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		5: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=0;
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=0;
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		6: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=0;
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=(H_CNT==95)&((V_CNT>=20)&(V_CNT<=35));
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		7: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=0;
			r5=0;
			r6=0;
			r7=0;
			end
		8: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=(H_CNT==95)&((V_CNT>=20)&(V_CNT<=35));
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
		9: begin
			r1=(V_CNT==5)&((H_CNT>=95)&(H_CNT<=125));
			r2=(H_CNT==125)&((V_CNT>=5)&(V_CNT<=20));
			r3=(H_CNT==125)&((V_CNT>=20)&(V_CNT<=35));
			r4=(V_CNT==35)&((H_CNT>=95)&(H_CNT<=125));
			r5=0;
			r6=(H_CNT==95)&((V_CNT>=5)&(V_CNT<=20));
			r7=(V_CNT==20)&((H_CNT>=95)&(H_CNT<=125));
			end
	endcase
end

always @(posedge CLK) begin
	case(b1_inactive)
		0: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=(H_CNT==215)&((V_CNT>=20)&(V_CNT<=35));
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=0;
			end
		1: begin
		   b11=0;
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=0;
			b15=0;
			b16=0;
			b17=0;
			end
		2: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=0;
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=(H_CNT==215)&((V_CNT>=20)&(V_CNT<=35));
			b16=0;
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		3: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=0;
			b16=0;
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		4: begin
			b11=0;
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=0;
			b15=0;
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		5: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=0;
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=0;
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		6: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=0;
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=(H_CNT==215)&((V_CNT>=20)&(V_CNT<=35));
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		7: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=0;
			b15=0;
			b16=0;
			b17=0;
			end
		8: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=(H_CNT==215)&((V_CNT>=20)&(V_CNT<=35));
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
		9: begin
			b11=(V_CNT==5)&((H_CNT>=215)&(H_CNT<=245));
			b12=(H_CNT==245)&((V_CNT>=5)&(V_CNT<=20));
			b13=(H_CNT==245)&((V_CNT>=20)&(V_CNT<=35));
			b14=(V_CNT==35)&((H_CNT>=215)&(H_CNT<=245));
			b15=0;
			b16=(H_CNT==215)&((V_CNT>=5)&(V_CNT<=20));
			b17=(V_CNT==20)&((H_CNT>=215)&(H_CNT<=245));
			end
	endcase
end

always @(posedge CLK) begin
	case(b2_inactive)
		0: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=(H_CNT==295)&((V_CNT>=20)&(V_CNT<=35));
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=0;
			end
		1: begin
		   b21=0;
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=0;
			b25=0;
			b26=0;
			b27=0;
			end
		2: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=0;
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=(H_CNT==295)&((V_CNT>=20)&(V_CNT<=35));
			b26=0;
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		3: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=0;
			b26=0;
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		4: begin
			b21=0;
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=0;
			b25=0;
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		5: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=0;
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=0;
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		6: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=0;
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=(H_CNT==295)&((V_CNT>=20)&(V_CNT<=35));
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		7: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=0;
			b25=0;
			b26=0;
			b27=0;
			end
		8: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=(H_CNT==295)&((V_CNT>=20)&(V_CNT<=35));
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
		9: begin
			b21=(V_CNT==5)&((H_CNT>=295)&(H_CNT<=325));
			b22=(H_CNT==325)&((V_CNT>=5)&(V_CNT<=20));
			b23=(H_CNT==325)&((V_CNT>=20)&(V_CNT<=35));
			b24=(V_CNT==35)&((H_CNT>=295)&(H_CNT<=325));
			b25=0;
			b26=(H_CNT==295)&((V_CNT>=5)&(V_CNT<=20));
			b27=(V_CNT==20)&((H_CNT>=295)&(H_CNT<=325));
			end
	endcase
end

always @(posedge CLK) begin
	case(r1_inactive)
			0: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=(H_CNT==375)&((V_CNT>=20)&(V_CNT<=35));
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=0;
			end
		1: begin
		   r11=0;
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=0;
			r15=0;
			r16=0;
			r17=0;
			end
		2: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=0;
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=(H_CNT==375)&((V_CNT>=20)&(V_CNT<=35));
			r16=0;
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		3: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=0;
			r16=0;
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		4: begin
			r11=0;
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=0;
			r15=0;
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		5: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=0;
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=0;
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		6: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=0;
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=(H_CNT==375)&((V_CNT>=20)&(V_CNT<=35));
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		7: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=0;
			r15=0;
			r16=0;
			r17=0;
			end
		8: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=(H_CNT==375)&((V_CNT>=20)&(V_CNT<=35));
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
		9: begin
			r11=(V_CNT==5)&((H_CNT>=375)&(H_CNT<=405));
			r12=(H_CNT==405)&((V_CNT>=5)&(V_CNT<=20));
			r13=(H_CNT==405)&((V_CNT>=20)&(V_CNT<=35));
			r14=(V_CNT==35)&((H_CNT>=375)&(H_CNT<=405));
			r15=0;
			r16=(H_CNT==375)&((V_CNT>=5)&(V_CNT<=20));
			r17=(V_CNT==20)&((H_CNT>=375)&(H_CNT<=405));
			end
	endcase
end

always @(posedge CLK) begin
	case(r2_inactive)
			0: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=(H_CNT==455)&((V_CNT>=20)&(V_CNT<=35));
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=0;
			end
		1: begin
		   r21=0;
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=0;
			r25=0;
			r26=0;
			r27=0;
			end
		2: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=0;
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=(H_CNT==455)&((V_CNT>=20)&(V_CNT<=35));
			r26=0;
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		3: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=0;
			r26=0;
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		4: begin
			r21=0;
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=0;
			r25=0;
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		5: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=0;
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=0;
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		6: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=0;
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=(H_CNT==455)&((V_CNT>=20)&(V_CNT<=35));
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		7: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=0;
			r25=0;
			r26=0;
			r27=0;
			end
		8: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=(H_CNT==455)&((V_CNT>=20)&(V_CNT<=35));
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
		9: begin
			r21=(V_CNT==5)&((H_CNT>=455)&(H_CNT<=485));
			r22=(H_CNT==485)&((V_CNT>=5)&(V_CNT<=20));
			r23=(H_CNT==485)&((V_CNT>=20)&(V_CNT<=35));
			r24=(V_CNT==35)&((H_CNT>=455)&(H_CNT<=485));
			r25=0;
			r26=(H_CNT==455)&((V_CNT>=5)&(V_CNT<=20));
			r27=(V_CNT==20)&((H_CNT>=455)&(H_CNT<=485));
			end
	endcase
end


//COLOR ASSIGNMENTS
always @(posedge CLK) begin
	VGA_R[7] <= RED;
	VGA_G[7] <= GREEN;
	VGA_B[7] <= BLUE;
	VGA_R[6] <= R_light;
	VGA_G[6] <= G_light;
	VGA_B[6] <= B_light;
end

endmodule
