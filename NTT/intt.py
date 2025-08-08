import numpy as np
from dataclasses import dataclass

POLY_N = 256
POLY_Q = 3329 # 62209
NTT_F = 3303

NTT_ZETAS = np.array([
    1, 1729, 2580, 3289, 2642, 630, 1897, 848,
    1062, 1919, 193, 797, 2786, 3260, 569, 1746,
    296, 2447, 1339, 1476, 3046, 56, 2240, 1333,
    1426, 2094, 535, 2882, 2393, 2879, 1974, 821,
    289, 331, 3253, 1756, 1197, 2304, 2277, 2055,
    650, 1977, 2513, 632, 2865, 33, 1320, 1915,
    2319, 1435, 807, 452, 1438, 2868, 1534, 2402,
    2647, 2617, 1481, 648, 2474, 3110, 1227, 910,
    17, 2761, 583, 2649, 1637, 723, 2288, 1100,
    1409, 2662, 3281, 233, 756, 2156, 3015, 3050,
    1703, 1651, 2789, 1789, 1847, 952, 1461, 2687,
    939, 2308, 2437, 2388, 733, 2337, 268, 641,
    1584, 2298, 2037, 3220, 375, 2549, 2090, 1645,
    1063, 319, 2773, 757, 2099, 561, 2466, 2594,
    2804, 1092, 403, 1026, 1143, 2150, 2775, 886,
    1722, 1212, 1874, 1029, 2110, 2935, 885, 2154
], dtype=np.int16)

@dataclass
class PolynomialRing:
    coeffs: np.ndarray
    ntt: bool = False
    valid: bool = False

def ntt_inv(p: PolynomialRing) -> PolynomialRing:
    p.coeffs = p.coeffs.astype(np.int64)
    l = 2
    l_upper = 128
    k = l_upper - 1

    while l <= l_upper:
        start = 0
        while start < POLY_N:
            zeta = int(NTT_ZETAS[k])
            # print(start, l, k)
            k -= 1
            
            for j in range(start, start + l):
                # print(f"({j}, {j + l})", end=" ")
                t = p.coeffs[j]
                u = p.coeffs[j + l]
                p.coeffs[j] = (t + u) % POLY_Q
                p.coeffs[j + l] = ((u - t + POLY_Q) % POLY_Q * zeta) % POLY_Q
            # print()
            # print()
            start += 2 * l
        l <<= 1

    for i in range(POLY_N):
        p.coeffs[i] = (p.coeffs[i] * NTT_F) % POLY_Q

    p.ntt = False
    return p

def ntt(p: PolynomialRing) -> PolynomialRing:
    p.coeffs = p.coeffs.astype(np.int64)
    k = 1
    l = 128

    while l >= 2:
        start = 0
        while start < POLY_N:
            zeta = int(NTT_ZETAS[k])
            k += 1
            for j in range(start, start + l):
                t = (zeta * p.coeffs[j + l]) % POLY_Q
                p.coeffs[j + l] = (p.coeffs[j] - t + POLY_Q) % POLY_Q
                p.coeffs[j] = (p.coeffs[j] + t) % POLY_Q
            start += 2 * l
        l >>= 1

    p.ntt = True
    return p


# Khởi tạo mẫu
p = PolynomialRing(coeffs=np.zeros(POLY_N, dtype=np.int32), ntt=False)
p.coeffs[0] = 16
p.coeffs[1] = 20
p.coeffs[128] = 3
p.coeffs[129] = 5

# Forward NTT
p_ntt = ntt(PolynomialRing(coeffs=p.coeffs.copy()))
print("After NTT:", p_ntt.coeffs[:11])

# Inverse NTT
p_inv = ntt_inv(PolynomialRing(coeffs=p_ntt.coeffs.copy(), ntt=True))
print("After INTT:", p_inv.coeffs[:11])
