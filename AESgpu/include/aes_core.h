#ifndef AES_CORE
#define AES_CORE
#include <aes_tables.h>
#include <common.h>

int
AES_set_encrypt_key_128 (const unsigned char *userKey, AES_KEY *key);

void AES_ecb_128_encrypt_gpu (const u8          *in_h,
                              u8                *out_h,
                              const AES_KEY     *expanded_key_h,
                              cudaStream_t       stream = 0,
                              unsigned long      aes_block_count = 32,
                              const unsigned int threads_per_blk = 32);

#endif // AES_CORE