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
		North South East West u d U D up down Up Down l L look Look);
	
	if (grep $_ eq $command, @accepted_commands) {
		my $desired_direction = translate_direction($command);
		if ($desired_direction eq "look") {
			view_location(our $player->get_current_location);
		}
		move_location($desired_direction);
	} else {
		print "Command ($command) rejected!\n";
		print "Please use n/s/e/w/u/d for navigation.\n";
		player_prompt();
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
	my @look = qw(l L look Look);

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
	if (grep $_ eq $direction, @look) {
		return "look";
    }
}	

# Connect to world database, check for connection
# If no exisiting connection, jump back to prompt with error message
# Else move to new location and display it
# 2011-04-26 josephcostlow

sub move_location() {

	use DBI;
	use DBD::mysql;
	
	my $host = "173.53.87.55";
	my $database = "rpg";
	my $user = "rpg_client";
	my $pass = "Co0ley47";
	
	my $desired_direction = shift;
	my $current_location = our $player->get_current_location;
	my $query = "select $desired_direction from world where loc_id=$current_location";
		 
	my $data_source = "dbi:mysql:$database:localhost:3306";

	my $datasource = DBI->connect($data_source, $user, $pass);
	
	my $query_handle = $datasource->prepare($query);

	$query_handle->execute();
	
	my $new_location;
	$query_handle->bind_columns(undef, \$new_location);

	while ($query_handle->fetch()) {
		if ($new_location == 0) {
			print "\nSorry, you can't go that way.\n";
			player_prompt();
		}
		#print "\nMoving to $new_location \n";
		#$query_handle->finish;
		#$datasource->disconnect;
		$player->location( $new_location );
		view_location($new_location);
	}

}

# View a location from the world table based on its ID
# 2011-04-26 josephcostlow

sub view_location() {

	use DBI;
	use DBD::mysql;
	
	my $host = "173.53.87.55";
	my $database = "rpg";
	my $user = "rpg_client";
	my $pass = "Co0ley47";
	
	my $new_location = shift;
	my $query = "select * from world where loc_id=$new_location";
		 
	my $data_source = "dbi:mysql:$database:localhost:3306";

	my $datasource = DBI->connect($data_source, $user, $pass);
	
	my $query_handle = $datasource->prepare($query);

	$query_handle->execute();
	
	my ($loc_id, $loc_name, $loc_zone, $loc_desc, $loc_north, $loc_south);
	my ($loc_east, $loc_west, $loc_up, $loc_down, $loc_items, $loc_npc);
	$query_handle->bind_columns(undef, \$loc_id, \$loc_name, \$loc_zone, \$loc_desc, \$loc_north, \$loc_south, \$loc_east, \$loc_west, \$loc_up, \$loc_down, \$loc_items, \$loc_npc);

	while ($query_handle->fetch()) {
		print "\nNow in - $loc_name \n";
		print "$loc_desc";
		#$query_handle->finish;
		#$datasource->disconnect;
		player_prompt();
	}

}

1;





