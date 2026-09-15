CLASS z2ui5_cl_demo_app_366 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA pdf_source TYPE string.

    METHODS on_event_display_pdf.
    METHODS view_display.
    METHODS pdf_get_xstring
      RETURNING
        VALUE(result) TYPE xstring.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_366 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `DISPLAY_PDF` ).
      on_event_display_pdf( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event_display_pdf.

    " the XSTRING is encoded to Base64 and handed over to the browser as a
    " data URI - no additional service or temporary file is needed
    pdf_source = |data:application/pdf;base64,{ z2ui5_cl_util=>conv_encode_x_base64( pdf_get_xstring( ) ) }|.
    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Display PDF from XSTRING`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            class          = `sapUiContentPadding` ).
    page->button(
        text  = `Display PDF`
        icon  = `sap-icon://pdf-attachment`
        type  = `Emphasized`
        press = client->_event( `DISPLAY_PDF` ) ).

    IF pdf_source IS NOT INITIAL.
      page->_generic(
          name   = `iframe`
          ns     = `html`
          t_prop = VALUE #( ( n = `src`    v = pdf_source )
                            ( n = `height` v = `700px` )
                            ( n = `width`  v = `99%` ) ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD pdf_get_xstring.

    " replace this by your own source, for example a document read from the
    " database, a spool request or the output of a form processing framework -
    " the demo PDF is kept as a Base64 literal and decoded back to XSTRING here
    result = z2ui5_cl_util=>conv_decode_x_base64(
        `JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1Bh` &&
        `Z2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVk` &&
        `aWFCb3ggWzAgMCA1OTUgODQyXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA0IDAgUiAvRjIgNSAwIFIgPj4gPj4gL0NvbnRlbnRz` &&
        `IDYgMCBSID4+CmVuZG9iago0IDAgb2JqCjw8IC9UeXBlIC9Gb250IC9TdWJ0eXBlIC9UeXBlMSAvQmFzZUZvbnQgL0hlbHZldGljYS1C` &&
        `b2xkID4+CmVuZG9iago1IDAgb2JqCjw8IC9UeXBlIC9Gb250IC9TdWJ0eXBlIC9UeXBlMSAvQmFzZUZvbnQgL0hlbHZldGljYSA+Pgpl` &&
        `bmRvYmoKNiAwIG9iago8PCAvTGVuZ3RoIDIxMCA+PgpzdHJlYW0KQlQKL0YxIDI0IFRmCjYwIDc0MCBUZAooYWJhcDJVSTUgLSBQREYg` &&
        `RGVtbykgVGoKRVQKQlQKL0YyIDEyIFRmCjYwIDcwMCBUZAooVGhpcyBQREYgaXMgc3RvcmVkIGFzIFhTVFJJTkcgaW4gdGhlIEFCQVAg` &&
        `YmFja2VuZCwpIFRqCkVUCkJUCi9GMiAxMiBUZgo2MCA2ODIgVGQKKGVuY29kZWQgdG8gQmFzZTY0IGFuZCByZW5kZXJlZCBhcyBhIGRh` &&
        `dGEgVVJJLikgVGoKRVQKZW5kc3RyZWFtCmVuZG9iagp4cmVmCjAgNwowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMDkgMDAwMDAg` &&
        `biAKMDAwMDAwMDA1OCAwMDAwMCBuIAowMDAwMDAwMTE1IDAwMDAwIG4gCjAwMDAwMDAyNTEgMDAwMDAgbiAKMDAwMDAwMDMyNiAwMDAw` &&
        `MCBuIAowMDAwMDAwMzk2IDAwMDAwIG4gCnRyYWlsZXIKPDwgL1NpemUgNyAvUm9vdCAxIDAgUiA+PgpzdGFydHhyZWYKNjU2CiUlRU9G` &&
        `Cg==` ).

  ENDMETHOD.

ENDCLASS.
