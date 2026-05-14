(* top *) module blink(
  (* iopad_external_pin,clkbuf_inhibit *) input clk,
  (* iopad_external_pin *) output LED,
  (* iopad_external_pin *) output LED_en,
  (* iopad_external_pin *) output clk_en
);

reg [31:0] counter = 0;
reg LED_status = 0;  

assign LED = LED_status;

assign LED_en = 1'b1;
assign clk_en = 1'b1;

always @(posedge clk) begin

    if(counter == 50_000_000 - 1) begin
        counter <= 0;
        LED_status <= ~LED_status;   
    end
    else begin
        counter <= counter + 1;
    end

end

endmodule