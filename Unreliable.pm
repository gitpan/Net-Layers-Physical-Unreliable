package Net::Layers::Physical::Unreliable;

require 5.005_62;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';

# Technique for new class borrowed from Effective Perl Programming by Hall / Schwartz pp 211
sub new{
  my $pkg = shift;
  # bless package variables
  bless{
  drop_percentage => 20,
  garble_percentage => 20,
  drop => 0,
  garble => 0,
  orignal => 0,
  attempted => 0,
  last => 0,
  @_}, $pkg;
}

# attempt message (if ok), update stats as necessary
sub attempt{
  my $self = shift;
  my $message = shift;

  # increment attempted 
  $self->{attempted}++;

  my $rnd = rand 101; # (will return 1 and 100)
  if ($rnd < $self->{drop_percentage})
    {
      $self->{last}=0;
      $self->{drop}++;
      return(undef);
    }
  else
    {
      if ($rnd < ($self->{garble_percentage} + $self->{drop_percentage}))
       {
         $self->{garble}++;
         $self->{last}=-1;
         return("thisisagarbledmessagethathastobehandled");
       }
     else
       {
         $self->{orignal}++;
         $self->{last}=1;
         return($message);
       }
    } 
}

sub getAttempted{
  my $self=shift;
  return($self->{attempted});
}

sub getOrignal{
  my $self = shift;
  return($self->{orignal});
}

sub getGarble{
  my $self = shift;
  return($self->{garble});
}

sub getDrop{
  my $self = shift;
  return($self->{drop});
}

sub getLast{
  my $self = shift;
  return($self->{last});
}


1;
__END__


=head1 NAME

Net::Layers::Physical::Unreliable - Perl extension for testing network layer protocols on an unreliable physical layer.

=head1 SYNOPSIS

  use Net::Layers::Physical::Unreliable;

  my $obj = Net::Layers::Physical::Unreliable->new();
  $obj->attempt("Message");


=head1 DESCRIPTION

Perl extension for testing network layer protocols (TCP|UDP|etc) on an unreliable physical layer.

The attempt method will returned a dropped (null) string, a garbled string (a string replaced with a
non-sensical characters), or the orignal string.

Statistics are generated and can be called as shown bellow.

=head1 DETAILS

=head2 $obj = new(drop_percentage=> 5, garble_percentage=> 5);

Creates a new unreliable object.  Optional parameters drop_percentage and garble_percentage are the percentages
of a message being droped or garbled respectivly, in the range of 0 to 100 percent.

=head2 $obj->attempt("message");

Returns the orignal string, if the packet is not dropped or grabled.  The following things happen: 1) The message
is accepted.  The number of attempted messages is incremented by 1.  2) A random number is generated in the range
of 0..100.  3) If the random number is less than the drop_percentage, the message is "dropped" (an undef is returned),
and the drop counter is incremented by one.  If the random number is less than the drop_percentage plus the
garble_percentage, the message is garbled, and is returned.  4) Else, the orignal message is returned and the orignal 
counter is incremented by one.

=head2 $obj->getAttempted();

Returns the number of attempted messages.

=head2 $obj->getOrignal();

Returns the number of messages that were returned in the orignal form.

=head2 $obj->getGarble();

Returns the number of messages that were garbled.

=head2 $obj->getDrop();

Returns the number of messsages that were dropped.

=head2 $obj->getLast();

Returns what happened last to the packet.
Code Description
-1   Packet returned was dropped
0    Packet returned was a garbled
1    Packet returned was the orignal packet

=head1 AUTHOR

Zachary Zebrowski, zak@freeshell.org

=head1 SEE ALSO

Effective Perl Programming by Joseph N. Hall with Randl L. Schwartz

Computer Networks by Andrew Anenbaum

http://freeshell.org/~zak

=cut
