package main

// imports

// structs and others
Stats6 :: struct {
	hp, atk, def, spa, spd, spe: int,
}
Stats8 :: struct {
	hp, atk, def, spa, spd, spe, acc, eva: int,
}
Types :: struct {
	t1, t2: string,
}
Attack :: struct {
	name: string,
	types: Types,
	base_power: int,
	base_accuracy: int,	
}
Mon :: struct {
	species: string,
	name: string,
	ability: string,
	types: Types,
	base_stats: Stats6,
	ivs: Stats6,
	evs: Stats6,
	actual_stats: Stats6,
	current_hp: int,
	status1: string,
}
BattleMon :: struct {
	mon: ^Mon,
	type_changes: Types,
	stat_changes: Stats8,
	status2: string,
}

// procs

// main
main :: proc() {

}
