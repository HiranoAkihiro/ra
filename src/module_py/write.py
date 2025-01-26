def elem(elem_divided, node_index):
    inc = 0
    for i in range(len(node_index[0])):
        for j in range(len(node_index[1])):
            inc = inc + 1
            with open(f'subcell_all_monolis_v3/block_{inc}/elem.dat', mode='w') as f:
                print(f'{len(elem_divided[i][j])} 8', file=f)
                for k in range(len(elem_divided[i][j])):
                    print(f'{elem_divided[i][j][k][0]: >8},', file=f, end='')
                    for l in range(2, 10, 1):
                        if l == 9:
                            print(f'{elem_divided[i][j][k][l]: >8}', file=f)
                        else:
                            print(f'{elem_divided[i][j][k][l]: >8},', file=f, end='')

def node(node_divided, node_index):
    inc = 0
    for i in range(len(node_index[0])):
        for j in range(len(node_index[1])):
            inc = inc + 1
            with open(f'subcell_all_monolis_v3/block_{inc}/node.dat', mode='w') as f:
                print(f'{len(node_divided[i][j])} 8', file=f)
                for k in range(len(node_divided[i][j])):
                        print(f'{int(node_divided[i][j][k][0]):>8},', file=f, end='')
                        print(f'{node_divided[i][j][k][1]:>23.15g},', file=f, end='')
                        print(f'{node_divided[i][j][k][2]:>23.15g},', file=f, end='')
                        print(f'{node_divided[i][j][k][3]:>23.15g}', file=f)
