#!/usr/bin/perl

use strict;
use warnings;

use Carp;

sub isVisible {
  my ($line, $frame) = @_;
  my ($lower,$upper) = ($line->[1]->[0],$line->[1]->[1]);
  if( $lower == -1 || $lower == $frame ) { return 1; }
  if( $lower <= $frame ){
    if( $upper >= $frame || $upper == -1 ) { return 1; }
  }
  return 0;
}

sub max {
  my ($elements, $maxFrame) = @_;
  my $max = 0;
  for(@$elements, $maxFrame) {
    if( $_ > $max) { $max = $_; }
  }
  return $max;
}

sub process {
  my $line = shift;
  my $lower = -1;
  my $upper = 0;
  if( $line =~ /^\s*#(\d)-(\d)\s(.*)/ ) {
    $lower = $1;
    $upper = $2;
    $line = $3."\n";
  }
  elsif( $line =~ /\s*#(\d)-\s(.*)/ ) {
    $lower = $1;
    $upper = -1;
    $line = $2."\n";
  }
  elsif( $line =~ /\s*#(\d)\s(.*)/ ) {
    $lower = $1;
    $line = $2."\n";
  }
  carp "line:$line\nlower:$lower\nupper: $upper\n\n";
  return ($line, [$lower, $upper]);
}

my $FH;
open( $FH, $ARGV[0] ) or croak "open ",$ARGV[0],":$!";

my @lines;
@lines = <$FH>;

my @denominatedLines;
my $maxFrame=0;

foreach( @lines ) {
  my $denom;
  my ($line, $bounds) = process($_);
  $maxFrame = max($bounds, $maxFrame);
  push( @denominatedLines, [ $line, $bounds ]);
}

for( my $i = 0; $i <= $maxFrame; $i++ ) {
  my $fh;
  my $file = $i;
  if( $ARGV[0] =~ /(.*).gva/ ) { $file = $file."-$1.gv"; }
  open( $fh, ">$file") or croak "open ",$ARGV[0],".$i:$!";
  print "\n\n$i\n";
  for my $line ( @denominatedLines ){
    if( isVisible($line, $i) ){
      print $fh $line->[0];
      print $line->[0];
    }
  }
}
