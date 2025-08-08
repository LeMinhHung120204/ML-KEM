def compute_k(B, q):
    INV = pow(2**16, -1, q)  # 2^(-16) mod q
    return (B * INV) % q


def AHMM(a, b, q, mu):
    w = 16
    AL = a & 0xFFFF          # A[15:0]
    AH = (a >> 16) & 0xFFFF  # A[31:16]

    #K = compute_k(b, q)      # B * 2^(-16) mod q

    C = AL * b + AH * b * 2**16

    # Montgomery Reduction loop, 2 iterations since L=2
    for _ in range(2):
        T = (C & 0xFFFF) * mu
        C = (C + (T& 0xFFFF) * q) >> w

    if C >= q:
        C -= q
    return C

# l = 2, w = 16
# mu = 57343

q = 8380417
a = 12345678
b = 12345678
R = 2**(32) % q # 4193792

mu = (-pow(q, -1, 2**16)) % 2**16
res = AHMM(a, b, q, mu)
print(f"{a} * {b} * R^-1 mod {q} = {res}")
print("Expected:", (a * b * pow(2**32, -1, q)) % q)
print()
print(f"{a} * {b} mod {q} = {(res * R) % q}")
print("Expected:", (a * b) % q)

