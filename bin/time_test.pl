#!/usr/bin/perl -I. -w

use Aw 'test@active:7449';
require Aw::Client;
require Aw::Event;



print "Creating client...\n";
my $client = newEZ Aw::Client ( "devkitClient" );

print "Subscribing to AdapterDevKit::time...\n";
$client->newSubscription ( "AdapterDevKit::time" );

print "Publishing AdapterDevKit::timeRequest...\n";
my $event = new Aw::Event ( $client, "AdapterDevKit::timeRequest" );

$event->setTag ( 1 );
$client->publish ( $event ) and die ( "Publish Error: $!" );


print "Waiting for AdapterDevKit::time...\n";
while ( $event = $client->getEvent( AW_INFINITE ) ) {

	if ( (my $eventTypeName = $event->getTypeName) eq "AdapterDevKit::time" ) {
		my $eventTag = $event->getTag;

		my $date = $event->getDateField ( "time" );
		if ( $eventTag ) {
			printf "Received AdapterDevKit::time reply  %s\n", $date->toString;
		} else {
			printf "Received AdapterDevKit::time update %s\n", $date->toString;
		}
		undef ($eventTag);
		undef ($date);
	} else {
	    	printf "Received \"%s\"\n", $eventTypeName;
	}
	undef ($event);

}

print "done!\n";
