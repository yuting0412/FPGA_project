# FPGA 期末 project - 打磚塊
- Author : 107213021

## input/output
### input
- 指撥開關
    - ![](https://i.imgur.com/bZ6uZ9V.jpg)
    - `藍 1` :暫停遊戲
        - `1` : 暫停
        - `0` : 開始
    - `藍 2` : 是否重設遊戲版面
        - `1` : 不會重設遊戲版面
        - `0` : 會重設遊戲版面
    - `紅 3` `紅 4` : 關卡等級設定

- 輕觸開關
    - ![](https://i.imgur.com/VepAwF6.jpg)
    - `S1`, `S2` : 控制平台左右移動
    - `S3` : 球掉出遊戲範圍後，若還有球數，使用新的球繼續遊戲
    - `S4` : 球數歸零後，重新開始遊戲
### output
- 8x8 LED 矩陣
    - 顯示遊戲畫面
        - ![](https://i.imgur.com/ToeYDRZ.jpg)

- 七段顯示器
    - 打掉幾個 block (得分)
        - ![](https://i.imgur.com/BMZhXlN.jpg)

- LED 陣列
    - 剩餘球數
        - ![](https://i.imgur.com/styprnb.jpg)

## 功能說明
- 單人遊戲，每人有 3 球
- 螢幕上部有若干層磚塊，一個球在螢幕上方的磚塊和牆壁、螢幕下方的移動短板和兩側牆壁之間來回彈，當球碰到磚塊時，球會反彈，而磚塊會消失。玩家要控制螢幕下方的板子，讓「球」通過撞擊消去所有的「磚塊」，球碰到螢幕底邊就會消失，所有的球消失則遊戲失敗。

## 程式模組說明
```verilog=
module Breakout(output reg [7:0] RED, GREEN, BLUE, // 紅色 綠色 藍色 LED
                output reg [3:0] COMM, // 控制亮燈排數
                output reg [6:0] seg, // 七段顯示器
                output reg [1:0]COM, // 控制哪個七段顯示器要亮
                output [2:0] life,  // LED 陣列
                input CLK, Left, Right, // 控制短板方向
                start, // 使用新的球繼續遊戲
                restart, // 球數歸零後，重新開始遊戲
                pause, // 暫停
                keepBoard, // 是否重設遊戲版面
                input [1:0]	level); // 關卡等級設定
```
###  I/O 變數對應 FPGA I/O 裝置
- output
    - 8*8 全彩點矩陣
        - reg [7:0] RED, GREEN, BLUE
        - reg [3:0] COMM
    - 7 SEG *4
        - reg [6:0] seg
        - reg [1:0]COM
    - 16 BITS LED
        - [2:0] life
- input
    - 4 BITS SW
        - Left, Right
        - start
        - restart
    - 8 DIPSW
        - pause
        - keepBoard
        - [1:0] level

## Demo video
[demo 影片](https://drive.google.com/file/d/1PUduK0oTOes7FbF6AjKVl6U4bZn0RYDZ/view?usp=sharing)