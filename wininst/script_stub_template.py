'''
This is a (slightly templated) Python script responsible for preparing the sys.path environment
before each actual Turtle script runs.
'''

_cfg_base_dir = None # optional, autodetected if set to None
_cfg_lib_dir_name = None # optional, autodetected if set to None
_cfg_lib_dir_name_pattern = 'lib-python-%s.%s-%sbit'
_cfg_src_dir_name = 'src'
_cfg_publisher_name = r'''REPLACE_WITH_PUBLISHER_NAME'''
_cfg_app_name = r'''REPLACE_WITH_APP_NAME'''

_is_initialized = False
_cfg_reg_key = r'Software\%s\%s' % (_cfg_publisher_name, _cfg_app_name) # e.g. Software\Nelen & Schuurmans\Turtle Urban

class TurtleException(Exception):
	pass

def set_sys_path():
	global _is_initialized
	if not _is_initialized:
		import sys
		import os
		import logging
		logger = logging.getLogger(_cfg_app_name)

		base_dir = None
		if _cfg_base_dir:
			base_dir = os.path.abspath(_cfg_base_dir)
		else:
			# try reading from the Windows Registry
			try:
				import _winreg as winreg
				key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, _cfg_reg_key, 0, winreg.KEY_ALL_ACCESS)
				base_dir = winreg.QueryValueEx(key, 'Install_Dir')
				base_dir = os.path.abspath(base_dir[0])
				key.Close()
			except:
				pass
			# last resort: check relative dir
			if not base_dir or not os.path.isdir(base_dir):
				try:
					cur_dir = os.path.dirname(__file__)
				except:
					cur_dir = '.'
				base_dir = os.path.abspath(os.path.join(cur_dir, '..', '..'))

		# determine what lib dir (64 / 32 bits to use)
		if _cfg_lib_dir_name:
			lib_dir = os.path.join(base_dir, _cfg_lib_dir_name)
		else:
			import struct
			bits = 8 * struct.calcsize('P')
			version = sys.version_info[0:2]
			lib_dir_name = _cfg_lib_dir_name_pattern % (version[0], version[1], bits)
			lib_dir = os.path.join(base_dir, lib_dir_name)

		# a bit of logging, just to be sure
		logger.info('using %s as base_dir' % (base_dir))
		print 'using %s as base_dir' % (base_dir)
		logger.info('using %s as lib_dir' % (lib_dir))
		print 'using %s as lib_dir' % (lib_dir)

		# store the base_dir for later use (eg. so apps can find gdal)
		os.environ['TURTLE_BASE_DIR'] = base_dir

		# sanity check
		if not os.path.isdir(lib_dir):
			raise TurtleException('Could not read from lib_dir (%s)' % (lib_dir))

		# add any egg file/directory in the lib dir
		libs = []
		for fn in os.listdir(lib_dir):
			lib = os.path.join(lib_dir, fn)
			if os.path.isdir(lib) or lib.lower().endswith('.egg'):
				libs.append(lib)

		# sanity check
		if not libs:
			raise TurtleException('Could not find any libraries in (%s)' % (lib_dir))

		# manually add our own libs
		libs.append(os.path.join(base_dir, _cfg_src_dir_name))

		# prepend our libs to sys.path so they get loaded first
		sys.path[0:0] = libs
	_is_initialized = True

if __name__ == '__main__':
	set_sys_path()
	from REPLACE_WITH_MODULE_NAME.REPLACE_WITH_SCRIPT_NAME import main as script_main
	script_main()
