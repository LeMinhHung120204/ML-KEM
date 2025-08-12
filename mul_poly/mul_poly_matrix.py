a0 = 135
a1 = 23
a2 = 35
a3 = 46
b0 = 386
b1 = 43
b2 = 513
b3 = 64
zetas = 2761
print ((a0 * b0 + zetas * a1 * b1) % 3329)
print ((a0 * b1 + a1 * b0)% 3329)

print ((a2 * b2 + (-zetas) * a3 * b3) % 3329)
print ((a3 * b2 + a2 * b3) % 3329)
