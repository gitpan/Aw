#!/usr/bin/perl -w

use strict;

use Aw;
use Aw::Admin;

my %basic	=(
	#
	# all of the '_' fields are optional, they can be set at any
	# time with the respective ->set* methods
	#
	_name		=> "Perl::EventOfDoom",
	_description	=> "If this works, nothing can break me!",
	_timeToLive	=> 50,
	#
	# use a name or AW_STORAGE constant
	#
	# _storageType	=> AW_STORAGE_PERSISTENT,
	_storageType	=> "Guaranteed",

	#
	#  simple types, 's' and 'uc' are quoted because the
	#  have special meanings in perl:
	#
	b 	=> FIELD_TYPE_BOOLEAN,
	by	=> FIELD_TYPE_BYTE,
	c	=> FIELD_TYPE_CHAR,
	d	=> FIELD_TYPE_DOUBLE,
	dt	=> FIELD_TYPE_DATE,
	l	=> FIELD_TYPE_LONG,
	f	=> FIELD_TYPE_FLOAT,
	i	=> FIELD_TYPE_INT,
	's'	=> FIELD_TYPE_STRING,
	sh	=> FIELD_TYPE_SHORT,
	'uc'	=> FIELD_TYPE_UNICODE_CHAR,
	us 	=> FIELD_TYPE_UNICODE_STRING,
	x	=> { x_key => FIELD_TYPE_LONG },

	#
	#  only one element of an array need be populated to setup
	#  sequence definition:
	#
	b_array		=> [ FIELD_TYPE_BOOLEAN        ],
	by_array	=> [ FIELD_TYPE_BYTE           ],
	c_array		=> [ FIELD_TYPE_CHAR           ],
	d_array		=> [ FIELD_TYPE_DOUBLE         ],
	dt_array	=> [ FIELD_TYPE_DATE           ],
	l_array		=> [ FIELD_TYPE_LONG           ],
	f_array		=> [ FIELD_TYPE_FLOAT          ],
	i_array		=> [ FIELD_TYPE_INT            ],
	s_array		=> [ FIELD_TYPE_STRING         ],
	sh_array	=> [ FIELD_TYPE_SHORT          ],
	uc_array	=> [ FIELD_TYPE_UNICODE_CHAR   ],
	us_array	=> [ FIELD_TYPE_UNICODE_STRING ],
	x_array		=> [ { x_item_key => FIELD_TYPE_LONG } ] 
);


my %basicA = %basic;
my %basicB = %basic;

my $doom           = \%basic;


#
#  if %basicA was NOT a _copy_ of %basic and the next line was $doom->{st} = \%basic; 
#  the type def setup would loop endlessly.
#
$doom->{st}        = \%basicA;
$doom->{st}{st}    = \%basicB;

my %structA        = %$doom;
$doom->{st_array}  = [ \%structA ];


#
#  setup an anonymous struct: 
#
#  this might look a little awkward..
#  since we are being efficient and recycling %basicA here as a copy of %basic
#  but actually setting up a FIELD_TYPE_STRUCT we need to eliminate the _keys
#  to avoid triggering the automatic ->set* calls which would throw an error when
#  applied to a STRUCT type:
#
delete($basicA{_name});
delete($basicA{_description});
delete($basicA{_timeToLive});
delete($basicA{_storageType});

my $tt = new Aw::Admin::TypeDef ( FIELD_TYPE_STRUCT, \%basicA );
$doom->{type_def} = $tt;
$doom->{type_def_array} = [ $tt ];


#
#  instantiate the mother load and run for cover!
#
my $t = new Aw::Admin::TypeDef ( $doom );

#
#  or do in two steps, if you likes more typing:
#
#  my $event_type_name = "Fp::EventOfDoom";	
#  my $t = new Aw::Admin::TypeDef ( $event_type_name, $doom );
#  my $t = new Aw::Admin::TypeDef ( $event_type_name, EVENT_TYPE_EVENT, $doom );
#

print $t->toString, "\n";


#
#  if you want to write this mess to a broker:
#
#  my $c = new Aw::Admin::Client ( $broker_host, $broker_name, "", "admin",
#          "The Creator", "" ) || die "Broker Connection Failed: $@\n";
#
#  $c->setEventAdminTypeDef ( $t );
#
#  GUIs?  We don't need no stink'n GUIs!!