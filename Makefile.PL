#Makefile.PL for a package defined by PP code.

use PDL::Core::Dev;            # Pick up development utilities
use ExtUtils::MakeMaker;
use Config;

# 
## Search for netcdf library and include file
#

foreach my $libdir (
                    '/usr/local/netcdf/lib',
                    '/usr/local/lib',
                    '/opt/local/lib',
                    '/usr/lib',
                    '/opt/lib',
		    '/home/nino/linux_os/logiciels/hdf4.1r4/lib',
		    '/home/logiciels/hdf4.1r4/lib'
                                  # Add new library paths here!!
		   ) {
  
  if (-e "$libdir/libdf.a") {
    $hdf_lib_path = $libdir;
    print "Found libdf.a at $libdir/libdf.a\n";
    last;
  }

}

die "Cannot find hdf library, libdf.a.  
Please add the correct library path to Makefile.PL or install HDF" 
  unless defined ($hdf_lib_path);

foreach my $incdir (
                    '/usr/local/netcdf/include',
                    '/usr/local/include',
                    '/opt/local/include',
                    '/usr/include',
                    '/opt/include',
		    '/home/nino/linux_os/logiciels/hdf4.1r4/include',
		    '/home/logiciels/hdf4.1r4/include'
                                  # Add new header paths here!!
                    ) {

  if (-e "$incdir/hdf.h") {
    $hdf_include_path = $incdir;
    print "Found hdf.h at $incdir/hdf.h\n";
    last;
  }
}

die "Cannot find hdf header file, hdf.h.
Please add the correct library path to Makefile.PL or install Hdf" 
  unless defined ($hdf_include_path);


#print "\ninstall lib dir : ".$(INST_LIBDIR)."\n";
#$package = ["HDF.pd",HDF,PDL::IO::HDF];
WriteMakefile(
              'NAME'         => 'PDL::IO::HDF',
              'CCFLAGS'      => "$define_bool -g",  
              'VERSION_FROM' => 'HDF.pm',
              'TYPEMAPS'     => [&PDL_TYPEMAP()], 
              'PM'           => { 'HDF.pm' => '$(INST_LIBDIR)/HDF.pm'},
              'INC'          => &PDL_INCLUDE()." -I$hdf_include_path", 
              'LIBS'         => ["-L$hdf_lib_path -lmfhdf -ldf -ljpeg -lz"],  
              'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' }, 
	      'DIR'          => ['SD','VS'],
              );

sub MY::postamble { pdlpp_postamble($package); }        

