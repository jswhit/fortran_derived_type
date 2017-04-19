module testDerivedType_Interop

use iso_c_binding, only: c_ptr, c_loc, c_double, c_int, c_char, c_bool
implicit none 

!type :: SomeDerivedType_pointer
!  type(SomeDerivedType), pointer :: ptr
!end type SomeDerivedType_pointer
type :: SomeDerivedType
  integer :: i
  integer, allocatable, dimension(:) :: iarr
end type SomeDerivedType

contains
! Given the address of a C_PTR this subroutine allocates the memory required
! for a SomeDerivedType derived data type, initializes it with the given values,
! and stores the C_LOCated address in the C_PTR.
subroutine makeDerivedType(cdt) bind (c)
  type (C_PTR) :: cdt
  type (SomeDerivedType) :: fdt
  integer i,ndim
  ndim = 5
  allocate(fdt%iarr(ndim))
  do i=1,ndim
   fdt%iarr(i)=i
  enddo
  fdt%i=ndim
  cdt = C_LOC(fdt)
end subroutine makeDerivedType

! This subroutine converts the given C_PTR value to a fortran pointer making
! it accessible again from Fortran
subroutine examineDerivedType(this) bind (c')
   type (C_PTR), value :: this
   type (SomeDerivedType), pointer :: that
   call C_F_POINTER(this, that)
   print *, "that%i", that%i
   print *, "that%iarr", that%iarr
end subroutine examineDerivedType
