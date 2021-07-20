#!/bin/sh
pandoc -s -t revealjs --section-divs -V theme=moon -V slideNumber slides.md -o index.html
sed -i.bak "s:unpkg.com/reveal.js@\^4//dist/:cdn.li3huo.com/reveal/4.1.0/dist/:g" index.html
# -V revealjs-url=https://cdn.li3huo.com/reveal/4.1.0
# unpkg.com/reveal.js@^4//dist/  ==> cdn.li3huo.com/reveal/4.1.0/
# Reveal.initialize({ slideNumber: true }); https://revealjs.com/slide-numbers/
