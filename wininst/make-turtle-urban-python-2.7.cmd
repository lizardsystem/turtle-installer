del stubs\*-script.py
rmdir stubs
mkdir stubs

"C:\Python27\python.exe" gen_script_stubs.py --publisher-name="Nelen & Schuurmans" --app-name="Turtle Urban" --module-name="turtle_urban" --dir="../src/turtle_urban" --dstdir="./stubs"

"C:\Program Files\NSIS\makensis.exe" /DPUBLISHERNAME="Nelen & Schuurmans" /DPYTHONVERSION="2.7" /DPYTHONBITS="32" /DAPPNAME="Turtle Urban" /DAPPNAMESAFE="turtle-urban" /DMODULENAME="turtle_urban" wininst.nsi

del stubs\*-script.py
rmdir stubs

pause
