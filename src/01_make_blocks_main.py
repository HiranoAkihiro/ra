from module_py import read_subcell_all_v2 as read
from module_py import write_subcell_all_v2 as write
from module_py import arrange_subcell_all_v2 as arrange
from module_py import geom
import os
import numpy as np
import sys

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
elif sys.argv[1] :
    file_path = './keyword/subcell_all_v3.k'
    start_line_e = 137
    end_line_e = 2235
    start_line_e_num = 139
    end_line_e_num = 2234
    start_line_n = 2235
    end_line_n = 6224
    start_line_n_num = 2237
    end_line_n_num = 6223


# keywordファイルから要素＆節点情報（リストのリスト）読み込み
elem = read.get_elem_array(file_path, start_line_e, end_line_e, start_line_e_num, end_line_e_num)
node = read.get_node_array(file_path, start_line_n, end_line_n, start_line_n_num, end_line_n_num)

print('*** read files ***')
print('')

# 幾何判定（各座標軸について、どのような節点分布があるかを把握）
# z方向、x方向が縦と横に対応、y方向が高さに対応しているので、z,x方向について分割情報を取得
# 節点のみブロックごとに分割したリストを取得（node_divided）
node_index = []
node_index.append(geom.get_node_index(node, 'x'))
node_index.append(geom.get_node_index(node, 'z'))
# print(node_index[0])
# print(node_index[1])

node_divided = geom.divide_node_to_subcell(node, node_index)
# for i in range(2):
#     for j in range(3):
#         print(len(node_divided[i][j]))

# print(len(node))

print('*** divided nodes ***')
print('')

# node_divided（ブロックごとに仕分けた節点情報）をもとに、全体の要素コネクティビティもブロックごとに分割する
elem_divided = geom.divide_elem_to_subcell(node_divided, elem)







# node = arrange.normalize_node(node) # 節点座標正規化



# メッシュデータをブロックごとに分割

# dir = 'subcell_all_monolis_v3'
# for i in range(1,6,1):
#     path = os.path.join(dir, f"block_{i}")
#     os.makedirs(path, exist_ok=True)
# write.elem(elem)
# write.orientation(elem)
# write.node(node)

# # print(elem[0]) # eid     pid      n1      n2      n3      n4      n5      n6      n7      n8
# print(node[0])
# print(node[1979])