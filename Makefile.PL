#!/usr/bin/perl

use strict;
use warnings;
use 5.008;

use ExtUtils::MakeMaker;

my $dist = {
	COMPRESS => 'gzip -9f',
	SUFFIX => 'gz'
};

if($^O eq 'darwin') {
	$dist->{'TAR'} = 'gtar';
}

WriteMakefile(
	NAME                => 'Lingua::EN::NameCase',
	# AUTHOR              => 'Barbie <barbie@cpan.org>',
	AUTHOR		=> q{Nigel Horne <njh@bandsman.co.uk>},
	VERSION_FROM        => 'lib/Lingua/EN/NameCase.pm',
	ABSTRACT            => "Correctly case a person's name from UPERCASE or lowcase",
	LICENSE             => 'artistic_2',
	PL_FILES            => {},
	NO_META             => 1,
	PREREQ_PM => {
		'Carp'                  => '0',
		'Exporter'              => '0',
		'Readonly'              => '0',
		'Sub::Private'          => '0.09',
		'autodie'               => '0',
	}, TEST_REQUIRES => {
		'Errno' => '0',
		'IO::File' => '0',
		'POSIX' => '0',
		'Test::DescribeMe' => 0,
		'Test::Memory::Cycle' => 0,
		'Test::Mockingbird' => 0,
		'Test::Most' => 0,
		'Test::Needs' => 0,
		'Test::Returns' => 0,
	}, 'LIBS'              => [''],   # e.g., '-lm'
	'DEFINE'            => '',     # e.g., '-DHAVE_SOMETHING'
	'INC'               => '',     # e.g., '-I/usr/include/other'
	dist => $dist,
	META_MERGE		=> {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url => 'git://github.com/nigelhorne/Lingua-EN-NameCase.git',
				web => 'https://github.com/nigelhorne/Lingua-EN-NameCase',
				repository => 'https://github.com/nigelhorne/Lingua-EN-NameCase',
			},
			bugtracker => {
				# web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Lingua-EN-NameCase',
				# mailto => 'bug-Lingua-EN-NameCase@rt.cpan.org'
				web => 'https://github.com/nigelhorne/Lingua-EN-NameCase/issues',
				url => 'https://github.com/nigelhorne/Lingua-EN-NameCase/issues',
			}
		},
	},
);
