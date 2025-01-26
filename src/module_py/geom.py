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

def divide_elem_to_subcell_temp(node_divided, elem):
    list = [[[] for _ in range(len(node_divided[0]))] for _ in range(len(node_divided))]
    for i in range(len(node_divided)):
        for j in range(len(node_divided[1])):
            for k in range(len(node_divided[i][j])):
                for l in range(len(elem)):
                    for m in range(2, 10, 1):
                        elem_temp = elem[l][m]
                        if elem_temp == int(node_divided[i][j][k][0]):
                            list[i][j].append(elem[l])
    
    return list

def divide_elem_to_subcell(elem_divided_temp, n_x, n_z):
    temp_list = [[[] for _ in range(n_z)] for _ in range(n_x)]
    
    # eidのみを抽出（重複あり）
    for i in range(n_x):
        for j in range(n_z):
            for k in range(len(elem_divided_temp[i][j])):
                temp_list[i][j].append(elem_divided_temp[i][j][k][0])

    temp_list_set = [[[] for _ in range(n_z)] for _ in range(n_x)]

    # eidの重複解消
    for i in range(n_x):
        for j in range(n_z):
            temp_list_set[i][j] = list(dict.fromkeys(temp_list[i][j]))
            # print(len(temp_list[i][j]))

    # for i in range(n_x):
    #     for j in range(n_z):
    #         print(len(temp_list_set[i][j]))

    elem_divided = [[[] for _ in range(n_z)] for _ in range(n_x)]
    for i in range(n_x):
        for j in range(n_z):
            inc = 0
            for k in range(len(elem_divided_temp[i][j])):
                if inc != len(temp_list_set[i][j]) and elem_divided_temp[i][j][k][0] == temp_list_set[i][j][inc]:
                    elem_divided[i][j].append(elem_divided_temp[i][j][k])
                    inc = inc + 1

    return elem_divided

def arrange_coord_v3(node_divided, node_index):
    for i in range(len(node_divided)):
        for j in range(len(node_divided[0])):
            val_x = node_index[0][i]
            val_z = node_index[1][j]
            for k in range(len(node_divided[i][j])):
                node_divided[i][j][k][1] = node_divided[i][j][k][1] - val_x
                node_divided[i][j][k][3] = node_divided[i][j][k][3] - val_z

def sort_v3(node_divided):
    for i in range(len(node_divided)):
        for j in range(len(node_divided[0])):
            node_divided[i][j].sort(key=lambda x: x[0])

def renumber(elem_devided, node_divided, node_index):
    for i in range(len(node_index[0])):
        for j in range(len(node_index[1])):
            for k in range(len(node_divided[i][j])):
                n_id = int(node_divided[i][j][k][0])
                for l in range(len(elem_devided[i][j])):
                    for m in range(2,10,1):
                        if elem_devided[i][j][l][m] == n_id:
                            elem_devided[i][j][l][m] = k+1