
if exists("loaded_matchit")
    let b:match_words =
                \ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\(\s\+if\)\@!\>'
                \ . ',' . b:match_words
endif

