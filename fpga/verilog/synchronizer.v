module synchronizer #(
    parameter SYNC_STAGES = 2
) (
    input wire clk,
    input wire in,
    output reg out
);

    reg [SYNC_STAGES-1:0] sync_regs = {SYNC_STAGES{1'b0}};

    always @(posedge clk) begin
        sync_regs <= {sync_regs[SYNC_STAGES-2:0], in};
        out <= sync_regs[SYNC_STAGES-1];
    end

endmodule