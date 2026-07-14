;; extends

; // language=SQL
; /* language=SQL */
; /** language=SQL */
([
  (line_comment)
  (block_comment)
] @_injection_comment
  .
  [
    (let_declaration
      value: [
        (string_literal
          (string_content) @injection.content)
        (raw_string_literal
          (string_content) @injection.content)
      ])
    (const_item
      value: [
        (string_literal
          (string_content) @injection.content)
        (raw_string_literal
          (string_content) @injection.content)
      ])
    (static_item
      value: [
        (string_literal
          (string_content) @injection.content)
        (raw_string_literal
          (string_content) @injection.content)
      ])
  ]
  (#lua-match? @_injection_comment "^[/#%*%s]*[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]%s*=%s*[Ss][Qq][Ll]%s*[%*/%s]*$")
  (#set! injection.language "sql"))
