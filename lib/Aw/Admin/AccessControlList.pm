package Aw::Admin::AccessControlList;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

require Aw::Admin;



sub getUserNames
{
	my $result = Aw::Admin::Client::getUserNamesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getAuthNames
{
	my $result = Aw::Admin::Client::getAuthNamesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



#########################################################
# Do not change this, Do not put anything below this.
# File must return "true" value at termination
1;
##########################################################


__END__

=head1 NAME

Aw::Admin::AccessControlList - ActiveWorks AccessControlList Module.

=head1 SYNOPSIS

require Aw::Admin::AccessControl;

my $acl = new Aw::Admin::AccessControl;


=head1 DESCRIPTION

Enhanced interface for the Aw/Admin.xs AccessControlList methods.


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1).  Aw(3).>

=cut
