# liblevenshtein

### A library for generating Finite State Transducers based on Levenshtein Automata.

Levenshtein transducers accept a query term and return all terms in a
dictionary that are within n spelling errors away from it. They constitute a
highly-efficient (space _and_ time) class of spelling correctors that work very
well when you do not require context while making suggestions.  Forget about
performing a linear scan over your dictionary to find all terms that are
sufficiently-close to the user's query, using a quadratic implementation of the
[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) or
[Damerau-Levenshtein
distance](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance),
these babies find _all_ the terms from your dictionary in linear time _on the
length of the query term_ (not on the size of the dictionary, on the length of
the query term).

If you need context, then take the candidates generated by the transducer as a
starting place, and plug them into whatever model you're using for context (such
as by selecting the sequence of terms that have the greatest probability of
appearing together).

For a quick demonstration, please visit the [Github Page,
here](http://dylon.github.io/liblevenshtein/).

The library is currently only written in CoffeeScript (and JavaScript), but I
will be porting it to other languages, soon.  If you have a specific language
you would like to see it in, or package-management system you would like it
deployed to, let me know.

This library is based largely on the work of [Stoyan
Mihov](http://www.lml.bas.bg/~stoyan/), [Klaus
Schulz](http://www.klaus-schulze.com/), and Petar Nikolaev Mitankin: "[Fast
String Correction with
Levenshtein-Automata](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.16.652
"Klaus Schulz and Stoyan Mihov (2002)")".  For more details, please see the
[wiki](https://github.com/dylon/liblevenshtein/wiki).
