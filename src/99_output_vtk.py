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

mesh7 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_7')
mesh7.output_vtk('block_7.vtk')

mesh8 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_8')
mesh8.output_vtk('block_8.vtk')

mesh9 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_9')
mesh9.output_vtk('block_9.vtk')

mesh10 = io.Meshdef.input_mesh('subcell_all_monolis_v3/block_10')
mesh10.output_vtk('block_10.vtk')

meso_mesh = io.Meshdef.input_mesh('subcell_merged_(meso_mesh)')
meso_mesh.output_vtk('meso_mesh.vtk')

mesh_d = io.Meshdef.input_mesh('subcell_debug/3,2')
mesh_d.output_vtk('mesh_d.vtk')