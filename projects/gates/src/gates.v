(* top *) module Gates(
 (* iopad_external_pin, clkbuf_inhibit *) input clk,

 (* iopad_external_pin *) output reg Y = 0,
 (* iopad_external_pin *) output Y_en ,

 (* iopad_external_pin *) input A ,
 (* iopad_external_pin *) output A_en ,

 (* iopad_external_pin *) input B ,
 (* iopad_external_pin *) output B_en ,

 (* iopad_external_pin *) input S0 ,
 (* iopad_external_pin *) output S0_en ,

 (* iopad_external_pin *) input S1 ,
 (* iopad_external_pin *) output S1_en ,

 (* iopad_external_pin *) input S2 ,
 (* iopad_external_pin *) output S2_en 
 );

 assign Y_en  = 1'b1;
 assign A_en  = 1'b0;
 assign B_en  = 1'b0;
 assign S0_en = 1'b0;
 assign S1_en = 1'b0;
 assign S2_en = 1'b0;

 always @(*) begin

     case ({S2,S1,S0})

         3'd0: Y = A&B;      
         3'd1: Y = A | B;      
         3'd2: Y = ~(A & B);   
         3'd3: Y = ~(A | B);   
         3'd4: Y = A ^ B;      
         3'd5: Y = ~(A ^ B);   
         3'd6: Y = ~A;         
         3'd7: Y = ~B;         

         default: Y = 1'b0;

     endcase

 end

 endmodule
