def normalize_node(array):
    for i in range(0, 405, 1):
        array[i][1] = array[i][1] - 30.75
        array[i][2] = (array[i][2] - 0.35)/0.65
        array[i][3] = array[i][3] + 1.75
        
    for i in range(405, 900, 1):
        array[i][1] = array[i][1] - 30.75
        array[i][2] = (array[i][2] - 0.35)/0.65
        array[i][3] = array[i][3] + 3.25
        
    for i in range(900, 1485, 1):
        array[i][1] = array[i][1] - 32.25
        array[i][2] = (array[i][2] - 0.35)/0.65
        array[i][3] = array[i][3] + 3.25
        
    for i in range(1485, 1980, 1):
        array[i][1] = array[i][1] - 32.25
        array[i][2] = (array[i][2] - 0.35)/0.65
        array[i][3] = array[i][3] + 1.75
        
    return array