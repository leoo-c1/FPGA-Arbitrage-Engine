module Segment_Selector (
    input wire [3:0] input_bits,    // 4 bits we send to the SSD
    input wire dash,                // Flag to indicate if we want to show a single dash on the SSD
    output wire [6:0] segments      // SSD segments that get activated
    );

    reg [6:0] raw_logic;

    assign segments = ~raw_logic;   // Segments are active low, so invert

    always @(*) begin
        if (~dash) begin            // If we don't want to show the dash, show input bits
            case (input_bits)
                4'h0: raw_logic = 7'b0111111;
                4'h1: raw_logic = 7'b0000110;
                4'h2: raw_logic = 7'b1011011;
                4'h3: raw_logic = 7'b1001111;
                4'h4: raw_logic = 7'b1100110;
                4'h5: raw_logic = 7'b1101101;
                4'h6: raw_logic = 7'b1111101;
                4'h7: raw_logic = 7'b0000111;
                4'h8: raw_logic = 7'b1111111;
                4'h9: raw_logic = 7'b1100111;
                4'hA: raw_logic = 7'b1110111;
                4'hB: raw_logic = 7'b1111100;
                4'hC: raw_logic = 7'b0111001;
                4'hD: raw_logic = 7'b1011110;
                4'hE: raw_logic = 7'b1111001;
                4'hF: raw_logic = 7'b1110001;
                default: raw_logic = 7'b0000000;
            endcase
        end else begin              // Show the dash
            raw_logic = 7'b1000000;
        end
    end

endmodule