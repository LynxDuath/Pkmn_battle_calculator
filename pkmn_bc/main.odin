package main

// imports
import "core:fmt"

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
Move :: struct {
	name: string,
	types: Types,
	base_power: int,
	base_accuracy: int,	
	// secondary effects
}
Mon :: struct {
	species: string,
	// name: string,
	level: int,
	// ability: string,
	// nature: string,
	types: Types,
	base_stats: Stats6,
	ivs: Stats6,
	evs: Stats6,
	actual_stats: Stats6,
	current_hp: int,
	status1: string,
}
BattleMon :: struct {
	stat_mon: ^Mon,
	dyn_mon: struct {
		type_changes: Types,
		stat_changes: Stats8,
		status2: string,
	}
}

// procs

// main
main :: proc() {
	my_mon := Mon{"Pikachu", 50, {"Electro", "None"}, {35, 55, 40, 50, 50, 90}, {31, 31, 31, 31, 31, 31}, {4, 252, 0, 0, 0, 252}, {111, 107, 60, 70, 70, 142}, 111, "None"}
	enemy_mon := Mon{"Charizard", 50, {"Fire", "Flying"}, {78, 84, 78, 109, 85, 100}, {31, 31, 31, 31, 31, 31}, {4, 0, 0, 252, 0, 252}, {154, 104, 98, 161, 105, 152}, 111, "None"}
	my_battle_mon := BattleMon{&my_mon, {my_mon.types, {1, 1, 1, 1, 1, 1, 1, 1}, "None"}}

	fmt.println(my_battle_mon.stat_mon.species)
	fmt.println(my_battle_mon.dyn_mon.type_changes.t1)
	fmt.println(my_battle_mon.stat_mon.types.t1)

	my_battle_mon.dyn_mon.type_changes.t1 = "Ice"
	fmt.println(my_battle_mon.dyn_mon.type_changes)
	fmt.println(my_battle_mon.stat_mon.types)
}
