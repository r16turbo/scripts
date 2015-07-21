Option Explicit
ElevatePermission
ChScriptDir


' StreamWriteEnum
Const adWriteChar = 0, adWriteLine = 1
' StreamReadEnum
Const adReadAll = -1, adReadLine = -2
' StreamTypeEnum
Const adTypeBinary = 1, adTypeText = 2
' LineSeparatorsEnum
Const adCR = 13, adCRLF = -1, adLF = 10
' SaveOptionsEnum
Const adSaveCreateNotExist = 1, adSaveCreateOverWrite = 2


Dim source, result, stylesheet, output, buffer
Set source = WScript.CreateObject("MSXML2.DOMDocument.6.0")
Set result = WScript.CreateObject("MSXML2.DOMDocument.6.0")
Set stylesheet = WScript.CreateObject("MSXML2.FreeThreadedDOMDocument.6.0")
Set output = WScript.CreateObject("ADODB.Stream")
Set buffer = WScript.CreateObject("ADODB.Stream")


' Load data.
With source
    .async = False
    .validateOnParse = False
    .setProperty "ProhibitDTD", False
    .preserveWhiteSpace = True
    .load "TextStyles.plist"
End With
If (source.parseError.errorCode <> 0) Then
   MsgBox("You have error " & source.parseError.reason)
Else
    ' Load style sheet.
    With stylesheet
        .async = False
        .validateOnParse = False
        .setProperty "ProhibitDTD", False
        .preserveWhiteSpace = True
        .load "TextStyles.xsl"
    End With
    If (stylesheet.parseError.errorCode <> 0) Then
        MsgBox("You have error " & stylesheet.parseError.reason)
    Else
        ' Do the transform.
        With result
            .async = False
            .validateOnParse = False
            .setProperty "ProhibitDTD", False
            .preserveWhiteSpace = True
        End With
        source.transformNodeToObject stylesheet, result

        ' Result save to output stream
        output.Type = adTypeText
        output.Charset = "UTF-8"
        output.LineSeparator = adCRLF
        output.Open
        result.save output

        ' Convert CRLF to LF
        buffer.Type = adTypeText
        buffer.Charset = "UTF-8"
        buffer.LineSeparator = adLF
        buffer.Open
        output.Position = 0
        buffer.WriteText Replace(output.ReadText(adReadLine), "><", ">" & vbLf & "<"), adWriteLine
        Do Until output.EOS
            buffer.WriteText output.ReadText(adReadLine), adWriteLine
        Loop
        output.Close

        ' Remove BOM
        buffer.Position = 0
        buffer.Type = adTypeBinary
        buffer.Position = 3
        output.Type = adTypeBinary
        output.Open
        output.Write buffer.Read
        buffer.Close

        ' Write to file
        output.SaveToFile "TextStyles.xml", adSaveCreateOverWrite
        output.Close
   End If
End If


Sub ElevatePermission
' ' フォルダ削除のコードをここに書く
' If Err.Number <> 0 Then
' WScript.Echo "削除する権限がありません"
' End If
    Dim Shell
    ' No arguments
    If WScript.Arguments.Count = 0 Then
        ' Run this script as admin
        Set Shell = CreateObject("Shell.Application")
        Shell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ uac", "", "runas"
        WScript.Quit
    End If
End Sub

Sub ChScriptDir
    Dim SH, FS
    Set SH = WScript.CreateObject("WScript.Shell")
    Set FS = WScript.CreateObject("Scripting.FileSystemObject")
    SH.CurrentDirectory = FS.GetParentFolderName(WScript.ScriptFullName)
End Sub
