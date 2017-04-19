module ftype

use iso_c_binding, only: c_int, c_char, c_null_char
implicit none 

! fortran derived type
integer, parameter :: namelen=20
type :: Somederivedtype
  integer :: i
  character(len=namelen) :: name
  integer, allocatable, dimension(:) :: iarr
end type Somederivedtype


! container that has pointer to derived type
type :: Somederivedtype_pointer
  type(Somederivedtype), pointer :: ptr
end type Somederivedtype_pointer

contains

! create pointer to derived type, popluate derived type.
subroutine create(ih,i,iarr_len,name,iarr) bind (c)
  integer(c_int), intent(inout), dimension(12) :: ih
  integer(c_int), intent(in) :: i,iarr_len
  integer(c_int), intent(in), dimension(iarr_len) :: iarr
  character(c_char), intent(in) :: name(namelen+1)
  character(len=namelen) :: name_f
  type (Somederivedtype_pointer) :: fdtp
  allocate(fdtp%ptr)
  call copy_string_ctof(name,name_f)
  call initialize(fdtp%ptr,i,name_f,iarr,iarr_len)
  ih = transfer(fdtp, ih)
end subroutine create

subroutine initialize(fdt,i,name,iarr,iarr_len)
  integer, intent(in) :: i,iarr_len
  integer, intent(in), dimension(iarr_len) :: iarr
  character(*), intent(in) :: name
  type(SomeDerivedType), intent(out) :: fdt
  allocate(fdt%iarr(iarr_len))
  fdt%i = i
  fdt%name = name
  fdt%iarr = iarr
end subroutine initialize

! set derived type member i
subroutine set_i(ih, i) bind(c)
   integer(c_int), intent(inout), dimension(12) :: ih
   integer(c_int), intent(in) :: i
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   fdtp % ptr % i = i
   ih = transfer(fdtp, ih)
end subroutine set_i

! get derived type member i
subroutine get_i(ih,i) bind (c)
   integer(c_int), intent(in), dimension(12) :: ih
   integer(c_int), intent(out) :: i
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   i = fdtp % ptr % i
end subroutine get_i

! get derived type member name
subroutine get_name(ih,name) bind (c)
   integer(c_int), intent(in), dimension(12) :: ih
   character(c_char), intent(out) :: name(namelen+1)
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   call copy_string_ftoc(fdtp%ptr%name,name)
end subroutine get_name

! set derived type member name
subroutine set_name(ih, name) bind(c)
   integer(c_int), intent(inout), dimension(12) :: ih
   character(c_char), intent(in) :: name(namelen+1)
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   call copy_string_ctof(name,fdtp%ptr%name)
   ih = transfer(fdtp, ih)
end subroutine set_name 

! set derived type member iarr
subroutine set_iarr(ih, iarr, n) bind(c)
   integer(c_int), intent(in) :: n
   integer(c_int), intent(inout), dimension(12) :: ih
   integer(c_int), intent(in), dimension(n) :: iarr
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   fdtp % ptr % iarr = iarr
   ih = transfer(fdtp, ih)
end subroutine set_iarr

! get derived type member iarr
subroutine get_iarr(ih,iarr,n) bind (c)
   integer(c_int), intent(in) :: n
   integer(c_int), intent(in), dimension(12) :: ih
   integer(c_int), intent(out), dimension(n) :: iarr
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   iarr = fdtp % ptr % iarr
end subroutine get_iarr

! derived type destructor
subroutine destroy(ih) bind(c)
   integer(c_int), intent(inout), dimension(12) :: ih
   type (Somederivedtype_pointer) :: fdtp
   fdtp = transfer(ih, fdtp)
   deallocate(fdtp % ptr % iarr)
   deallocate(fdtp % ptr)
   ih = 0
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
