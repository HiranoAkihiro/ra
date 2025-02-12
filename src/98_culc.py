size = 12
nb = [0 for _ in range(size)]
p=7
nb[1] = 8*(p-1)
nb[2] = p
nb[3] = p*(p-1)
nb[4] = 2*(p-2)
nb[5] = p*(p-1)
nb[6] = 4*(p**2)
nb[7] = p
nb[8] = (p**2) - 3*p + 4
nb[9] = (p**2) - 3*p + 4
if p==2:
    nb[10] = 0
    nb[11] = 0
elif p==3:
    nb[10] = 0
    nb[11] = 1
else:
    a = p - 3
    b = p - 2
    nb[10] = a*(a+1)/2
    nb[11] = b*(b+1)/2
    
total = sum(nb)
sq = (3*p)**2
print(total, sq)