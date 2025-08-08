def div3329(a):
    # a * μ  (μ = 5039)
    tmp = a * 20159
    print(tmp)
    return tmp >> 26  # chia 2^26

# Test
a = 3329
print(a)
print(a // 3329, div3329(a))
