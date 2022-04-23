#ifndef COMMON_H
#define COMMON_H
#include <cstdint>
typedef uint32_t u32;
typedef uint8_t u8;
int constexpr    NR = 10;
struct aes_key_st
{
    u32 rd_key[4 * (NR + 1)];
    int rounds;
};
typedef struct aes_key_st AES_KEY;

#define GETU32(pt)                                                            \
    (((u32)(pt)[0] << 24) ^ ((u32)(pt)[1] << 16) ^ ((u32)(pt)[2] << 8)        \
     ^ ((u32)(pt)[3]))
#define PUTU32(ct, st)                                                        \
    {                                                                         \
        (ct)[0] = (u8)((st) >> 24);                                           \
        (ct)[1] = (u8)((st) >> 16);                                           \
        (ct)[2] = (u8)((st) >> 8);                                            \
        (ct)[3] = (u8)(st);                                                   \
    }
#endif // COMMON_H