package Aw::Admin::TypeDef;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

require Aw::Admin;



sug getFieldNames
{
	my $result = Aw::Admin::TypeDef::getFieldNamesRef ( @_ )
	( wantarray ) ? @{ $result } : $result ;
}



#########################################################
# Do not change this, Do not put anything below this.
# File must return "true" value at termination
1;
##########################################################


__END__

=head1 NAME

Aw::Admin::TypeDef - ActiveWorks TypeDef Module.

=head1 SYNOPSIS

require Aw::Admin::TypeDef;

my $typedef = new Aw::Admin::TypeDef;


=head1 DESCRIPTION

Enhanced interface for the Aw/Admin.xs TypeDef methods.


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1).  Aw(3).>
