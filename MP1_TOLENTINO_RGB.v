`timescale 1ns / 1ps



module RGB(
    input clk,
    input nrst,
    input btn,
    input en, 
    input [3:0] cmode_colorch, //color that was chosen
    input cmode_btn0, //when color is confirmed by button select
    output reg r_out, g_out, b_out
    );
    reg enabled_state;
    reg [7:0] red;
    reg [7:0] green;
    reg [7:0] blue;
    
    reg [3:0] state;
    reg [27:0] blink_ctr;
    reg [7:0] counter;
    reg menu;
    
    
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
    
    always@(posedge clk or negedge nrst)
        if(!nrst) begin
            counter <= 0;
            blink_ctr <= 0;
            state <= S_off;
            r_out <= 0;
            b_out <= 0;
            g_out <= 0;
            enabled_state<=0;
        end
        else begin

            if(!en)
                state <= S_off;
            if (en && !enabled_state) begin
                state <= S_maroon;
                enabled_state <=1;
            end
            blink_ctr <= blink_ctr + 28'd1;
            counter <= counter + 8'd1;
            if(counter == 100000000)
      
            counter <= 0;
            if((blink_ctr >= 50000000) && (blink_ctr <= 100000000)) begin
           
                r_out <= 0;
                b_out <= 0;
                g_out <= 0;

            if(cmode_btn0) begin state <= cmode_colorch; end
            
            if(blink_ctr == 100000000-1)
            blink_ctr <= 0;
            end
            else begin
                if(counter < red)
                    r_out <= 1;
                else
                    r_out <= 0;
                if(counter < green)
                    g_out <= 1;
                else
                    g_out <= 0;
                if(counter < blue)
                    b_out <= 1;
                else
                    b_out <= 0;
               
            end
            case(state)
                S_maroon: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                        red <=  8'd128;
                        blue <= 8'd0;
                        green <= 8'd0;
                        state <= S_maroon;
                    end
                end
                S_red: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                        red <=  8'd255;
                        blue <= 8'd0;
                        green <= 8'd0;
                        state <= S_red;
                    end
                end
                S_orange: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd255;
                    green <= 8'd165;
                    blue <= 8'd0;
                    state <= S_orange;
                    end
                end
                S_yellow: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd255;
                    green <= 8'd255;
                    blue <= 8'd0;
                    state <= S_yellow;
                    end
                end
                S_green: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd0;
                    green <= 8'd128;
                    blue <= 8'd0;
                    state <= S_green;
                    end
                end
                S_lime: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd0;
                    green <= 8'd255;
                    blue <= 8'd0;
                    state <= S_lime;
                    end
                end
                S_teal: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd0;
                    green <= 8'd128;
                    blue <= 8'd128;
                    state <= S_teal;
                    end
                end
                S_cyan: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd0;
                    blue <= 8'd255;
                    green <= 8'd255;
                    state <= S_cyan;
                    end
                end
                S_blue: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd0;
                    green <= 8'd0;
                    blue <= 8'd255;
                    state <= S_blue;
                    end
                end
                S_purple: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd128;
                    blue <= 8'd128;
                    green <= 8'd0;
                    state <= S_purple;
                    end
                end
                S_violet: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd238;
                    green <= 8'd130;
                    blue <= 8'd238;
                    state <= S_violet;
                    end
                end
                S_sienna: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd160;
                    blue <= 8'd45;
                    green <= 8'd82;
                    state <= S_sienna;
                    end
                end
                S_silver: begin
                    if(cmode_btn0) begin state <= cmode_colorch; end
                    else begin
                    red <=  8'd192;
                    blue <= 8'd192;
                    green <= 8'd192;
                    state <= S_silver;
                    end
                end


                S_off: begin
                    if (en)
                        menu <=0;
                    if(btn) begin 
                        if (menu)
                            state <= S_off;
                        else begin
                            state <= S_maroon; 
                            menu <=1;
                        end
                    end

                    else begin
                    red <=  8'd0;
                    green <= 8'd0;
                    blue <= 8'd0;
                    
                    state <= S_off;
                    end
                end
            endcase
         end      
endmodule