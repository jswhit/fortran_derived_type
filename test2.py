def test():
    """
    >>> import ftype2
    >>> import numpy as np
    >>> iarr = np.linspace(1,5,5)
    >>> fdt = ftype2.SomeDerivedType(i=-1,name='foo',iarr=iarr)
    >>> fdt.i
    -1
    >>> fdt.name
    'foo'
    >>> fdt.iarr
    array([1, 2, 3, 4, 5], dtype=int32)
    >>> fdt.i = 6
    >>> fdt.iarr = np.ones(5)
    >>> fdt.name = 'goober'
    >>> fdt.i
    6
    >>> fdt.name
    'goober'
    >>> fdt.iarr
    array([1, 1, 1, 1, 1], dtype=int32)
    >>> fdt.iarr = np.zeros(6)
    Traceback (most recent call last):
        ...
    ValueError: cannot change the size of iarr member
    """

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
