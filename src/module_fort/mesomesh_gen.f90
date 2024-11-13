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
    integer(kint) :: i, j, in
    logical :: a, b

    if(p==1)then
        allocate(map(p,p))
        map(1,1)%block_id = 1
        map(1,1)%angle = 0
        return
    endif

    !(3)
    n = 3*p
    allocate(map(n,n))

    !(4)
    map = mapdef(1,1)

    !(5)
    map(1,1)%block_id = 4
    map(1,1)%angle = 0

    !(6)
    m = 3*p-2
    map(1,m)%block_id = 3
    map(1,m)%angle = 0

    !(7)
    i = m
    j = 1
    do while(i/=1)
        j = j + 3
        map(j,i)%block_id = 4
        map(j,i)%angle = 2
        i = i - 3
        map(j,i)%block_id = 3
        map(j,i)%angle = 3
    enddo
    map(j,i)%block_id = 3
    map(j,i)%angle = 2

    !(8)
    do j=1, n
        a = .false.
        b = .false.
        do i=1, n
            b = (map(j,i)%block_id==3 .or. map(j,i)%block_id==4)
            if(a.and.(.not.b))then
                if(j==1)then
                    map(j,i)%block_id = 2
                    map(j,i)%angle = 0
                else
                    map(j,i)%block_id = 2
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
            b = (map(j,i)%block_id==3 .or. map(j,i)%block_id==4)
            if(a.and.(.not.b))then
                if(i==1)then
                    map(j,i)%block_id = 2
                    map(j,i)%angle = 1
                else
                    map(j,i)%block_id = 2
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
                if(map(j,i)%block_id==2)then
                    in = in + 1
                    cycle
                endif
            elseif(in==1)then
                if(map(j,i)%block_id/=1)then
                    in = 0
                    cycle
                endif
                map(j,i)%block_id = 1
                map(j,i)%angle = 0
            endif
        enddo
        in=0
    enddo
end subroutine mesh_pattern_map

subroutine arrange_blocks(map,p)
    implicit none
    type(mapdef), intent(in) :: map(:,:)
    type(meshdef) :: mesh(4)
    type(meshdef), allocatable :: mesh_merged(:,:)
    integer(kint), intent(in) :: p
    integer(kint) :: i
    character(len=100) :: dir_name 
    character(len=:), allocatable :: fname
    integer(kint) :: sum1, sum2

    do i=1,4
        write(dir_name,'(a,i0)')'block_',i
        fname = merge_fname(dir_name,'node.dat')
        call input_node(fname, mesh(i))
        fname = merge_fname(dir_name,'elem.dat')
        call input_elem(fname, mesh(i))
        fname = merge_fname(dir_name,'orientation.dat')
        call input_orientation(fname, mesh(i))
    enddo

    sum1 = 0.0d0
    sum2 = 0.0d0
    do i=1,4
        sum1 = sum1 + mesh(i)%nelem
        sum2 = sum2 + mesh(i)%nnode
    enddo

    allocate(mesh_merged(3*p,3*p))
    ! mesh_merged%nbase_func = mesh(1)%nbase_func
    ! mesh_merged%nelem = sum1
    ! mesh_merged%nnode = sum2
    ! allocate(mesh_merged%elem(mesh_merged%nbase_func,mesh_merged%nelem), source=0)
    ! allocate(mesh_merged%node(3,mesh_merged%nnode), source=0.0d0)

    
    
end subroutine arrange_blocks
end module mod_mesomesh_gen