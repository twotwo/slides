#!/bin/sh
sed -i.bak "s:unpkg.com/reveal.js@\^4//dist/:cdn.li3huo.com/reveal/4.1.0/:g" index.html
# unpkg.com/reveal.js@^4//dist/  ==> cdn.li3huo.com/reveal/4.1.0/
# Reveal.initialize({ slideNumber: true }); https://revealjs.com/slide-numbers/