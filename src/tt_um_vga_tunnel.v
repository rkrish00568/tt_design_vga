`default_nettype none

module tt_um_vga_tunnel(
 input  wire [7:0] ui_in,
 output wire [7:0] uo_out,
 input  wire [7:0] uio_in,
 output wire [7:0] uio_out,
 output wire [7:0] uio_oe,
 input  wire       ena,
 input  wire       clk,
 input  wire       rst_n
);

 // VGA signals
 wire hsync, vsync;
 wire [1:0] R, G, B;
 wire video_active;
 wire [9:0] x, y;

 assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
 assign uio_out = 0;
 assign uio_oe  = 0;

 wire _unused_ok = &{ena, ui_in, uio_in};

 reg [9:0] counter;

 // VGA controller
 hvsync_generator hvsync_gen(
   .clk(clk),
   .reset(~rst_n),
   .hsync(hsync),
   .vsync(vsync),
   .display_on(video_active),
   .hpos(x),
   .vpos(y)
 );


 // Center coordinates
 wire signed [10:0] cx = x - 320;
 wire signed [10:0] cy = y - 240;

 // Absolute values
 wire [10:0] ax = cx[10] ? -cx : cx;
 wire [10:0] ay = cy[10] ? -cy : cy;

 // Distance + angle
 wire [10:0] distance_val = ax + ay;
 wire [10:0] angle_val = cx ^ cy;

 // Time
 wire [10:0] t = counter;

 // Motion
 wire [10:0] rings = distance_val + t;
 wire [10:0] stripes = angle_val + (t << 1);

 // Pattern
 wire pattern = rings[5] ^ stripes[5];

 // Depth shading
 wire [1:0] shade = distance_val[8:7];

 // RGB output
 assign R = video_active ? (pattern ? {shade[1], 1'b0} : 2'b00) : 2'b00;
 assign G = video_active ? (pattern ? {shade[0], 1'b0} : 2'b00) : 2'b00;
 assign B = video_active ? (pattern ? {1'b1, shade[1]} : 2'b00) : 2'b00;

 // Animation counter
 always @(posedge vsync or negedge rst_n) begin
   if (!rst_n)
     counter <= 0;
   else
     counter <= counter + 1;
 end

endmodule