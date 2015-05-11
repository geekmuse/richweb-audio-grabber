#!/usr/bin/perl -w

use WWW::Mechanize;

my $m = WWW::Mechanize->new(
                              cookie_jar => {},
                              ssl_opts => {
                                verify_hostname => 0
                              }
  );
$m->show_progress(1);

&login(\$m);


my $i = 0;

open LIST, "richweb_out.txt" or die $!;

while (<LIST>) {
  chomp;
  my @file = split("::", $_);
  my $filename = $file[0];
  my $fileurl = $file[1];
  if ($i < 5) {
    $m->get($fileurl, ":content_file" => "$filename.m4a");
  }
  else {
    $i = 0;
    &login(\$m);
    $m->get($fileurl, ":content_file" => "$filename.m4a");
  }
  $i++;
  sleep 8;  # maybe need to do this to keep from violating any server policies and having our TCPs severed?
}

sub login {
  my $m_ref = shift;
  $$m_ref->get("https://therichwebexperience.com/n/login/view");
  $$m_ref->submit_form(
    form_number => 1,
    fields => {j_username => 'my_username', j_password => 'my_password'} );
  die unless ($$m_ref->success);
}
