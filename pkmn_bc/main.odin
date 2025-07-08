#+feature dynamic-literals
package main

// imports
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:slice"

// type chart
TypeMapIndex := map[string]int { //PLEASE NEVER CHANGE
	"Normal" = 0,
	"Fighting" = 1,
	"Flying" = 2,
	"Poison" = 3,
	"Ground" = 4,
	"Rock" = 5,
	"Bug" = 6,
	"Ghost" = 7,
	"Steel" = 8,
	"Fire" = 9,
	"Water" = 10,
	"Grass" = 11,
	"Electric" = 12,
	"Psychic" = 13,
	"Ice" = 14,
	"Dragon" = 15,
	"Dark" = 16,
	"Fairy" = 17,
}
@(rodata)
nr_types := 18
@(rodata)
type_chart_raw := [?]f32 { // rows: type of move, columns: type of defending Pokémon
	1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 0.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // Normal
	2.0, 1.0, 0.5, 0.5, 1.0, 2.0, 0.5, 0.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 0.5, // Fighting
	1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, // Flying
	1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 0.5, 0.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, // Poison
	1.0, 1.0, 0.0, 2.0, 1.0, 2.0, 0.5, 1.0, 2.0, 2.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, // Ground
	1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 2.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, // Rock
	1.0, 0.5, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 0.5, // Bug
	0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 1.0, // Ghost
	1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 2.0, // Steel
	1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 0.5, 0.5, 2.0, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, // Fire
	1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 2.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, // Water
	1.0, 1.0, 0.5, 0.5, 2.0, 2.0, 0.5, 1.0, 0.5, 0.5, 2.0, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, // Grass
	1.0, 1.0, 2.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, // Electric
	1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 0.0, 1.0, // Psychic
	1.0, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 2.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, // Ice
	1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.0, // Dragon
	1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, // Dark
	1.0, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, // Fairy
	1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // None
}

// moves
move_chart := map[MoveName]Move { //PLEASE NEVER CHANGE
	"Volt Tackle" = {{"Electric", "None"}, .physical, 60, 100, 0}, // power halved for slower battles
	"Iron Tail" = {{"Steel", "None"}, .physical, 50, 75, 0}, // power halved for slower battles
	"Quick Attack" = {{"Normal", "None"}, .physical, 20, 100, 1}, // power halved for slower battles
	"Thunderbolt" = {{"Electric", "None"}, .special, 45, 100, 0}, // power halved for slower battles
	"Flare Blitz" = {{"Fire", "None"}, .physical, 60, 100, 0}, // power halved for slower battles
	"Air Slash" = {{"Flying", "None"}, .special, 38, 95, 0}, // power halved for slower battles
	"Blast Burn" = {{"Fire", "None"}, .special, 75, 90, 0}, // power halved for slower battles
	"Dragon Pulse" = {{"Dragon", "None"}, .special, 43, 100, 0}, // power halved for slower battles
}

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
MoveName :: distinct string
MoveCategory :: enum u8 {physical, special, status}
Move :: struct {
	types: Types,
	category: MoveCategory,
	base_power: int,
	base_accuracy: int,
	prio: i8,
	// secondary effects
	// AP
}
MovePool :: [4]MoveName
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
	moves: MovePool,
}
BattleMon :: struct {
	stat_mon: ^Mon,
	dyn_mon: struct {
		type_changes: Types,
		stat_changes: Stats8,
		status2: string,
	}
}
AttackResult :: enum u8 {none, miss, supeff, noteff, crit, critsupeff, critnoteff}
PrioEntry :: struct{
	prio: i8,
	spe: ^int,
	atk_mon: ^BattleMon,
	def_mon: ^BattleMon,
	move: ^MoveName,
}
PrioList :: [dynamic]PrioEntry

// procs
attack :: proc(mon_1, mon_2: ^BattleMon, move: ^MoveName) -> (damage: int, result := AttackResult.none) {
	move_data := move_chart[move^]

	// damage = floor(((level*2+10)*bdmg*atk/250/def*F1+2)*crit*F2*Z/100*stab*type1*type2*F3)
	// bdmg = bpwr * stuff
	// atk = stat * mod * ability * item
	// def = stat * mod * ability * item * sandstorm
	// F1 = burn * screens * 2v2 * weather * flash fire
	// F2 = life orb/metronome * me first
	// F3 = solid rock/filter * expert belt * tinted lens * berry
	// Omission for now: abilities, items, funky moves, status, weather
	// => F1, F2, F3, atk, def = stat * mod, bdmg = bpwr

	// Hitting (accuracy and evasion)
	// Acc_mod = acc_move * acc_eva_mod * stuff
	bacc := f32(move_data.base_accuracy)
	acc_stat := f32(mon_1.dyn_mon.stat_changes.acc)
	eva_stat := f32(mon_2.dyn_mon.stat_changes.eva)
	acc_eva_diff := max(min(acc_stat - eva_stat, 6), -6)
	acc_eva_mod: f32 = 1.0
	if acc_eva_diff > 0 {
		acc_eva_mod = (3 + acc_eva_diff) / 3
	} else if acc_eva_diff < 0 {
		acc_eva_mod = 3 / (3 - acc_eva_diff)
	}
	acc_move := min(int(bacc * acc_eva_mod), 100)
	acc_eva_rand := rand.int_max(101)
	if acc_eva_rand > acc_move {
		damage = 0
		result = AttackResult.miss
		return damage, result
	}

	level := f32(mon_1.stat_mon.level)
	bpwr := f32(move_data.base_power)
	atk_stat: f32
	atk_mod: f32
	def_stat: f32
	def_mod: f32
	#partial switch move_data.category {
	case .physical:
		atk_stat = f32(mon_1.stat_mon.actual_stats.atk) // spa
		atk_mod = f32(mon_1.dyn_mon.stat_changes.atk) // spa
		def_stat = f32(mon_2.stat_mon.actual_stats.def) // spd
		def_mod = f32(mon_2.dyn_mon.stat_changes.def) // spd
	case .special:
		atk_stat = f32(mon_1.stat_mon.actual_stats.spa) // spa
		atk_mod = f32(mon_1.dyn_mon.stat_changes.spa) // spa
		def_stat = f32(mon_2.stat_mon.actual_stats.spd) // spd
		def_mod = f32(mon_2.dyn_mon.stat_changes.spd) // spd
	}
	random_factor := (f32(85 + rand.int_max(16)) / 100.0)
	stab: f32 = 1.0
	if move_data.types.t1 == mon_1.dyn_mon.type_changes.t1 || move_data.types.t1 == mon_1.dyn_mon.type_changes.t2 {
		stab = 1.5
	}
	type1: f32 = type_chart_raw[TypeMapIndex[move_data.types.t1]*nr_types+TypeMapIndex[mon_2.dyn_mon.type_changes.t1]]
	type2: f32 = type_chart_raw[TypeMapIndex[move_data.types.t1]*nr_types+TypeMapIndex[mon_2.dyn_mon.type_changes.t2]]
	if type1 * type2 > 1 {
		result = AttackResult.supeff
	} else if type1 * type2 < 1 {
		result = AttackResult.noteff
	}

	// check for crit
	// 1: 1/24, 2: 1/8, 3: 1/2, 4: 1
	crit_chance: f32 = 1.0/24.0
	crit_rand := rand.float32()
	crit: f32 = 1.0
	if crit_rand <= crit_chance {
		crit = 1.5
		atk_mod = min(atk_mod, 1.0)
		def_mod = max(def_mod, 1.0)
		#partial switch result {
		case .none:
			result = AttackResult.crit
		case .supeff:
			result = AttackResult.critsupeff
		case .noteff:
			result = AttackResult.critnoteff
		}
	}

	bdmg := bpwr
	atk := atk_stat * atk_mod
	def := def_stat * def_mod

	/*
	fmt.println(level)
	fmt.println(bdmg)
	fmt.println(atk)
	fmt.println(def)
	fmt.println(random_factor)
	*/

	damage_raw := ((level + 5) * bdmg * atk / def / 125 + 2) * crit * random_factor * stab * type1 * type2
	damage = int(damage_raw)

	return damage, result
}

half_round :: proc(mon_1, mon_2: ^BattleMon, move: ^MoveName) {
	fmt.println()
	damage, result := attack(mon_1, mon_2, move)
	#partial switch result {
	case .miss:
		fmt.println(mon_1.stat_mon.species, "missed.")
	case .crit, .critsupeff, .critnoteff:
		fmt.println("It\'s a critical hit!")
	}
	#partial switch result {
	case .supeff, .critsupeff:
		fmt.println("It\'s super effective.")
	case .noteff, .critnoteff:
		fmt.println("It\'s not very effective.")
	}
	if damage < mon_2.stat_mon.current_hp {
		fmt.printfln("%s (%s) against %s: %d", move^, mon_1.stat_mon.species, mon_2.stat_mon.species, damage)
		mon_2.stat_mon.current_hp -= damage
		fmt.printfln("%s's current HP: %d", mon_2.stat_mon.species, mon_2.stat_mon.current_hp)
	} else {
		fmt.printfln("%s fainted!", mon_2.stat_mon.species)
		mon_2.stat_mon.current_hp = 0
	}
	fmt.println()
}

prio_sort :: proc(lhs, rhs: PrioEntry) -> bool {
	return lhs.prio > rhs.prio
}

speed_sort :: proc(lhs, rhs: PrioEntry) -> bool {
	return lhs.prio == rhs.prio && lhs.spe^ > rhs.spe^
}

full_round :: proc(mon_1, mon_2: ^BattleMon, move1, move2: ^MoveName) {
	// determining order // no speed modifyer
	prio_list := PrioList{
		{move_chart[move1^].prio, &mon_1.stat_mon.actual_stats.spe, mon_1, mon_2, move1},
		{move_chart[move2^].prio, &mon_2.stat_mon.actual_stats.spe, mon_2, mon_1, move2},
	}
	slice.sort_by(prio_list[:], prio_sort)
	slice.sort_by(prio_list[:], speed_sort)

	// calling half_round() in order
	for entry in prio_list {
		half_round(entry.atk_mon, entry.def_mon, entry.move)
	}
}

// main
main :: proc() {
	my_mon := Mon{"Pikachu", 50, {"Electric", "None"}, {35, 55, 40, 50, 50, 90}, {31, 31, 31, 31, 31, 31}, {4, 252, 0, 0, 0, 252}, {111, 107, 60, 70, 70, 142}, 111, "None", {"Volt Tackle", "Iron Tail", "Quick Attack", "Thunderbolt"}}
	enemy_mon := Mon{"Charizard", 50, {"Fire", "Flying"}, {78, 84, 78, 109, 85, 100}, {31, 31, 31, 31, 31, 31}, {4, 0, 0, 252, 0, 252}, {154, 104, 98, 161, 105, 152}, 154, "None", {"Flare Blitz", "Air Slash", "Blast Burn", "Dragon Pulse"}}
	my_battle_mon := BattleMon{&my_mon, {my_mon.types, {1, 1, 1, 1, 1, 1, 1, 1}, "None"}}
	enemy_battle_mon := BattleMon{&enemy_mon, {enemy_mon.types, {1, 1, 1, 1, 1, 1, 1, 1}, "None"}}
	my_move := rand.choice(my_mon.moves[:])
	enemy_move := rand.choice(enemy_mon.moves[:])

	// first implementation of a full round of battle: both Pikachu and Charizard use a random attack from their movepool
	full_round(&my_battle_mon, &enemy_battle_mon, &my_move, &enemy_move)
}
