#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; --- 1. 初始化数据库 ---
; 确保 Class_SQLite.ahk 在脚本同目录下
#Include Class_SQLite.ahk

DBFile := A_ScriptDir . "\CounterData.db"
DB := new SQLiteDB  

if !DB.OpenDB(DBFile) {
    MsgBox, 16, 错误, % "无法打开数据库: " . DB.ErrorMsg
    ExitApp
}

; 创建表（如果不存在）
SQL := "CREATE TABLE IF NOT EXISTS MyCounter (id INTEGER PRIMARY KEY, val INTEGER);"
if !DB.Exec(SQL)
    MsgBox, 16, 错误, % DB.ErrorMsg

; 检查并设置初始数据
SQL := "INSERT INTO MyCounter (id, val) SELECT 1, 1 WHERE NOT EXISTS (SELECT 1 FROM MyCounter WHERE id=1);"
DB.Exec(SQL)

; --- 2. 快捷键部分 (Win+Alt+C) ---
*$#C::
    ; A. 查询当前序号
    SQL := "SELECT val FROM MyCounter WHERE id=1;"
    if !DB.GetTable(SQL, Table) {
        MsgBox, % "查询失败: " . DB.ErrorMsg
        return
    }
    
    ; 获取数据库当前的序号
    CurrentVal := Table.Rows[1][1]
    
    ; B. 格式化日期 (yyyyMMdd-HHmmss 格式，已去掉毫秒)
    clipboard := "" 
    FormatTime, OutputVar, , yyyyMMdd-HHmmss
    
    ; C. 组合字符串 (时间-序号)
    clipboard := OutputVar . "-" . CurrentVal
    
    ; 执行粘贴及后续全选复制动作 (保留你原有的逻辑)
    Send ^v
    Sleep 200
    Send {Space}
    Sleep 250
    Send ^a
    Sleep 300
    Send ^c
    
    ; D. 数据库序号自增
    NextVal := CurrentVal + 1
    SQL := "UPDATE MyCounter SET val = " . NextVal . " WHERE id=1;"
    if !DB.Exec(SQL)
        MsgBox, % "更新失败: " . DB.ErrorMsg
        
    ; 屏幕右下角提示
    ToolTip, 当前序号: %CurrentVal% -> 下次: %NextVal%
    SetTimer, RemoveToolTip, -1000
return

RemoveToolTip:
    ToolTip
return

; --- 3. 退出处理 ---
GuiClose:
    DB.CloseDB()
    ExitApp