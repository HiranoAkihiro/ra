from module_py import read_subcell_all_v2 as read
# from module_py import write_subcell_all_v2 as write
# from module_py import arrange_subcell_all_v2 as arrange
from module_py import geom
from module_py import write
import os
import numpy as np
import sys
import ctypes

if sys.argv[1] == 'v2':
    file_path = './keyword/subcell_all_v2.k'
    start_line_e = 82
    end_line_e = 1428
    start_line_e_num = 84
    end_line_e_num = 1427
    start_line_n = 1428
    end_line_n = 3410
    start_line_n_num = 1430
    end_line_n_num = 3409
    print('NO PROGRAM')
    exit()
elif sys.argv[1] == 'v3':
    file_path = './keyword/subcell_all_v3.k'
    start_line_e = 137
    end_line_e = 2235
    start_line_e_num = 139
    end_line_e_num = 2234
    start_line_n = 2235
    end_line_n = 6224
    start_line_n_num = 2237
    end_line_n_num = 6223
else:
    print('NO PROGRAM')
    exit()


# keywordファイルから要素＆節点情報（リストのリスト）読み込み [OK]
print('reading files...', end=' ', flush=True)
elem = read.get_elem_array(file_path, start_line_e, end_line_e, start_line_e_num, end_line_e_num)
node = read.get_node_array(file_path, start_line_n, end_line_n, start_line_n_num, end_line_n_num)
print('done.')
print('')

# 幾何判定（各座標軸について、どのような節点分布があるかを把握）
# z方向、x方向が縦と横に対応、y方向が高さに対応しているので、z,x方向について分割情報を取得
# 節点のみブロックごとに分割したリストを取得（node_divided）
print('dividing nodes...', end=' ', flush=True)
node_index = []
node_index.append(geom.get_node_index(node, 'x'))
node_index.append(geom.get_node_index(node, 'z'))
node_divided = geom.divide_node_to_subcell(node, node_index) # [OK?]
n_x = len(node_index[0])
n_z = len(node_index[1])
print('done.')
print('')


# node_divided（ブロックごとに仕分けた節点情報）をもとに、全体の要素コネクティビティもブロックごとに分割する
print('dividing elems...', end=' ', flush=True)
elem_divided_temp = geom.divide_elem_to_subcell_temp(node_divided, elem)
elem_divided = geom.divide_elem_to_subcell(elem_divided_temp, n_x, n_z)
print('done.')
print('')

print('arranging nodes and elems...', end=' ', flush=True)
geom.arrange_coord_v3(node_divided, node_index)
geom.sort_v3(node_divided)
geom.sort_v3(elem_divided)
geom.renumber(elem_divided, node_divided, node_index)
# print(node_divided[0][0][0])
# print(elem_divided[0][0][0])
print('done.')
print('')

print('writing out mesh...', end=' ', flush=True)
write.elem(elem_divided, node_index)
write.node(node_divided, node_index)
write.mat(elem_divided, node_index)
f = np.ctypeslib.load_library("libfort.so", "./sobj/")
f.rotate_wrapper_()
print('done.')
print('')