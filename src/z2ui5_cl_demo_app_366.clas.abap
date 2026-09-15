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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).
    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:html`    v = `http://www.w3.org/1999/xhtml`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - Display PDF from XSTRING`
                )->a( n = `class`          v = `sapUiContentPadding`
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `Button`
        )->a( n = `text`  v = `Display PDF`
        )->a( n = `icon`  v = `sap-icon://pdf-attachment`
        )->a( n = `type`  v = `Emphasized`
        )->a( n = `press` v = client->_event( `DISPLAY_PDF` ) ).

    IF pdf_source IS NOT INITIAL.

      " the data URI is document data, not binding vocabulary, so it is set
      " with t - a curly brace in a value passed to v would be read by UI5
      " as a binding path instead of being rendered
      page->tag( n = `iframe` ns = `html`
          )->a( n = `src`    t = pdf_source
          )->a( n = `height` v = `700px`
          )->a( n = `width`  v = `99%` ).

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
