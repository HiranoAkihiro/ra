subroutine mesh_pattern_map_wrapper(p, n, block_id, angle)
        use mesomesh_gen
        integer(4), intent(in), value :: p
        integer(4), intent(in), value :: n
        integer(4), intent(out) :: block_id(n,n)
        integer(4), intent(out) :: angle(n,n)

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