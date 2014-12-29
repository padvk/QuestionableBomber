@echo off
haxe -cp source -main Server -neko export/server.n
neko export/server
pause