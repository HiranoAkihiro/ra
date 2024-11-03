from module_py import read_subcell_all_v2 as read
from module_py import write_subcell_all_v2 as write
from module_py import arrange_subcell_all_v2 as arrange
import os
import numpy as np

file_path = './keyword/subcell_all_v2.k'
start_line_e = 82
end_line_e = 1428
start_line_e_num = 84
end_line_e_num = 1427
start_line_n = 1428
end_line_n = 3410
start_line_n_num = 1430
end_line_n_num = 3409

elem = read.get_elem_array(file_path, start_line_e, end_line_e, start_line_e_num, end_line_e_num)
node = read.get_node_array(file_path, start_line_n, end_line_n, start_line_n_num, end_line_n_num)

print(node[0])
print(node[1979])
node = arrange.normalize_node(node) # 節点座標正規化

dir = 'subcell_all_monolis'
for i in range(1,6,1):
    path = os.path.join(dir, f"block_{i}")
    os.makedirs(path, exist_ok=True)
write.elem(elem)
write.orientation(elem)
write.node(node)

# print(elem[0]) # eid     pid      n1      n2      n3      n4      n5      n6      n7      n8
print(node[0])
print(node[1979])