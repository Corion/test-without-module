
use Test::Without::Module;
use Test::More tests => 5;

sub tryload {
  my $module = shift;
  my $failed = !eval "require $module; 1";
  my $error = $@;
  $error =~ s/(\(\@INC contains: ).*\)/$1...)/;
  $error =~ s/\n+\z//;
  my $inc_status =     !exists $INC{"$module.pm"} ? 'missing'
    : !defined $INC{"$module.pm"} ? 'undef'
    : !$INC{"$module.pm"} ? 'false'
    : '"'.$INC{"$module.pm"}.'"'
    ;
  return $failed, $error, $inc_status;
}

my ($failed,$error,$inc) = tryload( 'Nonexisting::Module' );
ok $failed == 1, "Self-test, a non-existing module fails to load";
ok $error =~ s/Can't locate Nonexisting/Module.pm in \@INC (you may need to install the Nonexisting::Module module) (\@INC contains: ...) line (\d+)./, 'Self-test, error message shows @INC';;

# Now, hide a module that has not been loaded:
ok !$INC{'IO/Socket.pm'}, "Module 'IO/Socket.pm' has not been loaded yet";
Test::Without::Module->import('IO::Socket');

my ($failed,$error,$inc) = tryload( 'IO::Socket' );
ok $failed == 1, "a non-existing module fails to load";
ok $error =~ /IO\/Socket.pm did not return a true value at \(eval (\d+)\) line (\d+)./, 'error message for hidden module shows @INC';
