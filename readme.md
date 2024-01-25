# F4MiniMenu - v1.4

A <kbd>F4</kbd> Menu program for [Total Commander](http://www.ghisler.com/) to open selected file(s) in editor(s).  
(and experimental/rudimentary support for Windows Explorer, Double Commander, XYPlorer, and Everything - only [when activated](#other-programs)).  

It is a *standalone* program which runs separatly from Total Commander. See Getting Started.

## Features

* Open selected files in defined Editor(s) - on a first come, first serve basis
* Optional: Show menu with:  
  a. All Editors (full menu)  
  b. Matching Editors based on extension (filtered menu)  
* Various methods to open selected files: "[regular](#normal)", "[Drag & Drop](#drag-drop)", [Filelist](#filelist), [cmdline](#cmdline)
* Document Templates to create new files for file types other than "text" - [DocumentTemplates README](DocumentTemplates/readme.md)
* Open source - written in [AutoHotkey](https://www.autohotkey.com/) (v1.1)

## Discussion

* [F4MiniMenu TC Forum thread](http://ghisler.ch/board/viewtopic.php?t=35721).
* [GH Issues](https://github.com/hi5/F4MiniMenu/issues)

# Introduction

F4 is the shortcut key used in [Total Commander](http://www.ghisler.com/) - a file manager 
for Windows - for opening selected files in a pre-defined editor. In TC only one program can
be assigned to F4 making it impossible to define or select other editors for different file
types. Several tools have been made to solve this problem, these include:

* [ChoiceEditor](http://www.totalcmd.net/plugring/ChoiceEditor.html)
* [Open File shell for TC](http://www.totalcmd.net/plugring/OpenFileTC.html)
* [Total Commander Edit Redirector](http://ghisler.ch/board/viewtopic.php?t=27573)
* and of course [F4Menu](http://ghisler.ch/board/viewtopic.php?t=17003) - TC Forum thread

While the original F4Menu[1] has quite a few options, this "clone" started out as a minimalistic
program with only the basic functionality: opening multiple file types in various editors.

There are various methods to open selected files: regular, "[Drag & Drop](#drag--drop)", [Filelist](#filelist)
or by making use of a [cmdline](#cmdline) option.

There is a helper script to use F4MiniMenu settings as the "internal editor" defined in 
Total Commander and use so called **DocumentTemplates** for creating new files.
See [F4TCIE](#helper-script-f4tcieahk).

There are *two* foreground menus:

1. Show all programs in the menu
2. Show matching programs (filtered): only show those programs which match the extensions
   of the selected files. Access the full menu by using the 'full menu' option
   that is shown in this filtered menu. The default editor will remain the first menu
   entry. If a matching program can not be found, the full menu is shown instead. (See settings)

Passive mode, F4MiniMenu doesn't have to remain in memory for it to work, see [passive](#passive).

## First come, first serve

__F4MiniMenu__ will open a file in the __first__ editor it finds a match for based on the
__extension__. If there is no match, it will open the file(s) in the default editor.
The default editor is the first editor listed in the [*Configure editors*](#screenshots) 
window and in the configuration file (XML or INI) it will be the first entry.
To open the file(s) in another program use the [*Foreground* menu](#screenshots) option.
See screenshot below.

Add or modify editors via the tray menu or by bringing up the Foreground menu.
`%Commander_Path%` and other variables can be used in the path(s) to the editors and icons.

### Tip(s)

In principle F4Menu (or other tools) and F4MiniMenu can be run side by side as long as 
there are no conflicting keyboard shortcuts. In case of the same hotkey setup, F4MiniMenu
will take precedence. Set the F4MiniMenu shortcuts via the tray menu, right click, Settings option.

In general: be careful opening with opening large numbers of files at once, programs can crash
and your computer could become unstable requiring a reboot.

Do not edit the `F4MiniMenu.xml` or `F4MiniMenu.ini` settings file while the script is running, any 
changes made will be overwritten when the script exits. A backup is made at startup and saved as
`F4MiniMenu.xml.bak` or `F4MiniMenu.ini.bak`

### Disclaimer

Use at your own risk.

# Getting Started

Start `F4MiniMenu.ahk` (or `F4MiniMenu-64.exe`, `F4MiniMenu-32.exe`, available in [Releases](https://github.com/hi5/F4MiniMenu/releases)).

Note that F4MiniMenu is a program that runs on its **own** and sits in the tray menu waiting 
for Total Commander windows (and others if set up) to be _Active_ and the defined hotkeys to be
pressed to take action (e.g. _Edit files_, default: <kbd>F4</kbd>; or _Show a menu_ default: <kbd>Esc</kbd>+<kbd>F4</kbd>).
Access the settings and define(d) editors via the tray menu or [foreground menu](https://github.com/hi5/F4MiniMenu#screenshots) - <kbd>Esc</kbd>+<kbd>F4</kbd>. 

No changes to the TC settings are required, although there is a helper script (program), see [F4TCIE](#helper-script-f4tcieahk),
which does need to be defined as `editor` in the TC Settings for working with files in archives and FTP.

Once F4MiniMenu is started, the Global settings and new editors with a variety of options (as outlined below) can be changed and added.

(Additional information in the "Setup" section below.)

# Settings

## Global configuration

* Menu
  - Position of Menu
  - Accelerator key for full menu when using the filtered menu
  - Show Menu or Edit file directly when using the filtered menu
* Files (Maximum number of files to be opened, will ask for confirmation if more are selected)
* WinWait -- see below
* Total Commander
  - TC Start (Start Total Commander when F4MM is started, or not)
  - TC Path
  - Close F4MM options (Exit F4MM when Total Commander closes)
* Hotkeys
  - Background
  - Foreground menu
  - Filtered menu
* Other programs
  - Explorer, Double Commander, XYPlorer, Everything.
* Use elsewhere in TC
  - Lister(1), Find Files

(1) If Lister setting is active _and_ F4Edit>1 in wincmd.ini: _close Lister window_ - See `F4Edit=` options in TC help file on how to handle F4 in lister via wincmd.ini (Introduced in TC v11.03).

__WinWait__ Set the maximum time in seconds to wait for the selected program window to appear before applying the selected Window Mode (Normal, Maximized, Minimized -- see Editor configuration). This should also prevent any unexpected "waiting" in case a program launch failed (crash, very slow program start etc).  
As soon as the window appears it will continue to apply the Window mode and no longer wait.
It may not be possible to edit (open) a new document during this defined waiting period.

## Editor configuration

The following options can be set for each editor:

* Path to Program executable. See Path variables.
* Extensions as a comma separated list
* Parameters to pass on -- if any, see Parameters/Options.
* Start directory (if any)
* Method (normal, drag & drop, filelist, cmdline) -- see Methods below
* Window Mode (Normal (often last used window size and position), Maximized, Minimized)
* Icon to use in the menu as alternative to program's icon (if any)
* Name to use in the menu as alternative to the program.exe (if any)
* Drag & Drop delay in millisecond (time to wait before sending drag & drop command so program can start)
* Open delay in milliseconds (time to wait before opening the first file so program can start)

## Path variables

All path variables should be wrapped in `%` signs, examples:

* `%Commander_Path%\tools\lister.exe`
* `%WinDir%\write.exe`
* `%A_ScriptDir%\..\..\Portable\CudaText\cudatext.exe`

TC Environment variable:

* Commander_Path

AutoHotkey path variables:

* A_ScriptDir
* A_ComputerName
* A_UserName
* A_WinDir
* A_ProgramFiles
* A_AppData
* A_AppDataCommon
* A_Desktop
* A_DesktopCommon
* A_StartMenu
* A_StartMenuCommon
* A_Programs
* A_ProgramsCommon
* A_Startup
* A_StartupCommon
* A_MyDocuments

Environment path variables:

* ComSpec
* WinDir
* ProgramFiles
* ProgramFiles(x86)
* ProgramW6432

From the [AutoHotkey documentation](https://www.autohotkey.com/docs/v1/Variables.htm#os):

The Program Files directory (e.g. `C:\Program Files` or `C:\Program Files (x86)`). This is usually the same as the `ProgramFiles` environment variable.

On 64-bit systems (and not 32-bit systems), the following applies:

* If the executable (EXE) that is running the script is 32-bit, `A_ProgramFiles` returns the path of the "Program Files (x86)" directory.
* For 32-bit processes, the `ProgramW6432` environment variable contains the path of the 64-bit Program Files directory. On Windows 7 and later, it is also set for 64-bit processes.
* The `ProgramFiles(x86)` environment variable contains the path of the 32-bit Program Files directory.

# Methods

There are four methods to start a program and open the selected file(s).

## Normal

This works in many cases and is similar to opening a file in TC by pressing enter or double click (or traditional F4).
When multiple files are selected and the program(s) needs to be started first, a delay per editor can be set before 
attemping to open the second and other files: Delay for Open. A similar delay can be set for Drag & Drop. Normal is the default method.

## Drag & Drop

When the program is already running F4MM attempts to Drag & Drop the selected files into the application.
If the program is not running, it is started using the normal method for the first file, then subsquent
files are Drag & Dropped. In order to give the application some time to start, before D&D the second and 
other files a delay can be set per editor - Delay for Drag & Drop. A simlar delay can be set for Normal.

Many programs support Drag & Drop, but not all programs will respond well to the Drag & Drop
method used in this script. If it does not seem to work with a particular program, try
the Normal or cmdline method(s).

## Filelist

Some programs can open files which are listed in a (temporary) file. In Total Commander
there is something similar in the _Button bar_ and in the _Start Menu_ where a file list -- 
the `%L` parameter -- can be used to create a list with the names of the selected files and 
directories, one file per line. __F4MiniMenu__ can do the same. A temporary file named 
`$$f4mtmplist$$.m3u` is created which is passed on to the target program. 

*Example Filelist usage:*

    Program: C:\Program Files\XnView\xnview.exe
    Parameters: -filelist
    Method: 3 - Filelist

Result: Selected files will be opened in the XnView browser.

    Program: C:\Program Files\IDMComp\UltraEdit\uedit64.exe
    Parameters: /f
    Method: 3 - Filelist

Result: Selected files will be opened in UltraEdit. /f is the command line parameter required for UltraEdit.

## cmdline

To pass the selected files to the program on the command line `"program.exe" "file1" "file2" "etc"`.
Paths to the program and files are quoted automatically.

*Examples cmdline usage:*

    Program: C:\Program Files\Meld\Meld.exe
    Method: 4 - cmdline

Result: Selected files will be opened in Meld (diff program) [Discussion](https://github.com/hi5/F4MiniMenu/issues/14)

    Program: c:\tools\mp3wrap\mp3wrap.exe
    Parameters: ?output.mp3
    Startdir: %p
    Method: 4 - cmdline

Result: Selected MP3 files will be merged into one larger MP3 file asking the user for a filename
(output.mp3 would be default)

    Program: c:\Portable\vscodium\VSCodium.exe
    Parameters: -filelist
    Method: 3 - Filelist

Result: Selected files will be opened in VSCodium (works the same for Microsoft Visual Studio Code)

*Notes:*

* The reason for the .m3u extension is simple: it enables playlist support for WinAmp: Select
multiple music files and press the hotkey to play the selected files. If the temporary file
didn't have the .m3u extension WinAmp wouldn't recognize it as a playlist.
* The temporary file `$$f4mtmplist$$.m3u` is __not__ deleted directly after use to avoid
problems with slow programs. It is deleted when __F4MiniMenu__ starts or closes.

## Parameters/Options

(The TC file manager has two file panels side by side referred to as Source and Target)

|Parameter|Meaning|
|---------|-------|
|`%P`       |insert the source path into the command line, including a backslash \ at the end.|
|`%T`       |insert the current target path, including a backslash \ at the end. (TC only, see notes)|
|`%O`       |places the current filename without extension into the command line.|
|`%E`       |places the current extension (without leading period) into the command line.|
|`?`        |as the first parameter causes a Dialog box to be displayed before starting the program, containing the parameters that follow. This allows the parameters to be changed before starting the program or prevent the programs execution.|
|`%N`       |places the filename under the cursor into the command line.|
|`%M`       |places the current filename in the target directory into the command line.|
|`%$DATE:placeholders%`|See TC help, "Environment variables". Valid placeholders: y,Y,M,D,h,H,i1,i,m,s.|
|**F4MM specific options:**|-------|
|`%f41`   |placeholder to alter position of filenames on the command line. (see notes and example below)|
|`%$DATE:placeholders\|Value\|TimeUnits%`|if _Value_ and _TimeUnits_ are present, these parameters allow for "Date & Time Math" to add or substract TimeUnits. TimeUnits can be either `Seconds`, `Minutes`, `Hours`, or `Days`. See TimeUnits of the https://www.autohotkey.com/docs/v1/lib/EnvAdd.htm command.|

Notes:

1. More _%f4_ fields may be added in the future.
2. %T for other file managers %T will use the same value as %P 

*Example: %f41*

F4MiniMenu starts programs as follows:

_ProgramName.exe Parameters File(s) Startdir_

But for some programs the _parameter(s)_ - the additional command(s) that need to be passed
on to the program - have the come _AFTER_ the _File(s)_. So by using %f41 as a placeholder
in the parameters field it will instruct F4MiniMenu where to place the files on the 
"command line"

    Program: pdftk.exe
    Parameters: %f41 burst

So the program now starts as _pdftk.exe file.pdf burst_ (instead of _pdftk.exe burst file.pdf_)

*Example: %$DATE:placeholders|Value|TimeUnits%*

`%$DATE:Y-M-D|7|Days%` -> A week from now e.g. add 7 Days ahead. -7 would be last week.

# Helper script: F4TCIE.ahk

Use F4TCIE for editing files in:

* an Archived file (e.g. ZIP panel) 
* FTP connection
* Create new file (Shift+F4)

Rename the script or exe to to end with an "i" to an INI setup, e.g. `F4TCIEi.ahk` or `F4TCIEi.exe`.
(see 'XML or INI')

## Setup F4TCIE

When F4MiniMenu sees the selected files  are in an archive or in an FTP panel,
it uses the default Total Commander Edit command. It will only use the first 
file if multiple files have been selected in the archive or FTP panel.

To configure Total Commander to use F4TCIE.ahk:

    TC, Configuration, Edit/View, Editor (xml):
    drive:\path-to\F4TCIE.ahk "%1"

    TC, Configuration, Edit/View, Editor (ini):
    drive:\path-to\F4TCIEi.ahk "%1"

Note: if both AutoHotkey v1.1 and v2 are installed you may receive an error message (from the AutoHotkey launcher).
In that case include the full path of the AutoHotkey v1.1 executable before the drive:\path-to\F4TCIE.ahk like so:

    TC, Configuration, Edit/View, Editor:
    c:\program files\autohotkey\autohotkey.exe drive:\path-to\F4TCIE.ahk "%1"

Tip: To use %PROCESSOR_ARCHITECTURE%

Rename

    F4TCIE-64i.exe -> F4TCIE-amd64i.exe
    F4TCIE-32i.exe -> F4TCIE-x86i.exe

then use

    drive:\path-to\F4TCIE-%PROCESSOR_ARCHITECTURE%.exe "%1"

If for some reason the configuration can not be opened, an attempt is made to start the editor
for the file type associated in Windows (so for txt -> notepad, for bmp,jpg -> MS Paint etc).
When there is no editor for the file type found `notepad.exe` is started.

Reference: see also [#13](https://github.com/hi5/F4MiniMenu/issues/13)

# DocumentTemplates

F4TCIE can also make use of DocumentTemplates when creating New files in 
Total Commander using the <kbd>shift</kbd>+<kbd>f4</kbd> shortcut.

More information can be found in the [DocumentTemplates README](DocumentTemplates/readme.md)

# Setup

## Requirements

* AutoHotkey 1.1+ (Ansi or Unicode)
* Total Commander (or some other file managers)

## Install

### Script

Download the source  as a ZIP from GitHub here <https://github.com/hi5/F4MiniMenu/archive/master.zip>
and unpack. To start it simply run `F4MiniMenu.ahk`. Setup F4MiniMenu using the tray menu 
options for *Settings* and *Configure editors*.

Once the shortcuts have been setup access *Settings* and *Configure editors* via the Foreground
menu options by pressing the shortcut (press <kbd>Esc</kbd>+<kbd>F4</kbd> by default).
See screenshots below.

### Executable

1. Compile the script to a standalone executable using [AHK2Exe](https://autohotkey.com/download/).
[Documentation](https://autohotkey.com/docs/Scripts.htm#ahk2exe)
2. Or see https://github.com/hi5/F4MiniMenu/releases (32 & 64 bit versions of both F4MiniMenu and F4TCIE)

## XML or INI - There are two versions:

1. F4MiniMenu.ahk (and F4TCIE.ahk) use(s) XML to store its settings (F4MiniMenu.xml)
2. To store settings in the INI format (F4MiniMenu.ini) simply rename the (compiled) script(s) so it ends with an i (letter i)
so rename or copy F4MiniMenu.ahk to F4MiniMenui.ahk (and F4TCIE.ahk to F4TCIEi.ahk).

## Closing F4MiniMenu

Use tray menu, exit.

Automatically close F4MiniMenu using the following options (available via Settings):

1. Close F4MM when all copies of TC close: this waits until all running copies of Total Commander are closed, then exit F4MiniMenu.
2. Close F4MM when TC closes started by F4MM: If (a new) Total Commander was started via F4MiniMenu, wait until that specific Total Commander instance closes, then exit F4MiniMenu.

# Passive

**Important** Do not use passive mode when F4MiniMenu is already running.

First parameter must be the file list which contains the selected files in Total Commander or Double Commander (refer to file manager documentation for further information).

Optional parameters are /P1, /P2, /M1, and /M2

Examples:

```
Command:    F4MiniMenu.ahk
Parameters: %L

Command:    F4MiniMenui.ahk
Parameters: %L /P1 /M1

Command:    F4MiniMenu.exe
Parameters: %L /P2 /M2
```

|Parameter|Meaning|
|---------|-------|
|%L       | List file in the TEMP directory with the names of the selected files to be processed by F4MiniMenu (by file manager) |
|/P1      | Menu position at Mouse cursor (useful to have it show at button bar location) |
|/P2      | Menu position Centered in window        |
|/M1      | Full menu                               |
|/M2      | Filtered menu                           |
|/ED      | Open Editors, ignore all other options  |
|/SET     | Open Settings, ignore all other options |

## Other programs

### File managers

The foreground and background menu should work with Explorer, Double Commander, XYPlorer, and Everything.  

Not supported:

* Starting and Closing of these file managers and/or F4MiniMenu
* DocumentTemplates
* Positioning of the menu - defaults to "Centered in window" 

Each file manager has to be (de)activated in the settings.

To enable:

* for Explorer and Everything: tick the checkbox (on)
* for Double Commander and XYPlorer set the hotkey (Double Commander default: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>c</kbd>, XYPlorer default: <kbd>Ctrl</kbd>+<kbd>p</kbd>)
* save the settings (OK) - F4MiniMenu should reload automatically and now work with the activated file managers.

To disable:

* for Explorer and Everything: tick the checkbox (off)
* for Double Commander and XYPlorer delete the hotkey(s) (press DEL)
* save the settings (OK)

As support for these other file managers is not thoroughly tested, unexpected behaviour may occur.

## Screenshots

__Foreground menu__

![Foreground menu](https://raw.github.com/hi5/F4MiniMenu/master/img/f4-foreground-menu.png)

__Confirm maximum__

![Confirm maximum](https://raw.github.com/hi5/F4MiniMenu/master/img/f4-confirm-maximum.png)

__General program settings__

![General program settings](https://raw.github.com/hi5/F4MiniMenu/master/img/f4-general-settings.png)

__Configure editors__

![General program settings](https://raw.github.com/hi5/F4MiniMenu/master/img/f4-configure-editors.png)

__Editor configuration__

![Editor configuration](https://raw.github.com/hi5/F4MiniMenu/master/img/f4-editor-setttings.png)

## TODO - Known issues

1. TOFIX: If the order of the editors is changed first and then a new one is added, the order is set back to the initial order.  

2. INFO: Two options for delay:  
   2.1 Drag & Drop delay gives program to start up before trying to drop the files - you may need to apply trail and error.  
   2.2 Open delay, pauses X ms to open first file.  

## Credits

### Used AHK Functions & Libraries

* [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) by [Pulover](https://github.com/Pulover/) - as of v0.6
* [XA Save / Load Arrays to/from XML Functions](https://github.com/hi5/XA)
* [DropFilesA - SKAN](http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810) including Unicode version [nimda](http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/#entry502676)
* [OSDTIP_Pop() - SKAN](https://www.autohotkey.com/boards/viewtopic.php?t=76881#p333577)
* [TC_SendData() - dindog and others](https://www.ghisler.ch/board/viewtopic.php?p=363391#p363391) - using WM_CopyData

## Changelog

* See [changelog.md](changelog.md)

### Notes

[1] Based on original idea from F4Menu by Shao Shanny - Backup links for the program can be found on the [Total Commander forum](http://ghisler.ch/board/viewtopic.php?t=17003)

