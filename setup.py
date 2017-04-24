from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os, sys, subprocess, numpy

# build iso_c_binding fortran wrapper.
compiler = 'gfortran'
#compiler = 'ifort'
fname = 'ftype'
fopts = '-c -O2 -fPIC'
fsource = '%s.f90' % fname
strg = '%s %s %s' % (compiler, fopts, fsource)
sys.stdout.write('executing "%s"\n' % strg)
subprocess.call(strg,shell=True)

# remove existing source file to force cython to regenerate it.
if os.path.exists('ftype.c'): os.remove('ftype.c') # trigger a rebuild

inc_dirs = [numpy.get_include()] # numpy include dirs
objs = ['%s.o' % fname] # fortran object to link
ext_modules = [Extension('ftype',                       # module name
                        ['ftype.pyx'],                  # cython source file
                        include_dirs  = inc_dirs,
                        extra_objects = objs)]

setup(name = 'ftype',
      cmdclass = {'build_ext': build_ext},
      ext_modules  = ext_modules)
