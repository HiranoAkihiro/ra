#!/bin/bash
echo "<select program>"
echo "1 → 与えられた.kファイルからmonolis形式のメッシュ(block)を作成"
echo ""
echo "2 → map情報作成のテストを実行 & 作成されたmap情報をグリッドへ可視化する"
echo ""
echo "3 → map情報から、メッシュのマージを行う & mesh_merged（mesh型2次元配列）を作成"
echo ""
read -p "プログラムの選択（対応する整数値を入力） : " case
echo ""

if [ $case -eq 1 ]; then
    read -p "kファイルのバージョンを選択 : " case2
    echo ""
    echo "********** COMPILE FORTRAN MODEULE **********"
    echo ""
    make clean
    make
    echo ""
    echo "*********************************************"
    echo ""
    echo "python3 ./ssrc/01_make_blocks_main.py"
    echo ""
    python3 ./src/01_make_blocks_main.py $case2
elif [ $case -eq 2 ];then
    echo "********** COMPILE FORTRAN MODEULE **********"
    echo ""
    make clean
    make
    echo ""
    echo "*********************************************"
    echo ""
    echo "python3 ./ssrc/02_blocks_main.py"
    echo ""
    python3 ./src/02_place_blocks_main.py
elif [ $case -eq 3 ];then
    echo "********** COMPILE FORTRAN MODEULE **********"
    echo ""
    make clean
    make
    echo ""
    echo "*********************************************"
    echo ""
    echo "python3 ./ssrc/03_test.py"
    echo ""
    python3 ./src/03_test.py
elif [ $case -eq 99 ];then
    python3 ./src/99_output_vtk.py
fi