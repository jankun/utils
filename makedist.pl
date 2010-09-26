#!/usr/bin/perl
use strict;
use Cwd 'abs_path';

my $bin = shift;

my($bin_app, $bin_version);
open(my $fh, '<', $bin) or die($!);
while(<$fh>) {
  if(/\$APP\s*=\s*(?:'|")(.+)(?:'|")/) {
    $bin_app = $1;
  }
  if(/\$VERSION\s*=\s*(?:'|")(.+)(?:'|")/) {
    $bin_version = $1;
  }
}
close($fh);

if(!defined($bin_app)) {
  print "app: ";
  chomp($bin_app = <STDIN>);
  print "ver: ";
  chomp($bin_version = <STDIN>);
}

my $cwd  = abs_path($bin);
$cwd =~ s;(.+)/.*$;$1;;
my $dist = "$bin_app-$bin_version";
my $tgz  = "$dist.tar.gz";

if(-f $tgz) {
  if(unlink($tgz)) {
    print "\e[1m$tgz deleted, creating new dist\e[0m\n";
  }
}

system('tar', 'cvfz', $tgz, $cwd); #== 0 or die($!);
system('scp', '-P 19216', $tgz, "scp1\@192.168.1.100:http/hacks") == 0 or die($!);
system("echo http://hacks.trapd00r.se/$tgz && echo http://hacks.trapd00r.se/$tgz|xclip");
