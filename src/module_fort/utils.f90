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
    Rmat(2,2) = -1.0d0
    Rmat(3,1) = -sin_theta
    Rmat(3,3) = cos_theta

    coord = matmul(Rmat, coord)
end subroutine rotate_y
end module mod_utils