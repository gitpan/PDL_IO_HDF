
# Makefile.PL for PDL::Primitive module.

# Use this as a template for the Makefile.PL for
# any external PDL module.

use PDL::Core::Dev;
use ExtUtils::MakeMaker;

use Config;

$package = ["VS.pd",VS,PDL::IO::HDF::VS];
WriteMakefile(
              'NAME'         => 'PDL::IO::HDF::VS',
#              'CCFLAGS'      => "$define_bool -g",  
              'TYPEMAPS'     => [&PDL_TYPEMAP()], 
              'OBJECT'       => 'VS.o ',
              'PM'           => { 'VS.pm' => '$(INST_LIBDIR)/VS.pm'},
              'INC'          => &PDL_INCLUDE()." -I$hdf_include_path", 
              'LIBS'         => ["-L$hdf_lib_path -lmfhdf -ldf -ljpeg -lz"],  
              'clean'        => {'FILES'  => 
                                   'VS.pm VS.xs VS.o VS.c'},
              'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' }, 
              );

sub MY::postamble { pdlpp_postamble($package); }        

