# F4MiniMenu - v0.96

A minimalistic clone of the F4Menu program for Total Commander (open selected files
in editor(s)) just offering the basic functionality. Original F4Menu program by Shao
Shanny - www [.] shanny [.] com [.] cn (website seems to be offline, see TC forum links below)

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
basic functionality: opening multiple file types in various editors. There are various
methods to open selected files: regular, "[Drag & Drop](#dragdrop)", [Filelist](#filelist)
or by making use of a [cmdline](#cmdline) option.

As of v0.95 you can make use a helper script to use F4MiniMenu settings as the "internal
editor" defined in Total Commander and use so called **DocumentTemplates** for creating
new files. See [F4TCIE](#f4tcie).

*First come, first serve*

__F4MiniMenu__ will open a file in the __first__ editor it can find a match for based on the
__extension__. If it can not find a match it will open the file(s) in the default editor.
The default editor is the first editor listed in the [*Configure editors*](#screenshots) 
window. If you look in the configuration XML it will be the first editor there.
If you want to open the file(s) in another program you can use the [*Foreground* menu](#screenshots) option.
See screenshot below.

You can add or modify editors via the tray menu or by bringing up the Foreground menu.
You can use %Commander_Path% in the paths to the editors and icons.

*Tip(s)*

In principle you can run F4Menu and F4MiniMenu side by side as long as you do not 
use conflicting keyboard shortcuts. If you use same hotkey setup, F4MiniMenu will take precedence.
You can set the F4MiniMenu shortcuts via the tray menu, right click, Settings option.

In general: be careful opening with opening large numbers of files at once, programs can crash
and your computer could become unstable requiring a reboot.

Do not edit the "F4MiniMenu.xml" or "F4MiniMenu.ini" settings file while the script is running, any 
changes you make will be overwritten when the script exits. As of v0.61 a backup is made at startup
and saved as "F4MiniMenu.xml.bak" or "F4MiniMenu.ini.bak"

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

__cmdline support__<a name="cmdline"></a>

In case you need to pass the selected files to the program on the command line (program.exe file1 file2 etc)
you can use the cmdline method.

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

**XML or INI** - There are two versions:

1. F4MiniMenu.ahk uses XML to store settings (F4MiniMenu.xml)
2. <strike>F4MiniMenui.ahk uses INI to store settings (F4MiniMenu.ini)</strike> If you want to store your 
settings in INI format (F4MiniMenu.ini) simply rename the (compiled) script so it ends with an i (letter i)
so rename or copy F4MiniMenu.ahk to F4MiniMenui.ahk and start. That would work, but F4MMi.exe as well.

*Executable*

If you wish you can compile the script to a standalone executable using [AHK2Exe](https://autohotkey.com/download/).
[Documentation](https://autohotkey.com/docs/Scripts.htm#ahk2exe)

## Helper script: F4TCIE.ahk <a name='f4tcie'></a>

If you want to make use of your preferred editor(s) when the active panel
is in an Archived file (ZIP panel) or FTP connection you can make use of
a helper script called F4TCIE. If you are using the INI format to store
your settings be sure to rename the script to end with an "i" (see 'XML or INI' above)

**Setup F4TCIE**

When F4MiniMenu sees the files you have selected are in an archive or in an
FTP panel, it uses the default Total Commander Edit command. It will only
use the first file if you had selected multiple files in the archive or FTP.

So we need to configure Total Commander to use F4TCIE.ahk like so:

    TC, Configuration, Edit/View, Editor:
    drive:\path-to\F4TCIE.ahk "%1"

If for some reason it can't open the configuration file it will try to start the editor for the
file type associated in Windows (so for txt -> notepad, for bmp,jpg -> MS Paint etc) - if there
is no editor for the file type it would start notepad.exe as a final resort.

Reference: see also [#13](https://github.com/hi5/F4MiniMenu/issues/13)

## DocumentTemplates

F4TCIE can also make use of DocumentTemplates when creating New files in 
Total Commander using the <kbd>shift</kbd>+<kbd>f4</kbd> shortcut.

More information can be found in the [DocumentTemplates README](DocumentTemplates/readme.md)

# Parameters/Options

|Field|Meaning|
|-----|-------|
|%P|causes the source path to be inserted into the command line, including a backslash \ at the end.|
|%T|inserts the current target path.|
|%O|places the current filename without extension into the command line.|
|%E|places the current extension (without leading period) into the command line.|
|? |as the first parameter causes a Dialog box to be displayed before starting the program, containing the following parameters. You can change the parameters before starting the program. You can even prevent the program's execution.|
|-----|-------|
|%f41|placeholder to alter position of filenames on the command line. (see example below)|

Note: More _%f4_ fields may be added in the future.

*Example: %f41*

F4MiniMenu starts programs as follows:

_ProgramName.exe Parameters File(s) Startdir_

But for some programs the _parameter(s)_ - the additional command(s) you want to pass
on to the program - have the come _AFTER_ the _File(s)_ so by using %f41 as a placeholder
in the parameters field you can tell F4MiniMenu where to place the files on the 
"command line"

    Program: pdftk.exe
    Parameters: %f41 burst

So the program now starts as _pdftk.exe file.pdf burst_ (instead of _pdftk.exe burst file.pdf_)

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
<strike>2. INFO: Delay (in milliseconds) is only applicable to Drag & Drop method.</strike>
2. INFO: Two options for delay (as of v0.9):  
   2.1 Drag & Drop delay gives program to start up before trying to drop the files - you may need to apply trail and error.  
   2.2 Open delay, pauses X ms to open next file.  
3. TODO: Change from standalone setup (as it currently is) to #include mode, which will make it easier to #include it in a "always" running AHK script.

## Benefits

* Open source - written in AutoHotkey
* Supports [Drag & Drop](#dragdrop) (for AutoHotkey 1.1+ Ansi and Unicode)
* Supports [Filelist](#filelist) method (Similar to %L in TC) as of v0.5

## Credits

### Used AHK Functions & Libraries

* [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) by [Pulover](https://github.com/Pulover/) - as of v0.6
* [XA Save / Load Arrays to/from XML Functions](https://github.com/hi5/XA)
* [DropFilesA - SKAN](http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810) including Unicode version [nimda](http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/#entry502676)

### Original idea

* Based on original idea from F4Menu by Shao Shanny - Backup links for the program can be found on the [Total Commander forum](http://ghisler.ch/board/viewtopic.php?t=17003)

## Changelog

* See [changelog.md](changelog.md)
