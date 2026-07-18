;; extends

; // language=html
; /* language=SQL */
; /** language=json */
((comment) @injection.language
  .
  (expression_statement
    (assignment_expression
      right: [
        (string
          (string_content) @injection.content)
        (encapsed_string
          (string_content) @injection.content)
        (heredoc
          (heredoc_body) @injection.content)
        (nowdoc
          (nowdoc_body) @injection.content)
      ]))
  (#lua-match? @injection.language "^[/#%*%s]*[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]%s*=%s*[%w_%-]+%s*[%*/%s]*$")
  (#gsub! @injection.language "^[/#%*%s]*[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]%s*=%s*([%w_%-]+)%s*[%*/%s]*$" "%1")
  (#set! injection.include-children))
