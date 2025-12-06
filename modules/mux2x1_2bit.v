module mux2x1_2bit (
    input  wire [1:0] in0,
    input  wire [1:0] in1,
    input  wire       sel,
    output wire [1:0] out
);

    assign out = sel ? in1 : in0;

endmodule
