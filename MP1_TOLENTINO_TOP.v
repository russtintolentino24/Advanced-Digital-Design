`timescale 1ns / 1ps



module top(
    
    input clk, input nrst,
    input switch0, input btn0, 
    input btn1, input btn2,
    input btn3,
    
    
    output reg [3:0] data_lines,
    output reg rs, output reg rw,
    output reg enable, output r_out, 
    output b_out, output g_out
    );

    wire btn_out0; wire btn_out1;
    wire btn_out2; wire btn_out3;

    reg cmode_enable;//color mode enable

    reg cmode_btn0; //color mode confirm selected color

    reg [31:0] init_counter;

    reg [2:0] state;

    reg [3:0] cmode_state;
    reg [3:0] tmode_state;

    reg [31:0] cmode_ctr;
    reg [31:0] tmode_ctr;
   
   
    reg [3:0] cmode_colorch; //color mode choosen color
    reg [3:0] pr_hibit;
    reg [3:0] pr_lowbit;

    parameter initialize = 2'd0;
    parameter colormode = 2'd1;
    parameter typemode = 2'd2;

    parameter R_cursor = 4'd0;
    parameter R_write = 4'd1;
    parameter R_browse = 4'd2;

    parameter S_maroon = 4'd0;
    parameter S_red = 4'd1;
    parameter S_orange = 4'd2;
    parameter S_yellow = 4'd3;
    parameter S_green = 4'd4;
    parameter S_lime = 4'd5;
    parameter S_teal = 4'd6;
    parameter S_cyan = 4'd7;
    parameter S_blue = 4'd8;
    parameter S_purple = 4'd9;    
    parameter S_violet = 4'd10;
    parameter S_sienna = 4'd11;
    parameter S_silver = 4'd12;
    parameter S_off = 4'd13;

    
    
    

    



    RGB RGB1(.clk(clk),
        .nrst(nrst),
        .en(cmode_enable),
        .btn(btn_out1),
        .cmode_colorch(cmode_state),
        .cmode_btn0(btn_out0),
        .r_out(r_out),
        .b_out(b_out),
        .g_out(g_out)
    );
    
    debounce db_0 (
    .clk(clk),
    .nrst(nrst),
    .pb_1(btn0),
    .pb_out(btn_out0)
    );
    debounce db_1 (
    .clk(clk),
    .nrst(nrst),
    .pb_1(btn1),
    .pb_out(btn_out1)
    );
    debounce db_2 (
    .clk(clk),
    .nrst(nrst),
    .pb_1(btn2),
    .pb_out(btn_out2)
    );
    
    debounce db_3 (
    .clk(clk),
    .nrst(nrst),
    .pb_1(btn3),
    .pb_out(btn_out3)
    );
    
    
    

    
    ///Initialization
    always@(posedge clk)
        if(!nrst) begin
            data_lines <= 4'd0;
            init_counter <= 0;
            cmode_ctr <= 0;
            tmode_ctr <= 0;
            rs <= 0; 
            rw <= 0;        
            enable <= 0;    
            state <= 0;
            cmode_btn0 <= 0; //confirm selected color
            cmode_state <= S_maroon;
            cmode_colorch <= S_maroon; //chosen color
            tmode_state <= T_browse; 
            pr_hibit <= 4'h3; //print high bit
            pr_lowbit <= 4'h4; //print low bit
         

        end 
        else begin
            case(state)
                initialize:   begin          
                    if(btn_out0) begin 
                    state <= typemode; 
                    tmode_ctr <=0;
                    end 
                    else if(btn_out1) begin 
                    state <= colormode; 
                    cmode_ctr <=0;
                    end
                    else begin
                        init_counter = init_counter + 1;
                        

                        //State 1: delay 15ms + 100ns
                        
                        if(init_counter == 1600000) begin                         
                            enable <= 1;
                            data_lines <= 4'b0011; //State 2: Send Data (000011)        
                        end
                        
                            else if(init_counter == 1600050+500) begin            
                            enable <= 1;
                        end  
                        
                            else if(init_counter == 1600100+1000) begin             
                            enable <= 0;
                           // data_lines <= 4'b0000;
                        end  
                        
                            else if(init_counter == 1600150+1500) begin             
                            enable <= 0;
                        end              //State 3: delay 4.1ms + 100ns              //State 4: Send Data (000011)
                        
                            else if (init_counter == 2300000+2000) begin 
                            enable <= 1;
                            data_lines <= 4'b0011;          //2
                        end              
                        
                            else if (init_counter == 2300050+2500) begin 
                            //enable <= 1;
                        end              
                        
                            else if (init_counter == 2300100+3000) begin 
                            enable <= 0;                
                            //data_lines <= 4'b0000;
                        end 
                        
                            else if (init_counter == 2300150+3500) begin 
                          //  enable <= 0;             
                        end            //State 5: delay 100us + 100ns              //State 6: Send Data (000011)
                        
                            else if (init_counter == 2320000+4000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0011;          //3
                        end             
                        
                            else if (init_counter == 2320050+4500) begin 
                            enable <= 1;             
                        end 
                        
                            else if (init_counter == 2320150+5500) begin 
                            enable <= 0;                         
                          //  data_lines <= 4'b0000;         
                        end 
                       
                            else if (init_counter == 2320200+6000) begin 
                            enable <= 0;             
                        end  + 100ns //State 7: Send Data (000010) 
                        
                            else if (init_counter == 2320260+6500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0010;        
                        end 
                        
                            else if (init_counter == 2320410+8000+5000) begin 
                            enable <= 0;                         
                          //  data_lines <= 4'b0000;         
                        end  + 100ns //State 8: Send Data (000010) 
                        
                            else if (init_counter == 2320600+9000+10000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0010;      
                        end 
                        
                            else if (init_counter == 2320700+10000+10000) begin 
                            enable <= 0;                         
                          //  data_lines <= 4'b0000;         
                        end  + 100ns //State 9: Send Data (000000) 
                        
                            else if (init_counter == 2320800+11000+15000) begin 
                            enable <= 1;                         
                            data_lines <= 4'b1000;        
                        end  + 100ns 
                        
                            else if (init_counter == 2320900+12000+15000) begin 
                            enable <= 0;                
                                 
                        end 
                        
                            else if (init_counter == 2321000+13000+20000) begin 
                            enable <= 1;                   
                        end  
                        
                            else if (init_counter == 2321100+14000+20000) begin 
                            enable <= 0;                
                                 
                        end 
                        
                            else if (init_counter == 2321200+15000+25000) begin 
                            enable <= 1;                         
                            data_lines <= 4'b1000;            
                        end  
                        
                            else if (init_counter == 2321300+16000+25000) begin 
                            enable <= 0;             
                         //   data_lines <= 4'b0000;
                        end  + 100ns //State 10: Send Data (000000) 
                        
                            else if (init_counter == 2321400+17000+30000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0000;           
                        end 
                        
                            else if (init_counter == 2321500+18000+30000) begin 
                            enable <= 0;             
                        end 
                        else if (init_counter == 2321600+19000+35000) begin 
                            enable <= 1;                         
                            data_lines <= 4'b0001;               
                        end 
                        
                            else if (init_counter == 2321700+20000+35000) begin 
                            enable <= 0;        
                            
                        end  + 100ns //State 11: Send Data (000000) 
                        
                            else if (init_counter == 2321800+21000+40000+1500000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0000;             
                        end 
                        
                            else if (init_counter == 2321900+22000+40000+1500000) begin 
                            enable <= 0;             
                        end 
                       
                            else if (init_counter == 2322000+23000+45000+1500000) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0110;            
                        end 
                        
                            else if (init_counter == 2322100+24000+45000+1500000) begin
                            enable <= 0;
                           
                        end 
                        
                            else if (init_counter == 2322200+25000+50000+1500000) begin 
                            enable <= 1;              
                            data_lines <= 4'b0000;             
                        end   + 100ns //State 12: Send Data (000000) 
                        
                            else if (init_counter == 2322300+27000+50000+1500000) begin 
                            enable <= 0;                     
                          //  data_lines <= 4'b0000;     
                        end             
                        
                            else if (init_counter == 2322400+28000+55000+1500000) begin 
                            enable <= 1;                                   
                            data_lines <= 4'b1111; //send 1111    
                        end     
                        
                            else if (init_counter == 2322400+30000+55000+1500000) begin 
                            enable <= 0;       
                            rs <= 1;           //added   
                           // data_lines <= 4'b0000;     
                        end  
                        
     
                        
                        //PRINT C
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT o
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                       
                         //PRINT l
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                         //PRINT o
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                       
                       //PRINT r
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT _
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b1010;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                            
                            else if (init_counter == 2322400+30000+55000+1500000+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                         //PRINT M
                            
                            else if (init_counter == 4017200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                            
                            else if (init_counter == 4017200+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 4017200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1101;              
                        end 
                            
                            else if (init_counter == 4017200+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT o
                            
                            else if (init_counter == 4017200+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 4017200+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 4017200+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                            
                            else if (init_counter == 4017200+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT d
                            
                            else if (init_counter == 4053800+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 4053800+5000+1100) begin 
                            enable <= 0;             
                        end 
                            
                            else if (init_counter == 4053800+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                            
                            else if (init_counter == 4053800+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT e
                            
                            else if (init_counter == 4053800+5000+13300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            
                            else if (init_counter == 4053800+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4053800+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                            else if (init_counter == 4053800+5000+13300+5000+13300) begin
                            rs<=0;
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4053800+5000+13300+5000+13300) begin
                            enable <= 0;
                            rs<=0;
                           
                        end 
                        
                        //PRINT TYPE MODE
                        
                        //PRINT new line
                            else if (init_counter == 4090400+5000) begin
                            //rs <= 0; 
                            enable <= 1;                
                            data_lines <= 4'b1100;              
                        end 
                            else if (init_counter == 4090400+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4090400+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                            else if (init_counter == 4090400+5000+13300) begin
                             rs <=1;
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4090400+5000+13300) begin
                            enable <= 0;
                            rs <=1;
                           
                        end 
                        
                        //PRINT T
                            else if (init_counter == 4108700+5000) begin
                            //rs <= 1; 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                            else if (init_counter == 4108700+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4108700+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                            else if (init_counter == 4108700+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4108700+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT y
                            else if (init_counter == 4127000+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                            else if (init_counter == 4127000+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4127000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                            else if (init_counter == 4127000+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4127000+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT p
                            else if (init_counter == 4145300+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                            else if (init_counter == 4145300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4145300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                            else if (init_counter == 4145300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4145300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT e
                            else if (init_counter == 4163600+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            else if (init_counter == 4163600+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4163600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                            else if (init_counter == 4163600+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4163600+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT _
                            else if (init_counter == 4163600+5000+13300+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b1010;              
                        end 
                            else if (init_counter == 4163600+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4163600+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                            else if (init_counter == 4163600+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4163600+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT M
                            else if (init_counter == 4200200+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                            else if (init_counter == 4200200+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4200200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1101;              
                        end 
                            else if (init_counter == 4200200+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4200200+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT o
                            else if (init_counter == 4218500+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            else if (init_counter == 4218500+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4218500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                            else if (init_counter == 4218500+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4218500+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT d
                            else if (init_counter == 4236800+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            else if (init_counter == 4236800+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4236800+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                            else if (init_counter == 4236800+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4236800+5000+13300) begin
                            enable <= 0;
                           
                        end 
                        
                        //PRINT e
                            else if (init_counter == 4236800+5000+13300+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                            else if (init_counter == 4236800+5000+13300+5000+1100) begin 
                            enable <= 0;             
                        end 
                            else if (init_counter == 4236800+5000+13300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                            else if (init_counter == 4236800+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end 
                            else if (init_counter == 4236800+5000+13300+5000+13300) begin
                            enable <= 0;
                           
                        end     
                            else if (init_counter == 4236800+5000+13300+5000+13300+10000) begin
                                rs <=0;
                        end
                    end      
                end
                
                
                
                
                
                
                
                
                
                
                
                colormode: begin
                    cmode_ctr <= cmode_ctr + 1;
                    cmode_enable <=1;
                    
                    if (btn_out2) begin
                        if (cmode_state == S_silver)
                            cmode_state <= S_maroon;
                        else
                            cmode_state <= cmode_state + 1;
                        cmode_ctr <=0;
                    end
                        else if (btn_out3) begin
                        if (cmode_state == S_maroon)
                            cmode_state <= S_silver;
                        else
                            cmode_state <= cmode_state - 1;
                        cmode_ctr <=0;
                    end
                        else if (btn_out0) begin
                        cmode_btn0 = 1;
                        cmode_state =cmode_state;
                        cmode_colorch = cmode_state;
                        cmode_ctr = 0;
                    end
                        else if (btn_out1) begin
                        cmode_enable <= 0;
                        cmode_ctr <= 0;
                        state <= initialize;
                    end
                    
                    
                //Print display
//                  //Clear display
                        if (cmode_ctr == 5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 5000+13300) begin
                            enable <= 0;
                            rs <= 1;
                           
                        end 
                        
                  
                        
                        
                        //PRINT C
                        else if (cmode_ctr == 18300+5000) begin
                        
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 18300+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 18300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 18300+5000+13300) begin
                            enable <= 0;
                           
                        end   



                              //PRINT h
                        else if (cmode_ctr == 36600+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 36600+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 36600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1000;              
                        end 
                        else if (cmode_ctr == 36600+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        
                              //PRINT o
                        else if (cmode_ctr == 54900+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 54900+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 54900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 54900+5000+13300) begin
                            enable <= 0;
                           
                        end 


                           //PRINT o
                        else if (cmode_ctr == 73200+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 73200+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 73200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 73200+5000+13300) begin
                            enable <= 0;
                           
                        end 


                         //PRINT s
                        else if (cmode_ctr == 91500+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 91500+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 91500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 91500+5000+13300) begin
                            enable <= 0;
                           
                        end 


                         //PRINT e
                        else if (cmode_ctr == 109800+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 109800+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 109800+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 109800+5000+13300) begin
                            enable <= 0;
                           
                        end 


                         //PRINT _
                        else if (cmode_ctr == 128100+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b1010;              
                        end 
                        else if (cmode_ctr == 128100+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 128100+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 128100+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        //PRINT y
                        else if (cmode_ctr == 146400+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 146400+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 146400+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 146400+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        //PRINT o
                        else if (cmode_ctr == 164700+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 164700+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 164700+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 164700+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        //PRINT u
                        else if (cmode_ctr == 183000+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 183000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 183000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 183000+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        //PRINT r
                        else if (cmode_ctr == 201300+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 201300+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 201300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 201300+5000+13300) begin
                            enable <= 0;
                           
                        end 


                        //PRINT _
                        else if (cmode_ctr == 219600+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b1010;              
                        end 
                        else if (cmode_ctr == 219600+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 219600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 219600+5000+13300) begin
                            enable <= 0;
                           
                        end 

                        //PRINT c
                        else if (cmode_ctr == 237900+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 237900+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 237900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 237900+5000+13300) begin
                            enable <= 0;
                           
                        end 
//PRINTING ERROR OF "Choose Your Color" Starts here
//                        //PRINT o
//                        else if (cmode_ctr == 256200+5000) begin 
//                            enable <= 1;                
//                            data_lines <= 4'b0110;              
//                        end 
//                        else if (cmode_ctr == 256200+5000+1100) begin 
//                            enable <= 0;             
//                        end 
//                        else if (cmode_ctr == 256200+5000+12200) begin 
//                            enable <= 1;                      
//                            data_lines <= 4'b1111;              
//                        end 
//                        else if (cmode_ctr == 256200+5000+13300) begin
//                            enable <= 0;
//                           
//                        end 
                       
//                         //PRINT l
//                        else if (cmode_ctr == 274500+5000) begin 
//                            enable <= 1;                
//                            data_lines <= 4'b0110;              
//                        end 
//                        else if (cmode_ctr == 274500+5000+1100) begin 
//                            enable <= 0;             
//                        end 
//                        else if (cmode_ctr == 274500+5000+12200) begin 
//                            enable <= 1;                      
//                            data_lines <= 4'b1100;              
//                        end 
//                        else if (cmode_ctr == 274500+5000+13300) begin
//                            enable <= 0;
//                           
//                        end 
                        
//                         //PRINT o
//                        else if (cmode_ctr == 292800+5000) begin 
//                            enable <= 1;                
//                            data_lines <= 4'b0110;              
//                        end 
//                        else if (cmode_ctr == 292800+5000+1100) begin 
//                            enable <= 0;             
//                        end 
//                        else if (cmode_ctr == 292800+5000+12200) begin 
//                            enable <= 1;                      
//                            data_lines <= 4'b1111;              
//                        end 
//                        else if (cmode_ctr == 292800+5000+13300) begin
//                            enable <= 0;
//                           
//                        end 
                       
//                       //PRINT r
//                        else if (cmode_ctr == 311100+5000) begin 
//                            enable <= 1;                
//                            data_lines <= 4'b0111;              
//                        end 
//                        else if (cmode_ctr == 311100+5000+1100) begin 
//                            enable <= 0;             
//                        end 
//                        else if (cmode_ctr == 311100+5000+12200) begin 
//                            enable <= 1;                      
//                            data_lines <= 4'b0010;              
//                        end 
//                        else if (cmode_ctr == 311100+5000+13300) begin
//                            enable <= 0;
//                            rs<=0;      
//                           
//                        end 


//Attempt To Fix Problem


                    //PRINT C
                        else if (cmode_ctr == 237900+5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 237900+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 237900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 237900+5000+13300) begin
                            enable <= 0;
                           
                        end 



                        //PRINT C
                        else if (cmode_ctr == 256200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 256200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 256200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 256200+5000+13300) begin
                            enable <= 0;
                           
                        end 




                        //PRINT L
                        else if (cmode_ctr == 292800+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 292800+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 292800+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 292800+5000+13300) begin
                            enable <= 0;
                           
                        end 



                        //PRINT R
                        else if (cmode_ctr == 311100+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 311100+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 311100+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 311100+5000+13300) begin
                            enable <= 0;
                            rs <=0;
                           
                        end 


//END FIX
                        
                        //print >Color
                        
                        //PRINT new line
                        else if (cmode_ctr == 329400+5000) begin
                            //rs <= 0; 
                            enable <= 1;                
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 329400+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 329400+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 329400+5000+13300) begin
                             rs <=1;
                            enable <= 0;
                           
                        end 
                        else if (cmode_ctr == 329400+5000+13300) begin
                            enable <= 0;
                            rs <=1;
                           
                        end 


                        
                        //PRINT >
                        else if (cmode_ctr == 347700+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 347700+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 347700+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 347700+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 




                        case(cmode_state)
                        
                        
                            S_maroon:
                            //PRINT M
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1101;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT a
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT r
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT o
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT o
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 
                                
                            S_red:


                            //PRINT R
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                           // rs<=0;      
                           
                        end 


                            //PRINT d
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 


                            S_orange:

                            //PRINT O
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT r
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT a
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT g
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 

                            S_yellow:

                        //PRINT Y
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT o
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT w
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 




                            S_green:

                        //PRINT G
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT r
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 



                            S_lime:

                            //PRINT L
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT i
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT m
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1101;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 


                            S_teal:

                             //PRINT T
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT E
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT a
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 

                            S_cyan:

                         //PRINT C
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT y
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT a
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 


                            S_blue:

                         //PRINT B
                        if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT u
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 

                           
                            S_purple:begin
                            //P
                             if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT u
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT r
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT p
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0000;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 
                            end
                            
                            
                            S_violet:begin
                            //V
                             if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT i
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT o
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1111;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT t
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0100;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 
                            end                           
                            
                            S_sienna:
                            //S
                             if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT i
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT n
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1110;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT a
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 
                        
                        
                            S_silver: begin
                            //S
                             if (cmode_ctr == 366000+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 366000+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 366000+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0011;              
                        end 
                        else if (cmode_ctr == 366000+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT i
                        else if (cmode_ctr == 384300+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 384300+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 384300+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1001;              
                        end 
                        else if (cmode_ctr == 384300+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT l
                        else if (cmode_ctr == 402600+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 402600+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 402600+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b1100;              
                        end 
                        else if (cmode_ctr == 402600+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT v
                        else if (cmode_ctr == 420900+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 420900+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 420900+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 420900+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT e
                        else if (cmode_ctr == 439200+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0110;              
                        end 
                        else if (cmode_ctr == 439200+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 439200+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0101;              
                        end 
                        else if (cmode_ctr == 439200+5000+13300) begin
                            enable <= 0;
                                
                           
                        end 


                            //PRINT r
                        else if (cmode_ctr == 457500+5000) begin 
                            enable <= 1;                
                            data_lines <= 4'b0111;              
                        end 
                        else if (cmode_ctr == 457500+5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (cmode_ctr == 457500+5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0010;              
                        end 
                        else if (cmode_ctr == 457500+5000+13300) begin
                            enable <= 0;
                            rs<=0;      
                           
                        end 
                        end        
                            
                        endcase
                
                end
                
                
                
//Print display


                typemode: begin
                    tmode_ctr <= tmode_ctr + 1;
              
                    
                    
                    if (tmode_ctr == 5000) begin
                            enable <= 1;                
                            data_lines <= 4'b0000;              
                        end 
                        else if (tmode_ctr == 5000+1100) begin 
                            enable <= 0;             
                        end 
                        else if (tmode_ctr == 5000+12200) begin 
                            enable <= 1;                      
                            data_lines <= 4'b0001;              
                        end 
                        else if (tmode_ctr == 5000+13300) begin
                            enable <= 0;
                            rs <=1;
                           
                        end 
                        
                     case(tmode_state)

                        T_cursor: begin
                        
                        end



                        T_write:begin
                        
                        end
                        


                         T_browse: begin                      
                        
                         //PRINT C   
                            if (cmode_ctr == 200000+18300+5000) begin
                            
                                enable <= 1;                
                                data_lines <= pr_hibit;              
                            end 
                            else if (cmode_ctr == 200000+18300+1100) begin 
                                enable <= 0;             
                            end 
                            else if (cmode_ctr == 200000+18300+5000+12200) begin 
                                enable <= 1;                      
                                data_lines <= pr_lowbit;              
                            end 
                            else if (cmode_ctr == 200000+18300+5000+13300) begin
                                enable <= 0;
                                rs <=0;
                               
                            end     
    
                          
                        end

                        
                    endcase
                end
            endcase
        end
 
 endmodule