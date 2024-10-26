64tass   --map "main.map" --output-exec=start --c256-pgz "main.asm" --mw65c02 --list="app.lst" -Wno-portable -o "app.pgz"
mv app.pgz ../build

wine /mnt/d/Retro/Foenix/Emulator/FoenixIDE/FoenixIDE.exe
