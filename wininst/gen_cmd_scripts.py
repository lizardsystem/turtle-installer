tpl = \
r'''del stubs\*-script.py
rmdir stubs
mkdir stubs

"C:\Python27\python.exe" gen_script_stubs.py --publisher-name="Nelen & Schuurmans" --app-name="Turtle %(edition_uc)s" --module-name="turtle_%(edition)s" --dir="../src/turtle_%(edition)s" --dstdir="./stubs"

"C:\Program Files\NSIS\makensis.exe" /DPUBLISHERNAME="Nelen & Schuurmans" /DPYTHONVERSION="%(ver)s" /DPYTHONBITS="32" /DAPPNAME="Turtle %(edition_uc)s" /DAPPNAMESAFE="turtle-%(edition)s" /DMODULENAME="turtle_%(edition)s" wininst.nsi

del stubs\*-script.py
rmdir stubs

pause
'''

for edition in ['urban', 'rural']:
	edition_uc = edition.title()
	for ver in ['2.5', '2.6', '2.7']:
		fn = 'make-turtle-%s-python-%s.cmd' % (edition, ver)
		data = tpl % locals()
		with open(fn, 'w') as f:
			f.write(data)
