#!/usr/bin/perl -w

$| =1;

package PerlDemoAdapter;

use Aw;
require Aw::Adapter;
require Aw::Event;
use HelloWorld;

@PerlDemoAdapter::ISA=qw(Aw::Adapter);


my ($false, $true) = (0,1);


sub startup {

	my $self = shift;

	#  subscribe to AdapterDevKit::PerlDemo2 
	return $false if ( $self->newSubscription ( "AdapterDevKit::PerlDemo2", 0 ) );


	#  register the event
	my $event = new Aw::EventType ( "AdapterDevKit::PerlDemo2" );
	$self->addEvent( $event );

	
	#  set up subscriptions for the Adapter::lookup and Adapter::refresh events
	
	return ( $self->initStatusSubscriptions ) ? $false : $true ;  # init also does publishStatus
    
}


sub processPublication {

	my $self     = shift;
	my $eventDef = shift;

	print "Hello from processPublication Method\n";


	if ( $eventDef->name eq "AdapterDevKit::PerlDemo2" ) {
		$self->deliverAckReplyEvent;
		return $true;
	}

	print "GoodBye[false] from processPublication Method\n";
	$false;
}



sub processRequest
{
my ($self, $requestEvent, $eventDef) = @_;

	print "Hello from processRequest Method\n";

	my %hash = $requestEvent->toHash;
	my $world = eval ( $hash{structA}{structB}{stringC} );
	print "==============================================\n";
	print "           World Test:\n\n";
	$world->run;
	print "==============================================\n";
	$self->deliverAckReplyEvent;

	$true;
}


# =============================================================================#
#  END CALLBACKS SECTION
# =============================================================================#


package main;

main: {

	my @properties = (
	        "Perl Demo Adapter",
	        "test_broker\@active",
	        "0",
	        "debug=1",
	        "clientgroup=test",
	        "adapterType=perl_adapter",
	        "messageCatalog=perl_adapter"
	);


	#  Start with one step...
	#
	my $adapter = new PerlDemoAdapter ( \@properties );


	my $retVal = 0;

	#  process connection testing mode 
	#
	die ( "\n$retVal = ", $adapter->connectTest, "\n" )
		if ( $adapter->isConnectTest );


	if ( $adapter->createClient ) {
  		# we don't want to go here.
		$retVal = 1;
	} else {
		# we want to go here

		$retVal = $adapter->startup;

		my $test = $adapter->getEvents;

		$retVal = 1 if ($retVal && $adapter->getEvents);
	}


	print "\nRetval = $retVal\n";
}
