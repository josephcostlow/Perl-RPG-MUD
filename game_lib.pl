#!/usr/bin/perl

use strict;
use warnings;

# Get user input, send it to the validation routine
# 2011-4-26 josephcostlow

sub player_prompt() {
	print "\n> ";
	my $command = <STDIN>;
	chomp($command);
	input_check($command);
}

# Validate user input by comparing it to a list of accepted commands
# 2011-4-26 josephcostlow

sub input_check() {

	my $command = shift;

	my @accepted_commands = qw(n s e w N S E W north south east west
		North South East West u d U D up down Up Down);
	
	if (grep $_ eq $command, @accepted_commands) {
		my $desired_direction = translate_direction($command);
		move_location($desired_direction);
	} else {
		print "Command ($command) rejected!";
	}		


}


# Translate accepted user input into direction commands for mysql
# 2011-4-26 josephcostlow

sub translate_direction() {
	my $direction = shift;
	
	my @north = qw(n N north North);
	my @south = qw(s S south South);
	my @east = qw(e E east East);
	my @west = qw(w W west West);
	my @up = qw(u U up Up);
	my @down = qw(d D down Down);

	if (grep $_ eq $direction, @north) {
		return "north"; 
	}
    if (grep $_ eq $direction, @south) {
        return "south";
    }
    if (grep $_ eq $direction, @east) {
        return "east";
    }
    if (grep $_ eq $direction, @west) {
        return "west";
    }
    if (grep $_ eq $direction, @up) {
        return "up";
    }
    if (grep $_ eq $direction, @down) {
        return "down";
    }
}	

# Connect to world database, check for connection
# If no exisiting connection, jump back to prompt with error message
# Else move to new location and display it
# 2011-04-26 josephcostlow

sub move_location() {

	use DBI;
	use DBD::mysql;

	my $desired_direction = shift;
	my $current_location = our $player->get_current_location;
	my $query = "get $desired_direction from world where loc_id = $current_location";
	print $query;
	 


}


1;





