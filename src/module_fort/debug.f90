module mod_debug
    use mod_utils
    use mod_io
    implicit none
    
contains
subroutine output_mesh_merged(mesh_merged, n)
    implicit none
    type(meshdef), intent(in) :: mesh_merged(:,:)
    integer(kint), intent(in) :: n
    integer(kint) :: i, j, in
    character(len=:), allocatable :: fname, command
    character(len=100) :: num

    do i=1, n
        do j=1, n
            write(num, '(i0,a,i0)')j,',',i
            command = 'mkdir -p subcell_debug/'//trim(num)
            call execute_command_line(command)
            fname = 'subcell_debug/'//trim(num)//'/elem.dat'
            call output_elem(mesh_merged(j,i), fname)
            fname = 'subcell_debug/'//trim(num)//'/node.dat'
            call output_node(mesh_merged(j,i), fname)
            fname = 'subcell_debug/'//trim(num)//'/orientation.dat'
            call output_orientation(mesh_merged(j,i), fname)
        enddo
    enddo

    
end subroutine output_mesh_merged
    
end module mod_debug