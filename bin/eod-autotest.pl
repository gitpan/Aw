#!/usr/bin/perl -w

use strict;

use Aw;
use Aw::Admin;
use Aw::Event;
require Aw::Client;
require Aw::Admin::Client;
require Aw::Admin::ServerClient;


sub setEventOfDoomDef
{

my %basic	= (
	_name		=> "Perl::EventOfDoom",
	_description	=> "If this works, nothing can break me!",
	_timeToLive	=> 10,

	b 	=> FIELD_TYPE_BOOLEAN,
	by	=> FIELD_TYPE_BYTE,
	c	=> FIELD_TYPE_CHAR,
	d	=> FIELD_TYPE_DOUBLE,
	dt	=> FIELD_TYPE_DATE,
	l	=> FIELD_TYPE_LONG,
	f	=> FIELD_TYPE_FLOAT
	i	=> FIELD_TYPE_INT,
	's'	=> FIELD_TYPE_STRING,
	sh	=> FIELD_TYPE_SHORT,
	'uc'	=> FIELD_TYPE_UNICODE_CHAR,
	us 	=> FIELD_TYPE_UNICODE_STRING,

	b_array		=> [ FIELD_TYPE_BOOLEAN        ],
	by_array	=> [ FIELD_TYPE_BYTE           ],
	c_array		=> [ FIELD_TYPE_CHAR           ],
	d_array		=> [ FIELD_TYPE_DOUBLE         ],
	dt_array	=> [ FIELD_TYPE_DATE           ],
	f_array		=> [ FIELD_TYPE_FLOAT          ],
	i_array		=> [ FIELD_TYPE_INT            ],
	l_array		=> [ FIELD_TYPE_LONG           ],
	s_array		=> [ FIELD_TYPE_STRING         ],
	sh_array	=> [ FIELD_TYPE_SHORT          ],
	uc_array	=> [ FIELD_TYPE_UNICODE_CHAR   ],
	us_array	=> [ FIELD_TYPE_UNICODE_STRING ]
);


	my %basicA = %basic;
	my %basicB = %basic;

	my $doom           = \%basic;

	$doom->{st}        = \%basicA;
	$doom->{st}{st}    = \%basicB;

	my %structA        = %$doom;
	$doom->{st_array}  = [ \%structA ];

	new Aw::Admin::TypeDef ( $doom );
}



sub setEventOfDoom
{
my %basic	= (
	b 	=> 1,
	by	=> 0x10,
	c	=> 'c',
	d	=> 999999999,
	l	=> 111111111,
	f	=> 3.1415927,
	i	=> 100,
	's'	=> "Ahadu",
	sh	=> 4000,
	'uc'	=> 'u',
	us 	=> 'hello',
	b_array		=> [ 0, 1, 0, 1, 0 ],
	by_array	=> [ 0x0f, 0x10, 0xff ],
	c_array		=> [ 'a', 'b', 'c' ],
	d_array		=> [ 0.1, 0.2, 0.3, 0.4 ],
	f_array		=> [ 0.1, 0.2, 0.3, 0.4 ],
	i_array		=> [  10,  20,  30 ],
	l_array		=> [ 1, 2, 3, 4, 5 ],
	s_array		=> [ "String 1", "String 2", "String 3" ],
	sh_array	=> [ 1, 2, 3, 4, 5 ],
	uc_array	=> [ 'a', 'b', 'c' ],
	us_array	=> [ "UC String 1", "UC String 2", "UC String 3" ],
);

	$basic{dt} = new Aw::Date;
	$basic{dt}->setDateCtime ( time );

	print STDERR "Sleeping for a sec while populating Doom...\n";
	sleep 1;

	my $dT = new Aw::Date;
	$dT->setDateCtime ( time );

	$basic{dt_array} = [ $dT, $dT, $dT, $dT ];

	my %basicA = %basic;
	my %basicB = %basic;

	my $doom           = \%basic;

	$doom->{st}        = \%basicA;
	$doom->{st}{st}    = \%basicB;

	my %structA        = %$doom;
	my %structB        = %$doom;
	my %structC        = %$doom;

	$doom->{st_array}  = [ \%structA, \%structB, \%structC ];

	my $client = shift;
	new Aw::Event ( $client, "Perl::EventOfDoom", $doom );
}



main: {

	my $broker_host = ( $ARGV[0] ) ? $ARGV[0] : "localhost";

	my $iStarted = 0;

	my $s = new Aw::Admin::ServerClient ( $broker_host );

	unless ( $s ) {
		print STDERR "Hrmm.. $broker_host doesn't seem to be running.\n";
		print STDERR "I'll try one shot at start it up for you ";
		print STDERR "this could take a few moments...\n";
		Aw::Admin::ServerClient::startProcess ( $broker_host ) || die;
		$s = new Aw::Admin::ServerClient ( $broker_host ) || die;
		$iStarted = 1;
	}

	my $status = $s->getProcessRunStatus ( $broker_host );

	if ( $status == -1 ) {
	}
	elsif ( $status <= 2 ) {
		print STDERR "Great!  Broker server is running just fine.\n";
	}
	else {
		print STDERR "The broker\n";
		die ( "Failed to start broker server on $broker_host" )
			if ( $s->startProcess ( $broker_host ) );

		$status = $s->getProcessRunStatus ( $broker_host );
		die ( "Failed to start broker server on $broker_host" ) if ( $status == -1 || $status > 2 );

		print STDERR "Broker server started...\n";
		$iStarted = 1;
	}

	my $broker_name = "Perl_CADK_Test";
	print STDERR "Creating our test broker '$broker_name'.\n";

	if ( grep /$broker_name/, map { $_->{broker_name}} $s->getBrokers ) {
		print STDERR "'$broker_name' is already up!?\n";
	}
	else {
		if ( $s->createBroker ( $broker_name, "A test broker, delete at any time.", 0 ) ) {
			# stop broker server if started
			$s->processStop if ( $iStarted );
			die();
		}
	}

	my $a = new Aw::Admin::Client ( $broker_host, $broker_name, "", "admin",
                "The Creator", "" ) || die "Admin Connection Failed\n";

	my $client_group_name = "GroupOfDoom";
	my $event_type_name   = "Perl::EventOfDoom";
	if ( grep /$client_group_name/, $a->getClientGroupNames ) {
		print STDERR "'$client_group_name' already exists!?\n";
	}
	else {
		print STDERR "Creating ClientGroup: $client_group_name";
		$a->createClientGroup ( $client_group_name, AW_LIFECYCLE_DESTROY_ON_DISCONNECT, AW_STORAGE_VOLATILE ) && die( "Could not create client group $client_group_name: $!" );

		print STDERR "Giving the ClientGroup a Description...";
		$a->setClientGroupDescription ( $client_group_name, "Just here for testing..." );

		#
		# subscribe list must be a list, since have only one add the [ ]
		#
		print STDERR "Adding $event_type_name publish permission to $client_group_name.\n";
		$a->setClientGroupCanPublishList ( $client_group_name, [ $event_type_name ] );
	}

	print STDERR "Creating a Client of our new ClientGroup:\n";
	my $c = new Aw::Client ( $broker_host, $broker_name, "", $client_group_name,
                "The Client Of Doom", "" ) || die "Client Connection Failed\n";

	print STDERR "Creating an Aw::Admin::TypeDef of Doom:\n";
	my $t = setEventOfDoomDef || die  "Failed to set Doom: $!";

	print STDERR "Doom is set:\n";
	print STDERR $t->toString, "\n";
		
	print STDERR "Writing Doom TypeDef to Broker:\n";
	die "We Have Failed to Define Doom $!\n" if ( $a->setEventAdminTypeDef ( $t ) );
	
	print STDERR "Creating an Aw::Event of Doom:\n";
	my $eod = setEventOfDoom ( $c ) || die "Failed to Create Doom: $!";

	print STDERR "We Have Doom!\n";
	print STDERR $eod->toString, "\n";

	print STDERR "Destroing Perl::EventOfDoom EventType on $broker_name\@$broker_host\n";
	$a->destroyEventType ( $event_type_name, 1 );      # 1 is "force"

	print STDERR "Destorying $client_group_name on $broker_name\@$broker_host\n";
	$a->destroyClientGroup ( $client_group_name, 1 );  # 1 is "force"

	print STDERR "Destorying $broker_name on $broker_host\n";
	$a->destroyBroker;  # strange this isn't also an Aw::Admin::ServerClient method

	print STDERR "Test Complete\n";
}


__END__

This test comes close to running "one of each" as far as class types go.

./eod-autotest.pl  myhost.net:6996

It starts the broker server you specify if not already running, creates a broker,
a client group, sets permissions, adds the dreaded EventOfDoom, connects a client
to the new group, creates a populated EventOfDoom and prints to prove it worked.
The event type, client group and broker are destroyed on the way out.
