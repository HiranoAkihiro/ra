import numpy as np


class Meshdef:
    def __init__(self, nnode, nelem, node, elem):
        self.nnode = int(nnode)
        self.nelem = int(nelem)
        self.node = np.array(node, dtype=np.float64)
        self.elem = np.array(elem, dtype=np.int32)

    def __repr__(self):
        return f"Meshdef(nnode={self.nnode}, nelem={self.nelem}, node.shape={self.node.shape}, elem.shape={self.elem.shape})"

    @classmethod
    def input_mesh(cls, dir):
        with open(dir+'/elem.dat', 'r') as f:
            nelem, col = map(int, f.readline().split())
            elem = np.zeros((nelem, col), dtype=int)
            for i, line in enumerate(f):
                values = line.strip().split(',')
                elem[i] = np.array(values, dtype=int)
            
        with open(dir+'/node.dat', 'r') as f:
            nnode, col = map(int, f.readline().split())
            node = np.zeros((nnode, col))
            for i, line in enumerate(f):
                values = line.strip().split(',')
                node[i] = np.array(values)
            
        return cls(nnode, nelem, node, elem)

    def output_vtk(self, fname):
        output_file = 'visual/' + fname
        with open(output_file, 'w') as f:
            f.write("# vtk DataFile Version 4.1\n")
            f.write("Mesh Data\n")
            f.write("ASCII\n")
            f.write("DATASET UNSTRUCTURED_GRID\n")
            
            # ノードの出力
            f.write(f"POINTS {self.nnode} float\n")
            for node in self.node:
                f.write(f"{node[0]} {node[1]} {node[2]}\n")
            
            # 要素の出力
            f.write(f"CELLS {self.nelem} {self.nelem * 9}\n")
            for elem in self.elem:
                f.write(f"8 {' '.join(str(int(node) - 1) for node in elem)}\n")
            
            f.write(f"CELL_TYPES {self.nelem}\n")
            for _ in range(self.nelem):
                f.write("12\n")  # 12は8ノード六面体要素を表す

        print(f"VTK file has been written to {output_file}")
