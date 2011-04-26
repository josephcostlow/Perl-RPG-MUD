#!/usr/bin/perl

require "game_lib.pl";

package Player;

use Moose;

has 'location' => (
	is => 'rw',
	isa => 'Int',
);

sub get_current_location {
	our $location = shift;
	return $location->location;
}

1;

package main;

our $player = Player->new({ location => 9995 });
view_location(9995);

