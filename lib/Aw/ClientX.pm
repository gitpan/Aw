package Aw::ClientX;

# use strict;
# use vars qw($VERSION);

$VERSION = '0.1';

use Aw;
require Aw::Client;



sub newEZ
{
my ($class, $client_group)  = @_;
my $app_name = (@_ == 3) ? $_[2] : $0.".Client";
my $self = {};

	my $blessing = bless $self, $class;

	$self->{_client} = Aw::Client::new ( "Aw::Client", $Aw::DefaultBrokerHost, $Aw::DefaultBrokerName, "", $client_group, $app_name );

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
