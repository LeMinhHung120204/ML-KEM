import numpy as np

def negacyclic_mul(f, g, q=None):
    """
    h = f * g mod (x^n + 1); tùy chọn mod q cho hệ số.
    f, g: mảng độ dài n (list/np.array)
    """
    f = np.asarray(f, dtype=np.int64)
    g = np.asarray(g, dtype=np.int64)
    n = f.size
    h = np.zeros(n, dtype=np.int64)

    print(n)
    for i in range(n):
        s = 0
        # phần không wrap: + sum_{j=0..i} f_j * g_{i-j}
        print("add")
        for j in range(i + 1):
            print(f"({j}, {i - j})", end = " ")
            s += f[j] * g[i - j]
        

        print()
        print("sub")
        # phần wrap (vượt bậc): - sum_{j=i+1..n-1} f_j * g_{n+i-j}
        for j in range(i + 1, n):
            print(f"({j}, {n + i - j})", end = " ")
            s -= f[j] * g[n + i - j]
        print()
        print()
        if q is not None:
            s %= q
        h[i] = s
    return h

def negacyclic_mul_vec(f, g, q=None):
    f = np.asarray(f, dtype=np.int64)
    g = np.asarray(g, dtype=np.int64)
    n = f.size
    h = np.zeros(n, dtype=np.int64)

    for i in range(n):
        # chỉ số cho phần “+”
        j1 = np.arange(0, i+1)
        h[i] += (f[j1] * g[i - j1]).sum()
        # chỉ số cho phần “-”
        j2 = np.arange(i+1, n)
        h[i] -= (f[j2] * g[n + i - j2]).sum()
        if q is not None:
            h[i] %= q
    return h

def schoolbook_reduce_xn1(f, g, q=None):
    f = np.asarray(f, dtype=np.int64)
    g = np.asarray(g, dtype=np.int64)
    n = len(f)
    tmp = np.zeros(2*n-1, dtype=np.int64)
    for i in range(n):
        for j in range(n):
            tmp[i+j] += f[i]*g[j]
    # rút gọn theo x^n = -1
    h = tmp[:n].copy()
    for k in range(n, 2*n-1):
        h[k-n] -= tmp[k]  # vì x^n -> -1
    if q is not None:
        h %= q
    return h

# Ví dụ
n, q = 8, 41
f = np.array([3,1,0,2,0,0,0,0])
g = np.array([4,5,0,1,0,0,0,0])

h1 = negacyclic_mul(f, g, q)
h2 = schoolbook_reduce_xn1(f, g, q)
print(np.all(h1 == h2), h1)
