package Aw::Admin::LogInfo;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

use Aw::Admin;



sub getLogOutputsRef
{
	my $result = Aw::Admin::Client::getLogOutputs ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}

1;

__END__

