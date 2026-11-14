# Generated from Makefile.PL using makefilepl2cpanfile

requires 'Carp';
requires 'Exporter';
requires 'Readonly';
recommends 'Sub::Private', '0.09';    # optional; needs Perl 5.14+ and heavy dependencies
requires 'autodie';
requires 'IPC::System::Simple';    # needed by "use autodie qw(:all)"

on 'test' => sub {
	requires 'Errno';
	requires 'IO::File';
	requires 'POSIX';
	requires 'Test::DescribeMe';
	requires 'Test::Memory::Cycle';
	requires 'Test::Mockingbird';
	requires 'Test::Most';
	requires 'Test::Needs';
	requires 'File::Temp';
	requires 'JSON::PP';
	requires 'Test::Memory::Cycle';
	requires 'Test::Mockingbird';
	recommends 'Test::Returns';    # needs Perl 5.26+; t/lib/ReturnsOk.pm falls back without it
	requires 'Test::Without::Module';
};

on 'develop' => sub {
	requires 'Devel::Cover';
	requires 'Perl::Critic';
	requires 'Test::Pod';
	requires 'Test::Pod::Coverage';
};
