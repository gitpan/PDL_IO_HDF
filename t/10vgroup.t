#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use strict;
use Data::Dumper;

# Vdata test suite

my $res;

#my $file = "/home/foehn/pleilde/rud/04043.20001671208.QO.rud.HDF";
#my $file = "/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf";
my $file = "montest.HDF";
#my $file = "/home/bart/tmp/oarcher/QW/concat/c199929.rud.HDF";
#print "1..1\n";
# vdata OO interface test suite

my $vOBJ=PDL::IO::HDF::VS->new("+$file");

$res = $vOBJ->Vcreate('polux2','class2','polux');
print "res create = $res\n";

print Data::Dumper->Dump([$vOBJ->{VGROUP}], [qw(vOBJ->{VGROUP})]);

my @Vmains = $vOBJ->Vgetmains();
foreach(@Vmains)
  {
#    print "main : $_\n";
    my @Vchilds = $vOBJ->Vgetchilds($_);
    if( defined $Vchilds[0] )
      {
	foreach(@Vchilds)
	  {
#	    print "\tchilds : $_\n";
	  }
      }
  }


$res = $vOBJ->close;
#if ($res) {print "ok 1\n";} else {print "not ok 1\n";}




