#credit to tcitry on GitHub for base implementation
#Lightly edited by Alexander Korn, 11/24

import base64
import time
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend
from django.utils.encoding import force_bytes, force_str

SECRET_KEY = "WordsMeaninglessAsWickedAndCruel"
#value = force_bytes("Danny Rensch and Levy Rozman are the best people I know. But really all I need to do is to provide a bunch of random text and characters, like this: ?*!!!*?. You weren't expecting a normal sentence, were you? It's a test and in ASCII I need 256 characters.")
value = force_bytes("Danny Rensch and")

backend = default_backend()
key = force_bytes(base64.urlsafe_b64encode(force_bytes(SECRET_KEY))[:32])


class Crypto:

    def __init__(self):
        self.encryptor = Cipher(algorithms.AES(key), modes.ECB(), backend).encryptor()
        self.decryptor = Cipher(algorithms.AES(key), modes.ECB(), backend).decryptor()

    def encrypt(self):
        #padder = padding.PKCS7(algorithms.AES(key).block_size).padder()
        #padded_data = padder.update(value) + padder.finalize()
        padded_data = value
        encrypted_text = self.encryptor.update(padded_data) #+ self.encryptor.finalize()
        return encrypted_text

    def decrypt(self, value):
        #padder = padding.PKCS7(algorithms.AES(key).block_size).unpadder()
        decrypted_data = self.decryptor.update(value)
        return decrypted_data
        #unpadded = padder.update(decrypted_data) + padder.finalize()
        #return unpadded


if __name__ == '__main__':
    print('>>>>>>>>>>>')
    crypto = Crypto()
    #text = force_str(base64.urlsafe_b64encode(crypto.encrypt()))
    enc_start = time.time()
    text = crypto.encrypt()
    enc_end = time.time()
    suptext = crypto.decrypt(base64.urlsafe_b64decode(force_str(base64.urlsafe_b64encode(text))))
    dec_end = time.time()
    print("CPU Execution Times")
    print("Elapsed Encryption: " + str(enc_end-enc_start))
    print("Elapsed Decryption: " + str(dec_end-enc_end))
    print("Elapsed Total: " + str(dec_end-enc_start))
    hextext = text.hex()
    print(hextext)
    print('<<<<<<<<<<<<<')
    #text = crypto.decrypt(base64.urlsafe_b64decode(force_str(base64.urlsafe_b64encode(text))))
    print(suptext)