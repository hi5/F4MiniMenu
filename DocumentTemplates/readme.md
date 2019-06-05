# Document Templates for F4TCIE.ahk

Note that this is an additional functionality, if you don't place any template.* files
in this folder F4TCIE will not use it.

## Introduction

By default you can use the keyboard shortcut <kbd>Shift</kbd>+<kbd>F4</kbd> or the
*cm_EditNewFile* command to create a new text file and open this in your defined text
editor. 

By setting F4TCIE.ahk as editor:

    TC, Configuration, Edit/View, Editor:
    drive:\path-to\F4TCIE.ahk "%1"

you can extend this functionality to the programs you defined in F4MiniMenu.

Unlike text editors, many program simply don't accept or understand the new empty
file Total Commander creates. They may not start correctly or generate an error message.
Here is where F4TCIE comes in. It checks if there is a "template.ext" file for the new 
file you just created, if so it copies that template to your current active panel and
start your preferred program which you defined in F4MiniMenu.

So instead of opening your text editor when you create a new "MyImageFile.PNG" it
can start your preferred Graphics program for PNG files.

If it can't find a template, it will simply launch your default editor.

When you add new templates to this folder you need to Update (scan) the 
"Currently Available Document Templates" in the Settings window, or via 
"Scan Document Templates" in the Tray or Foreground menu OR restart F4MiniMenu.

You can find two examples in DocumentTemplatesExamples.zip to illustrate how it
works (RTF, PNG) - you can of course replace these with your own Template files.

## Limitation(s)

In versions prior to Total Commander 9.10:

* It won't work in/with ZIP files (but will copy file to Active panel)
* Shift+F4 doesn't work in FTP panels (default TC behaviour)
