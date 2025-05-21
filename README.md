# ABAP Range utility

For many years, I was annoyed by the cumbersome handling of *ABAP ranges*. There were countless attempts to program a tool to simplify their use. 
This repository is the result of my efforts. It essentially consists of the class ZCL_RANGE.

## Main usage

    existing_range = corresponding #( zcl_range=>init( )->equals( 'A' )->get( ) ).

Note that you need to convert to your range using `corresponding #(`. After that, you have a line with SIGN = 'I', OPTION = 'EQ' and low = 'A' in your range.
There are further base methods: `greater( ), less( ), between( )`

### Working with patterns

Patterns ('CP') are recognized automatically by the existence of wild cards and can be used with the equals( ) call.

### Using existing lines

    existing_range = corresponding #( zcl_range=>init( existing_range )->equuals( 'A' )->get( ) ).

When you pass an existing range, the new entries will be added.

### Working with qualifiers

    rng = corresponding #( zcl_range=>init( )->exclude( )->equals( 'A' )->get( ) ).

Note that this sets the SIGN to 'E' for all following actions, until `include( )` is called.

    rng = corresponding #( zcl_range=>init( )->not( )->equals( 'B' )->get( ) ).

This creates a 'NE' entry. The NOT qualifyer only affects the next call.

    rng = corresponding #( zcl_range=>init( )->and_equal( )->greater( 'B' )->get( ) ).

With this, you can create a 'GE' entry. Just as NOT, it affects only the following call.

### Making multiple entries

    tab = value #( ( 'A' ) ( 'B' ) ( 'C' ) ).
    rng = corresponding #( zcl_range=>init( )->equals( tab )->get( ) ).

EQUALS can take a table as parameter. It should be either without structure or with a compatible first component, which is being used then. You will get
one EQ entry for each line.

## Demo report

See ZP_RANGES_DEMO for some examples.

    rng = corresponding #( zcl_range=>init( )->from_list( 'A|B|C' )->get( ) ).

This shortcut creates multiple 'EQ' entries, using the pipe as separator

### Supported types

The range can be of character types, type D, type T, type P and type I. ABAPs intrinsinc type conversion makes sure that everything is being converted correctly.
