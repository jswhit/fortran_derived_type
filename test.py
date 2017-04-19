import ftype
import numpy as np
iarr = np.linspace(1,5,5)
fdt = ftype.SomeDerivedType(i=-1,iarr=iarr)
print fdt.i
print fdt.iarr
fdt.i = 6
fdt.iarr = np.ones(5)
print fdt.i
print fdt.iarr
