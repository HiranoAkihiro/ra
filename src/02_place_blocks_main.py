import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import ctypes
import numpy as np
import sys

def call_fortran(p, block_id, angle):
    f = np.ctypeslib.load_library("libfort.so", "./sobj/")
    f.mesh_pattern_map_wrapper_.argtypes = [
        ctypes.c_int32,
        ctypes.c_int32,
        np.ctypeslib.ndpointer(dtype=np.int32, ndim=2, flags='C_CONTIGUOUS'),
        np.ctypeslib.ndpointer(dtype=np.int32, ndim=2, flags='C_CONTIGUOUS')
        ]
    f.mesh_pattern_map_wrapper_.restype = None

    n = p*3
    f.mesh_pattern_map_wrapper_(ctypes.c_int32(p), ctypes.c_int32(n), block_id, angle)
    return n

p = int(sys.argv[1])
block_id = np.zeros([p*3,p*3], dtype=np.int32)
angle = np.zeros([p*3,p*3], dtype=np.int32)

n = call_fortran(p, block_id, angle)
print(block_id.shape)
# print(block_id[8,8])
# print(angle[8,8])

#'#00ff00'緑
#'#FFFF00'黄
#'#FF0000'赤
#'#FFC0CB'桃
#'#0000FF'青
#'#A52A2A'茶
#'#008000'深緑
#'#ADD8E6'水
#'#668811'黄緑

# 色データ生成
colors = np.full([n,n], '#00FF00')
# for i in range(0,n,1):
#     for j in range(0,n,1):
#         if block_id[i,j] == 1:
#             colors[i,j] = '#00FF00'
#         elif block_id[i,j] == 2:
#             colors[i,j] = '#FFFF00'
#         elif block_id[i,j] == 3:
#             colors[i,j] = '#FF0000'
#         elif block_id[i,j] == 4:
#             colors[i,j] = '#FFC0CB'
#         elif block_id[i,j] == 5:
#             colors[i,j] = '#A52A2A'
#         elif block_id[i,j] == 6:
#             colors[i,j] = '#668811'
#         elif block_id[i,j] == 7:
#             colors[i,j] = '#008000'
#         elif block_id[i,j] == 8:
#             colors[i,j] = '#0000FF'
#         elif block_id[i,j] == 9:
#             colors[i,j] = '#ADD806'
#         elif block_id[i,j] == 10:
#             colors[i,j] = '#FFFFFF'
#         elif block_id[i,j] == 11:
#             colors[i,j] = '#000000'

for i in range(0,n,1):
    for j in range(0,n,1):
        if block_id[i,j] == 1:
            colors[i,j] = '#FFFF00'
        elif block_id[i,j] == 2:
            colors[i,j] = '#FFC0CB'
        elif block_id[i,j] == 3:
            colors[i,j] = '#ADD806'
        elif block_id[i,j] == 4:
            colors[i,j] = '#A52A2A'
        elif block_id[i,j] == 5:
            colors[i,j] = '#008000'
        elif block_id[i,j] == 6:
            colors[i,j] = '#00FF00'
        elif block_id[i,j] == 7:
            colors[i,j] = '#FF0000'
        elif block_id[i,j] == 8:
            colors[i,j] = '#FFFFFF'
        elif block_id[i,j] == 9:
            colors[i,j] = '#ADD8E6'
        elif block_id[i,j] == 10:
            colors[i,j] = '#00ffff'

colors_rgb = np.array([[mcolors.to_rgb(color) for color in row] for row in colors])

# 数字データ生成
numbers = angle

fig, ax = plt.subplots()

im = ax.imshow(colors_rgb)

# 各セルに数字を追加
for i in range(n):
    for j in range(n):
        text = ax.text(j, i, numbers[i, j],
                        ha="center", va="center", color="k")

# plt.colorbar(im)

# グリッド線追加
ax.set_xticks(np.arange(-.5, n, 1), minor=True)
ax.set_yticks(np.arange(-.5, n, 1), minor=True)
ax.grid(which="minor", color="k", linestyle='-', linewidth=2)
ax.tick_params(which="minor", size=0)

# メジャーな目盛り削除
ax.set_xticks([])
ax.set_yticks([])

plt.show()
