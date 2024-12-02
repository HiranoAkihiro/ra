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
    integer(kint) :: p, i
    real(kdouble) :: nnodes(4)

    nnodes = 0.0d0
    p = 2
    call mesh_pattern_map(map, p)
    call arrange_blocks(map, p, mesh_merged)
    call shear_blocks(mesh_merged)

    do i=1, size(mesh_merged(3,3)%node, 2)
        write(*,*)mesh_merged(3,3)%node(:,i)
    enddo
end subroutine test