Example python interface to fortran derived type using cython.

ftype.f90: fortran module
ftype.pyx: cython interface to fortan using iso_c_binding. Includes cython object that mimics fortran derived type
test.py:  test program

0) edit setup.py to change fortran compiler, libs as necessary (default is to use gfortran)
1) run 'python setup.py build_ext --inplace'
2) run test.py

Uses approach outlined in [Pletzer et al (2008)](https://www.computer.org/cms/ComputingNow/homepage/0808/ExposingFortranDerivedTypestoCandOtherLanguages.pdf) (DOI: 10.1109/MCSE.2008.94).
