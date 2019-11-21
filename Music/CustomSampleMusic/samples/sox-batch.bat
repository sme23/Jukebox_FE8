@echo off

@rem Example of how to do batch processing with SoX on MS-Windows.
@rem
@rem Place this file in the same folder as sox.exe (& rename it as appropriate).
@rem You can then drag and drop a selection of files onto the batch file (or
@rem onto a `short-cut' to it).
@rem
@rem In this example, the converted files end up in a folder called `converted',
@rem but this, of course, can be changed, as can the parameters to the sox
@rem command.

@cd %~dp0
@mkdir converted
@cd convert
@dir *.wav /b > wav.txt
@cd "%~dp0sox-14.4.2"
@for /f "tokens=*" %%m in (%~dp0/convert/wav.txt) do sox "%~dp0/convert/%%m" -r 22050 -c 1 "%~dp0/converted/%%m.sb"
@cd %~dp0
@cd convert
@del "wav.txt"
pause
