;; extends

; // language=SQL
; /* language=SQL */
; /** language=SQL */
((comment) @_injection_comment
  .
  (expression_statement
    (assignment_expression
      right: [
        (string
          (string_content) @injection.content)
        (encapsed_string
          (string_content) @injection.content)
      ]))
  (#lua-match? @_injection_comment "^[/#%*%s]*[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]%s*=%s*[Ss][Qq][Ll]%s*[%*/%s]*$")
  (#set! injection.language "sql"))
