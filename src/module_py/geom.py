def get_node_index(node, axis):
    ndof = 0
    if axis == 'x':
        ndof = 1
    elif axis == 'z':
        ndof = 3
    else:
        print('ERROR:座標軸指定が適切でない')
        return[]

    list = []
    for i in range(len(node)):
        list.append(node[i][ndof])

    list_sorted = sorted(set(list))
    
    diff = []
    for i in range(1, len(list_sorted), 1):
        diff.append(list_sorted[i] - list_sorted[i-1])

    diff_max = max(diff)
    
    index_diff = []
    for i in range(len(diff)):
        if diff[i] == diff_max:
            index_diff.append(i)

    index = []
    index.append(list_sorted[0])
    for i in range(len(index_diff)):
        inc = index_diff[i]
        index.append(list_sorted[inc+1])

    # print(len(list_sorted))
    # print(list_sorted)
    return index

def divide_node_to_subcell(node, node_index):
    list = [[[] for _ in range(len(node_index[1]))] for _ in range(len(node_index[0]))]
    for i in range(len(node_index[0])):
        xn = node_index[0][i]
        for j in range(len(node_index[1])):
            zn = node_index[1][j]
            for k in range(len(node)):
                is_active_x = node[k][1] >= xn and node[k][1] <= xn + 1.0
                is_active_z = node[k][3] >= zn and node[k][3] <= zn + 1.0
                if is_active_x and is_active_z:
                    list[i][j].append(node[k])

    return list

