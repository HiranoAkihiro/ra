def read_file_specific_lines(file_path, start_line, n_lines):
    with open(file_path, 'r') as file:
        for _ in range(start_line - 1):
            next(file)

        return [next(file).strip() for _ in range(n_lines)]

def convert_e(file_path, start_line, n_lines, start_line_num, end_line_num):
    elem = []
    lines = read_file_specific_lines(file_path, start_line, n_lines)
    # print(lines[1])
    s_range = start_line_num - start_line
    e_range = end_line_num - start_line + 1

    for i in range(s_range, e_range, 1):
        line_row = lines[i]
        row = []

        for j in line_row.split():
            row.append(int(j))

        elem.append(row)

    return elem

def convert_n(file_path, start_line, n_lines, start_line_num, end_line_num):
    node = []
    lines = read_file_specific_lines(file_path, start_line, n_lines)
    # print(lines[1])
    s_range = start_line_num - start_line
    e_range = end_line_num - start_line + 1

    for i in range(s_range, e_range, 1):
        line_row = lines[i]
        row = []

        for j in line_row.split():
            row.append(float(j))

        node.append(row)

    return node

def get_elem_array(file_path, start_line, end_line, start_line_num, end_line_num):
    elem = []
    n_lines = end_line - start_line + 1
    elem = convert_e(file_path, start_line, n_lines, start_line_num, end_line_num)
    return elem

def get_node_array(file_path, start_line, end_line, start_line_num, end_line_num):
    node = []
    n_lines = end_line - start_line + 1
    node = convert_n(file_path, start_line, n_lines, start_line_num, end_line_num)
    return node