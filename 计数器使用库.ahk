
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; 包含 Just Me 的类库
#Include Class_SQLite.ahk

; --- 1. 初始化数据库 ---
DBFile := A_ScriptDir . "\CounterData.db"
DB := new SQLiteDB  ; 实例化类

; 打开（或创建）数据库文件
if !DB.OpenDB(DBFile) {
    MsgBox, 16, 错误, % "无法打开数据库: " . DB.ErrorMsg
    ExitApp
}

; 创建表（如果不存在）：id=1 为计数器专用，val 为当前数值
SQL := "CREATE TABLE IF NOT EXISTS MyCounter (id INTEGER PRIMARY KEY, val INTEGER);"
if !DB.Exec(SQL)
    MsgBox, 16, 错误, % DB.ErrorMsg

; 检查是否已经有初始数据，如果没有则插入 1
SQL := "INSERT INTO MyCounter (id, val) SELECT 1, 1 WHERE NOT EXISTS (SELECT 1 FROM MyCounter WHERE id=1);"
DB.Exec(SQL)

; --- 2. 快捷键部分 ---
^q::
    ; A. 查询当前数值
    SQL := "SELECT val FROM MyCounter WHERE id=1;"
    if !DB.GetTable(SQL, Table) {
        MsgBox, % "查询失败: " . DB.ErrorMsg
        return
    }
    
    ; 获取第一行第一列的数据
    CurrentVal := Table.Rows[1][1]
    
    ; B. 输出结果
    Clipboard := CurrentVal
    Send, ^v
    
    ; C. 更新数据库 (数值 + 1)
    NextVal := CurrentVal + 1
    SQL := "UPDATE MyCounter SET val = " . NextVal . " WHERE id=1;"
    if !DB.Exec(SQL)
        MsgBox, % "更新失败: " . DB.ErrorMsg
        
    ; 可选：气泡提示
    ToolTip, SQLite 计数: %CurrentVal% -> 下次: %NextVal%
    SetTimer, RemoveToolTip, -1000
return

RemoveToolTip:
    ToolTip
return

; --- 3. 退出时关闭数据库 ---
GuiClose:
    DB.CloseDB()
    ExitApp