#!/usr/bin/perl -I. -w

# use Aw;
use Aw 'test@active:7449';
require Aw::Client;
require Aw::Event;
use diagnostics;



my $myName     = "XS Perl Time!";
my $clientId   = 0;
my $eventTypeName;

print "Creating client...\n";
my $client = newEZ Aw::Client ( "devkitClient" );

print "Subscribing to AdapterDevKit::time...\n";
$client->newSubscription ( "AdapterDevKit::time" );

print "Publishing AdapterDevKit::timeRequest...\n";
my $event = new Aw::Event ( $client, "AdapterDevKit::timeRequest" );

$event->setTag ( 1 );
print "  publish Error!\n" if ( $client->publish ( $event ) );


print "Waiting for AdapterDevKit::time...\n";
while ( $event = $client->getEvent( AW_INFINITE ) ) {

	if ( ($eventTypeName = $event->getTypeName) eq "AdapterDevKit::time" ) {
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
	undef ($eventTypeName);

}

print "done!\n";
