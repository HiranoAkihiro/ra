module mod_io
    use mod_utils
    implicit none
    
contains
subroutine input_node(fname, mesh)
    implicit none
    type(meshdef), intent(inout) :: mesh
    character(len=*), intent(in) :: fname
    integer(kint) :: i, j, n

    open(20, file=fname, status='old')
        read(20,*)mesh%nnode, n
        allocate(mesh%node(n,mesh%nnode))
        do i=1,mesh%nnode
            read(20,*)(mesh%node(j,i), j=1,n)
        enddo
    close(20)
end subroutine input_node

subroutine input_elem(fname, mesh)
    implicit none
    type(meshdef), intent(inout) :: mesh
    character(len=*), intent(in) :: fname
    integer(kint) :: i, j

    open(20, file=fname, status='old')
        read(20,*)mesh%nelem, mesh%nbase_func
        allocate(mesh%elem(mesh%nbase_func,mesh%nelem))
        do i=1,mesh%nelem
            read(20,*)(mesh%elem(j,i), j=1,mesh%nbase_func)
        enddo
    close(20)
end subroutine input_elem

subroutine input_orientation(fname, mesh)
    implicit none
    type(meshdef), intent(inout) :: mesh
    character(len=*), intent(in) :: fname
    integer(kint) :: i, n
    character(len=100) :: string

    open(20, file=fname, status='old')
        read(20,*)string
        read(20,*)n
        allocate(mesh%pid(n))
        do i=1,mesh%nelem
            read(20,*)mesh%pid(i)
        enddo
    close(20)
end subroutine input_orientation

subroutine output_node(mesh, fname)
    implicit none
    type(meshdef) :: mesh
    character(len=*), intent(in) :: fname
    integer(kint) :: i, j

    open(20, file=fname, status='replace')
        write(20, '(i0,a,i0)')mesh%nnode, ' ', 3
        do i=1,mesh%nnode
            write(20, '(3(F23.15,:,","))') (mesh%node(j,i), j=1,3)
        enddo
    close(20)
end subroutine output_node

subroutine output_elem(mesh, fname)
    implicit none
    type(meshdef) :: mesh
    character(len=*), intent(in) :: fname
    integer(kint) :: i, j

    open(20, file=fname, status='replace')
        write(20, '(i0,a,i0)')mesh%nelem, ' ', mesh%nbase_func
        do i=1,mesh%nelem
            write(20, '(8(I0,:,","))') (mesh%elem(j,i), j=1,8)
        enddo
    close(20)
end subroutine output_elem
end module mod_io