package Aw::Admin::ServerClient;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

use Aw::Admin;



sub getServerLogEntries
{
	my $result = Aw::Admin::ServerClient::getServerLogEntriesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getServerBrokers
{
	my $result = Aw::Admin::ServerClient::getServerBrokersRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}

1;

__END__
