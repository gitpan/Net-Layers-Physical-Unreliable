# test.pl
BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}
use Net::Layers::Physical::Unreliable;
$loaded = 1;
print "ok 1\n";

# create new object

my $obj = Net::Layers::Physical::Unreliable->new(drop_percentage=>40,garble_percentage=>40);
my %hashTest;
print "ok 2\n";

for ($i=0;$i<100;$i++)
  {
    $obj->attempt("Message $i\n");
    $hashTest{$obj->getLast()}++;
  }

print "ok 3\n";
my $attempted = $obj->getAttempted();
print "Packets Attempted: $attempted\n";
my $orignal = $obj->getOrignal();
print "Orignal Packets Returned: $orignal\n";
my $garbled = $obj->getGarble();
print "Packets Garbled: $garbled\n";
my $dropped = $obj->getDrop();
print "Packets Dropped: $dropped\n";

print "ok 4\n";

if ($hashTest{1} == $orignal)
  {
    print "ok 5\n";
  }
else
  {
    print "NOT OK 5\n";
  }

if ($hashTest{-1} == $garbled)
  {
    print "ok 6\n";
  }
else
  {
    print "NOT OK 6\n";
  }

if ($hashTest{0} == $dropped)
  {
    print "ok 7\n";
  }
else
  {
    print "NOT OK 7\n";
  }

