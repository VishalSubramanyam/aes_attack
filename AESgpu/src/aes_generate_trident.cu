#include <aes_core.h>
#include <cinttypes>
#include <cstdio>
#include <sys/random.h>
int const NUM_MESSAGES = 1e6;

/**
 * argv[1] -> n -> n thread model
 */
int main(int argc, char *argv[]) {
    u8      secretKey[16 + 1] = "\x3F\x42\x3A\x45\x28\x48\xFB\x4D\x62\x50\x65\x53\x68\x56\x6D\x59";
    FILE   *generatedFile     = fopen("cipher.txt", "wt");
    AES_KEY key;
    AES_set_encrypt_key_128(secretKey, &key);
    for (int i = 0; i < NUM_MESSAGES; i++) {
        u8  plaintext[32 * 16];// 32 blocks of 16 bytes each
        u8  ciphertext[32 * 16];
        u64 timeTaken;
        // we are going to use n-thread model by controlling memory coalescing
        // In a 32 thread warp, the same plaintext message will be given to a group
        // of (32/n) threads, so effectively n different plaintexts need to be generated.
        int n = atoi(argv[1]);
        u8 pt[16];
        for (int j = 0; j < n; j++) {
            getrandom(pt, 16, 0);
            for (int k = 0; k < 32/n; k++) {
                memcpy(plaintext + 16 * (32/n) * j + 16 * k, pt, 16);
            }
        }
        AES_ecb_128_encrypt_gpu(plaintext, ciphertext, &key, &timeTaken);
        fprintf(generatedFile, "%" PRIu64 ":", timeTaken);
        for (int j = 0; j < 32 * 16; j++) {
            fprintf(generatedFile, "%.2X", plaintext[j]);
        }
        fprintf(generatedFile, ":");
        for (int j = 0; j < 32 * 16; j++) {
            fprintf(generatedFile, "%.2X", ciphertext[j]);
        }
        fprintf(generatedFile, "\n");
    }
}
