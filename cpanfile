# Generated from Makefile.PL using makefilepl2cpanfile

requires 'Carp';
requires 'Exporter';
requires 'Readonly';
requires 'Sub::Private', '0.09';
requires 'autodie';

on 'test' => sub {
	requires 'Errno';
	requires 'IO::File';
	requires 'POSIX';
	requires 'Test::DescribeMe';
	requires 'Test::Most';
	requires 'Test::Needs';
};

on 'develop' => sub {
	requires 'Devel::Cover';
	requires 'Perl::Critic';
	requires 'Test::Pod';
	requires 'Test::Pod::Coverage';
};
