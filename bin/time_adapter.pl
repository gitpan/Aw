#!/usr/bin/perl -I. -w

$| =1;

package TimeAdapter;

# use Aw;
use Aw 'test@active:6449';
use Aw::Event;
require Aw::Adapter;

@TimeAdapter::ISA=qw(Aw::Adapter);


my ($false, $true) = (0,1);

#  for use in the AdapterDevKit::time event
my $eventTime = new Aw::Date;   # should be empty and must be in the scope of startup and createTimeEvent

sub beginTransaction {
	my $self = shift;
	my $transactionId = shift;
	print "  Hello from beginTansaction Method\n";
	print "  [",$transactionId,"]\n" if ( $transactionId );
	$true;
}



sub startup {

	my $self = shift;

	#  subscribe to AdapterDevKit::timeRequest 
	return $false if ( $self->newSubscription ( "AdapterDevKit::timeRequest", 0 ) );


	#  register the event
	my $event = new Aw::EventType ( "AdapterDevKit::timeRequest" );
	$self->addEvent( $event );

	
	if ( $self->isMaster ) {
	 	#  set up the periodic publication of AdapterDevKit::time
		$event = new Aw::EventType ( "AdapterDevKit::time" );
	 	$event->isPublish ( $true );
	 	$event->publishInterval ( 15 );
	 	$event->nextPublish ( time );

		#  set the pubish time to fall onto an "even" time
	 	$event->nextPublish ( ($event->nextPublish + $event->publishInterval - ($event->nextPublish % $event->publishInterval)) );
	 	$self->addEvent ( $event );
	}
    
	#  set up subscriptions for the Adapter::lookup and Adapter::refresh events
	
	return ( $self->initStatusSubscriptions ) ? $false : $true ;  # init also does publishStatus
    
}


#
#  A subroutined used by the call backs
#
sub createTimeEvent {

	my $self = shift;
	my $event;

	return (undef)
		unless ( $event = $self->createEvent ( "AdapterDevKit::time" ) );

	$eventTime->setDateCtime ( time );

	$event->setDateField ( "time", $eventTime );

	$event;
}



# =============================================================================#
#
#  Call backs are written here.
#
#    adapter->processPublicationFunction = processPublication
#    adapter->processRequestFunction     = processRequest
#
# =============================================================================#

#
#  We schedule the next publication ourselves, and therefore, return $true.
#  Must return a boolean:  Adapter DK 6-44
#
sub processPublication {

	my $self     = shift;
	my $eventDef = shift;

	print "Hello from processPublication Method\n";


	if ( $eventDef->name eq "AdapterDevKit::time" ) {
		$eventDef->nextPublish ( $eventDef->nextPublish + $eventDef->publishInterval );

		my $reply = $self->createTimeEvent;

		return $true unless ( $reply );
	
		$self->publish ( $reply );
		undef ($reply);		 #  Forced because the Perl 5.004_4 gargabe collector misses this.
		# print "GoodBye[true] from processPublication Method\n";
		return $true;
	}

	# print "GoodBye[false] from processPublication Method\n";
	$false;
}



#
# callback to process a request:  Adapter DK 6-45
#
sub processRequest {

	my ( $self, $reqEvent, $eventDef ) = @_;

	print "Hello from processRequest Method\n";

	my $reply = $self->createTimeEvent ( $self );

	$self->deliverReplyEvent ( $reply ) if ( $reply );
	
	$true;
}

# =============================================================================#
#  END CALLBACKS SECTION
# =============================================================================#



package main;

main: {

	my @properties = (
	        # "XS Time Adapter",
	        "TimeAdapter",
	        "test_broker\@localhost:8849",
	        "0",
		"./adapters.cfg",
	        "debug=1",
	        "clientGroup=devkitAdapter",
	        # "adapterType=time_adapter",
	        "adapterType=Adapter40",
	        "messageCatalog=time_adapter"
	);
	my %properties = (
	        clientId	=> 'TimeAdapter',
	        broker		=> "test\@localhost:7449",
	        adapterId	=> 0,
	        debug		=> 1,
	        clientGroup	=> 'devkitAdapter',
	        adapterType	=> 'Adapter40',
	        messageCatalog	=> 'time_adapter'
	);


	#  Start with one step...
	#
	my $adapter = new TimeAdapter ( \%properties );
	# my $adapter = new TimeAdapter ( \@properties );


	#
	# Alternately
	#
	# $adapter = new TimeAdapter;
	# $adapter->loadProperties ( @properties );


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
