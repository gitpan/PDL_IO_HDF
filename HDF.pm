package PDL::IO::HDF;


=head1 NAME 

PDL::IO::HDF - An interface librairie for HDF file.

This librairy provide functions to manipulate
HDF files with SD, VS and V interface.

This package also contain some globals constantes and 
typemaps.

The 'new' function of this package use the
'new' functions of all HDF interface. This give
you the possibility to access to all interface in
one opening.

For more infomation on HDF, see http://hdf.ncsa.uiuc.edu/

=head1 SYNOPSIS

  use PDL;
  use PDL::IO::HDF;

   #open file 'foo.hdf' with all hdf interface
    my $HDF = PDL::IO::HDF->new("foo.hdf");

   #you can call any functions with this syntaxe :
   #  $obj->{$interface}->function
    $HDF->{SD}->SDget("Foo_data");
   #the same with VS interface : 
    $HDF->{VS}->VSgetnames();

   #There is an other syntaxe (the one I use):
   #  $$obj{$interface}->function
    $$HDF{SD}->SDget("Foo_data");
   #the same with VS interface : 
    $$HDF{VS}->VSgetnames();

   #to close all interface :
    $HDF->close;

For more infomation on functions, see the docs of interfaces.

=head1 DESCRIPTION

This is the description of the PDL::IO::HDF module.

=cut


$VERSION = '0.5';


use PDL::Primitive;
use PDL::Basic;

use PDL::IO::HDF::SD;
use PDL::IO::HDF::VS;

## Constant
$DFACC_READ=1;
$DFACC_WRITE=2;
$DFACC_CREATE=4;
$DFACC_ALL=7;
$DFACC_RDONLY=1;
$DFACC_RDWR=3;
$FULL_INTERLACE=0;
$NO_INTERLACE=1;
$DFNT_FLOAT32=5;
$DFNT_UCHAR=3;
$DFNT_CHAR=4;
$DFNT_FLOAT64=6;
$DFNT_INT8=20;
$DFNT_UINT8=21;
$DFNT_INT16=22;
$DFNT_UINT16=23;
$DFNT_INT32=24;
$DFNT_INT64=25;

#declaration des différents 'typemap' globaux

#typemap pour convertir typePDL->typeHDF
%SDtypeTMAP = (
		  PDL::byte->[0]   => $DFNT_UINT8, 
		  PDL::short->[0]  => $DFNT_INT16, 
		  PDL::ushort->[0]  => $DFNT_UINT16, 
		  PDL::long->[0]   => $DFNT_INT32, 
		  PDL::float->[0]  => $DFNT_FLOAT32, 
		  PDL::double->[0] => $DFNT_FLOAT64, 
		  PDL::byte->[0]   => $DFNT_UCHAR  ###attention PDL::byte 2x
		 );

#typemap pour convertir typeHDF->typePDL
%SDinvtypeTMAP = (
		   $DFNT_INT8 => sub { PDL::byte(@_); }, #badtype
		   $DFNT_UINT8 => sub { PDL::byte(@_); },
		   $DFNT_INT16 => sub { PDL::short(@_); },
		   $DFNT_UINT16 =>  sub { PDL::ushort(@_); },
		   $DFNT_INT32 => sub { PDL::long(@_); },
 		   $DFNT_INT64 => sub { PDL::long(@_); }, #badtype
		   $DFNT_FLOAT32  => sub { PDL::float(@_); }, 
		   $DFNT_FLOAT64  => sub { PDL::double(@_); },
		   $DFNT_UCHAR  => sub { PDL::byte(@_); },
		   $DFNT_CHAR  => sub { PDL::byte(@_); } #badtype
		  );


sub new
{
    my $type = shift;
    my $file = shift;
 
    my $obj = {};

    $obj->{SD} = PDL::IO::HDF::SD->new($file);
    $obj->{VS} = PDL::IO::HDF::VS->new($file);

    bless $obj, $type;
}

sub close
{
  my $self = shift;
  $self->{SD}->close;
  $self->{VS}->close;
}


sub DESTROY {
  my $self = shift;
  $self->close;
}


=head1 AUTHOR

Patrick Leilde patrick.leilde@ifremer.fr
contribs of Olivier Archer olivier.archer@ifremer.fr

=head1 SEE ALSO

perl(1), PDL(1), PDL::IO::HDF::SD(1), PDL::IO::HDF::VS(1).

=cut


