package Aw::Admin::Client;
use base qw(Aw::Client);

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

use Aw::Admin;
require Aw::Client;




sub getSubscriptionsById
{
	my $result = Aw::Admin::Client::getSubscriptionsByIdRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getEventAdminTypeDefs
{
	my $result = Aw::Admin::Client::getEventAdminTypeDefsRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getEventAdminTypeDefsByScope
{
	my $result = Aw::Admin::Client::getEventAdminTypeDefsByScopeRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}






sub getTerrioryGatewaySharedEventTypes
{
	my $result = Aw::Admin::Client::getTerrioryGatewaySharedEventTypesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getClientInfosById
{
	my $result = Aw::Admin::Client::getClientInfosByIdRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getTerritroyGatewaySharedEventTypes
{
	my $result = Aw::Admin::Client::getTerritroyGatewaySharedEventTypesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getAllTerritoryGateways
{
	my $result = Aw::Admin::Client::getAllTerritoryGatewaysRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getLogOutputs
{
	my $result = Aw::Admin::Client::getLogOutputsRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}

1;
__END__
