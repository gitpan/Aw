
print STDERR "Using compatibility macros/routines for Perl 5.004\n"
    if ($] < 5.0045);



use ExtUtils::MakeMaker;
use Config;

use Cwd;
my $pwd = fastcwd;
$MY_LD_RUN_PATH = "$Config{installsitearch}/auto/libawperl:$pwd";


WriteMakefile(
	'NAME'		=> 'libawperl',
	'VERSION_FROM'	=> '../lib/Aw.pm', # finds $VERSION
	'LINKTYPE'	=> 'static',
	#
	# Uncomment for 3.0
	#
	# 'LIBS'	=> ['-L/opt/active30/samples/adapter_devkit/c_lib -lcustcadk30 -L/opt/active30/lib -lawalog30 -lawl30 -lawc30 -lsocket -lnsl'],
	# 'INC'		=> '-I./../include -I/opt/active30/include -I/opt/active30/samples/adapter_devkit/c_lib',
	#
	# Uncomment for 4.0
	#
		#'LIBS'	=> ['-L/opt/active40/samples/adapter_devkit/c_lib -lcustcadk31 -L/opt/active40/lib -lawcadk31 -lawalog40 -lawl40 -lawc40 -lsocket -lnsl'],
	'INC'		=> '-I../include -I/opt/active40/include -I/opt/active40/samples/adapter_devkit/c_lib',
	'OBJECT'	=> '$(O_FILES)',
	'AUTHOR'	=> "Daniel Yacob <Yacob\@wMUsers.Com>",
	'ABSTRACT'	=> "Interface to the ActiveWorks Libraries.",
);

$ENV{LD_RUN_PATH} = 
    "$ENV{LD_RUN_PATH}:$Config{installsitearch}/auto/libawperl:$pwd";

sub MY::top_targets {
    my $self = shift;
    my $string = $self->MM::top_targets;
    my $libapreq = <<"EOF";
LD_RUN_PATH = $ENV{LD_RUN_PATH}
EOF

    my $so = "\n".'$(DLBASE).$(DLEXT): $(INST_DYNAMIC)'."\n";

    $string =~ s/(pure_all\s+::\s+)(.*)/$1 static $2/;
    return $libawperl . $so . $string;
}



sub no_MY {
    for (keys %MY::) {
        if (defined &{ $MY::{$_} }) {
            next if $_ eq 'dynamic';
            undef &{ $MY::{$_} };
            delete $MY::{$_};
        }
    }
}
