* color_ansi
    * 16 colors:
        * `\033[${ID}m`    (普通)
        * `\033[${ID};1m`  (加粗：由终端设置是否也高亮)
        * `\033[${ID};2m`  (低暗：由终端设置是否也低暗)
    * 256 color:
        * `\033[${fg_bg};5;${ID}m`
            > ${fg_bg}：背景为`38m`，前景为`48m`  
            > [256 color](https://jonasjacek.github.io/colors/)
    * true color:
        * `\c033[${fg_bg};2;${red};${green};${blue}m`
            > 把你的终端的调色板打开自己看

|  color | foreground | background |
|:------:|:----------:|:----------:|
|  black |     30     |     40     |
|   red  |     31     |     41     |
|  green |     32     |     32     |
| yellow |     33     |     33     |
|  blue  |     34     |     34     |
| purple |     35     |     35     |
|  cyan  |     36     |     36     |
|  white |     37     |     37     |
<!-- -->

* escape_ansi

|        escape       |    meaning   |
|:-------------------:|:------------:|
|       `\e[0m`       |     恢复     |
|       `\e[1m`       |     加粗     |
|       `\e[2m`       |     低暗     |
|       `\e[3m`       |     斜体     |
|       `\e[4m`       |    下划线    |
|       `\e[5m`       |     闪烁     |
|       `\e[7m`       |     反显     |
|       `\e[8m`       |     消隐     |
| `\e[30m` ~ `\e[37m` |    前景色    |
| `\e[40m` ~ `\e[47m` |    背景色    |
|       `\e[nA`       |  光标上移n行 |
|       `\e[nB`       |  光标下移n行 |
|       `\e[nC`       |  光标右移n行 |
|       `\e[nD`       |  光标左移n行 |
|        `\e[s`       | 保存光标位置 |
|        `\e[u`       | 恢复光标位置 |
|      `\e[?25l`      |   隐藏光标   |
<!-- -->

