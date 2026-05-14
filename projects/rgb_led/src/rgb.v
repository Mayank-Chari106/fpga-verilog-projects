module RGB_LED(  
  (* iopad_external_pin,clkbuf_inhibit *) input clk,

  (* iopad_external_pin *) output reg LEDr = 0,
  (* iopad_external_pin *) output LEDr_en,

  (* iopad_external_pin *) output reg LEDg = 0,
  (* iopad_external_pin *) output LEDg_en,

  (* iopad_external_pin *) output reg LEDb = 0,
  (* iopad_external_pin *) output LEDb_en,

  (* iopad_external_pin *) output clk_en

);
reg [31:0] counter = 0;
reg [1:0] color = 0;

assign LEDr_en = 1'b1;
assign LEDg_en = 1'b1;
assign LEDb_en = 1'b1;
assign clk_en  = 1'b1;

always @(posedge clk) begin

    counter <= counter + 1;

    if(counter == 50_000_000) begin

        counter <= 0;
        color <= color + 1;

        case(color)
        
            2'd0: begin
                LEDr <= 1'b0;
                LEDg <= 1'b1;
                LEDb <= 1'b1;
            end

            2'd1: begin
                LEDr <= 1'b1;
                LEDg <= 1'b0;
                LEDb <= 1'b1;
            end

            2'd2: begin
                LEDr <= 1'b1;
                LEDg <= 1'b1;
                LEDb <= 1'b0;
            end

            default: begin
                LEDr <= 1'b1;
                LEDg <= 1'b1;
                LEDb <= 1'b1;
            end

        endcase

    end

end
endmodule
