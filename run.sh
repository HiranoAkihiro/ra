#!/bin/bash
echo ""
echo "<select program>"
echo ""
echo "1 → 与えられた.kファイルからmonolis形式のメッシュ(block)を作成"
echo ""
echo "2 → map情報作成のテスト実行 & 作成されたmap情報をグリッドへ可視化"
echo ""
echo "3 → monolis形式のsubcell読み取り & map情報の作成 & meso meshの作成"
echo ""
echo "99 → 生成されたmeso meshのVTKファイル作成"
echo ""
read -p "プログラムの選択（対応する整数値を入力） : " case
echo ""

if [ $case -eq 1 ]; then
    echo "**************** RUN PROGRAMS ****************"
    echo "python3 ./ssrc/01_make_blocks_main.py"
    echo ""
    python3 ./src/01_make_blocks_main.py v3
elif [ $case -eq 2 ];then
    read -p "meso mesh におけるテープ数 p の入力 (2以上) : p = " case2
    echo ""
    echo "**************** RUN PROGRAMS ****************"
    echo "python3 ./ssrc/02_blocks_main.py"
    echo ""
    python3 ./src/02_place_blocks_main.py $case2
elif [ $case -eq 3 ];then
    read -p "meso mesh におけるテープ数 p の入力 (2以上) : p = " case2
    # echo ""
    # read -p "kdtree構造体で定義する各節点のバウンディングボックス（立方体）の一辺の長さ : inf = " case3
    echo ""
    echo "**************** RUN PROGRAMS ****************"
    echo "python3 ./src/03_create_mesomesh.py"
    echo ""
    python3 ./src/03_create_mesomesh.py $case2 #$case3
elif [ $case -eq 99 ];then
    python3 ./src/99_output_vtk.py
fi