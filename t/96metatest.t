#!/usr/bin/perl -w
use strict;

use Test::DescribeMe qw(author);
use Test::More;

eval 'use Test::CPAN::Meta::JSON';
plan skip_all => 'Test::CPAN::Meta::JSON required for testing META.json files' if $@;

plan 'no_plan';

exit;	# Don't use our own META.json file

my $meta = meta_spec_ok(undef,undef,@_);

use Lingua::EN::NameCase;
my $version = $Lingua::EN::NameCase::VERSION;

is($meta->{version},$version,
    'META.json distribution version matches');

if($meta->{provides}) {
    for my $mod (keys %{$meta->{provides}}) {
        is($meta->{provides}{$mod}{version},$version,
            "META.json entry [$mod] version matches distribution version");

        eval "require $mod";
        my $VERSION = '$' . $mod . '::VERSION';
        my $v = eval "$VERSION";
        is($meta->{provides}{$mod}{version},$v,
            "META.json entry [$mod] version matches module version");

        isnt($meta->{provides}{$mod}{version},0);
    }
}
