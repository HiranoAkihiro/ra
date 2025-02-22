import ctypes
import numpy as np
import sys

p = ctypes.c_int32(int(sys.argv[1]))
temp = 1.0e-4
inf = ctypes.c_double(temp)
f = np.ctypeslib.load_library("libfort.so", "./sobj/")
f.test_.argtypes = [ctypes.POINTER(ctypes.c_int32), ctypes.POINTER(ctypes.c_double)]
f.test_.restype = None
f.test_(ctypes.byref(p), ctypes.byref(inf))

