#!/usr/bin/perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    if( ! eval { require Module::Load::Conditional; 1 }) {
        SKIP: {
            skip "Module::Load::Conditional not installed: $@", 1;
        };
    };
};
use Test::Without::Module qw(Test::More);

my $res = Module::Load::Conditional::can_load(
     modules => {
         'Test::More' => undef,
     }
);
ok !$res, "We don't load Test::More";

diag "Test::Without::Module: $Test::Without::Module::VERSION";
diag "Module::Load::Conditional: $Module::Load::Conditional::VERSION";
done_testing;