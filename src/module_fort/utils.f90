module mod_utils
    implicit none
    integer(4), parameter :: kint=4
    integer(4), parameter :: kdouble=8

    type :: mapdef
        integer(4) :: block_id
        integer(4) :: angle
    end type mapdef

    type :: meshdef
        integer(4) :: nnode
        integer(4) :: nelem
        integer(4) :: nbase_func
        integer(4), allocatable :: pid(:)
        integer(4), allocatable :: elem(:,:)
        real(8), allocatable :: node(:,:)
    end type
    
contains
function merge_fname(dir_name, file_name)
    implicit none
    character(len=*), intent(in) :: dir_name
    character(len=*), intent(in) :: file_name
    character(len=:), allocatable :: merge_fname

    merge_fname = 'subcell_all_monolis/'//trim(dir_name)//'/'//trim(file_name)
end function merge_fname

subroutine rotate_y(coord, theta)
    implicit none
    real(kdouble), intent(inout) :: coord(3)
    real(kdouble), intent(in) :: theta
    real(kdouble) :: Rmat(3,3)
    real(kdouble) :: cos_theta, sin_theta

    cos_theta = cos(theta)
    sin_theta = sin(theta)
    Rmat = 0.0d0
    Rmat(1,1) = cos_theta
    Rmat(1,3) = sin_theta
    Rmat(2,2) = 1.0d0
    Rmat(3,1) = -sin_theta
    Rmat(3,3) = cos_theta

    coord = matmul(Rmat, coord)
end subroutine rotate_y

subroutine rotate_y_regular(coord, angle)
    implicit none
    real(kdouble), intent(inout) :: coord(3)
    integer(kint), intent(in) :: angle
    real(kdouble) :: Rmat(3,3)
    real(kdouble) :: coord_temp(3)

    Rmat = 0.0d0
    coord_temp = coord
    if(angle == 0)then

    elseif(angle == 1)then
        coord(1) = coord_temp(3)
        coord(3) = -coord_temp(1)
    elseif(angle == 2)then
        coord(1) = -coord_temp(1)
        coord(3) = -coord_temp(3)
    elseif(angle == 3)then
        coord(1) = -coord_temp(3)
        coord(3) = coord_temp(1)
    endif
end subroutine rotate_y_regular

subroutine arrange_connectivity(mesh, in_nelem, mesh_merged)
    implicit none
    type(meshdef), intent(in) :: mesh
    type(meshdef), intent(inout) :: mesh_merged
    integer(kint), intent(inout) :: in_nelem
    integer(kint) :: i, j

    allocate(mesh_merged%elem(mesh%nbase_func, mesh%nelem), source=0)

    do i=1,mesh%nelem
        do j=1, mesh%nbase_func
            mesh_merged%elem(j,i) = mesh%elem(j,i) + in_nelem
        enddo
    enddo

    in_nelem = in_nelem + mesh%nnode
end subroutine

subroutine arrange_nodecoord(mesh, angle, mesh_merged, imap, jmap)
    implicit none
    type(meshdef), intent(in) :: mesh
    type(meshdef), intent(inout) :: mesh_merged
    integer(kint), intent(in) :: angle, imap, jmap
    integer(kint) :: i
    real(kdouble) :: coord(3)

    coord = 0.0d0
    allocate(mesh_merged%node(3,mesh%nnode), source=0.0d0)

    do i=1,mesh%nnode
        coord(:) = mesh%node(:,i)
        call rotate_y_regular(coord, angle)
        mesh_merged%node(:,i) = coord(:)
    enddo

    mesh_merged%node(1,:) = mesh_merged%node(1,:) + dble(imap-1)
    mesh_merged%node(3,:) = mesh_merged%node(3,:) + dble(jmap-1)
end subroutine arrange_nodecoord
end module mod_utils