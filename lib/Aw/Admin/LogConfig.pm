package Aw::Admin::LogConfig;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

require Aw::Admin;



sub getLogOutputsRef
{
	my $result = Aw::Admin::Client::getLogOutputs ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



#########################################################
# Do not change this, Do not put anything below this.
# File must return "true" value at termination
1;
##########################################################


__END__

=head1 NAME

Aw::Admin::LogConfig - ActiveWorks Admin::LogConfig Module.

=head1 SYNOPSIS

require Aw::Admin::LogConfig;

my $log = new Aw::Admin::LogConfig;


=head1 DESCRIPTION

Enhanced interface for the Aw/Client.xs LogConfig methods.


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1).  Aw(3).>

=cut
