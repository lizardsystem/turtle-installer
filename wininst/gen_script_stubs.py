import os
from optparse import OptionParser

def main():
    parser = OptionParser()
    parser.add_option('--publisher-name', help='mostly likely "Nelen & Schuurmans"', action='store', dest='publisher_name', default='Nelen & Schuurmans')
    parser.add_option('--app-name', help='for locating the install dir in the Windows Registry, like "Turtle Urban"', action='store', dest='app_name', default='')
    parser.add_option('--module-name', help='like "turtle_urban"', action='store', dest='module_name', default='')
    parser.add_option('--dir', help='path to turtle(urban/rural) module containing the actual scripts', action='store', dest='dir', default='')
    parser.add_option('--dstdir', help='path where the stubs are written to', action='store', dest='dstdir', default='./stubs')
    (options, args) = parser.parse_args()

    with open('script_stub_template.py') as f:
        script_stub_template = f.read()

    for fn in os.listdir(options.dir):
        bn, ext = os.path.splitext(fn)
        if ext == '.py' and not bn.endswith('-script') and not bn == '__init__':
            # gen stub for this file
            script_stub = str(script_stub_template)
            script_stub = script_stub.replace('REPLACE_WITH_PUBLISHER_NAME', options.publisher_name)
            script_stub = script_stub.replace('REPLACE_WITH_APP_NAME', options.app_name)
            script_stub = script_stub.replace('REPLACE_WITH_MODULE_NAME', options.module_name)
            script_stub = script_stub.replace('REPLACE_WITH_SCRIPT_NAME', bn)
            dst_path = os.path.join(options.dstdir, '%s-script.py' % (bn))
            with open(dst_path, 'w') as f:
                f.write(script_stub)
            print 'Written', dst_path

if __name__ == '__main__':
    main()
