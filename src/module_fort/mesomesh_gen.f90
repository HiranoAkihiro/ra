module mesomesh_gen
    type :: mapdef
        integer(4) :: block_id
        integer(4) :: angle
    end type mapdef

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

contains

subroutine mesh_pattern_map(map, p)
    implicit none
    type(mapdef), allocatable, intent(inout) :: map(:,:)
    integer(4), intent(in) :: p
    integer(4) :: n, m
    integer(4) :: i, j, in
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
end module mesomesh_gen