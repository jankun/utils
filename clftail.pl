#!/usr/bin/perl
use strict;
use File::Tail;
use Term::ExtendedColor qw(fg bg);

my $log   = shift;
my $line  = "";
my $tail  = File::Tail->new(name=>$log,
                            maxinterval=>3,
                            adjustafter=>3,
                            interval=>0,
                            tail=>100
                            );
while(defined($line=$tail->read)) {
  my $e = "(.+?)";
  $line =~ /^$e $e $e \[$e:$e $e\] "$e $e $e" $e $e/;

  my $ip      = $1;
  my $ref     = $2;
  my $name    = $3;
  my $date    = $4;
  my $time    = $5;
  my $gmt     = $6;
  my $request = $7;
  my $file    = $8;
  my $ptcl    = $9;
  my $code    = $10;
  my $size    = $11;

  $code = fg(240, $code) if $code == 404;
  $code = fg(155, $code) if $code == 200;
  $code = fg(160, $code) if $code == 501;
  $code = fg(208, $code) if $code == 301;
  $code = fg(124, $code) if $code == 403;
  $code = fg(113, $code) if $code == 304;

  $request = fg(190, "    $request") if $request eq 'GET';
  $request = fg(196, "   $request") if $request eq 'POST';
  $request = fg(197, "   $request") if $request eq 'CONNECT';

  if($file =~ /\.(:?png|gif|jpg|jpeg)$/) {
    $file = fg(167, $file);
  }
  elsif($file =~ /\.html$/) {
    $file = fg(74, $file);
  }
  else {
    $file = fg(222, $file);
  }

  $size = fg(160, $size) if $size > 5;
  printf("%s %7s %s \e[38;5;215m%s\e[0m \t%-60.40s\n",
    $code, $request, $size, $ip, $file) unless $file =~ m/.+\.(?:css|ico)$/
}
