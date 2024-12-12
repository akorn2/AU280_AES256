module AES_Extractor# (parameter NumMods = 16)(in, en, ans);
//params
input [2047:0] in;
input en;
output [2047:0] ans;    //the answer
//NOTE: NIC SHELL NIC SHELL - LIKE OPEN NIC SHELL, BUT SOMETHING TO INTERACT WITH NIC 
//"variables"
//NumMods represent how many encryption & decryption modules are established
//wire [(NumMods*128)-1:0] secret;
reg [2047:0] ans;
wire [255:0] key;
reg [2047:0] decrypt_txt;
wire [2047:0] enc_ans;
wire [2047:0] dec_ans;
//wire [(NumMods*128)-1:0] plaintext;
//reg pending;
//assign secret[(NumMods*128)-1:((NumMods*128)*3/4)] = 512'h0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210_0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210;
//assign secret[((NumMods*128)*3/4)-1:((NumMods*128)/2)] = 512'h0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210_0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210;
//assign secret[((NumMods*128)/2)-1:((NumMods*128)/4)] = 512'h0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210_0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210;
//assign secret[((NumMods*128)/4)-1:0] = 512'h0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210_0123456789abcdef_0123456789abcdef_fedcba9876543210_fedcba9876543210;
//assign key = 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C;
//establish PCIe FIFO

//establish NIC FIFO

//establish AXI for PCIe

//establish AXI for NIC

//Instantiate encryption & decryption modules
genvar j;
generate
    for(j=0; j<16; j=j+1)begin : loop
        AES_Encrypt #(256, 14, 8) tester(in[(2048-(128*j)-1):(2048-(128*(j+1)))], 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,enc_ans[(2048-(128*j)-1):(2048-(128*(j+1)))]);
        AES_Decrypt #(256, 14, 8) decrypter(decrypt_txt[(2048-(128*j)-1):(2048-(128*(j+1)))], 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,dec_ans[(2048-(128*j)-1):(2048-(128*(j+1)))]);
        end
endgenerate
always @(*) begin
    if(en) begin
        decrypt_txt <= enc_ans;
        ans <= dec_ans;
    end
    else begin
        decrypt_txt <= 2048'h0;
        ans <= enc_ans;
    end
end
//AES_Encrypt #(256, 14, 8) tester0(in[2047:(2048-128)], 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f,ans[2047:(2048-128)]);

//AES_Encrypt #(256, 14, 8) enc0(in[2047:1920], key, ans[2047:1920]);
//AES_Encrypt #(256, 14, 8) enc1(in[1919:1792], key, ans[1919:1792]);
//AES_Encrypt #(256, 14, 8) enc2(in[1791:1664], key, ans[1791:1664]);
//AES_Encrypt #(256, 14, 8) enc3(in[1663:1536], key, ans[1663:1536]);
//AES_Encrypt #(256, 14, 8) enc4(in[1535:1408], key, ans[1535:1408]);
//AES_Encrypt #(256, 14, 8) enc5(in[1407:1280], key, ans[1407:1280]);
//AES_Encrypt #(256, 14, 8) enc6(in[1279:1152], key, ans[1279:1152]);
//AES_Encrypt #(256, 14, 8) enc7(in[1151:1024], key, ans[1151:1024]);
//AES_Encrypt #(256, 14, 8) enc8(in[1023:896], key, ans[1023:896]);
//AES_Encrypt #(256, 14, 8) enc9(in[895:768], key, ans[895:768]);
//AES_Encrypt #(256, 14, 8) enca(in[767:640], key, ans[767:640]);
//AES_Encrypt #(256, 14, 8) encb(in[639:512], key, ans[639:512]);
//AES_Encrypt #(256, 14, 8) encc(in[511:384], key, ans[511:384]);
//AES_Encrypt #(256, 14, 8) encd(in[383:256], key, ans[383:256]);
//AES_Encrypt #(256, 14, 8) ence(in[255:128], key, ans[255:128]);
//AES_Encrypt #(256, 14, 8) encf(in[127:0], key, ans[127:0]);
endmodule