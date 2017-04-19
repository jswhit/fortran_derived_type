import numpy as np
from numpy cimport ndarray 

cdef extern int create(int *ih, int *i, int *iarr_len, char *name, int *iarr);
cdef extern int get_i(int *ih, int *i);
cdef extern int set_i(int *ih, int *i);
cdef extern int get_iarr(int *ih, int *iarr, int *n);
cdef extern int set_iarr(int *ih, int *iarr, int *n);
cdef extern int get_name(int *ih, char *name);
cdef extern int set_name(int *ih, char *name);
cdef extern int destroy(int *ih);

cdef class SomeDerivedType:
    cdef ndarray ptr
    cdef int iarr_len
    def __init__(self,int i,char *name, ndarray iarr):
        cdef ndarray ih = np.empty(12, np.intc)
        cdef int iarr_len
        iarr = iarr.astype(np.intc)
        iarr_len = len(iarr)
        create(<int *>ih.data,&i,&iarr_len,name,<int *>iarr.data)
        self.ptr = ih
        self.iarr_len = iarr_len
    property i:
        """get and set i member of derived type"""
        def __get__(self):
            cdef int i
            get_i(<int *>self.ptr.data, &i)
            return i
        def __set__(self,int value):
            set_i(<int *>self.ptr.data, &value)
    property name:
        """get and set name member of derived type"""
        def __get__(self):
            cdef char name[20+1] # null char will be added
            get_name(<int *>self.ptr.data, name)
            return name
        def __set__(self,char *value):
            set_name(<int *>self.ptr.data, value)
    property iarr:
        """get and set iarr member of derived type"""
        def __get__(self):
            cdef ndarray iarr = np.empty(5,np.intc)
            get_iarr(<int *>self.ptr.data, <int *>iarr.data, &self.iarr_len)
            return iarr
        def __set__(self,ndarray value):
            value = value.astype(np.intc)
            set_iarr(<int *>self.ptr.data, <int *>value.data, &self.iarr_len)
    def __dealloc__(self):
        destroy(<int *>self.ptr.data)
