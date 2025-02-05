module mod_v3_init_placement
    use mod_utils
    use mod_io

contains
    subroutine rotate()
        implicit none
        type(meshdef), allocatable :: mesh(:)
        character(len=100) :: dir_name 
        character(len=:), allocatable :: fname, version
        integer(kint) :: i, n_block, n_mesh

        version = 'v3'

        if(version == 'v2')then
            n_block = 4
        elseif(version == 'v3')then
            n_block = 6
            n_mesh = 7
        endif
        allocate(mesh(n_mesh))

        do i=1, n_block
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name, 'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name, 'elem.dat')
            call input_elem(fname, mesh(i))
        enddo
        write(dir_name,'(a,i0)')'block_',2
        fname = merge_fname(version, dir_name, 'node.dat')
        call input_node(fname, mesh(7))
        fname = merge_fname(version, dir_name, 'elem.dat')
        call input_elem(fname, mesh(7))

        call routine_main(mesh)

        do i=1, n_mesh
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name, 'node.dat')
            call output_node(mesh(i), fname)
            fname = merge_fname(version, dir_name, 'elem.dat')
            call output_elem(mesh(i), fname)
        enddo

    end subroutine rotate

    subroutine routine_main(mesh)
        type(meshdef), intent(inout) :: mesh(:)
        real(kdouble) :: coord(3)
        real(kdouble) :: theta, pi
        integer(kint) :: i, j
    
        pi = acos(-1.0)

        ! block_7(blockB1)
        theta = -pi/2.0d0
        do i=1, mesh(2)%nnode
            coord(:) = mesh(2)%node(:,i)
            call reflect_y(coord, theta)
            ! call reflect_y(coord, 0.0d0)
            ! call rotate_y(coord, theta)
            mesh(7)%node(:,i) = coord(:)
            mesh(7)%node(1,i) = mesh(7)%node(1,i) + 1.0d0
            ! mesh(7)%node(3,i) = mesh(7)%node(3,i) + 1.0d0
        enddo

        ! block_1~6
        do j=1, 6
            theta = pi
            do i=1, mesh(j)%nnode
                coord(:) = mesh(j)%node(:,i)
                call rotate_y(coord, theta)
                mesh(j)%node(:,i) = coord(:)
                mesh(j)%node(1,i) = mesh(j)%node(1,i) + 1.0d0
                mesh(j)%node(3,i) = mesh(j)%node(3,i) + 1.0d0
            enddo
        enddo

    end subroutine routine_main
end module mod_v3_init_placement