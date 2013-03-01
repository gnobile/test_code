#!/usr/bin/perl

#Simple script for search and update data on database, with commit controll error. Userful for processing large number of rows. Easy customizable adding/modifing queries

use DBI;
no warnings;
 
my $sid ='my_sid';
my $host ='my.host.name';
my $port ='port';
my $dbuser ='DB_USER';
my $dbpass ='DB_PASS';
my $orahome;

$ENV{ORACLE_HOME}=$orahome;

my $out = "output";

#connessione al db
open (OUT,">> $out") or die("Error opening $out");        
my $dbh = DBI->connect("DBI:Oracle:sid=$sid;host=$host;port=$port", $dbuser, $dbpass) or die "Can't connect to database: " . DBI->errstr;

$dbh->{AutoCommit} = 0;
$dbh->{RaiseError} = 1;
0=user, 1=password
my $sth = $dbh->prepare('select field_0 from Tab_1 u, Tab_2 m where u.field_1 != m.field_1 and u.Id = m.Id'); 
my $sth1 = $dbh->prepare('update Tab_2 set field_1 = (select field_1 from Tab_1 where field_0 = ?) where field_0 = ?); 
$sth->execute() or die "Can't execute: " . DBI->errstr;
while (my @res = $sth->fetchrow_array)
   {
		my $err = 0;
		$sth1->execute($res[0]) || ($err = 1);
		$dhh->commit if (!$err);
        }
$sth->finish;
$sth1->finish;
$dbh->disconnect();
close OUT;
