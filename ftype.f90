module ftype

use iso_c_binding, only: c_int
implicit none 

! fortran derived type
type :: SomeDerivedType
  integer :: i
  integer, allocatable, dimension(:) :: iarr
end type SomeDerivedType

! container that has pointer to derived type
type :: SomeDerivedType_pointer
  type(SomeDerivedType), pointer :: ptr
end type SomeDerivedType_pointer

contains

! create pointer to derived type, populate derived type.
subroutine create(ih,i,iarr_len,iarr) bind (c)
  integer(c_int), intent(inout), dimension(12) :: ih
  integer(c_int), intent(in) :: i,iarr_len
  integer(c_int), intent(in), dimension(iarr_len) :: iarr
  type (SomeDerivedType_pointer) :: fdtp
  allocate(fdtp%ptr)
  allocate(fdtp%ptr%iarr(iarr_len))
  fdtp%ptr%i = i
  fdtp%ptr%iarr = iarr
  ih = transfer(fdtp, ih)
end subroutine create

! set derived type member i
subroutine set_i(ih, i) bind(c)
   integer(c_int), intent(inout), dimension(12) :: ih
   integer(c_int), intent(in) :: i
   type (SomeDerivedType_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   fdtp % ptr % i = i
   ih = transfer(fdtp, ih)
end subroutine set_i

! get derived type member i
subroutine get_i(ih,i) bind (c)
   integer(c_int), intent(in), dimension(12) :: ih
   integer(c_int), intent(out) :: i
   type (SomeDerivedType_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   i = fdtp % ptr % i
end subroutine get_i

! set derived type member iarr
subroutine set_iarr(ih, iarr, n) bind(c)
   integer(c_int), intent(in) :: n
   integer(c_int), intent(inout), dimension(12) :: ih
   integer(c_int), intent(in), dimension(n) :: iarr
   type (SomeDerivedType_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   fdtp % ptr % iarr = iarr
   ih = transfer(fdtp, ih)
end subroutine set_iarr

! get derived type member iarr
subroutine get_iarr(ih,iarr,n) bind (c)
   integer(c_int), intent(in) :: n
   integer(c_int), intent(in), dimension(12) :: ih
   integer(c_int), intent(out), dimension(n) :: iarr
   type (SomeDerivedType_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   iarr = fdtp % ptr % iarr
end subroutine get_iarr

! derived type destructor
subroutine destroy(ih) bind(c)
   integer(c_int), intent(inout), dimension(12) :: ih
   type (SomeDerivedType_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   deallocate(fdtp % ptr % iarr)
   deallocate(fdtp % ptr)
   ih = 0
end subroutine destroy

end module ftype
