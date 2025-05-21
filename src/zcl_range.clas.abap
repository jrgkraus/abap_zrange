class zcl_range definition
  public
  final
  create public .

  public section.
    types self type ref to zcl_range.
    data result_range type range of string.
    class-methods init
      importing
        existing_lines type standard table optional
      returning
        value(result)  type self.

    methods constructor
      importing
        existing_lines type standard table.

    methods exclude
      returning
        value(result) type self.

    methods include
      returning
        value(result) type self.

    methods from_list
      importing
        line          type string
      returning
        value(result) type self..

    methods equals
      importing
        value         type any
      returning
        value(result) type self.

    methods greater
      importing
        value         type any
      returning
        value(result) type self.

    " for compatibility
    methods lower
      importing
        value         type any
      returning
        value(result) type self.

    methods less
      importing
        value         type any
      returning
        value(result) type self.

    methods between
      importing
        low           type any
        high          type any
      returning
        value(result) type self.

    methods not
      returning
        value(result) type self.

    methods and_equal
      returning
        value(result) type self.

    methods get
      returning
        value(result) like result_range.
  protected section.
  private section.
    constants:
      include_sign type ddsign value 'I',
      exclude_sign type ddsign value 'E',
      wildcards    type char2 value '*+'.
    constants:
      begin of option,
        equals               type ddoption value 'EQ',
        not_equals           type ddoption value 'NE',
        between              type ddoption value 'BT',
        greater              type ddoption value 'GT',
        greater_equal        type ddoption value 'GE',
        lower                type ddoption value 'LT',
        lower_equal          type ddoption value 'LE',
        contains_pattern     type ddoption value 'CP',
        not_between          type ddoption value 'NB',
        not_contains_pattern type ddoption value 'NP',
      end of option.


    data sign type char1 value 'I'.
    data invert type abap_bool.
    data with_equals type abap_bool.

    methods equals_single
      importing
        value type any.

    methods equals_table
      importing
        value type standard table.

    methods is_not
      returning
        value(result) type abap_bool.

    methods is_with_equals
      returning
        value(result) type abap_bool.
endclass.



class zcl_range implementation.
  method init.
    result = new #( existing_lines ).
  endmethod.

  method exclude.
    sign = exclude_sign.
    result = me.
  endmethod.

  method include.
    sign = include_sign.
    result = me.
  endmethod.

  method not.
    invert = abap_true.
    result = me.
  endmethod.

  method equals.
    if cl_abap_structdescr=>describe_by_data( value )->type_kind = cl_abap_datadescr=>typekind_table.
      equals_table( value ).
    else.
      equals_single( value ).
    endif.
    result = me.
  endmethod.

  method equals_single.
    insert value #(
      sign = sign
      option =
        cond #(
          when value ca wildcards
          then cond #(
            when is_not( )
            then option-not_contains_pattern else option-contains_pattern )
          else cond #(
            when is_not( )
            then option-not_equals else option-equals ) )
      low = conv #( value ) )
      into table result_range.
  endmethod.

  method between.
    insert value #(
      sign = sign
      option =
        cond #(
          when is_not( )
          then option-not_between else option-between )
      low = conv #( low )
      high = high )
      into table result_range.
    result = me.
  endmethod.

  method is_not.
    result = invert.
    invert = abap_false.
  endmethod.

  method equals_table.
    field-symbols <line> type any.
    field-symbols <value> type any.
    " is_not( ) resets the invert flag. Conserve it for all lines of the table
    data(local_not) = is_not( ).
    loop at value assigning <line>.
      " restore the invert flag
      invert = local_not.
      assign component 1 of structure <line> to <value>.
      if sy-subrc = 0.
        equals_single( <value> ).
      else.
        equals_single( <line> ).
      endif.
    endloop.
  endmethod.

  method and_equal.
    with_equals = abap_true.
    result = me.
  endmethod.

  method greater.
    insert value #(
      sign = sign
      option =
        cond #(
          when is_with_equals( )
          then option-greater_equal else option-greater )
      low = conv #( value ) )
      into table result_range.
    result = me.
  endmethod.

  method less.
    insert value #(
      sign = sign
      option =
        cond #(
          when is_with_equals( )
          then option-lower_equal else option-lower )
      low = conv #( value ) )
      into table result_range.
    result = me.
  endmethod.
  
  method lower.
    result = less( value ).
  endmethod.

  method is_with_equals.
    result = with_equals.
    with_equals = abap_false.
  endmethod.

  method get.
    result = result_range.
  endmethod.

  method constructor.
    if existing_lines is not initial.
      result_range = corresponding #( existing_lines ).
    endif.
  endmethod.

  method from_list.
    data t type string_table.
    if line is initial.
      result = me.
    else.
      split line at sy-vline into table t.
      result = equals( t ).
    endif.
  endmethod.

endclass.
