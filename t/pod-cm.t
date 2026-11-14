#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

use Test::Needs 'Test::Pod::Spelling::CommonMistakes';    # block form: no string eval

Test::Pod::Spelling::CommonMistakes->import();
all_pod_files_ok();
