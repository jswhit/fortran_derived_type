Example python interface to fortran derived type using cython.

`ftype.f90`: fortran module containing derived type definition, fortran getters/setters.

`ftype.pyx`: cython interface to ftype.f90 using iso_c_binding. Includes cython object that mimics fortran derived type

`test.py`:  test python program

0) edit setup.py to change fortran compiler, libs as necessary (default is to use gfortran).
1) run 'python setup.py build_ext --inplace'.
   on my mac, I had to set the env var LDSHARED='gfortran -bundle -undefined dynamic_lookup'
2) run test.py.

Warning: The approach used here uses the fortran iso_c_binding routine c_loc to get a raw address to pass to python. 
When it comes back to fortran it is converted to a fortran pointer using c_f_pointer.  If all the internal metadata 
associated with the fortran derived type is not stored contiguously in memory, the resulting fortran pointer may not 
contain all the information it needs to deallocate the structure components. This will result in memory leakage.  It works 
with most fortran compilers (gfortran and intel fortran included) but may break in the future since nothing in
the fortran standard guarantees it.
