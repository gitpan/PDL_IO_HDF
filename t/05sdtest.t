#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF::SD;
use strict;

use Data::Dumper;
	
print "1..16\n";
my $ntest = 1;
my $res;

    ### Creating and writing to a HDF file

    #Create an HDF file
    my $SDobj = PDL::IO::HDF::SD->new("-montest.HDF");

    #Define some data
    my $data = PDL::short( sequence(500,5) );

    #Put data in file as 'myData' dataset
    #with the names of dimensions ('dim1' and 'dim2')
    $res = $SDobj->SDput("myData", $data , ['dim1','dim2']);
if ($res == 1 ) {print "ok 1\n";$ntest++;} else {print "not ok 1\n";}

    #Put some local attributs in 'myData'
    #Set the fill value as 0
    $res = $SDobj->SDsetfillvalue("myData", 0);
if ($res == 1 ) {print "ok 2\n";} else {print "not ok 2\n";}

    #Set the valid range from 0 to 2000
    $res = $SDobj->SDsetrange("myData", [0, 2000]);
if ($res == 1 ) {print "ok 3\n";} else {print "not ok 3\n";}

    #Set the default calibration for 'myData' (scale factor = 1, other = 0)
    $res = $SDobj->SDsetcal("myData");
if ($res == 1 ) {print "ok 4\n";} else {print "not ok 4\n";}

    #Set a global text attribut
    $res = $SDobj->SDsettextattr('This is a global text test!!', "myGText" );
if ($res == 1 ) {print "ok 5\n";} else {print "not ok 5\n";}

    #Set a local text attribut for 'myData'
    $res = $SDobj->SDsettextattr('This is a local text testl!!', "myLText", "myData" );
if ($res == 1 ) {print "ok 6\n";} else {print "not ok 6\n";}

    #Set a global value attribut (you can put all values you want)
    $res = $SDobj->SDsetvalueattr( PDL::short( 20 ), "myGValue");
if ($res == 1 ) {print "ok 7\n";} else {print "not ok 7\n";}

    #Set a local value attribut (you can put all values you want)
    $res = $SDobj->SDsetvalueattr( PDL::long( [20, 15, 36] ), "myLValues", "myData" );
if ($res == 1 ) {print "ok 8\n";} else {print "not ok 8\n";}

    #Close the file
    $SDobj->close;

    ### Reading from a HDF file

    #Open an HDF file in read only mode
    my $SDobj2 = PDL::IO::HDF::SD->new("montest.HDF");

    #Get a list of all datasets
    my @dataset_list = $SDobj2->SDgetvariablename();
if ($#dataset_list+1 != 0 ) {print "ok 9\n";} else {print "not ok 9\n";}

    #Get a list of all global attributs name
    my @globattr_list = $SDobj2->SDgetattributname();
if ($#globattr_list+1 != 0 ) {print "ok 10\n";} else {print "not ok 10\n";}

    #Get a list of local attributs name for a dataset
    my @locattr_list = $SDobj2->SDgetattributname("myData");
if ($#locattr_list+1 != 0 ) {print "ok 11\n";} else {print "not ok 11\n";}

    #Get the value of local attribut for a dataset
    my $value = $SDobj2->SDgetattribut("myLText","myData");
if (defined $value) {print "ok 12\n";} else {print "not ok 12\n";}

    #Get the all dataset 'myData'
    $data = $SDobj2->SDget("myData");
if ($data->nelem > 0 ) {print "ok 13\n";}
else {print "not ok 13\n";}
#print "info : ".$data->info."\n";

    #Apply the scale factor of 'myData'
    $res = $SDobj2->SDgetscalefactor("myData");
if (defined $res) {print "ok 14\n"; $data *= $res; }
else {print "not ok 14\n";}

    #Get the fill value
    #The fill value corresponding to the BAD value in pdl
    $res = $SDobj2->SDgetfillvalue("myData");
if (defined $res) {print "ok 15\n"; $data->inplace->setvaltobad( $res ); }
else {print "not ok 15\n";}

    #Get the valid range of datas
    my @range = $SDobj2->SDgetrange("myData");
if ($#range+1 != 0 ) {print "ok 16\n";} 
else {print "not ok 16\n";}

#print Data::Dumper->Dump([$SDobj2],[qw(SDobj2)]);
 
    #Now you can do what you want with your data
    $SDobj2->close;

