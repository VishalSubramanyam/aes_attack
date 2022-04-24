#include <aes_core.h>
#include <aes_tables.h>
#include <common.h>

#include <cassert>

__constant__ AES_KEY globalKey;

__global__ void AES_ecb_encrypt_kernel(
        const u8     *in_d,
        u8           *out_d,
        unsigned long block_count,
        u64          *timeTaken_d
) {
    /* computer the thread id */
    int        idx = blockDim.x * blockIdx.x + threadIdx.x;
    const u32 *rk;
    u32        s0, s1, s2, s3, t0, t1, t2, t3;
    const u8  *in  = in_d + 16 * idx;
    u8        *out = out_d + 16 * idx;
    assert(in && out);
    rk = globalKey.rd_key;
    __syncthreads();
    u64 beginning = clock64();
    /*
     * map byte array block to cipher state
     * and add initial round key:
     */
    s0 = GETU32(in) ^ rk[0];
    s1 = GETU32(in + 4) ^ rk[1];
    s2 = GETU32(in + 8) ^ rk[2];
    s3 = GETU32(in + 12) ^ rk[3];
    /* round 1: */
    t0 = Te0[s0 >> 24] ^ Te1[(s1 >> 16) & 0xff] ^ Te2[(s2 >> 8) & 0xff] ^
         Te3[s3 & 0xff] ^ rk[4];
    t1 = Te0[s1 >> 24] ^ Te1[(s2 >> 16) & 0xff] ^ Te2[(s3 >> 8) & 0xff] ^
         Te3[s0 & 0xff] ^ rk[5];
    t2 = Te0[s2 >> 24] ^ Te1[(s3 >> 16) & 0xff] ^ Te2[(s0 >> 8) & 0xff] ^
         Te3[s1 & 0xff] ^ rk[6];
    t3 = Te0[s3 >> 24] ^ Te1[(s0 >> 16) & 0xff] ^ Te2[(s1 >> 8) & 0xff] ^
         Te3[s2 & 0xff] ^ rk[7];
    /* round 2: */
    s0 = Te0[t0 >> 24] ^ Te1[(t1 >> 16) & 0xff] ^ Te2[(t2 >> 8) & 0xff] ^
         Te3[t3 & 0xff] ^ rk[8];
    s1 = Te0[t1 >> 24] ^ Te1[(t2 >> 16) & 0xff] ^ Te2[(t3 >> 8) & 0xff] ^
         Te3[t0 & 0xff] ^ rk[9];
    s2 = Te0[t2 >> 24] ^ Te1[(t3 >> 16) & 0xff] ^ Te2[(t0 >> 8) & 0xff] ^
         Te3[t1 & 0xff] ^ rk[10];
    s3 = Te0[t3 >> 24] ^ Te1[(t0 >> 16) & 0xff] ^ Te2[(t1 >> 8) & 0xff] ^
         Te3[t2 & 0xff] ^ rk[11];
    /* round 3: */
    t0 = Te0[s0 >> 24] ^ Te1[(s1 >> 16) & 0xff] ^ Te2[(s2 >> 8) & 0xff] ^
         Te3[s3 & 0xff] ^ rk[12];
    t1 = Te0[s1 >> 24] ^ Te1[(s2 >> 16) & 0xff] ^ Te2[(s3 >> 8) & 0xff] ^
         Te3[s0 & 0xff] ^ rk[13];
    t2 = Te0[s2 >> 24] ^ Te1[(s3 >> 16) & 0xff] ^ Te2[(s0 >> 8) & 0xff] ^
         Te3[s1 & 0xff] ^ rk[14];
    t3 = Te0[s3 >> 24] ^ Te1[(s0 >> 16) & 0xff] ^ Te2[(s1 >> 8) & 0xff] ^
         Te3[s2 & 0xff] ^ rk[15];
    /* round 4: */
    s0 = Te0[t0 >> 24] ^ Te1[(t1 >> 16) & 0xff] ^ Te2[(t2 >> 8) & 0xff] ^
         Te3[t3 & 0xff] ^ rk[16];
    s1 = Te0[t1 >> 24] ^ Te1[(t2 >> 16) & 0xff] ^ Te2[(t3 >> 8) & 0xff] ^
         Te3[t0 & 0xff] ^ rk[17];
    s2 = Te0[t2 >> 24] ^ Te1[(t3 >> 16) & 0xff] ^ Te2[(t0 >> 8) & 0xff] ^
         Te3[t1 & 0xff] ^ rk[18];
    s3 = Te0[t3 >> 24] ^ Te1[(t0 >> 16) & 0xff] ^ Te2[(t1 >> 8) & 0xff] ^
         Te3[t2 & 0xff] ^ rk[19];
    /* round 5: */
    t0 = Te0[s0 >> 24] ^ Te1[(s1 >> 16) & 0xff] ^ Te2[(s2 >> 8) & 0xff] ^
         Te3[s3 & 0xff] ^ rk[20];
    t1 = Te0[s1 >> 24] ^ Te1[(s2 >> 16) & 0xff] ^ Te2[(s3 >> 8) & 0xff] ^
         Te3[s0 & 0xff] ^ rk[21];
    t2 = Te0[s2 >> 24] ^ Te1[(s3 >> 16) & 0xff] ^ Te2[(s0 >> 8) & 0xff] ^
         Te3[s1 & 0xff] ^ rk[22];
    t3 = Te0[s3 >> 24] ^ Te1[(s0 >> 16) & 0xff] ^ Te2[(s1 >> 8) & 0xff] ^
         Te3[s2 & 0xff] ^ rk[23];
    /* round 6: */
    s0 = Te0[t0 >> 24] ^ Te1[(t1 >> 16) & 0xff] ^ Te2[(t2 >> 8) & 0xff] ^
         Te3[t3 & 0xff] ^ rk[24];
    s1 = Te0[t1 >> 24] ^ Te1[(t2 >> 16) & 0xff] ^ Te2[(t3 >> 8) & 0xff] ^
         Te3[t0 & 0xff] ^ rk[25];
    s2 = Te0[t2 >> 24] ^ Te1[(t3 >> 16) & 0xff] ^ Te2[(t0 >> 8) & 0xff] ^
         Te3[t1 & 0xff] ^ rk[26];
    s3 = Te0[t3 >> 24] ^ Te1[(t0 >> 16) & 0xff] ^ Te2[(t1 >> 8) & 0xff] ^
         Te3[t2 & 0xff] ^ rk[27];
    /* round 7: */
    t0 = Te0[s0 >> 24] ^ Te1[(s1 >> 16) & 0xff] ^ Te2[(s2 >> 8) & 0xff] ^
         Te3[s3 & 0xff] ^ rk[28];
    t1 = Te0[s1 >> 24] ^ Te1[(s2 >> 16) & 0xff] ^ Te2[(s3 >> 8) & 0xff] ^
         Te3[s0 & 0xff] ^ rk[29];
    t2 = Te0[s2 >> 24] ^ Te1[(s3 >> 16) & 0xff] ^ Te2[(s0 >> 8) & 0xff] ^
         Te3[s1 & 0xff] ^ rk[30];
    t3 = Te0[s3 >> 24] ^ Te1[(s0 >> 16) & 0xff] ^ Te2[(s1 >> 8) & 0xff] ^
         Te3[s2 & 0xff] ^ rk[31];
    /* round 8: */
    s0 = Te0[t0 >> 24] ^ Te1[(t1 >> 16) & 0xff] ^ Te2[(t2 >> 8) & 0xff] ^
         Te3[t3 & 0xff] ^ rk[32];
    s1 = Te0[t1 >> 24] ^ Te1[(t2 >> 16) & 0xff] ^ Te2[(t3 >> 8) & 0xff] ^
         Te3[t0 & 0xff] ^ rk[33];
    s2 = Te0[t2 >> 24] ^ Te1[(t3 >> 16) & 0xff] ^ Te2[(t0 >> 8) & 0xff] ^
         Te3[t1 & 0xff] ^ rk[34];
    s3 = Te0[t3 >> 24] ^ Te1[(t0 >> 16) & 0xff] ^ Te2[(t1 >> 8) & 0xff] ^
         Te3[t2 & 0xff] ^ rk[35];
    /* round 9: */
    t0 = Te0[s0 >> 24] ^ Te1[(s1 >> 16) & 0xff] ^ Te2[(s2 >> 8) & 0xff] ^
         Te3[s3 & 0xff] ^ rk[36];
    t1 = Te0[s1 >> 24] ^ Te1[(s2 >> 16) & 0xff] ^ Te2[(s3 >> 8) & 0xff] ^
         Te3[s0 & 0xff] ^ rk[37];
    t2 = Te0[s2 >> 24] ^ Te1[(s3 >> 16) & 0xff] ^ Te2[(s0 >> 8) & 0xff] ^
         Te3[s1 & 0xff] ^ rk[38];
    t3 = Te0[s3 >> 24] ^ Te1[(s0 >> 16) & 0xff] ^ Te2[(s1 >> 8) & 0xff] ^
         Te3[s2 & 0xff] ^ rk[39];

    // move the pointer 16 * 10 bytes ahead to get to the final round key
    rk += globalKey.rounds << 2;
    /*
     * apply last round and
     * map cipher state to byte array block:
     */
    s0 = (Te4[(t0 >> 24)] & 0xff000000) ^ (Te4[(t1 >> 16) & 0xff] & 0x00ff0000) ^
         (Te4[(t2 >> 8) & 0xff] & 0x0000ff00) ^ (Te4[(t3) &0xff] & 0x000000ff) ^
         rk[0];
    PUTU32(out,
           s0);
    s1 = (Te4[(t1 >> 24)] & 0xff000000) ^ (Te4[(t2 >> 16) & 0xff] & 0x00ff0000) ^
         (Te4[(t3 >> 8) & 0xff] & 0x0000ff00) ^ (Te4[(t0) &0xff] & 0x000000ff) ^
         rk[1];
    PUTU32(out + 4,
           s1);
    s2 = (Te4[(t2 >> 24)] & 0xff000000) ^ (Te4[(t3 >> 16) & 0xff] & 0x00ff0000) ^
         (Te4[(t0 >> 8) & 0xff] & 0x0000ff00) ^ (Te4[(t1) &0xff] & 0x000000ff) ^
         rk[2];
    PUTU32(out + 8,
           s2);
    s3 = (Te4[(t3 >> 24)] & 0xff000000) ^ (Te4[(t0 >> 16) & 0xff] & 0x00ff0000) ^
         (Te4[(t1 >> 8) & 0xff] & 0x0000ff00) ^ (Te4[(t2) &0xff] & 0x000000ff) ^
         rk[3];
    PUTU32(out + 12,
           s3);
    u64 end      = clock64();
    *timeTaken_d = (end - beginning);
}

/**
 * AES ECB Encryption wrapper for the underlying CUDA kernel
 * Takes a 32 block (1 block = 128 bits) plaintext and encrypts it.
 * Each block is handled by a separate thread -> 32 threads for 32 blocks (1
 * warp)
 */
void AES_ecb_128_encrypt_gpu(
        const u8          *in_h,
        u8                *out_h,
        const AES_KEY     *expanded_key_h,
        u64               *timeTaken_h,
        cudaStream_t       stream,
        unsigned long      aes_block_count,
        const unsigned int threads_per_blk
) {
    u8  *in_d;
    u8  *out_d;
    u64 *timeTaken_d;
    cudaMalloc(
            &in_d,
            aes_block_count * 16
    );// 1 block -> 128 bits -> 16 bytes
    cudaMalloc(
            &out_d,
            aes_block_count * 16
    );// 1 block -> 128 bits -> 16 bytes

    cudaMalloc(
            &timeTaken_d,
            8
    );// allocate 4 bytes to store timing information

    // copy the input data to the GPU
    cudaMemcpy(
            in_d,
            in_h,
            aes_block_count * 16,
            cudaMemcpyHostToDevice
    );

    // copy the expanded key to the GPU's constant memory
    cudaMemcpyToSymbol(
            globalKey,
            expanded_key_h,
            sizeof(AES_KEY)
    );

    unsigned int num_cuda_blks =
            (aes_block_count + threads_per_blk - 1) / threads_per_blk;// ceil
    if (stream == 0) {
        AES_ecb_encrypt_kernel<<<num_cuda_blks, threads_per_blk>>>(
                in_d,
                out_d,
                aes_block_count,
                timeTaken_d
        );
    } else {
        AES_ecb_encrypt_kernel<<<num_cuda_blks, threads_per_blk, 0, stream>>>(
                in_d,
                out_d,
                aes_block_count,
                timeTaken_d
        );
    }
    cudaMemcpy(
            out_h,
            out_d,
            aes_block_count * 16,
            cudaMemcpyDeviceToHost
    );
    cudaMemcpy(
            timeTaken_h,
            timeTaken_d,
            8,
            cudaMemcpyDeviceToHost
    );
    cudaFree(in_d);
    cudaFree(out_d);
    cudaFree(timeTaken_d);
}

int AES_set_encrypt_key_128(
        const unsigned char *userKey,
        AES_KEY             *key
) {
    u32 *rk;
    int  i = 0;
    u32  temp;

    if (!userKey || !key)
        return -1;
    key->rounds = 10;
    rk          = key->rd_key;
    rk[0]       = GETU32(userKey);
    rk[1]       = GETU32(userKey + 4);
    rk[2]       = GETU32(userKey + 8);
    rk[3]       = GETU32(userKey + 12);
    for (;;) {
        temp  = rk[3];
        rk[4] = rk[0] ^ (Te4_host[(temp >> 16) & 0xff] & 0xff000000) ^
                (Te4_host[(temp >> 8) & 0xff] & 0x00ff0000) ^
                (Te4_host[(temp) &0xff] & 0x0000ff00) ^
                (Te4_host[(temp >> 24)] & 0x000000ff) ^ rcon[i];
        rk[5] = rk[1] ^ rk[4];
        rk[6] = rk[2] ^ rk[5];
        rk[7] = rk[3] ^ rk[6];
        if (++i == 10) {
            return 0;
        }
        rk += 4;
    }
    return 0;
}