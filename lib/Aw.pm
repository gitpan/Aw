package Aw;

use strict;
use Carp;
use vars qw($VERSION $VERSION_NAME @ISA @EXPORT @EXPORT_OK $AUTOLOAD $DefaultBrokerName $DefaultBrokerHost $SPAM);

$ENV{LD_LIBRARY_PATH} .= ':/opt/active40/lib:/opt/active40/samples/adapter_devkit/c_lib/'; # ':./blib/arch/auto/Aw';
# $ENV{'LD_PRELOAD'} = '/usr/local/users/yacob/Aw-0.12/blib/arch/auto/Aw.so';


require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.


@EXPORT = qw(
	AW_AUTO_SIZE
	AW_ACK_NONE
	AW_ACK_AUTOMATIC
	AW_ACK_THROUGH
	AW_ACK_SELECTIVE
	AW_CONNECT_STATE_CONNECTED
	AW_CONNECT_STATE_DISCONNECTED
	AW_CONNECT_STATE_RECONNECTED
	AW_ENCRYPT_LEVEL_NO_ENCRYPTION
	AW_ENCRYPT_LEVEL_US_DOMESTIC
	AW_ENCRYPT_LEVEL_US_EXPORT
	AW_ENTIRE_SEQUENCE
	AW_ERROR_BAD_STATE
	AW_ERROR_BROKER_EXISTS
	AW_ERROR_BROKER_FAILURE
	AW_ERROR_BROKER_NOT_RUNNING
	AW_ERROR_CLIENT_CONTENTION
	AW_ERROR_CLIENT_EXISTS
	AW_ERROR_CLIENT_GROUP_EXISTS
	AW_ERROR_COMM_FAILURE
	AW_ERROR_CONNECTION_CLOSED
	AW_ERROR_CORRUPT
	AW_ERROR_DEPENDENCY
	AW_ERROR_FIELD_NOT_FOUND
	AW_ERROR_FIELD_TYPE_MISMATCH
	AW_ERROR_FILE_NOT_FOUND
	AW_ERROR_FILTER_PARSE
	AW_ERROR_FILTER_RUNTIME
	AW_ERROR_FORMAT
	AW_ERROR_HOST_NOT_FOUND
	AW_ERROR_INCOMPATIBLE_VERSION
	AW_ERROR_INPUT_PARSE
	AW_ERROR_INTERRUPTED
	AW_ERROR_INVALID_ACCESS_LIST
	AW_ERROR_INVALID_ACKNOWLEDGEMENT
	AW_ERROR_INVALID_BROKER_NAME
	AW_ERROR_INVALID_CLIENT
	AW_ERROR_INVALID_CLIENT_GROUP_NAME
	AW_ERROR_INVALID_CLIENT_ID
	AW_ERROR_INVALID_DESCRIPTOR
	AW_ERROR_INVALID_EVENT
	AW_ERROR_INVALID_EVENT_TYPE_NAME
	AW_ERROR_INVALID_FIELD_NAME
	AW_ERROR_INVALID_FILTER
	AW_ERROR_INVALID_LICENSE
	AW_ERROR_INVALID_LOG_CONFIG
	AW_ERROR_INVALID_NAME
	AW_ERROR_INVALID_PERMISSION
	AW_ERROR_INVALID_PLATFORM_KEY
	AW_ERROR_INVALID_PORT
	AW_ERROR_INVALID_SUBSCRIPTION
	AW_ERROR_INVALID_TERRITORY_NAME
	AW_ERROR_INVALID_TYPE
	AW_ERROR_INVALID_TYPECACHE
	AW_ERROR_INVALID_TYPEDEF
	AW_ERROR_IN_TERRITORY
	AW_ERROR_NOT_IMPLEMENTED
	AW_ERROR_NOT_IN_TERRITORY
	AW_ERROR_NO_MEMORY
	AW_ERROR_NO_PERMISSION
	AW_ERROR_NULL_PARAM
	AW_ERROR_OUT_OF_RANGE
	AW_ERROR_PROTOCOL
	AW_ERROR_SECURITY
	AW_ERROR_SUBSCRIPTION_EXISTS
	AW_ERROR_TIMEOUT
	AW_ERROR_UNKNOWN
	AW_ERROR_UNKNOWN_BROKER_NAME
	AW_ERROR_UNKNOWN_CLIENT_GROUP
	AW_ERROR_UNKNOWN_CLIENT_ID
	AW_ERROR_UNKNOWN_EVENT_TYPE
	AW_ERROR_UNKNOWN_INFOSET
	AW_ERROR_UNKNOWN_KEY
	AW_ERROR_UNKNOWN_NAME
	AW_ERROR_UNKNOWN_SERVER
	AW_ERROR_UNKNOWN_SESSION_ID
	AW_ERROR_UNKNOWN_TERRITORY
	AW_INFINITE
	AW_NO_ERROR
	AW_NO_SHARE_LIMIT
	AW_PLATFORM_ANY
	AW_PLATFORM_HPUX
	AW_PLATFORM_IRIX
	AW_PLATFORM_SOLARIS
	AW_PLATFORM_WINDOWS
	AW_REPLY_FLAG_CONTINUE
	AW_REPLY_FLAG_END
	AW_REPLY_FLAG_START
	AW_REPLY_FLAG_START_AND_END
	AW_RETRIEVE_ALL
	AW_STORAGE_GUARANTEED
	AW_STORAGE_PERSISTENT
	AW_STORAGE_VOLATILE
	AW_TRANSACTION_LEVEL_ANY
	AW_TRANSACTION_LEVEL_BASIC
	AW_TRANSACTION_LEVEL_CONVERSATIONAL
	AW_TRANSACTION_LEVEL_NONE
	AW_TRANSACTION_LEVEL_PSEUDO
	AW_TRANSACTION_MODE_COMMIT
	AW_TRANSACTION_MODE_ROLLBACK
	AW_TRANSACTION_MODE_SAVEPOINT
	AW_VALIDATE_BAD_LICENSE
	AW_VALIDATE_BAD_PLATFORM
	AW_VALIDATE_BAD_PRODUCT
	AW_VALIDATE_BAD_VERSION
	AW_VALIDATE_EXPIRED
	AW_VALIDATE_OKAY
	AW_VERSION
	DEFAULT_TRANSACTION_TIMEOUT
	FIELD_TYPE_BOOLEAN
	FIELD_TYPE_BYTE
	FIELD_TYPE_CHAR
	FIELD_TYPE_DATE
	FIELD_TYPE_DOUBLE
	FIELD_TYPE_EVENT
	FIELD_TYPE_FLOAT
	FIELD_TYPE_INT
	FIELD_TYPE_LONG
	FIELD_TYPE_SEQUENCE
	FIELD_TYPE_SHORT
	FIELD_TYPE_STRING
	FIELD_TYPE_STRUCT
	FIELD_TYPE_UNICODE_CHAR
	FIELD_TYPE_UNICODE_STRING
	FIELD_TYPE_UNKNOWN
	CAT_BROKER
	CAT_ADAPTER
	CAT_MONITOR
	CAT_SYSTEM
	CAT_APPLICATION
	CAT_KERNEL
	CAT_TIMEOUT
	CAT_DEBUG
	CAT_FILLER9
	CAT_FILLER10
	MSG_GET_FAMILY_NAMES
	MSG_RETRIEVE_EVENT_TYPES
	ERR_BAD_LICENSE
	ERR_LICENSE_BAD_PLATFORM
	ERR_LICENSE_EXPIRED
	ERR_LICENSE_BAD_VERSION
	ERR_LICENSE_BAD_PRODUCT
	MSG_NO_REFRESH_FAMILY
	MSG_NOTIFICATION_NOT_SUPPORTED
	MSG_NO_CAN_SUBSCRIBE
	MSG_NO_CAN_PUBLISH_REPLY
	ERR_LICENSE_WILL_EXPIRE
	ERR_PUBLISH_ADAPTER_ERROR
	ERR_PUBLISH_STATUS
	MSG_DELIVER_STATUS
	ERR_CREATE_CLIENT
	ERR_SSL_DESCRIPTOR
	ERR_ADAPTER_SUBS
	ERR_GET_EVENTS
	ERR_PANIC
	MSG_CREATE_EVENT
	MSG_SUBSCRIPTION_ERROR
	ERR_SUBSCRIPTION_ERROR
	MSG_PUBLISH_ERROR
	MSG_DELIVER_ERROR
	MSG_DELIVER_REPLY_ERROR
	MSG_INFOSET_ENTRY_MISSING
	MSG_INFOSET_ENTRY_ERROR
	MSG_FIELD_SET_ERROR
	MSG_FIELD_SET_NOT_SUPPORTED
	MSG_GET_EVENT_FIELD
	MSG_SET_EVENT_FIELD
	MSG_FORMAT_ERROR
	MSG_NO_CAN_SUBSCRIBE_REPLY
	MSG_NO_CAN_PUBLISH
	MSG_NO_TYPE_DEF
	MSG_NO_TYPE_DEF_REPLY
	ERR_GET_ADAPTER_INFO
	GENERIC_ALERT
	GENERIC_WARNING
	GENERIC_INFO
	MSG_PUBLISH_REPLY_ERROR
	MSG_FORWARD_TO_SESSION
	MSG_FORWARD_SET_FIELDS
	MSG_FIELD_SET_NO_FORMAT
	PLACE_HOLDER38
	PLACE_HOLDER37
	PLACE_HOLDER36
	PLACE_HOLDER35
	PLACE_HOLDER34
	FORWARD_ERROR_REQUEST
	MSG_TRANSACTION_NOACK
	MSG_TRANSACTION_COMMIT_MISSING
	INFO_ADD_NOTIFY_EVENT
	INFO_ADD_REQUEST_EVENT
	INFO_RECEIVED_REQUEST
	INFO_TEST_BROKER
	INFO_PROCESS_PUBLICATION
	INFO_FORWARD_REQUEST
	INFO_CLEANUP_EVENTTYPE
	MSG_NO_TRANS_ID
	MSG_TRANS_LEVEL_MISMATCH
	MSG_TRANS_NOT_ACTIVE
	MSG_NO_TRANS_MODE
	MSG_TRANS_MODE_NOT_SUPPORTED
	MSG_TRANSACTION_TIMEOUT
	MSG_TRANSACTION_MODIFIED
	PLACE_HOLDER16
	PLACE_HOLDER15
	PLACE_HOLDER14
	PLACE_HOLDER13
	PLACE_HOLDER12
	PLACE_HOLDER11
	PLACE_HOLDER10
	PLACE_HOLDER9
	PLACE_HOLDER8
	PLACE_HOLDER7
	PLACE_HOLDER6
	PLACE_HOLDER5
	PLACE_HOLDER4
	PLACE_HOLDER3
	PLACE_HOLDER2
	PLACE_HOLDER1
);
$VERSION = '0.13.5';
$VERSION_NAME = 'Tadpole Ninja';
$DefaultBrokerName = 'test_broker';
# $DefaultBrokerHost = 'active';
# $DefaultBrokerName = 'Broker #1';
$DefaultBrokerHost = 'localhost:6449';
$SPAM = 0;


sub import {
my $pkg = shift;

	for ( my $i = 0; $i <= $#_; $i++ ) {
		$SPAM = 0 if ( $_[$i] =~ /^nospam$/i );
	}

 	setDefaultBroker ( @_ ) if ( @_ );
	Aw->export_to_level (1, $pkg, @EXPORT);  # this works too...
	#
	# Don't do this!  Resetting Exporter::ExportLevel _can_ hose other
	# packages using Exporter (such as POSIX, Data::Dumper).
	#
	# $Exporter::ExportLevel = 1;
	# Exporter::import ($pkg, @EXPORT);
}



sub setDefaultBroker {
my ( $name, $host ) = ($#_) ? ($_[0], $_[1]) : split ( "@", $_[0] );


	$DefaultBrokerName = $name if ($name);
	$DefaultBrokerHost = $host if ($host);

1;
}



sub setSpam {

	$SPAM = $_[0];

}



sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined Aw macro $constname";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Aw $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Aw - Perl extension for the ActiveWorks C Application Development Kit

=head1 SYNOPSIS

 use Aw;
 require Aw::Adapter;
 require Aw::Event;
 my %properties = (
        clientId	=> 'TimeAdapter',
        broker		=> "test\@active:7449",
        adapterId	=> 0,
        debug		=> 1,
        clientGroup	=> 'devkitAdapter',
        adapterType	=> 'Adapter40',
        messageCatalog	=> 'time_adapter'
 );

 my $adapter = new Aw::Adapter  ( \%properties ) ;
 my $event = new Aw::Event;

=head1 DESCRIPTION

  A Java like interface to the CADK thru Perl.

=head1 Exported Constants

Everything in the CADK include files I<should> be exported as constants.
  


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1). ActiveWorks Supplied Documentation>

=cut
