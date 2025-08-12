def brv(x, bits=7):
    return int(bin(x)[2:].zfill(bits)[::-1], 2)

q = 3329
zeta = 17
R = pow(2, 16, q)
NTT_ZETAS_128 = [(pow(zeta, brv(i), q) * R) % q for i in range(128)]
print(NTT_ZETAS_128)
