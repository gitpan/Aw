package Aw::Admin;

use strict;
use Carp;
use vars qw($VERSION $VERSION_NAME @ISA @EXPORT @EXPORT_OK $AUTOLOAD $DefaultBrokerName $DefaultBrokerHost $SPAM);

$ENV{LD_LIBRARY_PATH} .= ':/opt/active40/lib:/opt/active40/samples/adapter_devkit/c_lib/';


require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.


$VERSION = '0.13.4';
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
		croak "Your vendor has not defined Aw::Admin macro $constname";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Aw::Admin $VERSION;

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

my $adapter = new Aw::Adapter  ( "3.0", ) ;
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
