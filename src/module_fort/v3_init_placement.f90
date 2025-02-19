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
            n_mesh = 9
        endif
        allocate(mesh(n_mesh))

        do i=1, n_block
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name, 'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name, 'elem.dat')
            call input_elem(fname, mesh(i))
            fname = merge_fname(version, dir_name, 'mat.dat')
            call input_orientation(fname, mesh(i))
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
        type(meshdef) :: mesh_temp
        real(kdouble) :: coord(3)
        real(kdouble) :: theta, pi
        integer(kint) :: i, j
        integer(kint) :: p_2, p_4, p_5, p_6, in
        integer(kint) :: nnode_8, nnode_9, nelem_8, nelem_9
    
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

        p_2 = 0
        p_4 = 0
        p_5 = 0
        p_6 = 0
        do i=1, mesh(3)%nelem
            if(mesh(3)%pid(i) == 2)p_2 = p_2 + 1
            if(mesh(3)%pid(i) == 5)p_5 = p_5 + 1
        enddo

        do i=1, mesh(5)%nelem
            if(mesh(5)%pid(i) == 4)p_4 = p_4 + 1
            if(mesh(5)%pid(i) == 6)p_6 = p_6 + 1
        enddo

        nnode_8 = 396
        nelem_8 = p_2 + p_5
        ! mesh(8)%nelem = nelem_8
        ! mesh(8)%nbase_func = 8
        ! allocate(mesh(8)%elem(8,mesh(8)%nelem))
        ! mesh(8)%nnode = nnode_8
        ! allocate(mesh(8)%node(3,mesh(8)%nnode))

        nnode_9 = mesh(5)%nnode - 243
        nelem_9 = p_4 + p_6
        ! mesh(9)%nelem = nelem_9
        ! mesh(9)%nbase_func = 8
        ! allocate(mesh(9)%elem(8,mesh(9)%nelem))
        ! mesh(9)%nnode = nnode_9
        ! allocate(mesh(9)%node(3,mesh(9)%nnode))

        mesh(8)%nelem = nelem_8 + nelem_9
        mesh(8)%nbase_func = 8
        allocate(mesh(8)%elem(8,mesh(8)%nelem))
        mesh(8)%nnode = nnode_8 + nnode_9
        allocate(mesh(8)%node(3,mesh(8)%nnode))

        mesh(9)%nelem = nelem_8 + nelem_9
        mesh(9)%nbase_func = 8
        allocate(mesh(9)%elem(8,mesh(9)%nelem))
        mesh(9)%nnode = nnode_8 + nnode_9
        allocate(mesh(9)%node(3,mesh(9)%nnode))


        do i=1, mesh(3)%nelem
            if(mesh(3)%pid(i) == 2 .or. mesh(3)%pid(i) == 5)then
                mesh(8)%elem(:,i) = mesh(3)%elem(:,i)
            endif
        enddo

        in = nelem_8
        do i=1, mesh(5)%nelem
            if(mesh(5)%pid(i) == 4 .or. mesh(5)%pid(i) == 6)then
                in = in + 1
                mesh(8)%elem(:,in) = mesh(5)%elem(:,i) - 243 + nnode_8
            endif
        enddo

        do i=1, mesh(3)%nnode
            if(i <= nnode_8)then
                mesh(8)%node(:,i) = mesh(3)%node(:,i)
            endif
        enddo

        in = nnode_8
        do i=1, mesh(5)%nnode
            if(i >= 244)then
                in = in + 1
                mesh(8)%node(:,in) = mesh(5)%node(:,i)
            endif
        enddo

        mesh(9)%elem = mesh(8)%elem
        mesh(9)%node = mesh(8)%node

        theta = -pi/2.0d0
        do i=1, mesh(9)%nnode
            coord(:) = mesh(9)%node(:,i)
            call reflect_y(coord, theta)
            mesh(9)%node(:,i) = coord(:)
            mesh(9)%node(1,i) = mesh(9)%node(1,i) + 1.0d0
        enddo

        ! in = 0
        ! do i=1, mesh(5)%nelem
        !     if(mesh(5)%pid(i) == 4 .or. mesh(5)%pid(i) == 6)then
        !         in = in + 1
        !         mesh(9)%elem(:,in) = mesh(5)%elem(:,i) - 243
        !     endif
        ! enddo

        ! in = 0
        ! do i=1, mesh(5)%nnode
        !     if(i >= 244)then
        !         in = in + 1
        !         mesh(9)%node(:,in) = mesh(5)%node(:,i)
        !     endif
        ! enddo

    end subroutine routine_main
end module mod_v3_init_placement