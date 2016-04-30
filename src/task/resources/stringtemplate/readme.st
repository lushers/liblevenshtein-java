readme(project, cmd) ::= <<
# liblevenshtein

## Java

### A library for generating Finite State Transducers based on Levenshtein Automata.

[![Maven Central][maven-version-badge]][maven-repo]
[![Reference Status][maven-refs-badge]][maven-refs]
[![License][license-badge]][license]
[![Build Status][build-status-badge]][travis-ci]
[![Coverage Status][coverage-badge]][coveralls]
[![Coverity Scan Build Status][static-analysis-badge]][coverity]
[![Dependency Status][dependency-status-badge]][versioneye]
[![Gitter][gitter-badge]][gitter-channel]

Levenshtein transducers accept a query term and return all terms in a
dictionary that are within n spelling errors away from it. They constitute a
highly-efficient (space _and_ time) class of spelling correctors that work very
well when you do not require context while making suggestions.  Forget about
performing a linear scan over your dictionary to find all terms that are
sufficiently-close to the user's query, using a quadratic implementation of the
[Levenshtein distance][wikipedia-levenshtein-distance] or
[Damerau-Levenshtein distance][wikipedia-damerau-levenshtein-distance], these
babies find _all_ the terms from your dictionary in linear time _on the length
of the query term_ (not on the size of the dictionary, on the length of the
query term).

If you need context, then take the candidates generated by the transducer as a
starting place, and plug them into whatever model you're using for context (such
as by selecting the sequence of terms that have the greatest probability of
appearing together).

For a quick demonstration, please visit the [Github Page, here][live-demo].
There's also a command-line interface, [liblevenshtein-java-cli][java-cli].
Please see its [README.md][java-cli-readme] for acquisition and usage information.

The library is currently written in Java, CoffeeScript, and JavaScript, but I
will be porting it to other languages, soon.  If you have a specific language
you would like to see it in, or package-management system you would like it
deployed to, let me know.

### Branches

|                            Branch | Description                                 |
| ---------------------------------:|:------------------------------------------- |
|           [master][master-branch] | Latest, development source.                 |
|         [release][release-branch] | Latest, release source.                     |

### Documentation

When it comes to documentation, you have several options:
- [Wiki][wiki]
- [Javadoc][javadoc]
- [Source Code][tagged-source]

### Basic Usage:

### Minimum Java Version

liblevenshtein has been developed against Java &ge; $project.java.targetVersion$.
It will not work with prior versions.

$installation/all(project, cmd, "###")$

### Usage

Let's say you have the following content in a plain text file called,
[top-20-most-common-english-words.txt][top-20-most-common-english-words.txt]
(note that the file has one term per line):

```
the
be
to
of
and
a
in
that
have
I
it
for
not
on
with
he
as
you
do
at
```

The following provides you a way to query its content:

```java
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.github.dylon.liblevenshtein.collection.dawg.SortedDawg;
import com.github.dylon.liblevenshtein.levenshtein.Algorithm;
import com.github.dylon.liblevenshtein.levenshtein.Candidate;
import com.github.dylon.liblevenshtein.levenshtein.ITransducer;
import com.github.dylon.liblevenshtein.levenshtein.factory.TransducerBuilder;
import com.github.dylon.liblevenshtein.serialization.PlainTextSerializer;
import com.github.dylon.liblevenshtein.serialization.ProtobufSerializer;
import com.github.dylon.liblevenshtein.serialization.Serializer;

// ...

final SortedDawg dictionary;
final Path dictionaryPath =
  Paths.get("/path/to/top-20-most-common-english-words.txt");
try (final InputStream stream = Files.newInputStream(dictionaryPath)) {
  // The PlainTextSerializer constructor accepts an optional boolean specifying
  // whether the dictionary is already sorted lexicographically, in ascending
  // order.  If it is sorted, then passing true will optimize the construction
  // of the dictionary; you may pass false whether the dictionary is sorted or
  // not (this is the default and safest behavior if you don't know whether the
  // dictionary is sorted).
  final Serializer serializer = new PlainTextSerializer(false);
  dictionary = serializer.deserialize(SortedDawg.class, stream);
}

final ITransducer<Candidate> transducer = new TransducerBuilder()
  .dictionary(dictionary)
  .algorithm(Algorithm.TRANSPOSITION)
  .defaultMaxDistance(2)
  .includeDistance(true)
  .build();

for (final String queryTerm : new String[] {"foo", "bar"}) {
  System.out.println(
    "+-------------------------------------------------------------------------------");
  System.out.printf("| Spelling Candidates for Query Term: \"%s\"%n", queryTerm);
  System.out.println(
    "+-------------------------------------------------------------------------------");
  for (final Candidate candidate : transducer.transduce(queryTerm)) {
    System.out.printf("| d(\"%s\", \"%s\") = [%d]%n",
      queryTerm,
      candidate.term(),
      candidate.distance());
  }
}

// +-------------------------------------------------------------------------------
// | Spelling Candidates for Query Term: "foo"
// +-------------------------------------------------------------------------------
// | d("foo", "do") = [2]
// | d("foo", "of") = [2]
// | d("foo", "on") = [2]
// | d("foo", "to") = [2]
// | d("foo", "for") = [1]
// | d("foo", "not") = [2]
// | d("foo", "you") = [2]
// +-------------------------------------------------------------------------------
// | Spelling Candidates for Query Term: "bar"
// +-------------------------------------------------------------------------------
// | d("bar", "a") = [2]
// | d("bar", "as") = [2]
// | d("bar", "at") = [2]
// | d("bar", "be") = [2]
// | d("bar", "for") = [2]

// ...
```

If you want to serialize your dictionary to a format that's easy to read later,
do the following:

```java
final Path serializedDictionaryPath =
  Paths.get("/path/to/top-20-most-common-english-words.protobuf.bytes");
try (final OutputStream stream = Files.newOutputStream(serializedDictionaryPath)) {
  final Serializer serializer = new ProtobufSerializer();
  serializer.serialize(dictionary, stream);
}
```

Then, you can read the dictionary later, in much the same way you read the plain
text version:

```java
final SortedDawg deserializedDictionary;
try (final InputStream stream = Files.newInputStream(serializedDictionaryPath)) {
  final Serializer serializer = new ProtobufSerializer();
  deserializedDictionary = serializer.deserialize(SortedDawg.class, stream);
}
```

Serialization is not restricted to dictionaries, you may also (de)serialize
transducers.  Please see the [wiki][wiki] for more details.

### Reference

This library is based largely on the work of
[Stoyan Mihov][stoyan-mihov], [Klaus Schulz][klaus-schulz], and
Petar Nikolaev Mitankin:
[Fast String Correction with Levenshtein-Automata][fast-string-correction-2002].
For more information, please see the [wiki][wiki].

[top-20-most-common-english-words.txt]: https://raw.githubusercontent.com/universal-automata/liblevenshtein-java/$project.maven.version$/src/test/resources/top-20-most-common-english-words.txt "top-20-most-common-english-words.txt"

[maven-version-badge]: https://maven-badges.herokuapp.com/maven-central/com.github.dylon/liblevenshtein/badge.svg
[maven-repo]: https://maven-badges.herokuapp.com/maven-central/com.github.dylon/liblevenshtein
[maven-refs-badge]: https://www.versioneye.com/java/com.github.dylon:liblevenshtein/reference_badge.svg
[maven-refs]: https://www.versioneye.com/java/com.github.dylon:liblevenshtein/references
[license-badge]: https://img.shields.io/github/license/universal-automata/liblevenshtein-java.svg
[license]: https://raw.githubusercontent.com/universal-automata/liblevenshtein-java/master/LICENSE
[build-status-badge]: https://travis-ci.org/universal-automata/liblevenshtein-java.svg?branch=master
[travis-ci]: https://travis-ci.org/universal-automata/liblevenshtein-java
[coverage-badge]: https://coveralls.io/repos/github/universal-automata/liblevenshtein-java/badge.svg?branch=master
[coveralls]: https://coveralls.io/github/universal-automata/liblevenshtein-java?branch=master
[static-analysis-badge]: https://img.shields.io/coverity/scan/8476.svg
[coverity]: https://scan.coverity.com/projects/universal-automata-liblevenshtein-java
[dependency-status-badge]: https://www.versioneye.com/user/projects/570345d4fcd19a0051853d99/badge.svg
[versioneye]: https://www.versioneye.com/user/projects/570345d4fcd19a0051853d99
[gitter-badge]: https://badges.gitter.im/universal-automata/liblevenshtein-java.svg
[gitter-channel]: https://gitter.im/universal-automata/liblevenshtein-java?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge

$/wiki/footer(project, cmd)$
>>
/* vim: set ft=ghmarkdown: */