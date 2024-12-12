#include <iostream>
#include <string>
#include <chrono>
#include <openssl/aes.h>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/bio.h>
#include <openssl/buffer.h>
#include <openssl/err.h>
#include <vector>
#include <iomanip>

#define SECRET_KEY "WordsMeaninglessAsWickedAndCruel"
//#define VALUE "Danny Rensch and"
#define VALUE "Danny Rensch and Levy Rozman are the best people I know. But really all I need to do is to provide a bunch of random text and characters, like this: ?*!!!*?. You weren't expecting a normal sentence, were you? It's a test and in ASCII I need 256 characters."

class Crypto {
private:
    EVP_CIPHER_CTX* encryptCtx;
    EVP_CIPHER_CTX* decryptCtx;
    std::vector<unsigned char> key;

public:
    Crypto() {
        encryptCtx = EVP_CIPHER_CTX_new();
        decryptCtx = EVP_CIPHER_CTX_new();

        // Generate key from SECRET_KEY
        std::string encoded_key = SECRET_KEY;
        encoded_key = encoded_key.substr(0, 32); // Ensure the key is 32 bytes long
        key.assign(encoded_key.begin(), encoded_key.end());

        // Initialize encryption context
        EVP_EncryptInit_ex(encryptCtx, EVP_aes_256_ecb(), nullptr, key.data(), nullptr);

        // Initialize decryption context
        EVP_DecryptInit_ex(decryptCtx, EVP_aes_256_ecb(), nullptr, key.data(), nullptr);
    }

    ~Crypto() {
        EVP_CIPHER_CTX_free(encryptCtx);
        EVP_CIPHER_CTX_free(decryptCtx);
    }

    std::vector<unsigned char> encrypt(const std::string& value) {
        std::vector<unsigned char> encrypted(value.size() + AES_BLOCK_SIZE);
        int len;
        EVP_EncryptUpdate(encryptCtx, encrypted.data(), &len, reinterpret_cast<const unsigned char*>(value.data()), value.size());
        encrypted.resize(len);
        return encrypted;
    }

    std::string decrypt(const std::vector<unsigned char>& encrypted_data) {
        std::vector<unsigned char> decrypted(encrypted_data.size());
        int len;
        EVP_DecryptUpdate(decryptCtx, decrypted.data(), &len, encrypted_data.data(), encrypted_data.size());
        decrypted.resize(len);
        return std::string(decrypted.begin(), decrypted.end());
    }
};

int main() {
    std::cout << ">>>>>>>>>>>>>>>>>>" << std::endl;

    Crypto crypto;
	//change code 2 lines down to SHORT_VALUE for 
    // Encryption
    std::chrono::high_resolution_clock::time_point enc_start = std::chrono::high_resolution_clock::now();
    std::vector<unsigned char> encrypted_data = crypto.encrypt(VALUE);
    std::chrono::high_resolution_clock::time_point enc_end = std::chrono::high_resolution_clock::now();

    // Decryption
    std::chrono::high_resolution_clock::time_point dec_start = std::chrono::high_resolution_clock::now();
    std::string decrypted_data = crypto.decrypt(encrypted_data);
    std::chrono::high_resolution_clock::time_point dec_end = std::chrono::high_resolution_clock::now();

    int enc_time = std::chrono::duration_cast<std::chrono::nanoseconds>(enc_end-enc_start).count();
    int dec_time = std::chrono::duration_cast<std::chrono::nanoseconds>(dec_end - dec_start).count();

    // Execution times
    std::cout << "CPU Execution Times" << std::endl;
    std::cout << "Elapsed Encryption: " << enc_time << " nanoseconds" << std::endl;
    //std::cout << "Elapsed Encryption: " << std::chrono::duration_cast<std::chrono::nanoseconds>(enc_time).count() << " nanoseconds" << std::endl;
    std::cout << "Elapsed Decryption: " << dec_time << " nanoseconds" << std::endl;
    std::cout << "Elapsed Total: " << (enc_time + dec_time) << " nanoseconds" << std::endl;

    // Print encrypted data as hex
    std::cout << "Hex Ciphertext: ";
    for (unsigned char byte : encrypted_data) {
        std::cout << std::hex << std::setw(2) << std::setfill('0') << (int)byte;
    }
    std::cout << std::endl;

    // Print decrypted data
    std::cout << "Decrypted Text: " << decrypted_data << std::endl;
    std::cout << "<<<<<<<<<<<<<<<<<<" << std::endl;

    return 0;
}
