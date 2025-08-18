def k2_red_mod_3329(a):
    k = 13
    q = 3329
    k2_inv = pow(k * k, -1, q)  # = 1441

    # Ensure a is at most 24-bit
    a = a & ((1 << 24) - 1)

    # Step 1
    Cl = a & 0xFF              # a[7:0]
    Ch = a >> 8                # a[23:8]
    C1 = k * Cl - Ch           # Intermediate result

    # Step 2
    Cl_ = C1 & 0xFF            # C1[7:0]
    Ch_ = C1 >> 8              # C1[15:8]
    C2 = k * Cl_ - Ch_

    # Normalize
    if C2 < 0:
        C2 += q
    elif C2 >= q:
        C2 -= q

    # If needed, recover original a mod q:
    result = (C2 * k2_inv) % q
    return result


# a = 2655
# b = 3088
# t = a
# a = b + t
# b = (b - t) * 1729


# print(a % 3329, b % 3329)
# print((2414 * 3303) % 3329)
# print((2961 * 3303) % 3329)

a = 201
b = 830
zetas = 2154
t = zetas * b

print(t % 3329)
print(a - (t % 3329))
print(a + (t % 3329))

b = a - t
a = a + t

print(a % 3329, b % 3329)
