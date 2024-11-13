#!/bin/bash
echo "<select program>"
echo "1を選択した場合"
echo "      ⇓"
echo "与えられた.kファイルからmonolis形式のメッシュ(block)を作成"
echo ""
echo "2を選択した場合"
echo "      ⇓"
echo "map情報作成のテストを実行"
echo "作成されたmap情報をグリッドへ可視化する"
echo ""
read -p "手法パラメータを選択 : " case

if [ $case -eq 1 ]; then
    python3 ./src/01_make_blocks_main.py
elif [ $case -eq 2 ];then
    make clean
    make
    python3 ./src/02_place_blocks_main.py
fi