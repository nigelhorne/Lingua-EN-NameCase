## Name

Lingua::EN::NameCase - Correctly case a person's name from UPPERCASE or lowercase

## Version

Version 1.21

## Synopsis

```perl
    # Working with scalars; complementing lc and uc.

    use Lingua::EN::NameCase qw( nc );

    my $OriginalName = 'Nigel';
    my $FixedCasedName = nc( $OriginalName );

    $FixedCasedName = nc( \$OriginalName );

    # Working with arrays or array references.

    use Lingua::EN::NameCase 'NameCase';

    $FixedCasedName = NameCase( $OriginalName );
    my @OriginalNames = ('Nigel');
    my @FixedCasedNames = NameCase( @OriginalNames );

    $FixedCasedName = NameCase( \$OriginalName );
    @FixedCasedNames = NameCase( \@OriginalNames );

    NameCase( \@OriginalNames ) ; # In-place.

    # NameCase will not change a scalar in-place, i.e.
    NameCase( \$OriginalName ) ; # WRONG: null operation.

    $Lingua::EN::NameCase::SPANISH = 1;
    # Now 'El' => 'El' instead of (default) Greek 'El' => 'el'.
    # Now 'La' => 'La' instead of (default) French 'La' => 'la'.

    $Lingua::EN::NameCase::HEBREW = 0;
    # Now 'Aharon BEN Amram Ha-Kohein' => 'Aharon Ben Amram Ha-Kohein'
    #   instead of (default) => 'Aharon ben Amram Ha-Kohein'.

    $Lingua::EN::NameCase::ROMAN = 0;
    # Now 'Li' => 'Li' instead of (default) 'Li' => 'LI'.

    $Lingua::EN::NameCase::POSTNOMINAL = 0;
    # Now 'PHD' => 'Phd' instead of (default) 'PHD' => 'PhD'.
    # Leaving this set to 1 (the default) costs a little speed.
```

## Description

Forenames and surnames are often stored either wholly in UPPERCASE
or wholly in lowercase. This module allows you to convert names into
the correct case where possible.

Although forenames and surnames are normally stored separately if they
do appear in a single string, whitespace separated, NameCase and nc deal
correctly with them.

NameCase currently correctly name cases names which include any of the
following:

```
    Mc, Mac, al, el, ap, da, de, delle, della, di, du, del, der,
    la, le, lo, van and von.
```

It correctly deals with names which contain apostrophes and hyphens too.

### Example Fixes

```
    Original            Name Case
    --------            ---------
    KEITH               Keith
    LEIGH-WILLIAMS      Leigh-Williams
    MCCARTHY            McCarthy
    O'CALLAGHAN         O'Callaghan
    ST. JOHN            St. John
```

plus "son (daughter) of" etc. in various languages, e.g.:

```
    VON STREIT          von Streit
    VAN DYKE            van Dyke
    AP LLWYD DAFYDD     ap Llwyd Dafydd
    etc.
```

plus names with roman numerals (up to 89, LXXXIX), e.g.:

```
    henry viii          Henry VIII
    louis xiv           Louis XIV
```

### Configuration

The behaviour is controlled by package variables, read on every call
so they may be changed at any time:

- `$Lingua::EN::NameCase::HEBREW` (default 1)

    Lowercase the Hebrew particles "ben" and "bat" when they follow another word.

- `$Lingua::EN::NameCase::SPANISH` (default 0)

    Keep "El" and "La" capitalised (Spanish) instead of lowercasing them
    (Greek and French).

- `$Lingua::EN::NameCase::ROMAN` (default 1)

    Upper-case roman numerals (I to LXXXIX).

- `$Lingua::EN::NameCase::POSTNOMINAL` (default 1)

    Normalise a trailing post-nominal such as "PhD" or "MBE".

- `%Lingua::EN::NameCase::MESSAGES`

    Overrides the text of an error message by key (see ["MESSAGES"](#messages) under
    each routine).  The text may contain `{name}` placeholders, which are
    replaced by the arguments given when the error is raised.
    This is the hook for translating the error messages.

## Functions

### NameCase

Takes a scalar, scalarref, array or arrayref, and changes the case of the
contents, as appropriate. Essentially a wrapper around nc().

#### Purpose

Case one name, or a whole list of names, in one call.

#### Args

One scalar, one scalar reference, one array reference, or (in list context
only) a list of scalars.

#### Returns

- List context with a list, or an array reference

    A list of name-cased copies.  The source is not modified.

- Scalar or void context with an array reference

    The array is modified in place; the array reference is returned so calls
    can be chained.

- Scalar or scalar reference

    A name-cased copy.  A scalar reference is _not_ modified (see ["LIMITATIONS"](#limitations)).

#### Side Effects

Modifies the referenced array only in the in-place case above.
Dies (via ["croak" in Carp](https://metacpan.org/pod/Carp#croak)) on bad arguments.

#### Usage

See ["SYNOPSIS"](#synopsis).

#### Example

```perl
    my @fixed = NameCase( 'JOHN SMITH', 'mary o\'neil' );
    # ('John Smith', "Mary O'Neil")

    my @names = ( 'ANNE JONES', 'BOB MCVEY' );
    NameCase( \@names );
    # @names is now ('Anne Jones', 'Bob McVey')

    my $one = NameCase( 'DAVID VAN DYKE' );   # 'David van Dyke'
```

#### Api Specification

##### Input

```perl
    {
            names => {
                    type     => 'arrayref',    # list of scalars, or one [] / \scalar
                    optional => 0,
                    min      => 1,
            },
    }
```

A single hash reference, or any reference type other than SCALAR or ARRAY,
is rejected.

##### Output

```perl
    { type => 'arrayref', element_type => 'string' }    # list context
    { type => 'string' }                                # one scalar
    { type => 'arrayref' }                              # in place
```

#### Messages

- `usage_namecase`

    _Usage: $SCALAR|@ARRAY = NameCase \[\\\]$SCALAR|@ARRAY (got {got})_.
    The first argument was a reference of an unsupported type (`{got}`).
    Pass a scalar, a scalar ref or an array ref.

- `single_arg`

    _NameCase only accepts a single scalar, array or array ref_.
    No arguments were given, or several were given in scalar context.
    Pass exactly one value, or call in list context.

#### Formal Specification

```
    ┌─ NameCase ─────────────────────────────────────────────
    │ args? : seq ANY
    │ ctx?  : { list, scalar, void }
    │ out!  : seq STRING ∪ STRING ∪ ARRAYREF
    ├────────────────────────────────────────────────────────
    │ ref(head args?) ∉ { ARRAY, SCALAR, ∅ } ⇒ croak usage_namecase
    │ ctx? = list ∧ (#args? > 1 ∨ ref(head args?) = ARRAY)
    │     ⇒ out! = nc ∘ (elements args?)
    │ ctx? ≠ list ∧ ref(head args?) = ARRAY
    │     ⇒ head args? ' = nc ∘ (head args?) ∧ out! = head args?
    │ ref(head args?) = SCALAR ⇒ out! = nc(↑(head args?))
    │ ref(head args?) = ∅ ∧ #args? = 1 ⇒ out! = nc(head args?)
    │ otherwise ⇒ croak single_arg
    └────────────────────────────────────────────────────────
```

#### Pseudocode

```
    validate: reject refs that are neither ARRAY nor SCALAR
    if list context and (more than one arg or an ARRAY ref):
            return nc of each element
    elsif ARRAY ref:
            replace each element by nc(element); return the ref
    elsif SCALAR ref:
            return nc(dereferenced value)
    elsif exactly one arg:
            return nc(arg)
    else:
            croak single_arg
```

### Nc

Takes a scalar or scalarref, and change the case of the name in the
corresponding string appropriately.

#### Purpose

Name-case a single string.

#### Args

Zero or one argument: a string or a scalar reference to a string.
With no argument, `$_` is used (like `lc` and `uc`).

#### Returns

The name-cased string.  An undefined, empty or "0" input is returned
unchanged.  The input is never modified.

#### Side Effects

None.  Reads the package variables listed under ["CONFIGURATION"](#configuration).

#### Usage

```perl
    use Lingua::EN::NameCase qw(nc);
    print nc('MR. JON WHITACRE III');    # Mr. Jon Whitacre III
```

#### Example

```
    nc('KEITH');              # 'Keith'
    nc('o\'callaghan');       # "O'Callaghan"
    nc('mccarthy');           # 'McCarthy'
    nc(\ 'henry viii');       # 'Henry VIII'
    nc('van der post');       # 'van der Post'

    local $Lingua::EN::NameCase::ROMAN = 0;
    nc('na li');              # 'Na Li'
```

#### Api Specification

##### Input

```perl
    {
            name => {
                    type     => 'string',     # or a scalarref to a string
                    optional => 1,            # defaults to $_
            },
    }
```

##### Output

```perl
    { type => 'string', optional => 1 }    # undef in, undef out
```

#### Messages

- `usage_nc`

    _Usage: nc \[\[\\\]$SCALAR\] (got {got})_.
    More than one argument, or a reference that is not a scalar reference,
    was supplied (`{got}` names the type).  Pass one string or `\$string`.

#### Formal Specification

```
    ┌─ nc ───────────────────────────────────────────────────
    │ name? : STRING ∪ ↑STRING ∪ {⊥}
    │ out!  : STRING ∪ {⊥}
    ├────────────────────────────────────────────────────────
    │ #args > 1 ∨ ref(name?) ∉ { ∅, SCALAR } ⇒ croak usage_nc
    │ value = (name? ∈ ↑STRING ⇒ ↑name?  ∨  name?)
    │ value ∈ {⊥, "", "0"} ⇒ out! = value
    │ otherwise
    │   out! = postnominal ∘ roman ∘ particles ∘ mac ∘ base (value)
    │   where roman and postnominal apply only when enabled
    └────────────────────────────────────────────────────────
```

#### Pseudocode

```perl
    validate arguments (at most one; a plain scalar or SCALAR ref)
    take the argument, or $_ when none was given
    dereference it if it is a reference
    return it at once if it is false (undef, '', '0')
    lowercase it, capitalise each word, lowercase 's
    apply the Mc/Mac rules
    lowercase the particles (da, de, van, von, ...)
    if ROMAN: upper-case roman numerals
    if POSTNOMINAL: normalise a trailing PhD, MBE, ...
    return the result
```

## Limitations

The design choices below are known weaknesses.

- Global configuration

    `$HEBREW`, `$SPANISH`, `$ROMAN` and `$POSTNOMINAL` are package
    variables, so one part of a program changing them changes the result for
    all of it.  Use `local` to scope a change.  A per-call options hash would
    be better, but would change the API.

- Scalar references are not modified in place

    `NameCase(\$name)` returns a copy.  Changing this would break existing
    callers.

- Exceptions are prefixes

    The "Mac" exceptions match the start of a word, so MacInnes becomes
    Macinnes and MacKenzie becomes Mackenzie.  An exact-surname list would be
    more accurate but needs data this module does not have.

- Everything is an English-language heuristic

    Names are not cased by a grammar.  "Ben" and "Van" are lowercased only when
    they follow another word, and every word of a name is treated alike
    (`Estate Of Laura Jones`).  For real name parsing use
    [Lingua::EN::NameParse](https://metacpan.org/pod/Lingua%3A%3AEN%3A%3ANameParse).

- `use locale`

    The module honours the current `LC_CTYPE` locale.  That is correct for
    legacy 8-bit data, but in a Turkish locale "I" lowercases to a dotless "i".
    Decode your data and, if that matters, run with a neutral locale.

- Post-nominals only at the end

    Only the last word is checked, and the list is not exhaustive.
    Since the entries are now matched literally, "MCh." and "FCSP." require
    their final dot (the dot used to match any character).

- Error messages

    Messages are English templates with `{name}` placeholders, replaceable
    through `%MESSAGES`.  There is no plural or gender handling because none
    of the messages needs it.

- Encapsulation

    The internal routines are guarded with [Sub::Private](https://metacpan.org/pod/Sub%3A%3APrivate) in enforce mode.
    [Sub::Protected](https://metacpan.org/pod/Sub%3A%3AProtected) is not used because the module has no classes or methods
    to protect.

## Bugs

The module covers the rules that I know of. There are probably a lot
more rules, exceptions etc. for "Western"-style languages which could be
incorporated.

There are probably lots of exceptions and problems - but as a general
data 'cleaner' it may be all you need.

Use Kim Ryan's [Lingua::EN::NameParse](https://metacpan.org/pod/Lingua%3A%3AEN%3A%3ANameParse) for any really sophisticated name parsing.

## Support

You can find documentation for this module with the perldoc command.

```
    perldoc Lingua::EN::NameCase
```

You can also look for information at:

- MetaCPAN

    [https://metacpan.org/release/Lingua-EN-NameCase](https://metacpan.org/release/Lingua-EN-NameCase)

- RT: CPAN's request tracker

    [https://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-EN-NameCase](https://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-EN-NameCase)

- CPANTS

    [http://cpants.cpanauthors.org/dist/Lingua-EN-NameCase](http://cpants.cpanauthors.org/dist/Lingua-EN-NameCase)

- CPAN Testers' Matrix

    [http://matrix.cpantesters.org/?dist=Lingua-EN-NameCase](http://matrix.cpantesters.org/?dist=Lingua-EN-NameCase)

- CPAN Testers Dependencies

    [http://deps.cpantesters.org/?module=Lingua::EN::NameCase](http://deps.cpantesters.org/?module=Lingua::EN::NameCase)

## Author

```
1998-2014    Mark Summerfield <summer@qtrac.eu>
2014-present Barbie <barbie@cpan.org>

2020- Maintained by Nigel Horne, C<< <njh at bandsman.co.uk> >>
```

## Acknowledgements

Thanks to Kim Ryan <kimaryan@ozemail.com.au> for his Mc/Mac solution.

## Copyright

Copyright (c) Mark Summerfield 1998-2014. All Rights Reserved.
Copyright (c) Barbie 2014-2015. All Rights Reserved.

This distribution is free software; you can redistribute it and/or
modify it under the Artistic Licence v2.
