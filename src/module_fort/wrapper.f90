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
            write(*,*)map%block_id
            write(*,*)map%angle
        else
            block_id = map%block_id
            angle = map%angle
        endif

        deallocate(map)
end subroutine mesh_pattern_map_wrapper

subroutine test()
    use mod_mesomesh_gen
    implicit none
    type(mapdef), allocatable :: map(:,:)
    type(meshdef), allocatable :: mesh_merged(:,:)
    type(meshdef) :: meso_mesh
    integer(kint) :: p, i, j, k
    real(kdouble) :: nnodes(4)
    logical :: is_v3
    character(len=:), allocatable :: fname

    is_v3 = .true.

    nnodes = 0.0d0
    p = 2
    call mesh_pattern_map(map, p)
    call arrange_blocks(map, p, mesh_merged, is_v3)
    ! call shear_blocks(mesh_merged)
    ! call get_meso_mesh(mesh_merged, meso_mesh, is_v3, p)
    call get_meso_mesh_dupl(mesh_merged, meso_mesh, is_v3, p)

    fname = 'subcell_merged_(meso_mesh)/elem.dat'
    call output_elem(meso_mesh, fname)
    fname = 'subcell_merged_(meso_mesh)/node.dat'
    call output_node(meso_mesh, fname)
    fname = 'subcell_merged_(meso_mesh)/mat.dat'
    call output_orientation(meso_mesh, fname)

    ! j = 4
    ! k = 4
    ! write(*,*)mesh_merged(j,k)%nnode
    ! do i=1, size(mesh_merged(j,k)%node, 2)
    !     write(*,*)mesh_merged(j,k)%node(:,i)
    ! enddo
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