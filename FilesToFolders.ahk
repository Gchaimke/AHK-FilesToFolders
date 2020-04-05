#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FormatTime, Year,A_now, yy


;==========Main GUI START============
createMainGui:
Gui, guiMain:Default
Gui, Font, s10, Verdana

Gui, Add, GroupBox, w200 h420,Script settings
Gui, Add, Text,x20 y30,Select file extension
Gui, Add, edit,vSelectedExt

Gui, Add, Button,w180 h30 gStart,Start

Gui, Add, ListView,x250 y10 w350 r12 vStatusText gMyListView, Procesed Files log

Gui, Add, edit,w350 vSelectedFolderIn 
Gui, Add, Button,w150 gSelectFolderIn, Input Folder

Gui, Add, Text,

Gui, Add, edit,w350 vSelectedFolderOut
Gui, Add, Button,w150 gSelectFolderOut, Output Folder

Gui , Add, StatusBar ,, Please Select input & output folder...

GuiControl,,SelectedExt, pdf
GuiControl,,SelectedFolderIn, %A_Desktop%\TMP
GuiControl,,SelectedFolderOut, %A_Desktop%\TMP

Gui, Show, ,Files To Folders
return


guiMainGuiClose:
ExitApp

;==========Main GUI END============

SelectFolderIn:
sFolder := SelectFolder()
GuiControl,, SelectedFolderIn, %sFolder%
SB_SetText("Please Select output folder...")
return

SelectFolderOut:
sFolder := SelectFolder()
GuiControl,, SelectedFolderOut, %sFolder%
SB_SetText("Press Start...")
return

SelectFolder(){
FileSelectFolder, myFolder,,,Select folder
if myFolder =
    SB_SetText("The user didn't select any folder.")
else
    return %myFolder%
return
}

Start:
	FileList =
	Gui, Submit,NoHide
	;msgbox,4,,I will create folders in
	if(SelectedFolderIn =="" || SelectedFolderOut =="" ){
		msgbox,,Error,No input or output folder selected?
	}else{
		Loop Files, %SelectedFolderIn%\*.%SelectedExt%
			{	
				extLength := StrLen(A_LoopFileExt) + 1
				StringTrimRight,fName,A_LoopFileName,extLength
				LV_Add("", fName)
				FileCreateDir, %SelectedFolderOut%\%fName%
				FileCopy, %A_LoopFilePath%, %SelectedFolderOut%\%fName%\
			}
		SB_SetText("All Folders is Created successfully.")
	}
return

MyListView:
if (A_GuiEvent = "DoubleClick")
{
    LV_Delete()
}
return

