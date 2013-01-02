del stubs\*-script.py
rmdir stubs
mkdir stubs

"C:\Python27\python.exe" gen_script_stubs.py --publisher-name="Nelen & Schuurmans" --app-name="Turtle Rural" --module-name="turtle_rural" --dir="../src/turtle_rural" --dstdir="./stubs"

"C:\Program Files\NSIS\makensis.exe" /DPUBLISHERNAME="Nelen & Schuurmans" /DPYTHONVERSION="2.5" /DPYTHONBITS="32" /DAPPNAME="Turtle Rural" /DAPPNAMESAFE="turtle-rural" /DMODULENAME="turtle_rural" wininst.nsi

del stubs\*-script.py
rmdir stubs

pause
