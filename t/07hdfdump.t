#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use strict;
use Data::Dumper;

# Compression d'un dataset

print "1..1\n";

$|=1;

&start;

sub start
  {
#    my $H = PDL::IO::HDF->new("montest.HDF");
#    my $H = PDL::IO::HDF->new("montest2.HDF");

#    my $H = PDL::IO::HDF->new("/home/foehn/pleilde/rud/04043.20001671208.QO.rud.HDF");
    my $H = PDL::IO::HDF->new("/espace/SAR/bchapron/BSAR/db/EnviSAT/ers_wvs_1pxpde19970601_125242_00000600a015_00410_07424_0072.hdf");
#    print Data::Dumper->Dump([$H], [qw(H)]);

    my @dataset = $$H{SD}->SDgetvariablename();
    my @globattr = $$H{SD}->SDgetattributname();

    print ">>Global attributs :\n";
    foreach(@globattr)
      {
	my $curattr = $$H{SD}->SDgetattribut($_);
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
	my @dimname = $$H{SD}->SDgetdimname($_);
	my @dimsize = $$H{SD}->SDgetdimsize($_);
	my @dimsizeU = $$H{SD}->SDgetdimsizeunlimit($_);
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
	my @locattr = $$H{SD}->SDgetattributname($_);
	foreach(@locattr)
	  {
	    my $curattr = $$H{SD}->SDgetattribut($_,$curdata);
	    print "\t\t\t$curdata:$_ = $curattr\n"
	  }
      }
    my @Vname = $$H{VS}->VSgetnames();
    print ">>VData :\n";
    foreach(@Vname)
      {
	if(!$$H{VS}->VSisattr($_))
	  {
	    print "\t$_\n";
	    my $curvdata = $_;
	    my @Vfieldname = $$H{VS}->VSgetfieldsnames($_);
	    foreach(@Vfieldname)
	      {
		my $val = $$H{VS}->VSread($curvdata,$_);
		if($val->nelem>10)
		  { print "\t\t$_ : too much values\n"; }
		else{ print "\t\t$_ = $val\n"; }
		if($_ eq 'attach_flag'){print "**** $val\n";}
	      }
	  }
      }
#    print Data::Dumper->Dump([$H], [qw(H)]);

    $H->close();
    print "ok 1\n";
  }

