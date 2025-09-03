# ntt_mul16.py
from dataclasses import dataclass
from typing import List, Sequence, Tuple

# -------------------- Tham số --------------------
POLY_Q = 3329  # Kyber

# NTT_ZETAS bạn cung cấp (128 phần tử)
NTT_ZETAS: List[int] = [
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

# -------------------- Kiểu dữ liệu --------------------
@dataclass
class DoubleInt16:
    r0: int  # trong [0, q-1]
    r1: int  # trong [0, q-1]

@dataclass
class PolynomialRing:
    coeffs: List[int]              # 256 hệ số (giá trị 0..q-1)
    ntt: bool = False
    valid: bool = False

# -------------------- Tiện ích --------------------
def to_int16(x: int) -> int:
    """Ép x về int16 (two's complement) giống int16_t của C."""
    x &= 0xFFFF
    return x - 0x10000 if x >= 0x8000 else x

# -------------------- Core ops --------------------
def ntt_base_multiplication(a0: int, a1: int, b0: int, b1: int, zeta: int, q: int = POLY_Q) -> DoubleInt16:
    """
    (r0, r1) = (a0*b0 + zeta*a1*b1, a1*b0 + a0*b1) mod q
    Ép đầu vào về int16 như C trước khi nhân.
    """
    a0 = to_int16(a0); a1 = to_int16(a1)
    b0 = to_int16(b0); b1 = to_int16(b1)
    zeta = to_int16(zeta)

    r0 = (a0 * b0 + zeta * a1 * b1) % q
    r1 = (a1 * b0 + a0 * b1) % q
    return DoubleInt16(int(r0), int(r1))

def block_mul4(a: Sequence[int], b: Sequence[int], zeta: int, q: int = POLY_Q) -> Tuple[int, int, int, int]:
    """
    Nhân một block 4 hệ số:
      (a0,a1)*(b0,b1) với zeta
      (a2,a3)*(b2,b3) với -zeta
    Trả về (r0,r1,r2,r3).
    """
    assert len(a) == 4 and len(b) == 4
    r01 = ntt_base_multiplication(a[0], a[1], b[0], b[1], zeta, q)
    r23 = ntt_base_multiplication(a[2], a[3], b[2], b[3], -zeta, q)
    return r01.r0, r01.r1, r23.r0, r23.r1

def mul_polynomials16(a: PolynomialRing, b: PolynomialRing, NTT_ZETAS: Sequence[int] = NTT_ZETAS, q: int = POLY_Q) -> PolynomialRing:
    """
    Nhân hai đa thức 256 hệ số trong miền NTT theo block 4 hệ số:
      - zeta = NTT_ZETAS[64 + i] cho (a0,a1)*(b0,b1)
      - -zeta cho (a2,a3)*(b2,b3)
    """
    assert len(a.coeffs) == 256 and len(b.coeffs) == 256, "Mỗi đa thức cần 256 hệ số."
    assert len(NTT_ZETAS) >= 128, "NTT_ZETAS phải có >=128 phần tử."

    res = PolynomialRing(coeffs=[0] * 256, ntt=True, valid=True)

    for i in range(64):
        zeta = NTT_ZETAS[64 + i]
        r0, r1, r2, r3 = block_mul4(
            a.coeffs[4*i : 4*i+4],
            b.coeffs[4*i : 4*i+4],
            zeta,
            q
        )
        res.coeffs[4*i + 0] = r0
        res.coeffs[4*i + 1] = r1
        res.coeffs[4*i + 2] = r2
        res.coeffs[4*i + 3] = r3

    return res

# -------------------- CLI đơn giản --------------------
def _read_ints_needed(n: int) -> List[int]:
    """Đọc đủ n số nguyên từ stdin (có thể qua nhiều dòng)."""
    vals: List[int] = []
    while len(vals) < n:
        line = input().strip()
        if not line:
            continue
        vals.extend(map(int, line.split()))
    return vals[:n]

def main():
    print("Chọn chế độ: 'block' (4 hệ số) hoặc 'poly' (256 hệ số). Nhập 'block' hoặc 'poly':")
    mode = input().strip().lower()

    if mode == "block":
        print("Nhập 4 số a (a0 a1 a2 a3):")
        a = _read_ints_needed(4)
        print("Nhập 4 số b (b0 b1 b2 b3):")
        b = _read_ints_needed(4)
        print("Nhập i (0..63) để chọn zeta = NTT_ZETAS[64 + i]:")
        i = int(input().strip())
        if not (0 <= i <= 63):
            raise ValueError("i phải trong [0,63].")
        zeta = NTT_ZETAS[64 + i]
        r0, r1, r2, r3 = block_mul4(a, b, zeta, POLY_Q)
        print("res:", r0, r1, r2, r3)

    elif mode == "poly":
        print("Nhập 256 số cho đa thức a (cách nhau bởi khoảng trắng, có thể nhập nhiều dòng):")
        a_coeffs = _read_ints_needed(256)
        print("Nhập 256 số cho đa thức b (cách nhau bởi khoảng trắng, có thể nhập nhiều dòng):")
        b_coeffs = _read_ints_needed(256)
        A = PolynomialRing(coeffs=a_coeffs, ntt=True, valid=True)
        B = PolynomialRing(coeffs=b_coeffs, ntt=True, valid=True)
        R = mul_polynomials16(A, B, NTT_ZETAS, POLY_Q)
        # In kết quả 256 số trên một dòng:
        print("res:", *R.coeffs)
    else:
        print("Chế độ không hợp lệ. Vui lòng chạy lại và nhập 'block' hoặc 'poly'.")

if __name__ == "__main__":
    # main()
    print((1*101 + 2*102*(1637)) % 3329) 
    print((3*103 + 4*104*(-1637)) % 3329) 
