module rptr_empty #(parameter ADDRSIZE = 4)
                   (output reg rempty,
                    output [ADDRSIZE-1:0] raddr,   // Binary Pointer To Access The Memory
                    output reg [ADDRSIZE :0] rptr, // Gray Coded Pointer For Comparison
                    input [ADDRSIZE :0] rq2_wptr,
                    input rinc,
                    input rclk,
                    input rrst_n);
    
    reg  [ADDRSIZE:0] rbin;
    wire [ADDRSIZE:0] rgraynext, rbinnext;
    
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {rbin, rptr} <= 0;
        else
            {rbin, rptr} <= {rbinnext, rgraynext};
    end
    
    assign raddr     = rbin[ADDRSIZE-1:0];
    assign rbinnext  = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext>>1) ^ rbinnext;
    
    assign rempty_val = (rgraynext == rq2_wptr);
    
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1'b1;
        else
            rempty <= rempty_val;
    end
    
endmodule
