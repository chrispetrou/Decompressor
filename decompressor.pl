#!/usr/bin/perl -w

use utf8;
use v5.28;
use strict;
use SVN::Notify;
use Term::ANSIColor;

$| = 1;
binmode STDOUT, ":utf8";

#console colors
my ($bld, $rst, $rd) = (color('bold'), color('reset'), color('red'));
my $file = $ARGV[0];

unless (defined $file && -e $file && -r $file && !-z $file){
  say $bld . "┌════════════════┐" .$rst;
  say $bld . "│  Decompressor  │" .$rst;
  say $bld . "└════════════════┘" .$rst . $rd. "...v1.0" . $rst;
  say '-' x 38;
  say("uc <file>");
  say($bld."Example:".$rst." uc test.gz2");
  say '═' x 38;
  exit 1;
}

# add rmp, Z
my %ucomp = (
  "7z" => "7z x",     zip  => "unzip",
    z  => "gzip -d",  tar  => "tar xvf",
  deb  => "dpkg -x",  rar  => "unrar x",
  xar  => "xar -xvf", pkg  => "xar -xvf",
  gz   => "tar xvzf", arj  => "arj e -r -y", 
  bz2  => "tar xvjf"
);

sub check_util {
  unless (SVN::Notify->find_exe($_[0])) {
    if ($^O eq "darwin" && $_[0] eq "arj") {
      say($rd."[!] unarj is not installed...".$rst);
    } else {
      say($rd."[!] $_[0] is not installed...".$rst);
    }
    exit 1;
  }
}

sub decompress {
  if ($file =~ m/.*[.]([\w]+)$/i){
    my @util = split /\s+/, "$ucomp{$1}";
    &check_util($util[0]);
    
    if ($1 eq "deb") {
      `$ucomp{$1} $file $ENV{'PWD'}`;
    } elsif ($1 eq "arj") {
      if ($^O eq "darwin") {
        `unarj e $file`;
      } else {
        `$ucomp{$1} $file`;
      }
    } else {
      `$ucomp{$1} $file`;
    }
  } else {
    say($rd."[!] Couldn't decompress the file...".$rst);
  }
}

&decompress($file);