package Aw::Event;


my ( $types, %TypeMap );

BEGIN
{
	use strict;
	use vars qw($VERSION);

	$VERSION = '0.1';

	use Aw;

	$types = "((boolean)|(byte)|(char)|(date)|(double)|(float)|(int)|(long)|(short)|(string))";

	%TypeMap = (
		boolean	=> FIELD_TYPE_BOOLEAN,
		byte	=> FIELD_TYPE_BYTE,
		char	=> FIELD_TYPE_CHAR,
		date	=> FIELD_TYPE_DATE,
		double	=> FIELD_TYPE_DOUBLE,
		float	=> FIELD_TYPE_FLOAT,
		'int'	=> FIELD_TYPE_INT,
		long	=> FIELD_TYPE_LONG,
		short	=> FIELD_TYPE_SHORT,
		string	=> FIELD_TYPE_STRING
	);
}



sub new
{
my $self = undef;

	if ( @_ == 3 || ( @_ == 4 && ref($_[3]) eq "HASH" ) ) {
		$self = Aw::Event::_new ( @_ );
	} elsif ( @_ >= 4 ) {
		# we are passed at least 4 elements, the 4th is not a ref
		my ( $class, $client, $event_type_name ) = ( shift, shift, shift );
		my %hash = @_;
		$self = Aw::Event::_new ( $class, $client, $event_type_name, \%hash );
	} else {
		croak("Usage: Aw::Event::new(self, client, event_type_name, [hash_data])");
	}


	$self;
}



sub getEnvelope
{
	my $result = $_[0]->getField ( "_env" );
	(wantarray) ? %{$result} : $result ;
}



sub toHash
{
	my $result = Aw::Event::toHashRef ( @_ );
	(wantarray) ? %{$result} : $result ;
}



sub toHashOld
{
my $self = shift;


	$_ = $self->toString;
	# print "======================================\n";
	# print $_;
	s/^event (.*?) \{$/( _name => '$1',/m;
	s/^(\s+)$types /$1/mg;
	s/^(.*?) = /$1 => /mg;
	s/;$/,/mg;

	s/^(\s+)struct \{(.*?)\} (\w+(\[\])? =>)/$1$3/smg;
	# s/^(\s+)struct \{(.*?)\}\s+(\w+ =)/$1$3/smg;

	#
	# don't think [] appear else where but lets enforce the
	# => context here.
	#
	s/^(\s+)(\w+)\[\] => \{(.*?)\n\1\}/$1$2 => [$3\n$1]/osmg;


	#
	# this works on perl 5.005_62
	#
	# s/^(\s+)(\w+) => \{(\s+)\{(.*?)\3\}\n\1};/$1$2 => [$3\{$4$3\}\n$1];/osmg;
	#
	# use this for now
	#
	s/^(\s+)(\w+) => \{(\s+)\{/$1$2 => [$3\{/mg;
	s/(\s+)\}(\s+)},/$1\}$2],/mg;


	#
	# brackets with nothing being hashed is an array.
	#
	# s/^(\s+)(\w+) => \{((=(?!> ))*?)\n\1\}/$1$2 => [$3\n$1]/osmg;
	#

	#
	# the above is not working but we notice that AW denotes the
	# start of an array with "{ \n" and the start of a struct with
	# "{\n".  So we look for the tell tale " " and pray that AW
	# does not change this in the future (damn it's subtle!).
	#
	s/^(\s+)(\w+) => \{ \n(.*?)\n\1\}/$1$2 => [\n$3\n$1]/osmg;


	# 
	#  this works but chokes when the pattern nests within itself at
	#  greater indention, check some books on this.  Haven't tried
	#  it since the "{ \n" discover (though the code is updated for it).

	# s/^(\s+)(\w+) => \{ \n(.*?)\n\1\}/
	# 	my ($a,$b,$c) = ($1,$2,$3);
	# 	# print "  C => $c\n";
	# 	my ($l,$r)    = ( $c =~ m# => # ) ? ('{','}') : ('[',']');
	# 	"$a$b => $l$c\n$a$r"/osmge;

	s/((true)|(false))/"$1"/g;
	s/([\%\$\@])/\\$1/g;
	s/,(\s+\})/$1/sg;
	s/\},$/)/;

	# print "======================================\n";
	# print $_;
	# print "======================================\n";
	eval ($_);
}



sub getFIELD
{
	my $result = {};

	$result->{type}  = Aw::Event::getFieldType (@_);
	$result->{value} = Aw::Event::getField (@_);

	( wantarray ) ? %{ $result } : $result ;
}



sub getFieldAndType
{
	Aw::Event::getFIELD ( @_ );
}



sub getField
{

	my $result = Aw::Event::getFieldRef ( @_ );

	if ( wantarray ) {
		if ( ref($result) eq "HASH" ) {
			return ( %{ $result } );
		}
		return ( @{ $result } );
	}

	$result;
}



sub update
{
my $block = shift;
my $struct;

	$block =~ s/^\{\n(.*?)\n(\s+)\} //sm;
	$struct = "$1";
	$struct =~ s/(\w+) (\w+)/   $2 => "$1"/g;
	$block =~ s/(\w+)\[\] => \{/$1 => \[/mg;
	$block =~ s/(\s+\{\n)(.*?)(\n\s+\})/$1$struct$3/smg;

	$block;
}



sub toTypedHash
{
my $self = shift;


	$_ = $self->toString;
	s/^event (.*?) \{$/(/m;
	# s/^(\s+)$types (\w+) = (.*);$/$1$7 = "$2",/mg;
	s/^(\s+)$types (\w+) = (.*);$/$1$7 = $TypeMap{$2},/mg;
	s/ = / => /mg;
	s/;$/,/mg;

	s/^(\s+)struct (.*?)\n\1\},$/$1 . update($2)  . "\n$1],"/smge;

	s/((true)|(false))/"$1"/g;
	s/\@/\\@/g;
	s/,(\s+\})/$1/sg;
	s/},$/)/;
	eval ($_);
}



sub getClientId
{

	$_[0]->getStringField ( "_env.pubId" );
}



sub getStructFieldAsHash
{
	my $sfEvent = Aw::Event::getStructFieldAsEvent ( @_ );
	$sfEvent->toHash;
}



sub getStructFieldAsTypedHash
{
	my $sfEvent = Aw::Event::getStructFieldAsEvent ( @_ );
	$sfEvent->toTypedHash;
}



sub getFieldNames
{
	my $result = Aw::Event::getFieldNamesRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getSequenceField
{
	my $result = Aw::Event::getSequenceFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getBooleanSeqField
{
	my $result = Aw::Event::getBooleanSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getByteSeqField
{
	my $result = Aw::Event::getByteSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getCharSeqField
{
	my $result = Aw::Event::getCharSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getDateSeqField
{
	my $result = Aw::Event::getDateSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getDoubleSeqField
{
	my $result = Aw::Event::getDoubleSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getFloatSeqField
{
	my $result = Aw::Event::getFloatSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getIntegerSeqField
{
	my $result = Aw::Event::getIntegerSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getLongSeqField
{
	my $result = Aw::Event::getLongSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getShortSeqField
{
	my $result = Aw::Event::getShortSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getStringSeqField
{
	my $result = Aw::Event::getStringSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getUCCharSeqField
{
	my $result = Aw::Event::getUCCharSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getUCStringSeqField
{
	my $result = Aw::Event::getUCStringSeqFieldRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getStructSeqFieldAsEvents
{
	my $result = Aw::Event::getStructSeqFieldAsEventsRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub getSubscriptionIds
{
	my $result = Aw::Event::getSubscriptionIdsRef ( @_ );
	( wantarray ) ? @{ $result } : $result ;
}



sub setField
{
my ($self, $fieldName) = (shift, shift);


	return ( $self->init ( $fieldName ) )
		if ( ref($fieldName) eq "HASH" );     #  $fieldName was actually a Hash.


	my $ref = ref ( $_[0] );
	return $self->_setField ( $fieldName, $_[0] ) unless ( $ref || @_ > 1 );

	if ( $ref eq "ARRAY" ) {
		return $self->setSequenceField ( $fieldName, $_[0] );
	} elsif ( @_ > 1 ) {
		return $self->setSequenceField ( $fieldName, \@_ );
	} elsif ( $ref eq "HASH" ) {
		return $self->_setField ( $fieldName, $_[0] );
	}

}



#########################################################
# Do not change this, Do not put anything below this.
# File must return "true" value at termination
1;
##########################################################


__END__

=head1 NAME

Aw::Event - ActiveWorks Event Module.

=head1 SYNOPSIS

require Aw::Event;

my $event = new Aw::Event;


=head1 DESCRIPTION

Enhanced interface for the Aw.xs Event methods.


=head1 AUTHOR

Daniel Yacob Mekonnen,  L<Yacob@RCN.Com|mailto:Yacob@RCN.Com>

=head1 SEE ALSO

S<perl(1).  Aw(3).>

=cut
