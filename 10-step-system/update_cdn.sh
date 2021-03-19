#!/bin/sh
sed -i.bak "s:unpkg.com/reveal.js@\^4//dist/:cdnjs.cloudflare.com/ajax/libs/reveal.js/4.1.0/:g" index.html
# unpkg.com/reveal.js@^4//dist/  ==> cdnjs.cloudflare.com/ajax/libs/reveal.js/4.1.0/