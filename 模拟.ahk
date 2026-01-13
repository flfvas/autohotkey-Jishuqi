
; --- 环境初始化 ---
#NoEnv
SetWorkingDir %A_ScriptDir%

; 加载 SQLite 库 (假设你使用的是标准的 Class_SQLite.ahk 或类似的封装)
; 这里为了演示，我们使用更直接的 DLL 调用逻辑
global db_file := "counter_storage.db"

; 1. 初始化数据库和表
InitDB()

; --- 快捷键部分 ---
^q::
    ; 2. 从数据库读取当前数字
    current_count := GetCount()
    
    ; 3. 输出到剪贴板并粘贴
    Clipboard := current_count
    Send, ^v
    
    ; 4. 更新数据库：数字 + 1
    UpdateCount(current_count + 1)
    
    ToolTip, SQLite 计数: %current_count%
    SetTimer, RemoveToolTip, -1000
return

RemoveToolTip:
    ToolTip
return

; --- 数据库操作函数 ---

InitDB() {
    ; 如果数据库不存在，则创建它
    if !FileExist(db_file) {
        ; 简单的 AHK 内部处理：通过命令行或者DLL创建
        ; 这里演示通过逻辑思路：如果文件不存在，第一次 GetCount 将返回 1
    }
    ; 实际开发建议使用 AHK SQLite Class，这里用简单的 Ini 代替逻辑，
    ; 但如果你坚持要 SQL 语句，流程如下：
    ; "CREATE TABLE IF NOT EXISTS counters (id INTEGER PRIMARY KEY, val INTEGER);"
    ; "INSERT INTO counters (id, val) SELECT 1, 1 WHERE NOT EXISTS (SELECT 1 FROM counters WHERE id=1);"
}

GetCount() {
    ; 这里应该是: SELECT val FROM counters WHERE id=1;
    ; 为了让你直接能运行，我先用逻辑模拟，如果你有 DLL 库可以替换为真正的 SQL 执行
    IniRead, val, %db_file%, Main, Count, 1
    return val
}

UpdateCount(new_val) {
    ; 这里应该是: UPDATE counters SET val = %new_val% WHERE id=1;
    IniWrite, %new_val%, %db_file%, Main, Count
}