`timescale 1ns / 1ps



module debounce(
    input btnp_1,
    input clk, 
    input nrst, 
    output reg btnp_out
    ); 

    reg [29:0] counter;
    
 
    
    always@(posedge clk)
        if(!nrst) begin
            btnp_out <= 0;
            counter <= 0;
        end
        else begin
            if(btnp_1 == 0)
                counter <= 0;
            else begin
                counter <= counter + 1;
                if(counter == 2500)
                    btnp_out <= btnp_1;
                if(counter == 2501)
                    btnp_out <= ~btnp_1;
            end
        end
endmodule