#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF::SD;
use PDL::IO::HDF::VS;
use strict;
use Data::Dumper;

# Compression d'un dataset

#print "1..3\n";

$|=1;

&start;

sub start
  {
#    my $H = PDL::IO::HDF->new("/home/foehn/pleilde/rud/04043.20001671208.QO.rud.HDF");
    my $Hsd = PDL::IO::HDF::SD->new("/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf");
    my $Hvs = PDL::IO::HDF::VS->new("/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf");
#    print Data::Dumper->Dump([$H], [qw(H)]);

    my @dataset = $Hsd->SDgetvariablename();
    my @globattr = $Hsd->SDgetattributname();

    print ">>Global attributs :\n";
    foreach(@globattr)
      {
	my $curattr = $Hsd->SDgetattribut($_);
	my @Lattr = split("\n", $curattr);
	print "\t$_ = \n";
	foreach(@Lattr)
	  {
	    print "\t\t$_\n";
	  }
      }
    print ">>Datasets :\n";
    foreach(@dataset)
      {
	print "\t$_\n";
	my $curdata = $_;
	print "\t\tdimensions : \n";	
	my @dimname = $Hsd->SDgetdimname($_);
	my @dimsize = $Hsd->SDgetdimsize($_);
	my @dimsizeU = $Hsd->SDgetdimsizeunlimit($_);
	foreach(my $i=0; $i<=$#dimsize; $i++)
	  {
	    if($dimsize[$i]==0)
	      {
		print "\t\t\t$curdata:$dimname[$i] = $dimsizeU[$i] (UNLIMITED)\n";
	      }else{
		print "\t\t\t$curdata:$dimname[$i] = $dimsize[$i]\n";
	      }
	  }
	print "\t\tlocal attributs : \n";
	my @locattr = $Hsd->SDgetattributname($_);
	foreach(@locattr)
	  {
	    my $curattr = $Hsd->SDgetattribut($_,$curdata);
	    print "\t\t\t$curdata:$_ = $curattr\n"
	  }
      }
    my @Vname = $Hvs->VSgetnames();
    print ">>VData :\n";
    foreach(@Vname)
      {
	print "\t$_\n";
	my $curvdata = $_;
	my @Vfieldname = $Hvs->VSgetfieldsnames($_);
	foreach(@Vfieldname)
	  {
	    my $val = $Hvs->VSread($curvdata,$_);
	    if($curvdata eq 'mid_line_tie_points')
	      {
		print "\t\t$_ : $val\n";
	      }else{
		if($val->nelem>1)
		  { print "\t\t$_ : too much values\n"; }
		else{ print "\t\t$_ = $val\n"; }
	      }
	  }
      }
#    print Data::Dumper->Dump([$H], [qw(H)]);

    $Hsd->close();
    $Hvs->close();
    exit;
  }

