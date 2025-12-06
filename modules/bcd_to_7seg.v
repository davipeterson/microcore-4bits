module bcd_to_7seg (
    input  wire [3:0] in,
    output reg  [6:0] disp
);

    always @(*) begin
        case (in)
            4'd0:  disp = 7'b1000000; // 0
            4'd1:  disp = 7'b1111001; // 1
            4'd2:  disp = 7'b0100100; // 2
            4'd3:  disp = 7'b0110000; // 3
            4'd4:  disp = 7'b0011001; // 4
            4'd5:  disp = 7'b0010010; // 5
            4'd6:  disp = 7'b0000010; // 6
            4'd7:  disp = 7'b1111000; // 7
            4'd8:  disp = 7'b0000000; // 8
            4'd9:  disp = 7'b0010000; // 9
            4'd10: disp = 7'b0001000; // A
            4'd11: disp = 7'b0000011; // b
            4'd12: disp = 7'b1000110; // C
            4'd13: disp = 7'b0100001; // d
            4'd14: disp = 7'b0000110; // E
            4'd15: disp = 7'b0001110; // F
            default: disp = 7'b1111111; // Off
        endcase
    end
endmodule
