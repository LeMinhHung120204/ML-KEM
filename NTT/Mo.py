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


a = 2**9+134
print(k2_red_mod_3329(a))
print(a % 3329)