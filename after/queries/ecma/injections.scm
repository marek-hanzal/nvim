;; extends

; // language=SQL
; /* language=SQL */
; /** language=SQL */
((comment) @_injection_comment
  .
  [
    (lexical_declaration
      (variable_declarator
        value: [
          (string
            (string_fragment) @injection.content)
          (template_string
            (string_fragment) @injection.content)
        ]))
    (variable_declaration
      (variable_declarator
        value: [
          (string
            (string_fragment) @injection.content)
          (template_string
            (string_fragment) @injection.content)
        ]))
  ]
  (#lua-match? @_injection_comment "^[/#%*%s]*[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]%s*=%s*[Ss][Qq][Ll]%s*[%*/%s]*$")
  (#set! injection.language "sql"))
