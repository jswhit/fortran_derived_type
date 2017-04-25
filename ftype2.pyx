import numpy as np
from numpy cimport ndarray 

# fortran routines exposed by iso_c_binding (in ftype2.f90).
cdef extern int create(int *handle, int *i, int *iarr_len, char *name, int *iarr);
cdef extern int get_i(int *handle, int *i);
cdef extern int set_i(int *handle, int *i);
cdef extern int get_iarr(int *handle, int *iarr, int *n);
cdef extern int set_iarr(int *handle, int *iarr, int *n);
cdef extern int get_name(int *handle, char *name);
cdef extern int set_name(int *handle, char *name);
cdef extern int destroy(int *handle);

# python object corresponding to fortran derived type.
cdef class SomeDerivedType:
    cdef int ptr
    cdef public int iarr_len
    def __init__(self,int i,char *name, ndarray iarr):
        cdef int iarr_len
        iarr = iarr.astype(np.intc)
        self.iarr_len = len(iarr)
        create(&self.ptr,&i,&self.iarr_len,name,<int *>iarr.data)
    property i:
        """get and set i member of derived type"""
        def __get__(self):
            cdef int i
            get_i(&self.ptr, &i)
            return i
        def __set__(self,int value):
            set_i(&self.ptr, &value)
    property name:
        """get and set name member of derived type"""
        def __get__(self):
            cdef char name[20+1] # null char will be added
            get_name(&self.ptr, name)
            return name
        def __set__(self,char *value):
            set_name(&self.ptr, value)
    property iarr:
        """get and set iarr member of derived type"""
        def __get__(self):
            cdef ndarray iarr = np.empty(self.iarr_len,np.intc)
            get_iarr(&self.ptr, <int *>iarr.data, &self.iarr_len)
            return iarr
        def __set__(self,ndarray value):
            value = value.astype(np.intc)
            if value.size != self.iarr_len:
                raise ValueError('cannot change the size of iarr member')
            set_iarr(&self.ptr, <int *>value.data, &self.iarr_len)
    def __dealloc__(self):
        """make sure memory is deallocated when object goes out of scope"""
        destroy(&self.ptr)
