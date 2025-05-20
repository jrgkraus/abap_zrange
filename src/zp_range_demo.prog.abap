*&---------------------------------------------------------------------*
*& Report zp_range_demo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zp_range_demo.

selection-screen begin of line.
  selection-screen comment (30) clo.
  selection-screen position pos_low.
  parameters low type string visible length 10 lower case default '0Low'.
  parameters low2 type string visible length 10 lower case default 'Second'.
  parameters low3 type string visible length 10 lower case default 'Third'.
  selection-screen pushbutton (20) pb5 user-command pb5.
selection-screen end of line.
selection-screen begin of line.
  selection-screen comment (30) hig.
  selection-screen position pos_low.
  parameters high type string lower case default '1High'.
selection-screen end of line.
selection-screen begin of line.
  selection-screen comment (30) lis.
  selection-screen position pos_low.
  parameters list type string lower case default 'first|second|third'.
  selection-screen pushbutton (20) pb6 user-command pb6.
selection-screen end of line.
selection-screen begin of line.
  parameters excl as checkbox.
  selection-screen comment (10) exc.
  selection-screen pushbutton (20) pb1 user-command pb1.
  selection-screen pushbutton (20) pb2 user-command pb2.
  selection-screen pushbutton (20) pb3 user-command pb3.
  selection-screen pushbutton (20) pb4 user-command pb4.
selection-screen end of line.
selection-screen begin of line.
  parameters keep as checkbox.
  selection-screen comment (30) kep.
selection-screen end of line.


data sel type text255.
select-options s1 for sel.

data rng type ref to zcl_range.

initialization.
  clo = 'Low / multiple values'.
  hig = 'High (for add between)'.
  exc = 'exclude'.
  kep = 'Keep values'.
  pb1 = 'Add equals'.
  pb2 = 'Add not equals'.
  pb3 = 'Add between'.
  pb4 = 'Add not between'.
  pb5 = 'Add multiple equals'.
  pb6 = 'Add from a list'.
  %_S1_%_APP_%-TEXT = 'Resulting selection:'.

at selection-screen.
  if keep = abap_true.
    " use existing selections as base
    if excl = abap_true.
      " set excluding for SIGN
      " note that this can be reset using include( )
      rng = zcl_range=>init( s1[] )->exclude( ).
    else.
      rng = zcl_range=>init( s1[] ).
    endif.
  else.
    " re-build selection from scratch
    if excl = abap_true.
      rng = zcl_range=>init( )->exclude( ).
    else.
      rng = zcl_range=>init( ).
    endif.
  endif.
  case sy-ucomm.
    when 'PB1'.
      s1[] = corresponding #( rng->equals( low )->get( ) ).
    when 'PB2'.
      " note that NOT takes only effect for the following call (other than exclude( ) )
      s1[] = corresponding #( rng->not( )->equals( low )->get( ) ).
    when 'PB3'.
      s1[] = corresponding #( rng->between( low = low high = high )->get( ) ).
    when 'PB4'.
      s1[] = corresponding #( rng->not( )->between( low = low high = high )->get( ) ).
    when 'PB5'.
      data(multi) = value string_table( ( low ) ( low2 ) ( low3 ) ).
      s1[] = corresponding #( rng->equals( multi )->get( ) ).
    when 'PB6'.
      s1[] = corresponding #( rng->from_list( list )->get( ) ).
  endcase.
