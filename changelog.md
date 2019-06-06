## Changelog

* 20190606 - v0.96.1 - Fix: adding close F4MiniMenu setting to INI version (iob.ahk) https://www.ghisler.ch/board/viewtopic.php?p=355998#p355998  
* 20190527 - v0.96  
                   a) Added options to "Total Commander" startup settings on request https://www.ghisler.ch/board/viewtopic.php?p=355595#p355595 (always start, close F4MiniMenu)  
                   b) dpi + fix to avoid Gui error when calling New editor from menu while Browse Gui was active.  
                   c) tray menu: icons, left click opens tray menu, added "Open" to check keyhistory etc  
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
                  b) Introduced [Filelist](#filelist) method; 
				  c) Removed "Open Mode".
* 20121117 - v0.4 Configuration GUIs, tray menu. First editor now considered default editor.
* 20121111 - v0.3 Added menu for "foreground" feature - open all selected files with specific editor (its behaviour may change in future).
* 20121108 - v0.2 Added 0 (zero) entry in XML as default editor.
* 20121101 - v0.1 Initial very basic version.
