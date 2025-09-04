# -*- coding: utf-8 -*-
# NTT / iNTT (Kyber params) + input mapping interleaved như testbench:
# in0 @ addr 2*i, in1 @ addr 2*i+1  (i = 0..127)

# ----- Tham số -----
POLY_N = 256
POLY_Q = 3329
NTT_F  = 3303  # hệ số nhân sau cùng của iNTT (theo mã C đã cho)

NTT_ZETAS = [
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
]

def mod_q(x: int) -> int:
    return x % POLY_Q

def cal_ntt(a, b, zeta):
    t = zeta * b
    return ((a + t) % 3329, (a - t) % 3329)
def cal_intt(a, b, zeta):
    t = a
    a = t + b
    b = (b - t) * zeta
    return (a % 3329, b % 3329)

def ntt(a):
    """
    NTT theo Algorithm 9 (mã C đã cho).
    - Đầu vào: a độ dài 256, thứ tự chuẩn
    - Đầu ra:  a ở thứ tự bit-reversed (Kyber)
    """
    a = [mod_q(x) for x in a]
    k = 1
    l = POLY_N // 2  # 128
    while l >= 2:
        start = 0
        while start < POLY_N:
            zeta = NTT_ZETAS[k]
            k += 1
            for j in range(start, start + l):
                t = mod_q(zeta * a[j + l])
                a[j + l] = mod_q(a[j] - t)
                a[j]     = mod_q(a[j] + t)
            start += 2 * l
        l >>= 1
    return a

def div2(a):
    if (a & 1 == 1):
        return (a >> 1) + 1665
    else :
        return a >> 1
    

def intt(a):
    """
    Inverse NTT theo Algorithm 10 (mã C đã cho).
    - Đầu vào: a ở thứ tự bit-reversed (kết quả NTT)
    - Đầu ra:  trở về miền hệ số thường
    """
    a = [mod_q(x) for x in a]
    l = 2
    l_upper = POLY_N // 2  # 128
    k = l_upper - 1
    while l <= l_upper:
        start = 0
        while start < POLY_N:
            zeta = NTT_ZETAS[k]
            k -= 1
            for j in range(start, start + l):
                t = a[j]
                a[j]     = div2((t + a[j + l]) % POLY_Q)
                a[j + l] = div2(((a[j + l] - t) * zeta) % POLY_Q)
                
                # a[j]     = mod_q(t + a[j + l])
                # a[j + l] = mod_q((a[j + l] - t) * zeta)
            start += 2 * l
        l <<= 1
    # return [mod_q(x * NTT_F) for x in a]
    return [mod_q(x) for x in a]

def build_tb_interleaved():
    """
    Mapping đúng như TB:
      - 128 chu kỳ với k=1..128
      - in0 = k       --> ghi vào addr 2*(k-1)
      - in1 = 145+2k  --> ghi vào addr 2*(k-1)+1
    """
    a = [0]*POLY_N
    for k in range(1, 129):
        a[2*(k-1)]   = k
        a[2*(k-1)+1] = 145 + 2*k
    return a

if __name__ == "__main__":
    a = build_tb_interleaved()

    # Preview mapping đầu/cuối để đối chiếu
    # print("Mapping preview (addr:value):")
    # for i in range(6):
    #     i0, i1 = 2*i, 2*i+1
    #     print(f"{i0:3d}:{a[i0]:3d}   {i1:3d}:{a[i1]:3d}")
    # print("...")
    # for i in range(124, 128):
    #     i0, i1 = 2*i, 2*i+1
    #     print(f"{i0:3d}:{a[i0]:3d}   {i1:3d}:{a[i1]:3d}")
    # print()

    # Tính NTT và in 10 output đầu
    a_ntt = intt(a[:])
    print("First 10 NTT outputs:")
    for i in range(256):
        print(f"{i}: {a_ntt[i]}")

    # x = 1
    # y = 65
    # zetas = 1729
    # print(cal_ntt(x, y, zetas))
    # print((x - y * zetas) % 3329)
    # print((1598 * 3303) % 3329, (1201 * 3303) % 3329)

    # # Kiểm tra tròn vòng
    # a_back = intt(a_ntt[:])
    # ok = all((x % POLY_Q) == (y % POLY_Q) for x, y in zip(a, a_back))
    # print("\nRound-trip OK?:", ok)
