package Aw::ClientX;

use strict;
use vars qw($VERSION);

$VERSION = '0.2';

use Aw;
require Aw::Client;



sub new
{
my $self = {};

	my $blessing = bless $self, shift;

	if ( @_ > 2 ) {
		$self->{_client} = Aw::Client::_new ( "Aw::Client", @_ )
	}
	else {
		my ($client_group)  = @_;
		my $app_name = (@_ == 2) ? $_[1] : $0.".Client";

		$self->{_client} = Aw::Client::_new ( "Aw::Client", $Aw::DefaultBrokerHost, $Aw::DefaultBrokerName, "", $client_group, $app_name );

	}

	$blessing;
}


sub AUTOLOAD
{
	my($self) = shift;
	my($arg) = shift;
	my($method) = ($AUTOLOAD =~ /::([^:]+)$/);
	return unless ($method);

	$self->{_client}->$method ( $arg );

}

__END__

=head1 NAME

Aw::ClientX - ActiveWorks Client Module.

=head1 SYNOPSIS

require Aw::ClientX;

my $client = newEZ Aw::ClientX ( "myGroup", "myApp" );


=head1 DESCRIPTION

Demonstative module that allows for a blessed hash to act as a client.


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1).  Aw(3).>

=cut
