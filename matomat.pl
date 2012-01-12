﻿#!/usr/bin/perl
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# lofi schrieb diese Datei. Solange Sie diesen Vermerk nicht entfernen,
# können Sie mit der Datei machen, was Sie möchten.
# Wenn wir uns eines Tages treffen und Sie denken, die Datei ist es wert,
# können Sie mir dafür ein Bier bzw. eine Mate ausgeben.
# ----------------------------------------------------------------------------
#
# Version: 0.1.1
#
# lofi 23.02.2011: Initial Script
# lofi 24.02.2011: Removed all comments to make the code
#                  unreadable for any one else :)
# lofi 03.03.2011: t2s functions added
#
##############################################################

use strict;
use IO::Prompter;
use Text::FIGlet;
use Digest::SHA qw(sha512 sha512_base64 sha512_hex);

$ENV{'PATH'} = '/bin:/usr/bin';

my $t2s_wrongpass = "i am sorry dave. i am afraid i cant do that";
my $t2s_pay_minus5 = "you better pay soon";
my $t2s_pay_minus10 = "time to pay bitch";
my $t2s_pay_minus15 = "hi everbody i look at gay porrnno";
my $t2s_pay_minus15_pre = "i warned you";
my $echobin = "/bin/echo";
my $festivalbin = "| /usr/bin/festival --tts";
my $clear_string = `/usr/bin/clear`;
my $dbfile = "/var/matomat/matomat.db";
my $credfile = "/var/matomat/user.db";
my $statsfile = "/var/matomat/stats.db";
my $font = Text::FIGlet->new(-m=>-1,-f=>"/var/matomat/standard.flf");

&_login;

sub _login {
	&_login_banner;
	my @pwent = &_prompt_for_login;

	my $user = $pwent[0];
	my $password = $pwent[1];

	open CRED, "<", $credfile or die $!;
	while (<CRED>) {
		if ($_ =~ m/^$user/) {
			close CRED;
			chomp($_);
			my ($name, $pass, $flag) = split(/:/, $_, 3);
			my $digest = sha512_base64($password);
				if ($pass eq $digest) {
					close CRED;
					&_hello($user);
					@pwent = ($user, $pass);
					&_main(@pwent);
					return;
				} else {
					&_wrong_pass;
				}
		}
	}
	close CRED;
	&_wrong_pass;
}

sub _hello {
	my $name = $_[0];
	print "\n\nHi $name ...\n\n";
	system("$echobin hi $name $festivalbin");
}

sub _wrong_pass {
	print "\n[NO_MATE] Wrong Login!!!\n";
	system("$echobin $t2s_wrongpass $festivalbin");
	&_login;
}

sub _main {
	my $user = $_[0];
	&_banner;

	&_read_credit($user);

	my $selec = &_main_menu;
	print "SELECTION: $selec\n";
	if ($selec eq "more mate") {
		&_banner;
		&_add_mate;
		&_breake;
	} elsif ($selec eq "more beer") {
		&_banner;
		&_add_beer;
		&_breake;
	} elsif ($selec eq "more tschunk") {
		&_banner;
		&_add_tschunk;
		&_breake;
	} elsif ($selec eq "insert coins") {
		&_banner;
		&_add_coins;
		&_breake;
	} elsif ($selec eq "stats") {
		&_banner;
		&_read_stat($user);
		&_breake;
	} elsif ($selec eq "loscher stuff") {
		&_loscher_banner;
		&_loscher_menu;
		&_breake;
	} elsif ($selec eq "change passwd") {
		&_banner;
		&_change_pass($user, "0");
		&_breake;
	} elsif ($selec eq "Quit") {
		print "Bye Bye ...\n";
		&_quit_t2s;
	}
	&_quit;
}

sub _quit {
	&_banner;
	my $quit = prompt 'Main Menu or Quit ...', -number, -timeout=>20, -default=>'Quit', -menu => [
		'Main Menu',
		'Quit'], 'matomat>';
	if ($quit eq "Main Menu") {
		&_main;
	} else {
		print "Bye Bye ...\n";
		&_quit_t2s;
	}
}

sub _breake {
	my $breake = prompt 'Main Menu or Quit ...', -number, -timeout=>20, -default=>'Quit', -menu => [
		'Main Menu',
		'Quit'], 'matomat>';
	if ($breake eq "Main Menu") {
		&_main;
	} else {
		print "Bye Bye ...\n";
		&_quit_t2s;
	}
}

sub _main_menu {
	my $selec = prompt 'Choose wisely...', -number, -timeout=>20, -default=>'Quit', -menu => [
		'more mate',
		'more beer',
		'more tschunk',
		'insert coins',
		'stats',
		'loscher stuff',
		'change passwd',
		'Quit'], 'matomat>';
}

sub _prompt_for_login {
	my $user = prompt 'User:' ;
	my $passwd = prompt 'Password:', -echo=>'*';
	my @pwent = ($user, $passwd);
	return @pwent;
}

sub _read_credit {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	while (<DB>) {
		if ($_ =~ m/^$user/) {
			close DB;
			chomp($_);
			my ($login, $credit, $beercnt, $matecnt, $tschunkcnt) = split(/:/, $_, 5);
			print "Hi $login ... you have\n\n";
			print ~~$font->figify(-A=>"$credit credits");
			print "\n";
			if ($credit =~ m/^-/) {
				print ~~$font->figify(-A=>"TIME2PAY!");
				if ($credit <= -15) {
					system("$echobin $t2s_pay_minus15_pre $festivalbin");
					my $count = 1;
					while ($count <= 5) {
						system("$echobin $t2s_pay_minus15 $festivalbin");
						$count++;
					}
				} elsif ($credit <= -10) {
					system("$echobin $t2s_pay_minus10 $festivalbin");
				} elsif ($credit <= -5) {
					system("$echobin $t2s_pay_minus5 $festivalbin");
				}
			}
			print "\n\n\n";
		}
	}
	close DB;
}

sub _read_stat {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	while (<DB>) {
		if ($_ =~ m/^$user/) {
			close DB;
			chomp($_);
			my ($login, $credit, $beercnt, $matecnt, $tschunkcnt) = split(/:/, $_, 5);
			print "Hi $login ... you have\n\n";
			print ~~$font->figify(-A=>"$credit credits\n");
			print ~~$font->figify(-A=>"Beer: $beercnt\n");
			print ~~$font->figify(-A=>"Mate: $matecnt\n");
			print ~~$font->figify(-A=>"Tschunk: $tschunkcnt\n");
			print "\n\n\n";
		}
	}
	close DB;
	&_stats_t2s;
}

sub _add_mate {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	my @lines = <DB>;
	close DB;

	open DB, ">", $dbfile or die $!;
	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$user/) {
			my ($login, $credit, $beertmp, $matetmp, $tschunktmp) = split(/:/, $line, 5);

			$credit--;
			$matetmp++;
			print "Hi $login ... your new stats are\n\n";
			print "Credit: $credit\n";
			print "Beer: $beertmp\n";
			print "Mate: $matetmp\n";
			print "Tschunk: $tschunktmp\n\n\n";
			my $update = $login.":".$credit.":".$beertmp.":".$matetmp.":".$tschunktmp."\n";;
			print DB $update;

			&_mate_t2s;

			open STAT, ">>", $statsfile or die $!;
			my $current_time = time;
			print STAT "$current_time,$login,1,0\n";
			close STAT;
		} else {
			print DB $line."\n";
		}
	}
	close DB;
}

sub _add_beer {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	my @lines = <DB>;
	close DB;

	open DB, ">", $dbfile or die $!;
	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$user/) {
			my ($login, $credit, $beertmp, $matetmp, $tschunktmp) = split(/:/, $line, 5);
			$credit--;
			$beertmp++;
			print "Hi $login ... your new stats are\n\n";
			print "Credit: $credit\n";
			print "Beer: $beertmp\n";
			print "Mate: $matetmp\n";
			print "Tschunk: $tschunktmp\n\n\n";

			my $update = $login.":".$credit.":".$beertmp.":".$matetmp.":".$tschunktmp."\n";
			print DB $update;
			&_beer_t2s;

			open STAT, ">>", $statsfile or die $!;
			my $current_time = time;
			print STAT "$current_time,$login,0,1\n";
			close STAT;
		} else {
			print DB $line."\n";
		}
	}
	close DB;
}

sub _add_tschunk {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	my @lines = <DB>;
	close DB;

	open DB, ">", $dbfile or die $!;
	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$user/) {
			my ($login, $credit, $beertmp, $matetmp, $tschunktmp) = split(/:/, $line, 5);
			$credit-=2;
			$tschunktmp++;
			print "Hi $login ... your new stats are\n\n";
			print "Credit: $credit\n";
			print "Beer: $beertmp\n";
			print "Mate: $matetmp\n";
			print "Tschunk: $tschunktmp\n\n\n";

			my $update = $login.":".$credit.":".$beertmp.":".$matetmp.":".$tschunktmp."\n";;
			print DB $update;
			&_tschunk_t2s;
		} else {
			print DB $line."\n";
		}
	}
	close DB;
}

sub _add_coins {
	my $user = $_[0];

	open DB, "<", $dbfile or die $!;
	my @lines = <DB>;
	close DB;

	open DB, ">", $dbfile or die $!;
	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$user/) {
			my ($login, $credit, $beertmp, $matetmp, $tschunktmp) = split(/:/, $line, 5);
			my $coins = prompt "How much did you pay?\nmatomat> ", -integer;
			$credit=$credit+$coins;
			print "Hi $login ... your new stats are\n\n";
			print "Credit: $credit\n";
			print "Beer: $beertmp\n";
			print "Mate: $matetmp\n";
			print "Tschunk: $tschunktmp\n\n\n";

			my $update = $login.":".$credit.":".$beertmp.":".$matetmp.":".$tschunktmp."\n";;
			print DB $update;
		} else {
			print DB $line."\n";
		}
	}
	close DB;
	&_credits_t2s;
}

sub _loscher_menu {
	my $user = $_[0];

	open CRED, "<", $credfile or die $!;
	while (<CRED>) {
		if ($_ =~ m/^$user/) {
			close CRED;
			chomp($_);
			my ($name, $pass, $flag) = split(/:/, $_, 3);
			if ($flag == "1") {
				print "Hi Master aka $name ...\n\n";
				my $choice = prompt 'Add User or Back to Main ...', -number, -timeout=>20, -default=>'Main Menu', -menu => [
					'Add User', "Change Password",
					'Main Menu'], 'matomat>';
				if ($choice eq "Add User") {
					&_add_user;
				} elsif ($choice eq "Change Password") {
					$user = prompt "Change password of user: ";
					&_change_pass($user, "1");
				} else {
					&_main;
				}
			} else {
				print "\n[NO_MATE] You don't have loscher rights!!!\n";
				sleep 2;
				&_main;
			}
		}
	}
	close CRED;
}

sub _add_user {
	my $auser = prompt 'Enter Username:';
	my $apass = prompt 'Enter Password:';
	my $hashpass = sha512_base64($apass);
	my $startcredit = prompt 'Start credits:', -i;
	my $aflag;

	if ( prompt "Is this a Admin User?", -YN ) {
		$aflag = "1";
	} else {
		$aflag = "0";
	}

	open DB, "<", $dbfile or die $!;
	my @lines = <DB>;
	close DB;

	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$auser/) {
			print "\n[NO_MATE] Sorry ... User already exists in matomatdb!!\n\n";
			&_loscher_menu;
		}
	}
	my $line = "";

	open CRED, "<", $credfile or die $!;
	my @lines = <CRED>;
	close CRED;

	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$auser/) {
			print "\n[NO_MATE] Sorry ... User already exists in userdb!!\n\n";
			&_loscher_menu;
		}
	}

	open CRED, ">>", $credfile or die $!;
	my $update = $auser.":".$hashpass.":".$aflag."\n";;
	print CRED $update;
	close CRED;

	open DB, ">>", $dbfile or die $!;
	my $update = $auser.":".$startcredit.":0:0\n";;
	print DB $update;
	close DB;

	$auser = "";
	$apass = "";
	$hashpass = "";
	$startcredit = "";
	$aflag = "";
	$update = "";
	my $line = "";
}

sub _change_pass {
	my ($user, $admin) = @_;
	my $apass = "";
	my $hashpass = "";

	print "Changing password for user: $user\n\n";

	if ($admin eq "0") {
		$apass = prompt 'Enter current password:', -echo=>'*';
		$hashpass = sha512_base64($apass);
	}
	my $npass = prompt 'Enter new password:', -echo=>'*';
	my $dpass = prompt 'Again new password:', -echo=>'*';

	if ($npass ne $dpass) {
		print "\n[NO_MATE] Passwords differ... LEARN TO TYPE!\n\n";
		sleep 3;
		&_change_pass($user, $admin);
	}
	my $newhash = sha512_base64($npass);

	open DB, "<", $credfile or die $!;
	my @lines = <DB>;
	close DB;

	open CRED, ">", $credfile or die $!;
	foreach my $line (@lines) {
		chomp($line);
		if ($line =~ m/^$user/) {
			my ($name, $pass, $flag) = split(/:/, $line, 3);
			if ($admin eq "1" or $pass eq $hashpass) {
				my $newhash = sha512_base64($npass);
				my $update = $name.":".$newhash.":".$flag."\n";
				print CRED $update;
				print "\n[MORE_MATE] Password change successful!\n\n";
			} else {
				print "\n[NO_MATE] Your current password is not correct\n\n";
				print CRED $line."\n";
			}
		} else {
			print CRED $line."\n";
		}
	}
	close CRED;
}

sub _quit_t2s {
	my @stuff = ('so long sucker',
		'so long and. thanks for all the fish',
		'good bye');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
	&_login;
}

sub _beer_t2s {
	my @stuff = ('the cause and solution of all lifes problems',
		'thank you for you order',
		'cheers');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
}

sub _mate_t2s {
	my @stuff = ('caffeine the gateway drug',
		'thank you for you order',
		'enjoy you loscher drink');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
}

sub _tschunk_t2s {
	my @stuff = ('come get some',
		'seems to be camp time',
		'loscher mixed');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
}

sub _stats_t2s {
	my @stuff = ('stats stats stats',
		'nothing to see here',
		'what do you want google analytics');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
}

sub _credits_t2s {
	my @stuff = ('shake it baby',
		'good boy',
		'thank you',
		'you are now broke',
		'give me more');
	my $arrCnt = scalar(@stuff);
	my $rand = rand($arrCnt);
	system("$echobin $stuff[$rand] $festivalbin");
}

sub _banner {
	print $clear_string;
	print STDOUT << "EOF";
============================================================================
 __    __     ______     ______   ______     __    __     ______     ______
/\\ "-./  \\   /\\  __ \\   /\\__  _\\ /\\  __ \\   /\\ "-./  \\   /\\  __ \\   /\\__  _\\
\\ \\ \\-./\\ \\  \\ \\  __ \\  \\/_/\\ \\/ \\ \\ \\/\\ \\  \\ \\ \\-./\\ \\  \\ \\  __ \\  \\/_/\\ \\/
 \\ \\_\\ \\ \\_\\  \\ \\_\\ \\_\\    \\ \\_\\  \\ \\_____\\  \\ \\_\\ \\ \\_\\  \\ \\_\\ \\_\\    \\ \\_\\
  \\/_/  \\/_/   \\/_/\\/_/     \\/_/   \\/_____/   \\/_/  \\/_/   \\/_/\\/_/     \\/_/

============================================================================

EOF
}

sub _login_banner {
	print $clear_string;
	print STDOUT << "EOF";

                                    =?I777777II?????II777777?=
                               7777?                           I777?
                          I77I     I77               =777777777+     I77=
                      =77I    ?777777=                I7777777777777+   =77+
                   =77=   I7777777777                  77777777777777777+   77?
                 ?77   I7777777777777                  =7777777777777777777   ?77
               77=  I777777777777777?                   7777777777777777777777   77=
             ?7I  ?77777777777777777                     77777777777777777777777   77
           +77  77777777777777777777                     7777777777777777777777777   77
          77   777777777777777777777                      77777777777777777777777777  +7=
         77  77777777777777777777777                      777777777777777777777777777+  77
       I7   777777777777777777777777                          +7777777777777I+= +777777  77
      =7   77777777777777777777?=                   +?77777777777?             ?77777777  77
      7   7777777777=          =7777777777777777777777777=                  7777777777777  7I
     77  77777+                      ==+????++=                         I7777777777777777?  7
    I7  77777777I+                    ?77    ?777?+?7777+       +I777777777777777777777777  77
    7I  77777777777777777777777777    7777   777777777777  = 777777777777777777777777777777  7
    7  77777777777777777777777777+      ?  7 I=777777777 777 =77777777777777777777777777777  77
   77  77777777777777777777777777=777        =+==   I7777 7+ 777777777777777777777777777777  +7
   77  77777777777777777777777777 I? 77         77777=7777777777777777777777777777777777777?  7
   77  77777777777777777777777777777777=   777777777+?77777777777777I7777777777II7777777777I  7
   77  77777777777777777777777777    I       777777 ?777777777777777+7777777777 77777777777+ =7
   ?7  77777777777777777777777?                 77+ 7777777777777777=7777+7777+777777777777  I7
    7  ?777777777777777777I                     +7   =77777777777777+7777 7777 777777777777  7?
    77  777777777777777                                 77777777777+77777 77 I=77777777777+  7
     7  +777777777777                                     777777777 777=77+77I777777777777  7I
     77  I777777777                                        +7777=77=777?=777 777777777777  I7
      77  7777777                                            7 777=?777777? I77777777777=  7
       77  I777                                              77777777777    77777777777   7
        77  ?                                              ?777777777777I  77777777777   7
         ?7                                               777777777777777I77777777777  77
           77                                             777777777777I==I777777777=  7I
            +7+                                           77777      ?77777777777+  77
              +7+                                         777         ?77777777   77
                77=                                       77           +77777   77=
                   77                                                    7   I7?
                     77I                                                   77
                        +77?                                           77I
                            +77I                                  =777=
                                  7777I+                   ?7777+
                                          ++?IIII7III??+=

EOF
}

sub _loscher_banner {
	print $clear_string;
	print STDOUT << "EOF";
============================================================================
 __         ______     ______     ______     __  __     ______     ______
/\\ \\       /\\  __ \\   /\\  ___\\   /\\  ___\\   /\\ \\_\\ \\   /\\  ___\\   /\\  == \\
\\ \\ \\____  \\ \\ \\/\\ \\  \\ \\___  \\  \\ \\ \\____  \\ \\  __ \\  \\ \\  __\\   \\ \\  __<
 \\ \\_____\\  \\ \\_____\\  \\/\\_____\\  \\ \\_____\\  \\ \\_\\ \\_\\  \\ \\_____\\  \\ \\_\\ \\_\\
  \\/_____/   \\/_____/   \\/_____/   \\/_____/   \\/_/\\/_/   \\/_____/   \\/_/ /_/

============================================================================

EOF
}
