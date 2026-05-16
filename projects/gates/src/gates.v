 module Gates(

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

        3'b000: Y = A & B;
        3'b001: Y = A | B;
        3'b010: Y = A ^ B;
        3'b011: Y = ~(A & B);
        3'b100: Y = ~(A | B);
        3'b101: Y = A ~^ B;
        3'b110: Y = ~A;
        3'b111: Y = ~B;

        default: Y = 1'b0;

    endcase

end

endmodule