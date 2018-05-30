# VSCode配置(只适用于MaxOS环境)

## 用户配置
~/Library/Application\ Support/Code/User/

## 插件放哪里？
～/.vscode/extensions

## 问题列表
- [x] 导入sublime风格: 自动导入
- [x] esformatter格式化无效：command 'esformatter' not found: 用户设置："editor.formatOnSave": true
- [x] 快捷键移动光标(上下左右、起始、结束、按单词移动): [插件](https://github.com/zhaiduo/fastcursor)
- [x] 删除一行: shift+cmd+K
- [x] 新增一行: cmd+Enter
- [x] 复制一行: shift+cmd+D
- [ ] 快速移动页面、光标
- [ ] 快速切换vim模式
- [ ] 行为录制
- [ ] 快捷键切换区域
- [ ] 拆分窗口
- [x] 定义跳转: Opt+Cmd+down arrow
- [x] 定义跳转返回: ctrl+-
- [x] 切换控制台: shift+cmd+Y
- [x] 切换资源管理器与工作区: shift+cmd+E
- [x] 开关资源管理器: cmd+B
- [x] 多行注释: option+cmd+/ || shift+option+A
- [x] 切换窗口: cmd+`
- [x] 命令调用: shift+cmd+P
- [x] 焦点切换: ctrl+shift+M 然后按 tab 或者 shift+tab
- [x] Parsing error: 'import' and 'export' may appear only with 'sourceType: module'
	> 增加下面配置到.eslint.js

    > "parserOptions": {
    > "sourceType": "module"
    > },
- [x] command not found: code: Open the Command Palette (⇧⌘P) and type 'shell command' to find the Shell Command: Install 'code' command in PATH command.

## VS扩展
* michelemelluso.code-beautifier
* howardzuo.vscode-esformatter
* ms-vscode.sublime-keybindings
* TSLint

## 更多
https://github.com/Microsoft/vscode-tips-and-tricks

## 光标移动插件
https://github.com/zhaiduo/fastcursor

