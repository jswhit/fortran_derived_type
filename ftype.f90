module ftype

use iso_c_binding, only: c_int, c_char, c_null_char, c_loc, c_ptr, c_f_pointer
implicit none 

! fortran derived type
integer, parameter :: namelen=20
type :: Somederivedtype
  integer :: i
  character(len=namelen) :: name
  integer, allocatable, dimension(:) :: iarr
end type Somederivedtype

contains

! create derived type, convert to c pointer
subroutine create(handle,i,iarr_len,name,iarr) bind (c)
  type(c_ptr), intent(out) :: handle
  integer(c_int), intent(in) :: i,iarr_len
  integer(c_int), intent(in), dimension(iarr_len) :: iarr
  character(c_char), intent(in) :: name(namelen+1)
  character(len=namelen) :: name_f
  type (Somederivedtype), pointer :: fdt
  call copy_string_ctof(name,name_f)
  allocate(fdt)
  allocate(fdt%iarr(iarr_len))
  fdt%i = i
  fdt%name = name_f
  fdt%iarr = iarr
  handle = c_loc(fdt)
end subroutine create

! set derived type member i
subroutine set_i(handle, i) bind(c)
   type(c_ptr), intent(out) :: handle
   integer(c_int), intent(in) :: i
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   fdt % i = i
end subroutine set_i

! get derived type member i
subroutine get_i(handle,i) bind (c)
   type(c_ptr), intent(in) :: handle
   integer(c_int), intent(out) :: i
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   i = fdt % i
end subroutine get_i

! get derived type member name
subroutine get_name(handle,name) bind (c)
   type(c_ptr), intent(in) :: handle
   character(c_char), intent(out) :: name(namelen+1)
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   call copy_string_ftoc(fdt%name,name)
end subroutine get_name

! set derived type member name
subroutine set_name(handle, name) bind(c)
   type(c_ptr), intent(in) :: handle
   character(c_char), intent(in) :: name(namelen+1)
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   call copy_string_ctof(name,fdt%name)
end subroutine set_name 

! set derived type member iarr
subroutine set_iarr(handle, iarr, n) bind(c)
   type(c_ptr), intent(in) :: handle
   integer(c_int), intent(in) :: n
   integer(c_int), intent(in), dimension(n) :: iarr
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   fdt % iarr = iarr
end subroutine set_iarr

! get derived type member iarr
subroutine get_iarr(handle,iarr,n) bind (c)
   type(c_ptr), intent(in) :: handle
   integer(c_int), intent(in) :: n
   integer(c_int), intent(out), dimension(n) :: iarr
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   iarr = fdt % iarr
end subroutine get_iarr

! derived type destructor
subroutine destroy(handle) bind(c)
   type(c_ptr), intent(inout) :: handle
   type (Somederivedtype), pointer :: fdt
   call c_f_pointer(handle, fdt)
   deallocate(fdt % iarr)
   deallocate(fdt)
end subroutine destroy

subroutine copy_string_ctof(stringc,stringf)
  ! utility function to convert c string to fortran string
  character(len=*), intent(out) :: stringf
  character(c_char), intent(in) :: stringc(:)
  integer j
  stringf = ''
  char_loop: do j=1,min(size(stringc),len(stringf))
     if (stringc(j)==c_null_char) exit char_loop
     stringf(j:j) = stringc(j)
  end do char_loop
end subroutine copy_string_ctof

subroutine copy_string_ftoc(stringf,stringc)
  ! utility function to convert c string to fortran string
  character(len=*), intent(in) :: stringf
  character(c_char), intent(out) :: stringc(namelen+1)
  integer j,n
  n = len_trim(stringf)   
  do j=1,n    
    stringc(j) = stringf(j:j)   
  end do
  stringc(n+1) = c_null_char
end subroutine copy_string_ftoc

end module ftype
