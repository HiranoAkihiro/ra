from module_py import io_in_monolis as io
import os
import numpy as np
import sys

mesh1 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_1')
mesh1.output_vtk('block_1.vtk')

mesh2 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_2')
mesh2.output_vtk('block_2.vtk')

mesh3 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_3')
mesh3.output_vtk('block_3.vtk')

mesh4 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_4')
mesh4.output_vtk('block_4.vtk')

mesh5 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_5')
mesh5.output_vtk('block_5.vtk')

mesh6 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_6')
mesh6.output_vtk('block_6.vtk')