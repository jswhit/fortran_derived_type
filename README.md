Example python interface to fortran derived type using cython.

`ftype.f90`: fortran module containing derived type definition, fortran getters/setters.

`ftype.pyx`: cython interface to ftype.f90 using iso_c_binding. Includes cython object that mimics fortran derived type

`test.py`:  test python program

Requires numpy and cython (and a fortran compiler).

0) Edit `setup.py` to change fortran compiler as necessary (default is to use gfortran).

1) Run `python setup.py build_ext --inplace`.

   On my mac, I had to set the env var `LDSHARED='gfortran -bundle -undefined dynamic_lookup'`.

   On linux, I used `LDSHARED='gfortran -shared'`.

   To use ifort on linux, change compiler in setup.py to ifort, set `LDSHARED to 'ifort -shared'`.

2) Run test.py.

The approach used here uses the fortran iso_c_binding routine c_loc to get a raw address to pass to C/python. 
When it comes back to fortran it is converted to a fortran pointer using c_f_pointer.
