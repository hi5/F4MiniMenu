## Changelog

* 20251126 - v1.60 a) New: Replaced `ahk_class TTOTAL_CMD` with `ahk_pid %ActiveProcessPID%`; use WinTitle `A` in `ControlGet` for "Find Files" in various commands to (hopefully) ensure the _currently_ active TC is targetted vs potentially the wrong one in case multiple copies of TC are running. (ahk_pid Not yet implemented in GetTCFields/TC_SendData (p,t,n,m))  

* 20251018 - v1.51 a) Fix: only check QuickView if TC is active + refined RegEx to grab filename from WinGetText result  

* 20250915 - v1.50 a) Fix: add new editor didn't show New Editor gui (due to misplaced GuiResize)  
                   b) New: Allow user to setup new programs via INI & new settings Gui (see Settings and Examples and f4mm-other-file-managers.md)  
                   c) New: Allow user to set Copy Delay or use Clipwait (AutoHotkey Command) for TC and other programs (see Settings (TC) Copy Delay)  

* 20250209 - v1.47 a) Allow resizing of Configure Editors GUI (browse list) using AutoXYWH()  
                   b) Some code cleanup re Enter shortcuts; add everything64.exe to Esc Winclose routine  
                   c) Trace menu steps and result of GetFiles in log  

* 20250209 - v1.46 a) Finetuning Everything_GetSelection() to check for selected rows in listview (if none get first result only)  

* 20250208 - v1.45 a) Finetuning Everything_Active() (using "A" not "Everything" in WinGet to detect active window)  
                   b) Use TXT as default extension for default editor if user doesn't set one - otherwise it would not match correctly for defined extensions https://www.ghisler.ch/board/viewtopic.php?p=468305#p468305  
                   c) log option (manual setting, don't document)

* 20250208 - v1.44 a) Add Everything64.exe to ahk_group TCF4Windows; updated Everything-functions to check for Everything.exe or Everything64.exe - added notes to help tip and docs  

* 20250111 - v1.43 a) Fix: moved INI selection routine introduced in v1.42 as it interferred with selecting a (new) editor https://www.ghisler.ch/board/viewtopic.php?p=466621#p466621  
                   b) Additional hint in "Other programs" section re Hotkey to "Copy File Name(s) with Full Path"  
                   c) Added two ;@Ahk2Exe-Set* for compiled script properties (incl. AutoHotkey version)  

* 20240130 - v1.42 a) New: Enable/Disable using F4MM in Lister, Find Files and QuickView (Use elsewhere in TC)  
                      Fix: Resort to reading multiple locations in the registry + settings option to locate `wincmd.ini` to be able to read `F4Edit` setting  
                      and additional setting `INI Path`  
                      Hopefully this is now correctly handled in all cases (F4MM starts before TC, TC starts before F4MM)  

* 20240127 - v1.41 a) Fix: Check to see if TC is running in order to be able to read F4Edit= correctly (using environment variable %Commander_ini_Path%)

* 20240123 - v1.4  a) New: enable/disable F4MM for Lister and Find Files (search results) windows (see settings). If Lister setting is active and F4Edit>1 in wincmd.ini: close Lister   
                      In TC 11.03 the press "F4 to open currently viewed file in Lister" was added.  
                      (See F4Edit= options in TC help file on how to handle F4 in lister via wincmd.ini. F4TCIE _could_ be used.)

* 20231121 - v1.3  
                   a) Fix: `%N` and `%M` now processed correctly  
                   b) Added "#Requires AutoHotkey v1.1.31+" directive for users with v1 & v2 installed, added note in documention about using v1 AutoHotkey.exe in setup  

* 20231030 - v1.2  
                   a) Updated class name for Find Results control class (TMyListBox2, 32bit) for TC11  
                   b) Added: Help MsgBox-es in Settings Gui now Task Modal (32+8192=8224)  
                   c) Added: Settings label to Gui to better handle closing the Gui https://github.com/hi5/F4MiniMenu/issues/24#issuecomment-1573127847  
                   d) Added: GuiEscape for Add/Modify editors dialog to allow <kbd>Esc</kbd> to exit (next to <kbd>Alt</kbd>+<kbd>c</kbd>) https://github.com/hi5/F4MiniMenu/issues/24#issuecomment-1573127847  
                   e) Fix: no longer require full path for programs in PATH e.g. `write.exe` v `c:\windows\write.exe`, bug introduced in v1.1 due to GetFullPathName() https://github.com/hi5/F4MiniMenu/issues/24#issuecomment-1573127847  
                   f) Fix: use SplitPath for `%p` parameter when not using TC https://github.com/hi5/F4MiniMenu/issues/24#issuecomment-1573127847  
                   g) Change: `%p` and `%t` now use wm_copydata  
                   h) New: `%N` and `%M` to place filename under the cursor into the command line (source and target directory) using wm_copydata  
                   i) New: Added support for `%$DATE%`, `%$DATE:YMD%` + offset calculations via `%$DATE:YMD|value|timeunits%`   
                   j) Fix: F4TCIE quote file path for `%file%` to resolve paths\files with spaces  
                   k) Fix: F4TCIE `Run notepad` changed to `Run %A_WinDir%\notepad.exe` to avoid any potential path issues. Added ExitApp after Run command  

* 20230402 - v1.1  
                   a) Fix: TRY to catch all empty hotkeys to avoid errors at startup  
                   b) Change: Double click on an "editor" in Configure Editors listview now opens modify window  
                   c) Change: Settings - replace Radio controls for Esc/Win with DropDownLists (not thoroughly tested)  
                   d) Fix: WinMin/Hide/Maximize and Sleep function should work better (or again)  
                   e) Fix: additional check to prevent Modify Gui throwing "The same variable cannot be used for more than one control" error; modify window now always on top of editors window (); sysmenu removed  
                   f) New: TRY, catch -> revert to standard editor if defined editor can not be found, show notification using OSDTIP_Pop() for both F4MiniMenu and F4TCIE  
                   g) New: support `%windir%`, `%A_ScriptDir%` and other path variables (see list "Path variables" in readme.md) https://github.com/hi5/F4MiniMenu/issues/25  
                   h) New: Filtered foreground Menu - setting to launch program directly if only one program is found https://github.com/hi5/F4MiniMenu/issues/26  
                   i) New: Global setting MaxWinWaitSec to prevent stalling F4MM  
                   j) Fix: INI when reading a global setting as "Error" set as empty (lib\iob.ahk)  
* 20220528 - v1.0  
                   a) Fix: "Start Total Commander if not running" feature #23 https://github.com/hi5/F4MiniMenu/issues/23  
                   b) Fix: Use another method to calculate Y for Position = 2 in GetPos (as this is now default for c))  
                   c) Rudimentary support for Windows Explorer, Double Commander, XYPlorer, and Everything(e) (default foreground menu to center in Window)  
                   d) Passive mode using parameters to use F4MiniMenu via Button bar, Start Menu, or F4 Editor (start F4MM, processes files, close F4MM, so not a persistent script)  
                   e) Fix: Path from Lister Windows Title failed if file name started/ended with [ or ] characters e.g. "[2000] My Document.txt"  
                   f) remove stray file inc\inc.zip from repository
* 20190622 - v0.97  
                   a) New option for filtered foreground menu: only show programs that match selected extensions. See Settings for setup. https://github.com/hi5/F4MiniMenu/issues/21  
                   b) Fix: correctly use %commander_path% in Editor listview IL_Add routine (if v.Icon isn't set)  
                   c) Fix: Editor - Set as Default should now work correctly  
                   d) Fix: Editor - cancel should now work more reliably by using .clone()  
                   e) Only save settings when actually changing them e.g. no longer at each start/exit of the script 
                   f) New: Option(s) to Close F4MiniMenu when TC closes  
* 20190607 - v0.96.2 - Fix: adding Try to all Menu, tray, icons to avoid startup error for compiled scripts and autohotkey.exe is not installed. https://www.ghisler.ch/board/viewtopic.php?p=356022#p356022  
* 20190606 - v0.96.1 - Fix: adding close F4MiniMenu setting to INI version (iob.ahk) https://www.ghisler.ch/board/viewtopic.php?p=355998#p355998  
* 20190527 - v0.96  
                   a) Added options to "Total Commander" startup settings on request https://www.ghisler.ch/board/viewtopic.php?p=355595#p355595 (always start, close F4MiniMenu)  
                   b) dpi + fix to avoid Gui error when calling New editor from menu while Browse Gui was active.  
                   c) tray menu: icons, left click opens tray menu, added "Open" to check key history etc.  
* 20170710 - v0.95 Added F4TCIE and introduced DocumentTemplates. #13 https://github.com/hi5/F4MiniMenu/issues/13  
             New icon :-)
* 20170607 - v0.94c Minor fix to empty file and quoted startdir variables in GetInput(). Fix for %ComSpec% in Editor names.
* 20170106 - v0.94b Minor fix to ensure Commander_Path is not empty
* 20170105 - v0.94a Minor fix for launching via Drag&Drop (no longer worked correctly/reliably in v0.94)
* 20161231 - v0.94  
                   a) Added 4th method: cmdline -> program.exe file1 file2 file3 #14 https://github.com/hi5/F4MiniMenu/issues/14  
                   b) Accept TC Fields %P %T %O %E and ? in Parameters and Startdir. Introduced %f41. #15 https://github.com/hi5/F4MiniMenu/issues/15  
                   c) Build foreground menu only once vs delete/recreate (updating menu only after editing editors). Refactored menu code.  
                   d) Now use %TEMP%\$$f4mtmplist$$.m3u instead of ScriptFolder - [requested by Ovg](http://ghisler.ch/board/viewtopic.php?p=319773&sid=2e2472aec32f6906e699d095b4998ea3#319773)  
                   e) Fixed hotkeys - #12 https://github.com/hi5/F4MiniMenu/issues/12  
                   f) You can now specify an Icon and Menu name when you configure an Editor. #17 https://github.com/hi5/F4MiniMenu/issues/17  
                   g) %Commander_Path% now accepted in Editor and Icon paths.  
                   h) Removed F4MiniMenui.ahk - to use INI simply rename/copy the (compiled) script to end with "i".
* 20161023 - v0.93 OpenFile: add WinWait before WinActivate, merge request @nameanyone #10 https://github.com/hi5/F4MiniMenu/issues/10
* 20160618 - v0.92 Fix error checking on startup in case script is compiled - HT Ovg
* 20160618 - v0.91 Fix for INI Editors include (save to INI not XML when making backup). Refinement of regular expression for wildcards - HT [Ovg](http://ghisler.ch/board/viewtopic.php?p=310538#310538)
* 20160618 - v0.9 Added support for wildcards (? and *) in extensions #6 https://github.com/hi5/F4MiniMenu/issues/6. Added open delay (delay in ms between opening files)
* 20160617 - v0.83 Adding specific #include path for lib files to avoid possible error for portable users when compiling. HT [Ovg](ghisler.ch/board/viewtopic.php?p=310187#310187)
* 20151104 - v0.82 Further refinement of confusing error message at very first startup (missing configuration XML) - now also checks if BAK is present.
* 20151103 - v0.81 Fixed confusing error message at very first startup (missing configuration XML)
* 20141107 - v0.8 Added F4 functions to Lister (grabbing the filename from the Window title) and the search results in the Find Files dialog. Comment: if you use the Esc & Key as Foreground menu option it will fail as pressing Esc will close Lister and the Find Files dialog. The Winkey & Key combination does work - the menu will appear at the top of the window.
* 20140806 - v0.7 replaced Loop, object.MaxIndex() with proper for-loop to parse each key-value pair in the MatchList object; Added &letter to foreground menu options (program names)
* 20130731 - v0.61 added rudimentary backup & safety feature in case of a faulty/missing settings XML
* 20130701 - v0.6 a) [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) by [Pulover](https://github.com/Pulover/) replaces [LV_MoveRow()](http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview/). 
                     This resolves the problem with the listview not updating icons while moving the editors in the settings Gui;
                  b) Added Unicode support for drag & drop method so F4MiniMenu should now be compatible with both Ansi and Unicode versions of AutoHotkey.
* 20130607 - v0.51 Check if selected file(s) are archived, if so bypass F4MiniMenu all together and use internal TC Edit command to open file, this will only use the file under the cursor, not all selected files.
* 20130330 - v0.5 a) Process entire file list first and open per program; 
                  b) Introduced [Filelist](readme.md#filelist) method; 
                  c) Removed "Open Mode".
* 20121117 - v0.4 Configuration GUIs, tray menu. First editor now considered default editor.
* 20121111 - v0.3 Added menu for "foreground" feature - open all selected files with specific editor (its behaviour may change in future).
* 20121108 - v0.2 Added 0 (zero) entry in XML as default editor.
* 20121101 - v0.1 Initial very basic version.

