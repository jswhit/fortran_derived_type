import ftype
import numpy as np
iarr = np.linspace(1,5,5)
fdt = ftype.SomeDerivedType(i=-1,name='foo',iarr=iarr)
print fdt.i
print fdt.name
print fdt.iarr
fdt.i = 6
fdt.iarr = np.ones(5)
fdt.name = 'goober'
print fdt.i
print fdt.name
print fdt.iarr
# should get:
# -1
# foo
# [1 2 3 4 5]
# 6
# goober
# [1 1 1 1 1]
