package HelloWorld;
use base qw(Exporter);

$VERSION = '0.2';


require 5.000;


sub new
{
my $class = shift;
my $self  = {};

    bless $self, $class;

}


sub speak
{
	print "Hello World\n";
}


sub store
{
my $self = shift;
	
	$self->{data} = shift;
}


sub showData
{
my $self = shift;

	print $self->{data}, "\n";
}


sub run
{
my $self = shift;

	$self->speak;
	$self->showData;
}



#########################################################
# Do not change this, Do not put anything below this.
# File must return "true" value at termination
1;
##########################################################


__END__
