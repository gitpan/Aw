
print STDERR "Using compatibility macros/routines for Perl 5.004\n"
    if ($] < 5.0045);



use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	'NAME'		=> 'Aw',
	'VERSION_FROM'	=> 'Aw.pm', # finds $VERSION
	'DEFINE'	=>
		($] < 5.0045 ? '-DPERL5004_COMPAT -DAWXS_WARNS' : '-DAWXS_WARNS'),
	#
	# Uncomment for 3.0
	#
	# 'LIBS'	=> ['-L/opt/active30/samples/adapter_devkit/c_lib -lcustcadk30 -L/opt/active30/lib -lawalog30 -lawl30 -lawc30 -lsocket -lnsl'],
	# 'INC'		=> '-I./include -I/opt/active30/include -I/opt/active30/samples/adapter_devkit/c_lib',
	#
	# Uncomment for 4.0
	#
	'LIBS'	=> ['-L/opt/active40/samples/adapter_devkit/c_lib -lcustcadk31 -L/opt/active40/lib -lawcadk31 -lawalog40 -lawl40 -lawc40 -lsocket -lnsl'],
	'INC'		=> '-I./include -I/opt/active40/include -I/opt/active40/samples/adapter_devkit/c_lib',
	'OBJECT'	=> '$(O_FILES)',
	'dist'		=> { COMPRESS=>"gzip", SUFFIX=>"gz" }
);
