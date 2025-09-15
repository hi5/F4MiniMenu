# F4MM Other File Managers

## Introduction

F4MM will try to copy the path of the (selected) file(s) to the clipboard for further 
processing by sending the shortcut that has to be available in the "target" program. 
Often this will be <kbd>Ctrl</kbd>+<kbd>C</kbd>. Consult the documentation of the
target program(s) for the correct shortcut or how to change it.

Notes:
* F4MM assumes the "file list" is the currently __active__ control when activating F4MM,
  if not, the shortcut may be sent to another control, leading to unexpected results.
* F4MM will __not__ work with files stored in Archives (Zip, 7-Zip etc)

If F4MM doesn't seem to work correctly with a (new) file manager, try:
[list]
[*] Try various options for ProgramDelay (either 0 to use ClipWait) or increase the default 100ms.
[*] Change ProgramSendMethod to use ControlSend which _may_ help.
[/list]

⚠ Important: Adding and Deleting (Removing) have an immediate effect, even if you CANCEL
  the General Settings Window.

The information is stored in INI format in `F4MMOtherPrograms.ini` as follows:

```ini
[Name of Program]
ProgramExe=programname.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

* `[Name of Program]`  
Name of the program and how it will be listed in the Settings GUI.
* __ProgramExe__:  
  Program executable(s), can be a CSV list of multiple names to cover multiple versions e.g. `xplorer2.exe,xplorer2_lite.exe`.
* __ProgramShortCut__:  
  Keyboard Shortcut to copy the path(s) of the (selected) file(s) to the clipboard for further 
  processing by sending the shortcut that has to be available in the "target" program. Often this 
  will be `Ctrl+C`. Consult the documentation of the target program(s) for the correct shortcut or
  how to change it.  
  `^` = Ctrl, `+` = Shift, `!` = Alt  
* __Program Delay__:  
  0 will use another method to wait for the clipboard to receive the (selected) filepath(s) 
  [the AutoHotkey ClipWait command](https://www.autohotkey.com/docs/v1/lib/ClipWait.htm), otherwise it
  will wait the selected number of milliseconds before continuing. It impacts the display of the menu,
  it will "wait" that time before showing the menu.  
  100 ms seems to work well, but your mileage may vary.
* __Send Method__:  
  Choose between [Send](https://www.autohotkey.com/docs/v1/lib/Send.htm) (default) and [ControlSend](https://www.autohotkey.com/docs/v1/lib/ControlSend.htm).  
  If Send fails, ControlSend may work. If both methods do not work a custom solution for the target application might be required to be implemented in F4MM.  
  Open an `Issue` at GitHub with the program details (name + version).
* __Active__:  
  0 = F4MM is not active in this program  
  1 = F4MM is active in this program.

When a "setup" has been copied to the clipboard (for example from the list below), pressing the Clipboard icon will fill in the fields accordingly. This file has some examples.

When a program is added or edited it is automatically "Active" for F4MM. Use the Checkboxes to change the state (active/inactive) in the Settings GUI.

## Configs

Notes:
* Check `ProgramShortCut` to see it if (still) valid for the target program for your setup.
* (Many) Programs listed here only briefly tested, your results may vary.

Altap Salamander - https://www.altap.cz/
```ini
[Altap Salamander]
ProgramExe=salamand.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Double Commander - https://doublecmd.sourceforge.io/
(included in default setup)
```ini
[Double Commander]
ProgramExe=doublecmd.exe
ProgramShortCut=^+c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Dopus - https://www.gpsoft.com.au/  
(untested, shortcut found in documentation)
```ini
[Dopus]
ProgramExe=dopus.exe
ProgramShortCut=^+c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Everything - https://www.voidtools.com/
(included in default setup)
```ini
[Everything]
ProgramExe=Everything.exe,Everything64.exe
ProgramShortCut=^+c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Explorer - https://www.microsoft.com/en-us/windows/tips/file-explorer
Note: All Program* settings are ignored as it uses an different method of obtaining the (selected) files in Explorer.  
This entry is merely used to be able enable/disable F4MM in Explorer.
(included in default setup)
```ini
[Explorer]
ProgramExe=explorer.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Explorer++ - https://explorerplusplus.com/
```ini
[Explorer++]
ProgramExe=Explorer++.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

FileVoyager - https://www.filevoyager.com/
```ini
[FileVoyager]
ProgramExe=FileVoyager.exe
ProgramShortCut=^c
ProgramDelay=0
ProgramSendMethod=Send
Active=1
```

FreeCommander - https://freecommander.com/
```ini
[FreeCommander]
ProgramExe=FreeCommander.exe,FreeCommanderPortable.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

MultiCommander - https://multicommander.com/
```ini
[MultiCommander]
ProgramExe=MultiCommander.exe
ProgramShortCut=^p
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Nexusfile - https://www.xiles.app/
(as Esc is always assigned to perform an Action using Esc & hotkey for the filtered menu is tricky)
```ini
[Nexusfile]
ProgramExe=nexusfile.exe
ProgramShortCut=^!f
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

OneCommander - https://onecommander.com/
```ini
[OneCommander]
ProgramExe=OneCommander.exe
ProgramShortCut=^+c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Q-Dir - https://www.softwareok.com/?seite=Freeware/Q-Dir
```ini
[QDir]
ProgramExe=Q-Dir.exe,Q-Dir_x64.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

SpeedCommander - https://www.speedproject.com/
(using the default Ctrl+C even though there is a dedicated shortcut (Ctrl+Shift+c+p), this seems to work just as well)
```ini
[SpeedCommander]
ProgramExe=SpeedCommander.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

Tablacus Explorer - https://tablacus.github.io/explorer_en.html, https://github.com/tablacus/TablacusExplorer
```ini
[Tablacus Explorer]
ProgramExe=TE32.exe,TE64.exe
ProgramShortCut=^c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

V - File Viewer - https://www.fileviewer.com/Download.html
```ini
[V - File Viewer]
ProgramExe=v.exe
ProgramShortCut=^+p
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

xplorer2 - https://www.zabkat.com/, xplorer2 lite https://www.zabkat.com/x2lite.htm
```ini
[xplorer2]
ProgramExe=xplorer2.exe,xplorer2_lite.exe
ProgramShortCut=!c
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

XYPLorer - https://www.xyplorer.com/, XYPLorerFree https://www.portablefreeware.com/index.php?id=579
```ini
[XYPLorer]
ProgramExe=XYPLorer.exe,XYPLorerFree.exe
ProgramShortCut=^p
ProgramDelay=100
ProgramSendMethod=Send
Active=1
```

