Version = "1.06"
'V1.06 Updater Verbessert
On Error Resume Next
url = "https://raw.githubusercontent.com/michiil/vbs_scrips/master/Bremse_Excel.vbs"
Set objReq = CreateObject("Msxml2.ServerXMLHttp.6.0")
objReq.setTimeouts 500,500,500,500
objReq.open "GET", url, False
objReq.send
If Err.Number = 0 Then
  If objReq.Status = 200 Then
    ArrGit = Split(objReq.responseText, vbLf)
    MyOwn = Wscript.ScriptFullName
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objTextFile = objFSO.OpenTextFile(MyOwn, 1) '1 = For Reading
    ArrLocal = Split(objTextFile.ReadAll, vbCrLf)
    objTextFile.Close
    VerLocal = Split(ArrLocal(0),"""")
    VerGit = Split(ArrGit(0),"""")
    If CSng(VerGit(1)) > CSng(VerLocal(1)) Then
      Set objTextFile = objFSO.OpenTextFile(MyOwn, 2) '2 = For Writing
      objTextFile.Write (Join(ArrGit, vbCrLf))
      objTextFile.Close
      MsgBox "Update durchgefuehrt! Bitte neu starten." & VbCRLF & ArrGit(1)
      WScript.Quit
    End If
  End If
Else
  Err.Clear
End If

If WScript.Arguments.Count = 0 Then
  MsgBox "Zum starten bitte eine Datei auf das Script ziehen."
  WScript.Quit
End If

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.OpenTextFile (WScript.Arguments.Item(0) , 1)
Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = True
objExcel.ScreenUpdating = False
objExcel.Workbooks.Add
Dim arrspalten
arrspalten = Array("B", "C", "D", "E", "F")
n = 0
Do Until objTextFile.AtEndOfStream
    strLine = objTextFile.Readline
    arrtext = Split(strLine , ";")
    For i = 0 to Ubound(arrtext)
      objExcel.Cells((n + 1), (i + 1)).Value = arrtext(i)
    Next
  n = n + 1
Loop

objExcel.Range("A19").Value = "Abweichung"
For each letter in arrspalten
  objExcel.Range(letter & "19").Formula = "=MAX(ABS(MIN(" & letter & "7:" & letter & "18)),MAX(" & letter & "7:" & letter & "18))"
Next
objExcel.Range("A19:F19").Font.Bold = True

If objExcel.Range("A21").Value <> "" then
  objExcel.Range("A35").Value = "Abweichung"
  For each letter in arrspalten
  objExcel.Range(letter & "35").Formula = "=MAX(ABS(MIN(" & letter & "23:" & letter & "34)),MAX(" & letter & "23:" & letter & "34))"
  Next
  objExcel.Range("A35:F35").Font.Bold = True
End If

objExcel.Columns("A:F").EntireColumn.AutoFit
objExcel.Columns("A").HorizontalAlignment = -4131 'links
objExcel.Columns("B:F").HorizontalAlignment = -4152 'rechts
objExcel.ScreenUpdating = True

'Konstanten: http://woonjas.linuxnerd.org/web/download.nsf/files/8C6C00FB633BCDC0C1256F39001D899E/$file/msoffice_constants.txt
