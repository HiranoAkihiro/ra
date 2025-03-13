subroutine mesh_pattern_map_wrapper(p, n, block_id, angle)
        use mod_mesomesh_gen
        implicit none
        integer(kint), intent(in), value :: p
        integer(kint), intent(in), value :: n
        integer(kint), intent(out) :: block_id(n,n)
        integer(kint), intent(out) :: angle(n,n)
        type(mapdef), allocatable :: map(:,:)

        call mesh_pattern_map(map, p)

        if(p==1)then
            block_id(1,1) = map(1,1)%block_id
            angle(1,1) = map(1,1)%angle
        else
            block_id = map%block_id
            angle = map%angle
        endif

        deallocate(map)
end subroutine mesh_pattern_map_wrapper

subroutine test(p, inf)
    use mod_mesomesh_gen
    use mod_debug
    use iso_fortran_env, only: output_unit
    implicit none
    type(mapdef), allocatable :: map(:,:)
    type(meshdef), allocatable :: mesh_merged(:,:)
    type(meshdef) :: meso_mesh
    integer(kint) :: i, j, k
    integer(kint), intent(in) :: p
    real(kdouble), intent(in) :: inf
    logical :: is_v3
    character(len=:), allocatable :: fname

    is_v3 = .true.

    write(output_unit,'(A)',advance="no")'creating a map... '
    call flush(output_unit)
    call mesh_pattern_map(map, p)
    write(output_unit,'(A)') "done."
    write(*,*)

    write(output_unit,'(A)',advance="no")'arranging subcells... '
    call flush(output_unit)
    call arrange_blocks(map, p, mesh_merged, is_v3)
    write(output_unit,'(A)') "done."
    write(*,*)

    write(output_unit, '(A)', advance="no")'creating meso mesh... '
    call flush(output_unit)
    call get_meso_mesh(mesh_merged, meso_mesh, is_v3, p, inf)
    ! call get_meso_mesh_dupl(mesh_merged, meso_mesh, is_v3, p)
    write(output_unit,'(A)')"done."
    write(*,*)

    write(output_unit, '(A)', advance="no")'shearing the meso mesh... '
    call flush(output_unit)
    call shear_blocks(meso_mesh)
    write(output_unit,'(A)')"done."
    write(*,*)

    ! call output_mesh_merged(mesh_merged, 3*p)

    write(output_unit, '(A)', advance="no")'writing out the meso mesh... '
    call flush(output_unit)
    call output_mesomesh(meso_mesh)
    write(output_unit,'(A)')"done."
    write(*,*)
end subroutine test

subroutine rotate_wrapper()
    use mod_utils
    use mod_v3_init_placement
    implicit none

    call rotate()
end subroutine rotate_wrapper

subroutine kdtree()
    use mod_mesomesh_gen
    use mod_utils
    use mod_v3_init_placement
    use mod_mesomesh_gen
    implicit none
    type(meshdef) :: mesh
    real(kdouble) :: inf
    integer(kint) :: i, j, n_unique
    integer(kint), allocatable :: mapping(:), mapping_new(:)

    call input_elem('subcell_all_monolis_v3/block_6/elem.dat', mesh)
    call input_node('subcell_all_monolis_v3/block_6/node.dat', mesh)

    inf = 1.0d-4
    call eliminate_duplicates(mesh, inf, mapping, mapping_new)
    call check_consecutive_mapping(mapping_new)

    n_unique = count_unique_elements(mapping)
    i = maxval(mapping_new)
    j = maxval(mapping)
    write(*,*)n_unique, i
    write(*,*)mesh%nnode, j
    
end subroutine kdtree