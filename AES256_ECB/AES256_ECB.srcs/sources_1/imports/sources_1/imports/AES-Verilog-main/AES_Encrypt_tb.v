module AES_Encrypt_tb;
/*
reg [127:0] in1;
wire [127:0] out1;
reg [127:0] key1;

reg [127:0] in2;
wire [127:0] out2;
reg [191:0] key2;
*/
reg [127:0] in3;
wire [127:0] out3;
reg [255:0] key3;

wire [127:0] encrypted;

wire [127:0] truin3;
wire done;
wire finished;

//AES_Encrypt a(in1,key1,out1);
//AES_Encrypt #(192,12,6) b(in2,key2,out2);
AES_Encrypt #(256,14,8) c(in3,key3,out3);
AES_Decrypt #(256,14,8) d(encrypted, key3, truin3);

assign encrypted = (done) ? out3 : 128'h00000000_00000000_00000000_00000000;

initial begin
//$monitor("in128= %h, key128= %h ,out128= %h",in1,key1,out1);
//in1=128'h_3243f6a8_885a308d_313198a2_e0370734;
//key1=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
//#10;
//$monitor("in192= %h, key192= %h ,out192= %h",in2,key2,out2);
//in2=128'h_00112233_44556677_8899aabb_ccddeeff;
//key2=192'h_00010203_04050607_08090a0b_0c0d0e0f_10111213_14151617;
//#10;
in3=128'h0;
key3=128'h0;
#1
$monitor("in256= %h, key256= %h ,out256= %h ,decrypt256= %h",in3,key3,out3, encrypted);
in3=128'h61626364_65666768_696A6B6C_6D6E6F70;
key3=256'h00010203_04050607_08090a0b_0c0d0e0f_10111213_14151617_18191a1b_1c1d1e1f;

end
assign done = (out3!=128'hdc95c078a2408989ad48a21492842087) ? 1 : 0;
//end
always @(posedge done) in3 = 128'h31323334_35363738_39404142_43444546;

endmodule