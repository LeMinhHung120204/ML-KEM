def barrett_reduce_shift_add(a: int) -> int:
    q = 8380417  # 2^23 + 1
    r = a - (a >> 23) * q
    if r >= q:
        r -= q
    elif r < 0:
        r += q
    return r

q = 8380417
for a in [4294967295]:
    r1 = barrett_reduce_shift_add(a)
    r2 = a % q
    print(f"a = {a}, Reduced = {r1}, Expected = {r2}, Match = {r1 == r2}")
