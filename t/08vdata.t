#!/usr/bin/perl -w

use PDL;
#use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use Data::Dumper;
use strict;

print "1..1\n";
# vdata OO interface test suite

#my $vdataOBJ=new 'PDL::IO::HDF::VS', '/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf';
my $vdataOBJ=PDL::IO::HDF::VS->new('/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf');
my @vnames=$vdataOBJ->VSgetnames;
foreach my $name ( @vnames ) { 
  print "name: $name\n";
  my @fields=$vdataOBJ->VSgetfieldsnames($name);
  foreach ( @fields ) {
    print "   $_\n";
    my $data=$vdataOBJ->VSread($name,$_);
    print "     " . $data->info . "\n";
    print "        " . $data ."\n";
  }
    
};

print Data::Dumper->Dump([$vdataOBJ], [qw(vdataobj)])."\n";

print "ok 1\n";

#my $vdataOBJ=new 'PDL::IO::HDF', 'test.HDF';
