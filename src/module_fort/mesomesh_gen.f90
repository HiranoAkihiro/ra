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
    ! マップ情報については、python出力map情報における列が一次元、行が二次元
    implicit none
    type(mapdef), allocatable, intent(inout) :: map(:,:)
    integer(kint), intent(in) :: p
    integer(kint) :: n, m
    integer(kint) :: i, j, k, in
    integer(kint) :: ppp, qqq, rrr, sss, ttt, uuu, vvv, yyy, zzz, ooo
    logical :: a, b, is_v3

    ppp = 1
    qqq = 2
    rrr = 3
    sss = 4
    ttt = 5
    uuu = 6
    vvv = 7
    yyy = 8
    zzz = 9
    ooo = 10

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
    map = mapdef(uuu,1)

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
                        map(j+1,i)%block_id = ttt
                        map(j+2,i)%block_id = ttt
                        map(j+1,i)%angle = 0
                        map(j+2,i)%angle = 0
                    elseif(in == p)then
                        map(j,i+1)%block_id = rrr
                        map(j,i+2)%block_id = rrr
                        map(j,i+1)%angle = 0
                        map(j,i+2)%angle = 0
                    else
                        map(1,i)%block_id = sss
                        map(j,1)%block_id = ooo
                        map(j,1)%angle = 3
                        do k=2, j-1
                            map(k,i)%block_id = rrr
                            map(k,i)%angle = 3
                        enddo
                        do k=2, i-1
                            if(map(j,k)%block_id == rrr)then
                                map(j,k)%block_id = yyy
                                map(j,k)%angle = 1
                            else
                                map(j,k)%block_id = ttt
                                map(j,k)%angle = 1
                            endif
                        enddo
                    endif
                    in = in + 1
                endif
                if(map(j,i)%block_id==qqq)then
                    do k=i+1, n
                        map(j,k)%block_id = rrr
                        map(j,k)%angle = 2
                        ! map(k,i)%block_id = 8
                    enddo
                    do k=j+1, n
                        if(map(k,i)%block_id == rrr)then
                            map(k,i)%block_id = zzz
                            map(k,i)%angle = 2
                        else
                            map(k,i)%block_id = ttt
                            map(k,i)%angle = 2
                            ! map(j,k)%block_id = 9
                        endif
                    enddo
                endif
            enddo
        enddo
    endif
end subroutine mesh_pattern_map

subroutine arrange_blocks(map, p, mesh_merged, is_v3)
    implicit none
    type(mapdef), intent(in) :: map(:,:)
    type(meshdef), allocatable :: mesh(:)
    type(meshdef), intent(inout), allocatable :: mesh_merged(:,:)
    integer(kint), intent(in) :: p
    integer(kint) :: i, j, k, a, b
    character(len=100) :: dir_name 
    character(len=:), allocatable :: fname, version
    integer(kint) :: sum1, sum2, in_nelem
    integer(kint), allocatable :: nb(:)
    integer(kint) :: block_id, angle
    logical, intent(in) :: is_v3

    if(is_v3)then
        version = 'v3'
        allocate(mesh(10))
        do i=1, 10
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name,'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name,'elem.dat')
            call input_elem(fname, mesh(i))
            fname = merge_fname(version, dir_name,'orientation.dat')
            call input_orientation(fname, mesh(i))
            do j=1, mesh(i)%nelem
                if(mesh(i)%pid(j)==2)then
                    mesh(i)%pid(j) = 2
                elseif(mesh(i)%pid(j)==4)then
                    mesh(i)%pid(j) = 1
                elseif(mesh(i)%pid(j)==5)then
                    mesh(i)%pid(j) = 2
                elseif(mesh(i)%pid(j)==6)then
                    mesh(i)%pid(j) = 1
                endif
            enddo
        enddo
    else
        version = 'v2'
        allocate(mesh(4))
        do i=1,4
            write(dir_name,'(a,i0)')'block_',i
            fname = merge_fname(version, dir_name,'node.dat')
            call input_node(fname, mesh(i))
            fname = merge_fname(version, dir_name,'elem.dat')
            call input_elem(fname, mesh(i))
            fname = merge_fname(version, dir_name,'orientation.dat')
            call input_orientation(fname, mesh(i))
        enddo
    endif

    allocate(mesh_merged(3*p,3*p))

    in_nelem = 0
    do i=1, 3*p
        do j=1, 3*p
            block_id = map(j,i)%block_id
            angle = map(j,i)%angle
            call arrange_nodecoord(mesh(block_id), angle, mesh_merged(j,i), i, j)
            call arrange_connectivity(mesh(block_id), in_nelem, mesh_merged(j,i))
            mesh_merged(j,i)%nelem = mesh(block_id)%nelem
            mesh_merged(j,i)%nnode = mesh(block_id)%nnode
            mesh_merged(j,i)%pid = mesh(block_id)%pid
            do k=1, mesh(block_id)%nelem
                if(angle==0 .or. angle==2)then
                    mesh_merged(j,i)%pid(k) = mesh(block_id)%pid(k)
                elseif(angle==1 .or. angle==3)then
                    if(mesh(block_id)%pid(k)==1)then
                        mesh_merged(j,i)%pid(k) = 2
                    elseif(mesh(block_id)%pid(k)==2)then
                        mesh_merged(j,i)%pid(k) = 1
                    endif
                endif
            enddo
            mesh_merged(j,i)%nbase_func = mesh(block_id)%nbase_func
        enddo
    enddo

    ! do i=1, 3*p
    !     do j=1, 3*p
    !         do k=1, mesh_merged(j,i)%nelem
    !             if(mesh_merged(j,i)%pid(k) == 1)then
    !                 ! if(mod(j+5,6)==0 .or. mod(j+4,6)==0 .or. mod(j+3,6)==0)then
    !                 !     mesh_merged(j,i)%pid(k) = mesh_merged(j,i)%pid(k) + 10
    !                 ! endif
    !             elseif(mesh_merged(j,i)%pid(k) == 2)then
    !                 if(mod(i+5,6)==0 .or. mod(i+4,6)==0 .or. mod(i+3,6)==0)then
    !                     mesh_merged(j,i)%pid(k) = mesh_merged(j,i)%pid(k) + 10
    !                 endif
    !             endif
    !         enddo
    !     enddo
    ! enddo
end subroutine arrange_blocks

subroutine shear_blocks(meso_mesh)
    implicit none
    type(meshdef), intent(inout) :: meso_mesh
    real(kdouble) :: coord(3)
    real(kdouble) :: theta, pi
    integer(kint) :: i

    pi = acos(-1.0)
    theta = pi/6.0d0

    do i=1, meso_mesh%nnode
        coord(:) = meso_mesh%node(:,i)
        call get_shear_defo(coord, theta, 'zx', 'x')
        call rotate_y(coord, theta/2.0d0)
        meso_mesh%node(:,i) = coord(:)
    enddo
end subroutine shear_blocks

subroutine get_meso_mesh(mesh_merged, meso_mesh, is_v3, p, inf)
    implicit none
    type(meshdef), intent(in) :: mesh_merged(:,:)
    type(meshdef), intent(inout) :: meso_mesh
    type(meshdef) :: meso_mesh_temp
    type(monolis_kdtree_structure) :: kd_tree
    integer(kint), intent(in) :: p
    integer(kint) :: n_found
    integer(kint) :: unique_id, n_unique, n_unique2
    integer(kint), allocatable :: found_ids(:)
    integer(kint), allocatable :: BB_id(:)
    real(kdouble), allocatable :: BB(:,:)
    integer(kint), allocatable :: mapping(:), mapping_new(:)
    real(kdouble) :: pos(3)
    integer(kint) :: i, j, k, l, in_elem, in_node
    character(len=:), allocatable :: fname, version
    logical, intent(in) :: is_v3
    real(kdouble), intent(in) :: inf

    meso_mesh_temp%nbase_func = 8
    meso_mesh_temp%nelem = 0
    meso_mesh_temp%nnode = 0
    do i=1, 3*p
        do j=1, 3*p
            meso_mesh_temp%nelem = meso_mesh_temp%nelem + mesh_merged(j,i)%nelem
            meso_mesh_temp%nnode = meso_mesh_temp%nnode + mesh_merged(j,i)%nnode
        enddo
    enddo

    allocate(meso_mesh_temp%elem(meso_mesh_temp%nbase_func, meso_mesh_temp%nelem))
    allocate(meso_mesh_temp%node(3, meso_mesh_temp%nnode))
    allocate(meso_mesh_temp%pid(meso_mesh_temp%nelem))

    in_elem = 0
    in_node = 0
    do i=1, 3*p
        do j=1, 3*p
            do k=1, mesh_merged(j,i)%nelem
                meso_mesh_temp%elem(:,k+in_elem) = mesh_merged(j,i)%elem(:,k)
                meso_mesh_temp%pid(k+in_elem) = mesh_merged(j,i)%pid(k)
            enddo
            in_elem = in_elem + mesh_merged(j,i)%nelem

            do k=1, mesh_merged(j,i)%nnode
                meso_mesh_temp%node(:,k+in_node) = mesh_merged(j,i)%node(:,k)
            enddo
            in_node = in_node + mesh_merged(j,i)%nnode
        enddo
    enddo

    call eliminate_duplicates(meso_mesh_temp, inf, mapping, mapping_new)

    ! call check_consecutive_mapping(mapping_new)

    n_unique = count_unique_elements(mapping)
    n_unique2 = count_unique_elements(mapping_new)

    ! write(*,*)n_unique, n_unique2, meso_mesh_temp%nnode

    meso_mesh%nelem = meso_mesh_temp%nelem
    meso_mesh%nnode = n_unique
    meso_mesh%nbase_func = 8
    allocate(meso_mesh%elem(meso_mesh%nbase_func, meso_mesh%nelem))
    allocate(meso_mesh%node(3, meso_mesh%nnode))

    call create_meso_mesh(meso_mesh_temp, meso_mesh, mapping, mapping_new)
    
end subroutine get_meso_mesh

subroutine eliminate_duplicates(mesh, inf, mapping, mapping_new)
    implicit none
    type(meshdef) :: mesh
    real(kdouble), intent(in) :: inf
    integer(kint), intent(inout), allocatable :: mapping(:), mapping_new(:)
    type(monolis_kdtree_structure) :: kd_tree
    integer(kint) :: n_found
    integer(kint) :: unique_id, n_unique
    integer(kint) :: i, j, k
    integer(kint), allocatable :: found_ids(:)
    integer(kint), allocatable :: BB_id(:)
    real(kdouble), allocatable :: BB(:,:)
    real(kdouble) :: pos(3)

    allocate(BB(6,mesh%nnode))
    allocate(BB_id(mesh%nnode))

    do i=1, mesh%nnode
        BB(1,i) = mesh%node(1,i) - inf
        BB(2,i) = mesh%node(1,i) + inf
        BB(3,i) = mesh%node(2,i) - inf
        BB(4,i) = mesh%node(2,i) + inf
        BB(5,i) = mesh%node(3,i) - inf
        BB(6,i) = mesh%node(3,i) + inf
        BB_id(i) = i
    enddo

    call monolis_kdtree_init_by_BB(kd_tree, mesh%nnode, BB_id, BB)

    allocate(mapping(mesh%nnode), source=0)
    allocate(mapping_new(mesh%nnode), source=0)

    do i=1, mesh%nnode
        pos = mesh%node(:,i)
        n_found = 0
        call monolis_kdtree_get_BB_including_coordinates(kd_tree, pos, n_found, found_ids)
        ! 複数の節点が内包される場合、最初に登録された（インデックスが小さい）節点を唯一の代表とする
        unique_id = i
        do j=1, n_found
            if (found_ids(j) < unique_id) then
                unique_id = found_ids(j)
            end if
        end do
        mapping(i) = unique_id
        if (allocated(found_ids)) then
            deallocate(found_ids)
        end if
    end do

    call remap_consecutive(mapping, mapping_new)
    
end subroutine eliminate_duplicates

    function count_unique_elements(mapping) result(unique_count)
        implicit none
        integer(kint), intent(in) :: mapping(:)
        integer(kint) :: unique_count
        integer(kint) :: i, j
        logical :: is_new
        integer(kint), allocatable :: unique_arr(:)

        allocate(unique_arr(size(mapping)))
        unique_count = 0

        do i = 1, size(mapping)
            is_new = .true.
            do j = 1, unique_count
                if (mapping(i) == unique_arr(j)) then
                    is_new = .false.
                    exit
                end if
            end do
            if (is_new) then
                unique_count = unique_count + 1
                unique_arr(unique_count) = mapping(i)
            end if
        end do

        deallocate(unique_arr)
    end function count_unique_elements

    subroutine create_meso_mesh(meso_mesh_temp, meso_mesh, mapping, mapping_new)
        implicit none
        type(meshdef), intent(inout) :: meso_mesh
        type(meshdef), intent(in) :: meso_mesh_temp
        integer(kint), intent(in) :: mapping(:), mapping_new(:)
        integer(kint) :: i, j, k, l, nid, in
        logical, allocatable :: is_duplicate(:)

        allocate(is_duplicate(meso_mesh_temp%nnode), source = .false.)

        do i=1, meso_mesh_temp%nnode
            nid = mapping_new(i)
            meso_mesh%node(:,nid) = meso_mesh_temp%node(:,i)
        enddo

        do k=1, meso_mesh_temp%nnode
            do i=1, meso_mesh_temp%nelem
                do j=1, meso_mesh_temp%nbase_func
                    if(meso_mesh_temp%elem(j,i)==k)then
                        meso_mesh%elem(j,i) = mapping_new(k)
                    endif
                enddo
            enddo
        enddo
    
        allocate(meso_mesh%pid(meso_mesh%nelem))

        meso_mesh%pid = meso_mesh_temp%pid
    end subroutine create_meso_mesh

    subroutine get_meso_mesh_dupl(mesh_merged, meso_mesh, is_v3, p)
        implicit none
        type(meshdef), intent(in) :: mesh_merged(:,:)
    type(meshdef), intent(inout) :: meso_mesh
    integer(kint), intent(in) :: p
    real(kdouble) :: pos(3)
    real(kdouble) :: inf
    integer(kint) :: i, j, k, l, in_elem, in_node
    character(len=:), allocatable :: fname, version
    logical, intent(in) :: is_v3
    
    meso_mesh%nbase_func = 8

    meso_mesh%nelem = 0
    meso_mesh%nnode = 0
    do i=1, 3*p
        do j=1, 3*p
            meso_mesh%nelem = meso_mesh%nelem + mesh_merged(j,i)%nelem
            meso_mesh%nnode = meso_mesh%nnode + mesh_merged(j,i)%nnode
        enddo
    enddo

    allocate(meso_mesh%elem(meso_mesh%nbase_func, meso_mesh%nelem))
    allocate(meso_mesh%node(3, meso_mesh%nnode))
    allocate(meso_mesh%pid(meso_mesh%nelem))

    in_elem = 0
    in_node = 0
    do i=1, 3*p
        do j=1, 3*p
            do k=1, mesh_merged(j,i)%nelem
                meso_mesh%elem(:,k+in_elem) = mesh_merged(j,i)%elem(:,k)
                meso_mesh%pid(k+in_elem) = mesh_merged(j,i)%pid(k)
            enddo
            in_elem = in_elem + mesh_merged(j,i)%nelem

            do k=1, mesh_merged(j,i)%nnode
                meso_mesh%node(:,k+in_node) = mesh_merged(j,i)%node(:,k)
            enddo
            in_node = in_node + mesh_merged(j,i)%nnode
        enddo
    enddo
        
    end subroutine get_meso_mesh_dupl
end module mod_mesomesh_gen