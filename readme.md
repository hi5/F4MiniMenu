# F4MiniMenu - v0.6

A minimalistic clone of the F4Menu program for Total Commander (open selected files
in editor(s)) just offering the basic functionality. Original F4Menu program by Shao
Shanny - www.shanny.com.cn (website seems to be offline, see TC forum links below)

If you have any questions or suggestions do feel free to post them at the [F4MiniMenu TC Forum thread](http://ghisler.ch/board/viewtopic.php?t=35721).


__Introduction__

F4 is the shortcut key used in [Total Commander](http://www.ghisler.com/) - a file manager 
for Windows - for opening selected files in a pre-defined editor. In TC only one program can
be assigned to F4 making it impossible to define or select other editors for different file
types. Several tools have been made to solve this problem, these include:

* [ChoiceEditor](http://www.totalcmd.net/plugring/ChoiceEditor.html)
* [Open File shell for TC](http://www.totalcmd.net/plugring/OpenFileTC.html)
* [Total Commander Edit Redirector](http://ghisler.ch/board/viewtopic.php?t=27573)
* and of course [F4Menu](http://ghisler.ch/board/viewtopic.php?t=17003) - TC Forum thread

While the original F4Menu has quite a few options, this minimalistic "clone" only has the
basic functionality: opening multiple file types in various editors. An additional feature
is that it can open selected files using a "[Drag & Drop](#dragdrop)" method (a personal requirement)
or by preparing a [Filelist](#filelist).

*First come, first serve*

__F4MiniMenu__ will open a file in the __first__ editor it can find a match for based on the
__extension__. If it can not find a match it will open the file(s) in the default editor.
The default editor is the first editor listed in the [*Configure editors*](#screenshots) 
window. If you look in the configuration XML it will be the first editor there.
If you want to open the file(s) in another program you can use the [*Foreground* menu](#screenshots) option.
see below.

*Tip(s)*

In principle you can run F4Menu and F4MiniMenu side by side as long as you do not 
use conflicting keyboard shortcuts. If you use same hotkey setup, F4MiniMenu will take precedence.
You can set the F4MiniMenu shortcuts via the tray menu, right click, Settings option.

In general: be careful opening with opening large numbers of files at once, programs can crash
and your computer could become unstable requiring a reboot.

Do not edit the F4MiniMenu.xml file while the script is running, any changes you make will be
overwritten when the script exits.

*Disclaimer*

Use at your own risk.

__Drag & Drop support__<a name="dragdrop"></a>

Many programs support Drag & Drop, but not all programs will respond well to the Drag & Drop
method used in this script, so if it does not seem to work with a particular program, try
the Normal method.

__Filelist support__<a name="filelist"></a>

Some programs allow you to open files which are listed in a (temporary) file. In Total Commander
you can use something similar in the _Button bar_ and in the _Start Menu_ where you can use the %L
parameter to create a list file with the names of the selected files and directories, one file
per line. __F4MiniMenu__ can do the same. If you use this method a temporary file named 
_$$f4mtmplist$$.m3u_ is created which is passed on to the target program. 

*Example Filelist usage:*

    Program: C:\Program Files\XnView\xnview.exe
    Parameters: -filelist
    Method: 3 - Filelist

Result: Selected files will now be opened in the XnView browser.

*Notes:*

* The reason for the .m3u extension is simple: it enables playlist support for WinAmp: Select
multiple music files and press the hotkey to play the selected files. If the temporary file
didn't have the .m3u extension WinAmp wouldn't recognize it as a playlist.
* The temporary file _$$f4mtmplist$$.m3u_ is __not__ deleted directly after use to avoid
problems with slow programs. It is deleted when __F4MiniMenu__ starts or closes.

## Setup

__Requirements__

* AutoHotkey 1.1+ (Ansi or Unicode)
* Total Commander 

__Install__

*Script*

Download the source as a ZIP from GitHub here <https://github.com/hi5/F4MiniMenu/archive/master.zip>
and unpack. To start it simply run F4MiniMenu.ahk. You can now setup F4MiniMenu using 
the tray menu options for *Settings* and *Configure editors*.

Once you have setup your shortcuts you can also access *Settings* and *Configure editors* 
via the Foreground menu options by pressing the shortcut (press <kbd>Esc</kbd>+<kbd>F4</kbd> by default).
See screenshots below.

*Executable*

If you wish you can compile the script to a standalone executable using [AHK2Exe](http://l.autohotkey.net/#Get_It)

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

1. TOFIX: If you change the order of the editors first and then add a new one, the order is set back to the initial order.
2. INFO: Delay (in milliseconds) is only applicable to Drag & Drop method.
3. TODO: Change from standalone setup (as it currently is) to #include mode, which will make it easier to #include it in a "always" running AHK script.

## Benefits

* Open source - written in AutoHotkey
* Supports [Drag & Drop](#dragdrop) (for AutoHotkey 1.1+ Ansi and Unicode)
* Supports [Filelist](#filelist) method (Similar to %L in TC) as of v0.5

## Credits

### Used AHK Functions & Libraries

* [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) - by [Pulover](https://github.com/Pulover/)
* [XA Save / Load Arrays to/from XML Functions - trueski](http://www.autohotkey.com/board/topic/85461-ahk-l-saveload-arrays/) - using a 'fixed' version as forum post is messed up
* [DropFilesA - SKAN](http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810) including Unicode version [nimda](http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/#entry502676)

### Original idea

* Based on original idea from [F4Menu - Shao Shanny](http://www.shanny.com.cn/) - Backup links for the program can be found on the [Total Commander forum](http://ghisler.ch/board/viewtopic.php?t=17003)

## Changelog

* 20130707 - v0.6 a) Class LV_Rows by Pulover replaces [LV_MoveRow()](http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview/). 
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

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/a957ceab41dd2a966b307f9e6e3cdb90 "githalytics.com")](http://githalytics.com/hi5/F4MiniMenu)

