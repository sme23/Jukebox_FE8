@echo off

@rem USAGE: "MAKE HACK_full.cmd" [quick]
@rem If first argument is "quick", then this will not update text, tables, or generate a patch
@rem "MACK HACK_quick.cmd" simply calls this but with the quick argument, for convenience

@rem defining buildfile config

set "source_rom=%~dp0FE8_clean.gba"

set "main_event=%~dp0ROM Buildfile.event"

set "target_rom=%~dp0Jukebox.gba"
set "target_ups=%~dp0Jukebox.ups"

@rem defining tools

set "ups=%~dp0Tools\ups\ups"

@rem set %~dp0 into a variable because batch is stupid and messes with it when using conditionals?

set "base_dir=%~dp0"

@rem do the actual building

echo Copying ROM

copy "%source_rom%" "%target_rom%"

echo:
echo Assembling

cd "%base_dir%Event Assembler"
ColorzCore A FE8 "-output:%target_rom%" "-input:%main_event%" --build-times --nocash-sym

java -jar %~dp0Tools\sym\SymCombo.jar "%~dp0Jukebox.sym" "%~dp0FE8_clean.sym"

  echo:
  echo Generating patch

  cd "%base_dir%"
  "%ups%" diff -b "%source_rom%" -m "%target_rom%" -o "%target_ups%"

echo:
echo Done!

pause
