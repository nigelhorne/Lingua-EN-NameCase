# Generated from Makefile.PL using makefilepl2cpanfile

requires 'Carp';
requires 'Exporter';
requires 'IPC::System::Simple';   # needed by "use autodie qw(:all)"
requires 'Readonly';
requires 'autodie';
recommends 'Sub::Private', '0.09';

on 'test' => sub {
	requires 'Errno';
	requires 'File::Temp';
	requires 'IO::File';
	requires 'JSON::PP';
	requires 'POSIX';
	requires 'Test::DescribeMe';
	requires 'Test::Memory::Cycle';
	requires 'Test::Mockingbird';
	requires 'Test::Most';
	requires 'Test::Needs';
	requires 'Test::Which';
	requires 'Test::Without::Module';
	recommends 'Test::Returns';
};

on 'develop' => sub {
	requires 'Devel::Cover';
	requires 'Perl::Critic';
	requires 'Test::Pod';
	requires 'Test::Pod::Coverage';
};
