import numpy as np
from numpy cimport ndarray 

cdef extern int create(int *ih, int *i, int *iarr_len, int *iarr);
cdef extern int get_i(int *ih, int *i);
cdef extern int set_i(int *ih, int *i);
cdef extern int get_iarr(int *ih, int *iarr, int *n);
cdef extern int set_iarr(int *ih, int *iarr, int *n);
cdef extern int destroy(int *ih);

cdef class SomeDerivedType:
    cdef ndarray ptr
    cdef int iarr_len
    def __init__(self,int i,ndarray iarr):
        cdef ndarray ih = np.empty(12, np.intc)
        cdef int iarr_len
        iarr = iarr.astype(np.intc)
        iarr_len = len(iarr)
        create(<int *>ih.data,&i,&iarr_len,<int *>iarr.data)
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
    property iarr:
        """get and set iarr member of derived type"""
        def __get__(self):
            cdef ndarray iarr = np.empty(5,np.intc)
            get_iarr(<int *>self.ptr.data, <int *>iarr.data, &self.iarr_len)
            return iarr
        def __set__(self,ndarray value):
            value = value.astype(np.intc)
            if len(value) != self.iarr_len:
                raise ValueError('cannot change size of iarr member')
            set_iarr(<int *>self.ptr.data, <int *>value.data, &self.iarr_len)
    def __dealloc__(self):
        destroy(<int *>self.ptr.data)
