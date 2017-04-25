from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os, sys, subprocess, numpy

# build iso_c_binding fortran wrapper.
compiler = 'gfortran'
#compiler = 'ifort'
fname = 'ftype2'
fopts = '-cpp -c -O2 -fPIC'
fsource = '%s.F90' % fname
strg = '%s %s %s' % (compiler, fopts, fsource)
sys.stdout.write('executing "%s"\n' % strg)
subprocess.call(strg,shell=True)

# remove existing source file to force cython to regenerate it.
if os.path.exists('ftype2.c'): os.remove('ftype2.c') # trigger a rebuild

inc_dirs = [numpy.get_include()] # numpy include dirs
objs = ['%s.o' % fname] # fortran objects to link
ext_modules = [Extension('ftype2',                       # module name
                        ['ftype2.pyx'],                  # cython source file
                        include_dirs  = inc_dirs,
                        extra_objects = objs)]

setup(name = 'ftype2',
      cmdclass = {'build_ext': build_ext},
      ext_modules  = ext_modules)
