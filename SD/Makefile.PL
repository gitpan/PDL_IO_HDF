
# Makefile.PL for PDL::Primitive module.

# Use this as a template for the Makefile.PL for
# any external PDL module.

use PDL::Core::Dev;
use ExtUtils::MakeMaker;

use Config;


$package = ["SD.pd",SD,PDL::IO::HDF::SD];
WriteMakefile(
              'NAME'         => 'PDL::IO::HDF::SD',
#              'CCFLAGS'      => "$define_bool -g",  
              'TYPEMAPS'     => [&PDL_TYPEMAP()], 
              'OBJECT'       => 'SD.o ',
              'PM'           => { 'SD.pm' => '$(INST_LIBDIR)/SD.pm'},
              'INC'          => &PDL_INCLUDE()." -I$hdf_include_path", 
              'LIBS'         => ["-L$hdf_lib_path -lmfhdf -ldf -ljpeg -lz"],  
              'clean'        => {'FILES'  => 
                                   'SD.pm SD.xs SD.o SD.c'},
              'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' }, 
              );

sub MY::postamble { pdlpp_postamble($package); }        

