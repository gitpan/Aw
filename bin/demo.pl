#!/usr/bin/perl -w


use Aw;
require Aw::Adapter;
require Aw::Client;
require Aw::Event;

use HelloWorld;
use Data::Dumper;

my $EXIT_FAILURE = 1;

my ($false, $true) = (0,1);


sub MyDumper
{
	$_ = Dumper ( $_[0] );
	s/^(.*?)bless/bless/;
	$_;
}



sub getResponse
{
my $c = shift;

	my $e = $c->getEvent ( AW_INFINITE );

	unless ( $e ) {
		printf STDERR "%s\n", $c->errmsg;
		exit ( $EXIT_FAILURE );
	}

	my $eventName = $e->getTypeName; 
	print STDERR "Received a $eventName event\n";

	if ( $eventName eq "Adapter::ack" ) {
		my %eventData = $e->toHash;

		foreach my $key (sort keys %{$eventData{_env}}) {
			print STDERR "  $key => $eventData{_env}{$key}\n";
		}
	} else {
		print STDERR $e->toString;
	}

}



main:
{
my %Config = (
	# Adapter configuration structure.
	brokerName	=> 'test_broker',	#  Name of the broker.
	brokerHost 	=> 'active',		#  FQDN of the broker host.
	clientGroup	=> 'test',		#  Client group we're in.
	clientName	=> 'PerlDemo',		#  Name of client, for queueing.
	application	=> 'PerlDemo',		#  The application's name.
	adapterName	=> 'Perl Demo Adapter' 	#  The application's name.
);

my @arrayData = ( 'A', 'B', 'C' );
my %hashData  = ( structInt => 11, structString => "Hello From Struct B" );

my %FieldData = (
    booleanDemo		=>	$false,
    charDemo		=>	'Z',
    # dateDemo		=>	'2000-1-10',
    floatDemo,		=>	123.456,
    intDemo,		=>	123456,
    stringDemo		=>	"Hello World",
    stringSeqDemo	=>	[ "One", "Two", "Three" ],
    intSeqDemo		=>	[10,20,30,40,50],
    charSeqDemo		=>	\@arrayData,
    structADemo		=>	{ structInt => 99, structString => "Hello From Struct A" },
    structBDemo		=>	\%hashData,
    structCDemo		=>	{
					# charSeqDemo	=> \@arrayData
					# charSeqDemo	=> [ 'X', 'Y', 'Z' ]
					intSeqDemo	=> [ 1, 2, 3, 4, 5 ]
					# structInt	=> 33,
					# structString 	=> "Hello From Struct C"
				},
    structDDemo		=>	{
					structInt	=> 55,
					structADemo	=> { 
								structInt => 11,
								structString => "Hello From StructD:A"
							   } 
				}
);

%MoreData = (
	intA		=> 11,
	structA		=>	{
				intB		=> 22,
				structB		=> { 
							intC	=> 33,
							stringC	=> "Hello From StructB"
						   } 
				}
);


# my $eventName = "AdapterDevKit::PerlDemo";
my $eventName = "AdapterDevKit::PerlDemo2";
# my $eventName = "Ia::TestEvent";
my %TestEventData = (
			services => [
				{ service => "RIM", action => "DEL", args => "a=b,c=d" },
				{ service => "MAIL", action => "ACT", args => "a=b,c=d" },
				{ service => "WEB", action => "CRE", args => "a=b,c=d" },

				]
                    );

	my $world = new HelloWorld;
	$world->store(5);
	$MoreData{structA}{structB}{stringC} = MyDumper ( $world );
	undef ( $world );

	my $eventTime = new Aw::Date;
	$eventTime->setDateCtime ( time );
	$FieldData{dateDemo} = $eventTime;


	#  Create the client object, and check if we can publish to the
	#  supplied event.
	#
	# my $c = connect Aw::Client ( \%Config );
	my $c = Aw::Client::connect  ( \%Config );
	
	
	unless ( $c->canPublish ( $eventName ) ) {
		printf STDERR "Cannot publish to %s: %s\n", $eventName, $c->errmsg;
		exit ( $EXIT_FAILURE );
	}


	#  Create a new broker Event.
	#
	# my $e = new Aw::Event ( $c, $eventName, \%FieldData );
	my $e = new Aw::Event ( $c, $eventName, \%MoreData );
	# my $e = new Aw::Event ( $c, $eventName, %TestEventData );
	# my $e = new Aw::Event ( $c, $eventName );
	unless ( $e ) {	
		print STDERR $e->errmsg, "\n";
		exit ( $EXIT_FAILURE );
	}

	# $e->init ( \%TestEventData );


	#  Now that all event strings are set, publish the event to
	#  the broker.
	#  Then display the event as text once published.
	#
	if ( $c->deliver ( $Config{adapterName}, $e ) ) {
		print STDERR $c->errmsg;
		exit ( $EXIT_FAILURE );
	} else {
		print "Published a $eventName event.\n";
		print $e->toString, "\n";
	}

	getResponse ( $c );

	exit ( 0 );
}
