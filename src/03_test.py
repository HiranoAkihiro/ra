import ctypes
import numpy as np

f = np.ctypeslib.load_library("libfort.so", "./sobj/")
f.test_()

