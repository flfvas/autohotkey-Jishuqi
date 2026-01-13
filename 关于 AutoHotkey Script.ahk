#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



MsgBox, % "位数: " (A_PtrSize = 8 ? "64位" : "32位") . "`n版本: " A_AhkVersion . "`n编码: " (A_IsUnicode ? "Unicode" : "ANSI")