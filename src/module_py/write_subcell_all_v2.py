# block1:5,6
# block2:7,8,9,10
# block3:11,12
# block4:13,14,15
def elem(array):
    elem_block_1(array)
    elem_block_2(array)
    elem_block_3(array)
    elem_block_4(array)
    elem_block_5(array)

def orientation(array):
    ori_block_1(array)
    ori_block_2(array)
    ori_block_3(array)
    ori_block_4(array)
    ori_block_5(array)

def node(array):
    node_block_1(array)
    node_block_2(array)
    node_block_3(array)
    node_block_4(array)
    node_block_5(array)


def elem_block_1(array):
    with open('subcell_all_monolis/block_1/elem.dat', mode='w') as f:
        print('256 8', file=f)
        for i in range(0, 256, 1):
            for j in range(2, 10, 1):
                if j == 9:
                    print(f'{array[i][j]: >8}', file=f)
                else:
                    print(f'{array[i][j]: >8},', file=f, end='')

def elem_block_2(array):
    with open('subcell_all_monolis/block_2/elem.dat', mode='w') as f:
        print('336 8', file=f)
        for i in range(256, 592, 1):
            for j in range(2, 10, 1):
                if j == 9:
                    print(f'{array[i][j]-405: >8}', file=f)
                else:
                    print(f'{array[i][j]-405: >8},', file=f, end='')

def elem_block_3(array):
    with open('subcell_all_monolis/block_3/elem.dat', mode='w') as f:
        print('416 8', file=f)
        for i in range(592, 1008, 1):
            for j in range(2, 10, 1):
                if j == 9:
                    print(f'{array[i][j]-900: >8}', file=f)
                else:
                    print(f'{array[i][j]-900: >8},', file=f, end='')

def elem_block_4(array):
    with open('subcell_all_monolis/block_4/elem.dat', mode='w') as f:
        print('416 8', file=f)
        for i in range(592, 1008, 1):
            for j in range(2, 10, 1):
                if j == 9:
                    print(f'{array[i][j]-900: >8}', file=f)
                else:
                    print(f'{array[i][j]-900: >8},', file=f, end='')

def elem_block_5(array):
    with open('subcell_all_monolis/block_5/elem.dat', mode='w') as f:
        print('336 8', file=f)
        for i in range(1008, 1344, 1):
            for j in range(2, 10, 1):
                if j == 9:
                    print(f'{array[i][j]-1485: >8}', file=f)
                else:
                    print(f'{array[i][j]-1485: >8},', file=f, end='')

def ori_block_1(array):
    with open('subcell_all_monolis/block_1/orientation.dat', mode='w') as f:
        print('#PID', file=f)
        print('256 1', file=f)
        for i in range(0, 256, 1):
            print(f'{array[i][1]}', file=f)

def ori_block_2(array):
    with open('subcell_all_monolis/block_2/orientation.dat', mode='w') as f:
        print('#PID', file=f)
        print('336 1', file=f)
        for i in range(256, 592, 1):
            print(f'{array[i][1]}', file=f)


def ori_block_3(array):
    with open('subcell_all_monolis/block_3/orientation.dat', mode='w') as f:
        print('#PID', file=f)
        print('416 1', file=f)
        for i in range(592, 1008, 1):
            print(f'{array[i][1]}', file=f)

def ori_block_4(array):
    with open('subcell_all_monolis/block_4/orientation.dat', mode='w') as f:
        print('#PID', file=f)
        print('416 1', file=f)
        for i in range(592, 1008, 1):
            print(f'{array[i][1]}', file=f)

def ori_block_5(array):
    with open('subcell_all_monolis/block_5/orientation.dat', mode='w') as f:
        print('#PID', file=f)
        print('336 1', file=f)
        for i in range(1008, 1344, 1):
            print(f'{array[i][1]}', file=f)

def node_block_1(array):
    with open('subcell_all_monolis/block_1/node.dat', mode='w') as f:
        print('405', file=f)
        for i in range(0, 405, 1):
            print(f'{array[i][1]:>23.15g},', file=f, end='')
            print(f'{array[i][2]:>23.15g},', file=f, end='')
            print(f'{array[i][3]:>23.15g}', file=f)

def node_block_2(array):
    with open('subcell_all_monolis/block_2/node.dat', mode='w') as f:
        print('495', file=f)
        for i in range(405, 900, 1):
            print(f'{array[i][1]:>23.15g},', file=f, end='')
            print(f'{array[i][2]:>23.15g},', file=f, end='')
            print(f'{array[i][3]:>23.15g}', file=f)

def node_block_3(array):
    with open('subcell_all_monolis/block_3/node.dat', mode='w') as f:
        print('585', file=f)
        for i in range(900, 1485, 1):
            print(f'{array[i][1]:>23.15g},', file=f, end='')
            print(f'{array[i][2]:>23.15g},', file=f, end='')
            print(f'{array[i][3]:>23.15g}', file=f)

def node_block_4(array):
    with open('subcell_all_monolis/block_4/node.dat', mode='w') as f:
        print('585', file=f)
        for i in range(900, 1485, 1):
            print(f'{1.0-array[i][1]:>23.15g},', file=f, end='')
            print(f'{array[i][2]:>23.15g},', file=f, end='')
            print(f'{1.0-array[i][3]:>23.15g}', file=f)

def node_block_5(array):
    with open('subcell_all_monolis/block_5/node.dat', mode='w') as f:
        print('495', file=f)
        for i in range(1485, 1980, 1):
            print(f'{array[i][1]:>23.15g},', file=f, end='')
            print(f'{array[i][2]:>23.15g},', file=f, end='')
            print(f'{array[i][3]:>23.15g}', file=f)