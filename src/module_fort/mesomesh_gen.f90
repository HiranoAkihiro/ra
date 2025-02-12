module mod_mesomesh_gen
    use mod_utils
    use mod_io

contains

subroutine mesh_pattern_map(map, p)
    ! ブロックは以下の整数でラベル（mapdefのblock_idメンバ）
    ! 緑：blockC >>>>> 1
    ! 黄：blockA >>>>> 2
    ! 赤：blockB1 >>>> 3
    ! 桃：blockB2 >>>> 4

    ! 回転角度は以下のルールで決定
    ! （回転角度）=（整数値）×（90度）
    ! 例えばmapdefのangleメンバが2の時、
    ! 2 × 90 = 180
    ! となり、180度回転を表す。
    implicit none
    type(mapdef), allocatable, intent(inout) :: map(:,:)
    integer(kint), intent(in) :: p
    integer(kint) :: n, m
    integer(kint) :: i, j, k, in
    integer(kint) :: ppp, qqq, rrr, sss, ttt, uuu, vvv, www, xxx, yyy, zzz
    logical :: a, b, is_v3

    ppp = 2
    qqq = 4
    rrr = 9
    sss = 5
    ttt = 8
    uuu = 1
    vvv = 3
    www = 7
    xxx = 6
    yyy = 10
    zzz = 11

    is_v3 = .true.

    if(p==1)then
        allocate(map(p,p))
        map(1,1)%block_id = uuu
        map(1,1)%angle = 0
        return
    endif

    !(3)
    n = 3*p
    allocate(map(n,n))

    !(4)
    map = mapdef(1,1)

    !(5)
    map(1,1)%block_id = qqq
    map(1,1)%angle = 0

    !(6)
    m = 3*p-2
    map(1,m)%block_id = vvv
    map(1,m)%angle = 0

    !(7)
    i = m
    j = 1
    do while(i/=1)
        j = j + 3
        map(j,i)%block_id = qqq
        map(j,i)%angle = 2
        i = i - 3
        map(j,i)%block_id = vvv
        map(j,i)%angle = 3
    enddo
    map(j,i)%block_id = vvv
    map(j,i)%angle = 2

    !(8)
    do j=1, n
        a = .false.
        b = .false.
        do i=1, n
            b = (map(j,i)%block_id==vvv .or. map(j,i)%block_id==qqq)
            if(a.and.(.not.b))then
                if(j==1)then
                    map(j,i)%block_id = ppp
                    map(j,i)%angle = 0
                else
                    map(j,i)%block_id = ppp
                    map(j,i)%angle = 2
                endif
            endif
            if(b)a=.not.a
        enddo
    enddo

    !(9)
    do i=1, n
        a = .false.
        b = .false.
        do j=1, n
            b = (map(j,i)%block_id==vvv .or. map(j,i)%block_id==qqq)
            if(a.and.(.not.b))then
                if(i==1)then
                    map(j,i)%block_id = ppp
                    map(j,i)%angle = 1
                else
                    map(j,i)%block_id = ppp
                    map(j,i)%angle = 3
                endif
            endif
            if(b)a=.not.a
        enddo
    enddo

    !(10)
    in = 0
    do j=1, n
        do i=1, n
            if(in==0)then
                if(map(j,i)%block_id==ppp)then
                    in = in + 1
                    cycle
                endif
            elseif(in==1)then
                if(map(j,i)%block_id/=uuu)then
                    in = 0
                    cycle
                endif
                map(j,i)%block_id = uuu
                map(j,i)%angle = 0
            endif
        enddo
        in=0
    enddo

    in = 1
    if(is_v3)then
        do i=1, n
            do j=1, n
                if(j==1 .and. i==1)cycle
                if(map(j,i)%block_id==vvv)then
                    if(in == 1)then
                        map(j+1,i)%block_id = xxx
                        map(j+2,i)%block_id = xxx
                    elseif(in == p)then
                        map(j,i+1)%block_id = www
                        map(j,i+2)%block_id = www
                    else
                        map(1,i)%block_id = sss
                        map(j,1)%block_id = sss
                        do k=2, j-1
                            map(k,i)%block_id = www
                        enddo
                        do k=2, i-1
                            if(map(j,k)%block_id == www)then
                                map(j,k)%block_id = yyy
                            else
                                map(j,k)%block_id = xxx
                            endif
                        enddo
                    endif
                    in = in + 1
                endif
                if(map(j,i)%block_id==qqq)then
                    do k=i+1, n
                        map(j,k)%block_id = rrr
                        ! map(k,i)%block_id = 8
                    enddo
                    do k=j+1, n
                        if(map(k,i)%block_id == 9)then
                            map(k,i)%block_id = zzz
                        else
                            map(k,i)%block_id = ttt
                            ! map(j,k)%block_id = 9
                        endif
                    enddo
                endif
            enddo
        enddo
    endif
end subroutine mesh_pattern_map

subroutine arrange_blocks(map, p, mesh_merged)
    implicit none
    type(mapdef), intent(in) :: map(:,:)
    type(meshdef) :: mesh(4)
    type(meshdef), intent(inout), allocatable :: mesh_merged(:,:)
    integer(kint), intent(in) :: p
    integer(kint) :: i, j, a, b
    character(len=100) :: dir_name 
    character(len=:), allocatable :: fname, version
    integer(kint) :: sum1, sum2, in_nelem
    integer(kint), allocatable :: nb(:)
    integer(kint) :: block_id, angle
    logical :: is_v3

    is_v3 = .true.

    if(is_v3)then
        do i=1, 10
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name,'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name,'elem.dat')
            call input_elem(fname, mesh(i))
            fname = merge_fname(version, dir_name,'mat.dat')
            call input_orientation(fname, mesh(i))
            allocate(nb(11))

            nb(1) = 8*(p-1)
            nb(2) = p
            nb(3) = p*(p-1)
            nb(4) = 2*(p-2)
            nb(5) = p*(p-1)
            nb(6) = 4*(p**2)
            nb(7) = p
            nb(8) = (p**2) - 3*p + 4
            nb(9) = (p**2) - 3*p + 4
            if(p==2)then
                nb(10) = 0
                nb(11) = 0
            elseif(p==3)then
                nb(10) = 0
                nb(11) = 1
            else
                a = p - 3
                b = p - 2
                nb(10) = a*(a+1)/2
                nb(11) = b*(b+1)/2
            endif
        enddo
    else
        do i=1,4
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name,'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name,'elem.dat')
            call input_elem(fname, mesh(i))
            fname = merge_fname(version, dir_name,'orientation.dat')
            call input_orientation(fname, mesh(i))
            allocate(nb(4))

            nb(2) = 2*(5*p-6)
            nb(3) = p
            nb(4) = p
            nb(1) = 9*(p**2)-nb(2)-nb(3)-nb(4)
        enddo
    endif

    ! sum1 = 0.0d0
    ! sum2 = 0.0d0
    ! do i=1,4
    !     sum1 = sum1 + mesh(i)%nelem
    !     sum2 = sum2 + mesh(i)%nnode
    ! enddo

    allocate(mesh_merged(3*p,3*p))

    mesh_merged%nbase_func = mesh(1)%nbase_func
    mesh_merged%nelem = 0
    mesh_merged%nnode = 0

    if(is_v3)then
        do i=1,11
            mesh_merged%nelem = mesh_merged%nelem + nb(i)*mesh(i)%nelem
            mesh_merged%nnode = mesh_merged%nnode + nb(i)*mesh(i)%nnode
        enddo
    else
        do i=1,4
            mesh_merged%nelem = mesh_merged%nelem + nb(i)*mesh(i)%nelem
            mesh_merged%nnode = mesh_merged%nnode + nb(i)*mesh(i)%nnode
        enddo
    endif

    in_nelem = 0
    do i=1, 3*p
        do j=1, 3*p
            block_id = map(j,i)%block_id
            angle = map(j,i)%angle
            call arrange_nodecoord(mesh(block_id), angle, mesh_merged(j,i), i, j)
            call arrange_connectivity(mesh(block_id), in_nelem, mesh_merged(j,i))
        enddo
    enddo
end subroutine arrange_blocks

subroutine shear_blocks(mesh_merged)
    implicit none
    type(meshdef), intent(inout) :: mesh_merged(:,:)
    real(kdouble) :: coord(3)
    real(kdouble) :: theta, pi
    integer(kint) :: i, j, k, n

    pi = acos(-1.0)
    theta = pi/6.0d0
    n=size(mesh_merged, 1)

    do i=1,n
        do j=1,n
            do k=1, size(mesh_merged(j,i)%node, 2)
                coord(:) = mesh_merged(j,i)%node(:,k)
                call get_shear_defo(coord, theta, 'zx', 'x')
                call rotate_y(coord, theta/2.0d0)
                mesh_merged(j,i)%node(:,k) = coord(:)
            enddo
        enddo
    enddo
end subroutine shear_blocks
end module mod_mesomesh_gen