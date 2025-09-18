#+feature dynamic-literals
package main

// imports
import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:os"
import "core:slice"
import "core:reflect"

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
	"None" = 18,
}
@(rodata)
nr_types := 19
@(rodata)
type_chart_raw := [?]f32 { // rows: type of move, columns: type of defending Pokémon
	1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 0.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // Normal
	2.0, 1.0, 0.5, 0.5, 1.0, 2.0, 0.5, 0.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 0.5, 1.0, // Fighting
	1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // Flying
	1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 0.5, 0.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, // Poison
	1.0, 1.0, 0.0, 2.0, 1.0, 2.0, 0.5, 1.0, 2.0, 2.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // Ground
	1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 2.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, // Rock
	1.0, 0.5, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 0.5, 1.0, // Bug
	0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 1.0, 1.0, // Ghost
	1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, 0.5, 1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 2.0, 1.0, // Steel
	1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 0.5, 0.5, 2.0, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, // Fire
	1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 2.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, // Water
	1.0, 1.0, 0.5, 0.5, 2.0, 2.0, 0.5, 1.0, 0.5, 0.5, 2.0, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, // Grass
	1.0, 1.0, 2.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, // Electric
	1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 0.0, 1.0, 1.0, // Psychic
	1.0, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 2.0, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, // Ice
	1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.0, 1.0, // Dragon
	1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, 1.0, // Dark
	1.0, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, // Fairy
	1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, // None
}
Natures :: enum u8 {hardy, lonely, adamant, naughty, brave, bold, docile, impish, lax, relaxed, modest, mild, bashful, rash, quiet, calm, gentle, careful, quirky, sassy, timid, hasty, jolly, naive, serious}
@(rodata)
nature_chart := [Natures]Stats8 {
	.hardy =   {0,   0,   0,   0,   0,   0, 0, 0},
	.lonely =  {0,  10, -10,   0,   0,   0, 0, 0},
	.adamant = {0,  10,   0, -10,   0,   0, 0, 0},
	.naughty = {0,  10,   0,   0, -10,   0, 0, 0},
	.brave =   {0,  10,   0,   0,   0, -10, 0, 0},
	.bold =    {0, -10,  10,   0,   0,   0, 0, 0},
	.docile =  {0,   0,   0,   0,   0,   0, 0, 0},
	.impish =  {0,   0,  10, -10,   0,   0, 0, 0},
	.lax =     {0,   0,  10,   0, -10,   0, 0, 0},
	.relaxed = {0,   0,  10,   0,   0, -10, 0, 0},
	.modest =  {0, -10,   0,  10,   0,   0, 0, 0},
	.mild =    {0,   0, -10,  10,   0,   0, 0, 0},
	.bashful = {0,   0,   0,   0,   0,   0, 0, 0},
	.rash =    {0,   0,   0,  10, -10,   0, 0, 0},
	.quiet =   {0,   0,   0,  10,   0, -10, 0, 0},
	.calm =    {0, -10,   0,   0,  10,   0, 0, 0},
	.gentle =  {0,   0, -10,   0,  10,   0, 0, 0},
	.careful = {0,   0,   0, -10,  10,   0, 0, 0},
	.quirky =  {0,   0,   0,   0,   0,   0, 0, 0},
	.sassy =   {0,   0,   0,   0,  10, -10, 0, 0},
	.timid =   {0, -10,   0,   0,   0,  10, 0, 0},
	.hasty =   {0,   0, -10,   0,   0,  10, 0, 0},
	.jolly =   {0,   0,   0, -10,   0,  10, 0, 0},
	.naive =   {0,   0,   0,   0, -10,  10, 0, 0},
	.serious = {0,   0,   0,   0,   0,   0, 0, 0},
}

// moves
move_chart := map[MoveName]Move { //PLEASE NEVER CHANGE
	"ConfusedAttack" = {{"None", "None"}, .physical, 8, 100, 0, {}, {}}, // power/5, fix accuracy later
	"Volt Tackle" = {{"Electric", "None"}, .physical, 24, 100, 0, #partial {.paralyze=0.1, .recoil=1.0/3.0}, {}}, // power/5 for slower battles
	"Iron Tail" = {{"Steel", "None"}, .physical, 20, 75, 0, #partial {.statdrop=0.3}, #partial {def=-1}}, // power/5 for slower battles
	"Quick Attack" = {{"Normal", "None"}, .physical, 8, 100, 1, {}, {}}, // power/5 for slower battles
	"Thunderbolt" = {{"Electric", "None"}, .special, 18, 100, 0, #partial {.paralyze=0.1}, {}}, // power halved for slower battles
	"Flare Blitz" = {{"Fire", "None"}, .physical, 24, 100, 0, #partial {.burn=0.1, .recoil=1.0/3.0}, {}}, // power halved for slower battles
	"Air Slash" = {{"Flying", "None"}, .special, 15, 95, 0, #partial {.flinch=0.3}, {}}, // power halved for slower battles
	"Blast Burn" = {{"Fire", "None"}, .special, 30, 90, 0, #partial {.recharge=1}, {}}, // power halved for slower battles
	"Dragon Pulse" = {{"Dragon", "None"}, .special, 17, 100, 0, {}, {}}, // power halved for slower battles
} // infinite accuracy with math.inf_f32, but currently doesn't work with ints

// structs and others
Stats6 :: struct {
	hp, atk, def, spa, spd, spe: int,
}
Stats8 :: struct {
	hp, atk, def, spa, spd, spe, acc, eva: i8,
}
Types :: struct {
	t1, t2: string,
}
MoveName :: distinct string
MoveCategory :: enum u8 {physical, special, status}
MoveSec :: enum u8 {burn, freeze, paralyze, poison, badlypoison, sleep, confuse, yawn, flinch, recoil, absorb, statdrop, statboost, highcrit, recharge, charge} // probably not complete, completing later, working on implementation one by one, next one recharge and charge, but not now.
MoveSecProb :: [MoveSec]f32
Move :: struct {
	types: Types,
	category: MoveCategory,
	base_power: int,
	base_accuracy: int,
	prio: i8,
	sec: MoveSecProb,
	stat_change: Stats8,
	// AP
}
MovePool :: [4]MoveName
Status1 :: enum u8 {none, fainted, burned, frozen, paralyzed, poisoned, badlypoisoned, asleep} // in theory all are done, testing done
Status2 :: bit_set[enum u8 {confused, yawned1, yawned2, flinched}] // VERY incomplete
Mon :: struct {
	species: string,
	// name: string,
	level: int,
	// ability: string,
	nature: Natures,
	types: Types,
	base_stats: Stats6,
	ivs: Stats6,
	evs: Stats6,
	actual_stats: Stats6,
	current_hp: int,
	status1: Status1,
	moves: MovePool,
}
BattleMon :: struct {
	stat_mon: ^Mon,
	dyn_mon: struct {
		type_changes: Types,
		stat_changes: Stats8,
		status2: Status2,
		status_counters: struct {
			badpoison: u8,
			sleep: u8,
			confusion: u8,
		}
	}
}
AttackResult :: enum u8 {hit, miss, supeff, noteff, crit, critsupeff, critnoteff, confused}
PrioEntry :: struct{
	prio: i8,
	spe: int,
	atk_mon: ^BattleMon,
	def_mon: ^BattleMon,
	move: ^MoveName,
}
PrioList :: [dynamic]PrioEntry

// procs
stat_fac_from_mod :: proc(mod: i8) -> (factor: f32 = 1.0) {
	if mod > 0 {
		factor = f32(2 + mod) / 2.0
	} else if mod < 0 {
		factor = 2.0 / f32(2 - mod)
	}
	return factor
}

acev_fac_from_mod :: proc(mod: i8) -> (factor: f32 = 1.0) {
	if mod > 0 {
		factor = f32(3 + mod) / 3.0
	} else if mod < 0 {
		factor = 3.0 / f32(3 - mod)
	}
	return factor
}

attack :: proc(mon_1, mon_2: ^BattleMon, move: ^MoveName) -> (damage: int, result := AttackResult.hit) {
	move_data := move_chart[move^]
	conf := move^ == "ConfusedAttack"

	// damage = floor(((level*2+10)*bdmg*atk/250/def*F1+2)*crit*F2*Z/100*stab*type1*type2*F3)
	// bdmg = bpwr * stuff
	// atk = stat * mod * ability * item
	// def = stat * mod * ability * item * sandstorm
	// F1 = burn * screens * 2v2 * weather * flash fire
	// F2 = life orb/metronome * me first
	// F3 = solid rock/filter * expert belt * tinted lens * berry
	// Omission for now: abilities, items, funky moves, status, weather
	// => F1, F2, F3, atk, def = stat * mod, bdmg = bpwr

	// Hitting (not, due to missing target)
	if mon_2.stat_mon.status1 == .fainted {
		damage = 0
		result = .miss
		return damage, result
	}

	// Hitting (accuracy and evasion)
	// Acc_mod = acc_move * acc_eva_mod * stuff
	if ! conf {
		bacc := f32(move_data.base_accuracy)
		acc_stat := mon_1.dyn_mon.stat_changes.acc
		eva_stat := mon_2.dyn_mon.stat_changes.eva
		acev_diff := max(min(acc_stat - eva_stat, 6), -6)
		acev_mod := acev_fac_from_mod(acev_diff)
		acc_move := min(int(bacc * acev_mod), 100)
		acev_rand := rand.int_max(101)
		if acev_rand > acc_move {
			damage = 0
			result = .miss
			return damage, result
		}
	}

	// Basic values required
	level := f32(mon_1.stat_mon.level)
	bpwr := f32(move_data.base_power)
	atk_stat: f32
	atk_mod: f32
	def_stat: f32
	def_mod: f32
	burn: f32 = 1.0
	#partial switch move_data.category {
	case .physical:
		atk_stat = f32(mon_1.stat_mon.actual_stats.atk)
		atk_mod = stat_fac_from_mod(mon_1.dyn_mon.stat_changes.atk)
		def_stat = f32(mon_2.stat_mon.actual_stats.def)
		def_mod = stat_fac_from_mod(mon_2.dyn_mon.stat_changes.def)
		if mon_1.stat_mon.status1 == .burned {
			burn = 0.5
		}
	case .special:
		atk_stat = f32(mon_1.stat_mon.actual_stats.spa)
		atk_mod = stat_fac_from_mod(mon_1.dyn_mon.stat_changes.spa)
		def_stat = f32(mon_2.stat_mon.actual_stats.spd)
		def_mod = stat_fac_from_mod(mon_2.dyn_mon.stat_changes.spd)
	}
	random_factor := (f32(85 + rand.int_max(16)) / 100.0)
	stab: f32 = 1.0
	if move_data.types.t1 == mon_1.dyn_mon.type_changes.t1 || move_data.types.t1 == mon_1.dyn_mon.type_changes.t2 {
		stab = 1.5
	}
	type1: f32 = type_chart_raw[TypeMapIndex[move_data.types.t1]*nr_types+TypeMapIndex[mon_2.dyn_mon.type_changes.t1]]
	type2: f32 = type_chart_raw[TypeMapIndex[move_data.types.t1]*nr_types+TypeMapIndex[mon_2.dyn_mon.type_changes.t2]]
	if type1 * type2 > 1 {
		result = .supeff
	} else if type1 * type2 < 1 {
		result = .noteff
	}

	// check for crit
	// 1: 1/24, 2: 1/8, 3: 1/2, 4: 1
	crit: f32 = 1.0
	if ! conf {
		crit_chance: f32
		if move_data.sec[.highcrit] != 0.0 {
			crit_chance = 1.0/8.0
		} else {
			crit_chance = 1.0/24.0
		}
		crit_rand := rand.float32()
		if crit_rand <= crit_chance {
			crit = 1.5
			atk_mod = min(atk_mod, 1.0)
			def_mod = max(def_mod, 1.0)
			#partial switch result {
			case .hit:
				result = .crit
			case .supeff:
				result = .critsupeff
			case .noteff:
				result = .critnoteff
			}
		}
	}

	bdmg := bpwr
	atk := atk_stat * atk_mod
	def := def_stat * def_mod

	if conf {
		f1: f32 = 1.0
		damage_raw := ((level + 5) * bdmg * atk / def / 125 * f1 + 2) * random_factor
		damage = int(damage_raw)
		result = .confused
	} else {
		f1: f32 = burn
		damage_raw := ((level + 5) * bdmg * atk / def / 125 * f1 + 2) * crit * random_factor * stab * type1 * type2
		damage = int(damage_raw)
	}

	return damage, result
}

half_round :: proc(mon_1, mon_2: ^BattleMon, move: ^MoveName) {
	damage, result := attack(mon_1, mon_2, move)
	#partial switch result {
	case .miss:
		fmt.printfln("%s missed.", mon_1.stat_mon.species)
	case .confused:
		fmt.printfln("%s hit itself in confusion.", mon_1.stat_mon.species)
	case .crit, .critsupeff, .critnoteff:
		fmt.println("It's a critical hit!")
		fallthrough
	case:
		if move_chart[move^].types.t1 == "Fire" && mon_2.stat_mon.status1 == .frozen {
			mon_2.stat_mon.status1 = .none
			fmt.printfln("%s thawed out!", mon_2.stat_mon.species)
		}
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
		fmt.printfln("%s (%s) against %s: %d", move^, mon_1.stat_mon.species, mon_2.stat_mon.species, mon_2.stat_mon.current_hp)
		mon_2.stat_mon.current_hp = 0
		mon_2.stat_mon.status1 = .fainted
		fmt.printfln("%s fainted!", mon_2.stat_mon.species)
		// win condition
		fmt.printfln("%s wins the match!", mon_1.stat_mon.species)
		os.exit(0)
	}
	// secondary attack effects
	brn_chance := move_chart[move^].sec[.burn]
	brn_rand := rand.float32()
	if brn_rand <= brn_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .burned
		fmt.printfln("%s got burned!", mon_2.stat_mon.species)
	}
	frz_chance := move_chart[move^].sec[.freeze]
	frz_rand := rand.float32()
	if frz_rand <= frz_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .frozen
		fmt.printfln("%s was frozen!", mon_2.stat_mon.species)
	}
	par_chance := move_chart[move^].sec[.paralyze]
	par_rand := rand.float32()
	if par_rand <= par_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .paralyzed
		fmt.printfln("%s was paralyzed!", mon_2.stat_mon.species)
	}
	psn_chance := move_chart[move^].sec[.poison]
	psn_rand := rand.float32()
	if psn_rand <= psn_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .poisoned
		fmt.printfln("%s was poisoned!", mon_2.stat_mon.species)
	}
	bdlpsn_chance := move_chart[move^].sec[.badlypoison]
	bdlpsn_rand := rand.float32()
	if bdlpsn_rand <= bdlpsn_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .badlypoisoned
		fmt.printfln("%s was badly poisoned!", mon_2.stat_mon.species)
	}
	slp_chance := move_chart[move^].sec[.sleep]
	slp_rand := rand.float32()
	if slp_rand <= slp_chance && mon_2.stat_mon.status1 == .none {
		mon_2.stat_mon.status1 = .asleep
		mon_2.dyn_mon.status_counters.sleep = u8(2 + rand.int_max(4))
		fmt.printfln("%s fell asleep!", mon_2.stat_mon.species)
	}
	conf_chance := move_chart[move^].sec[.confuse]
	conf_rand := rand.float32()
	if conf_rand <= conf_chance {
		mon_2.dyn_mon.status2 = mon_2.dyn_mon.status2 + Status2{.confused}
		mon_2.dyn_mon.status_counters.confusion = u8(2 + rand.int_max(4))
		fmt.printfln("%s was confused!", mon_2.stat_mon.species)
	}
	yawn_chance := move_chart[move^].sec[.yawn]
	yawn_rand := rand.float32()
	if yawn_rand <= yawn_chance && .yawned1 not_in mon_2.dyn_mon.status2 {
		mon_2.dyn_mon.status2 = mon_2.dyn_mon.status2 + Status2{.yawned1}
		fmt.printfln("%s is yawning!", mon_2.stat_mon.species)
	}
	flinch_chance := move_chart[move^].sec[.flinch]
	flinch_rand := rand.float32()
	if flinch_rand <= flinch_chance {
		mon_2.dyn_mon.status2 = mon_2.dyn_mon.status2 + Status2{.flinched}
	}
	if move_chart[move^].sec[.recoil] != 0 {
		rec_damage := int(f32(damage) * move_chart[move^].sec[.recoil])
		if rec_damage < mon_1.stat_mon.current_hp {
			fmt.printfln("%s hurt itself in recoil: %d", mon_1.stat_mon.species, rec_damage)
			mon_1.stat_mon.current_hp -= rec_damage
			fmt.printfln("%s's current HP: %d", mon_1.stat_mon.species, mon_1.stat_mon.current_hp)
		} else {
			fmt.printfln("%s hurt itself in recoil: %d", mon_1.stat_mon.species, mon_1.stat_mon.current_hp)
			mon_1.stat_mon.current_hp = 0
			mon_1.stat_mon.status1 = .fainted
			fmt.printfln("%s fainted!", mon_1.stat_mon.species)
			// win condition
			fmt.printfln("%s wins the match!", mon_2.stat_mon.species)
			os.exit(0)
		}
	}
	if move_chart[move^].sec[.absorb] != 0 {
		abs_heal := int(f32(damage) * move_chart[move^].sec[.recoil])
		fmt.printfln("%s heals itself!", mon_1.stat_mon.species)
		mon_1.stat_mon.current_hp = min(mon_1.stat_mon.current_hp + abs_heal, mon_1.stat_mon.actual_stats.hp)
		fmt.printfln("%s's current HP: %d", mon_1.stat_mon.species, mon_1.stat_mon.current_hp)
	}
	statdrop_chance := move_chart[move^].sec[.statdrop]
	statdrop_rand := rand.float32()
	if statdrop_rand <= statdrop_chance {
		change_stats(mon_2, move_chart[move^].stat_change)
	}
	statboost_chance := move_chart[move^].sec[.statboost]
	statboost_rand := rand.float32()
	if statboost_rand <= statboost_chance {
		change_stats(mon_2, move_chart[move^].stat_change)
	}
}

change_stats_announcement :: proc(mon: string, change_value: i8, stat: string) {
	switch x := change_value; {
	case x >= 3:
		fmt.printfln("%s's %s rose drastically!", mon, stat)
	case x == 2:
		fmt.printfln("%s's %s rose sharply!", mon, stat)
	case x == 1:
		fmt.printfln("%s's %s rose!", mon, stat)
	case x == 0:
		fmt.printfln("%s's %s won't go any higher or lower!", mon, stat)
	case x == -1:
		fmt.printfln("%s's %s fell!", mon, stat)
	case x ==-2 :
		fmt.printfln("%s's %s harshly fell!", mon, stat)
	case x <= -3:
		fmt.printfln("%s's %s severely fell!", mon, stat)
	}
}

change_stats :: proc(mon: ^BattleMon, change: Stats8) {
	using mon.dyn_mon.stat_changes
	change_value: i8
	if change.atk != 0 {
		change_value = min(max(atk + change.atk, -6), 6) - atk
		atk += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Attack")
	}
	if change.def != 0 {
		change_value = min(max(def + change.def, -6), 6) - def
		def += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Defence")
	}
	if change.spa != 0 {
		change_value = min(max(spa + change.spa, -6), 6) - spa
		spa += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Special Attack")
	}
	if change.spd != 0 {
		change_value = min(max(spd + change.spd, -6), 6) - spd
		spd += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Special Defence")
	}
	if change.spe != 0 {
		change_value = min(max(spe + change.spe, -6), 6) - spe
		spe += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Speed")
	}
	if change.acc != 0 {
		change_value = min(max(acc + change.acc, -6), 6) - acc
		acc += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Accuracy")
	}
	if change.eva != 0 {
		change_value = min(max(eva + change.eva, -6), 6) - eva
		eva += change_value
		change_stats_announcement(mon.stat_mon.species, change_value, "Evasiveness")
	}
}

prio_sort :: proc(lhs, rhs: PrioEntry) -> bool {
	return lhs.prio > rhs.prio
}

para_spe :: proc(spe: int, status1: Status1) -> int {
		if status1 == .paralyzed {
			return spe / 2
		} else {
			return spe
		}
}

prio_speed_sort :: proc(lhs, rhs: PrioEntry) -> bool {
	return lhs.prio == rhs.prio && lhs.spe > rhs.spe
}

speed_sort :: proc(lhs, rhs: PrioEntry) -> bool {
	return lhs.spe > rhs.spe
}

full_round :: proc(mon_1, mon_2: ^BattleMon, move1, move2: ^MoveName) {
	prio_list := PrioList{
		{move_chart[move1^].prio, para_spe(mon_1.stat_mon.actual_stats.spe, mon_1.stat_mon.status1), mon_1, mon_2, move1},
		{move_chart[move2^].prio, para_spe(mon_2.stat_mon.actual_stats.spe, mon_2.stat_mon.status1), mon_2, mon_1, move2},
	}
	rand.shuffle(prio_list[:]) // for random outcome of speed ties
	slice.sort_by(prio_list[:], prio_sort)
	slice.sort_by(prio_list[:], prio_speed_sort)

	// calling half_round() in order
	for &entry in prio_list {
		fmt.println()
		#partial switch entry.atk_mon.stat_mon.status1 {
		case .frozen:
			// thaw out chance
			thaw_rand := rand.float32()
			if thaw_rand <= 0.2 {
				entry.atk_mon.stat_mon.status1 = .none
				fmt.printfln("%s thawed out!", entry.atk_mon.stat_mon.species)
			}
			// thaw out with attack
			// missing
		case .asleep:
			// wake up pseudochance
			if entry.atk_mon.dyn_mon.status_counters.sleep == 0 {
				entry.atk_mon.stat_mon.status1 = .none
				fmt.printfln("%s woke up!", entry.atk_mon.stat_mon.species)
			} else {
				entry.atk_mon.dyn_mon.status_counters.sleep -= 1
			}
		}
		#partial switch entry.atk_mon.stat_mon.status1 {
		case .fainted:
			fmt.printfln("%s is fainted, it can't fight!", entry.atk_mon.stat_mon.species)
		case .frozen:
			fmt.printfln("%s is frozen solid!", entry.atk_mon.stat_mon.species)
		case .asleep:
			fmt.printfln("%s is fast asleep!", entry.atk_mon.stat_mon.species)
		case .paralyzed:
			para_rand := rand.float32()
			if para_rand <= 0.25 {
				fmt.printfln("%s is paralyzed! It can't move!", entry.atk_mon.stat_mon.species)
				break
			}
			fallthrough
		case:
			if .flinched in entry.atk_mon.dyn_mon.status2 {
				fmt.printfln("%s flinches!", entry.atk_mon.stat_mon.species)
				break
			}
			if .confused in entry.atk_mon.dyn_mon.status2 {
				entry.atk_mon.dyn_mon.status_counters.confusion -= 1
				if entry.atk_mon.dyn_mon.status_counters.confusion == 0 {
					mon_2.dyn_mon.status2 = mon_2.dyn_mon.status2 - Status2{.confused}
					fmt.printfln("%s snapped out of confusion!", entry.atk_mon.stat_mon.species)
				} else {
					fmt.printfln("%s is confused!", entry.atk_mon.stat_mon.species)
					conf_chance: f32 = 1/3
					conf_rand := rand.float32()
					if conf_rand <= conf_chance {
						// confusion hit
						entry.move^ = "ConfusedAttack"
					}
				}
			}
			half_round(entry.atk_mon, entry.def_mon, entry.move)
		}
		fmt.println()
	}

	// burn, poison, sandstorm, hail, yawn into sleep, end flinches
	slice.sort_by(prio_list[:], speed_sort)
	for entry in prio_list {
		#partial switch entry.atk_mon.stat_mon.status1 {
		case .burned:
			damage := max(entry.atk_mon.stat_mon.actual_stats.hp / 16, 1)
			if damage < entry.atk_mon.stat_mon.current_hp {
				fmt.printfln("%s was hurt by its burn!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp -= damage
				fmt.printfln("%s's current HP: %d", entry.atk_mon.stat_mon.species, entry.atk_mon.stat_mon.current_hp)
			} else {
				fmt.printfln("%s was hurt by its burn!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp = 0
				entry.atk_mon.stat_mon.status1 = .fainted
				fmt.printfln("%s fainted!", entry.atk_mon.stat_mon.species)
			}
		case .poisoned:
			damage := max(entry.atk_mon.stat_mon.actual_stats.hp / 8, 1)
			if damage < entry.atk_mon.stat_mon.current_hp {
				fmt.printfln("%s was hurt by poison!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp -= damage
				fmt.printfln("%s's current HP: %d", entry.atk_mon.stat_mon.species, entry.atk_mon.stat_mon.current_hp)
			} else {
				fmt.printfln("%s was hurt by poison!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp = 0
				entry.atk_mon.stat_mon.status1 = .fainted
				fmt.printfln("%s fainted!", entry.atk_mon.stat_mon.species)
			}
		case .badlypoisoned:
			entry.atk_mon.dyn_mon.status_counters.badpoison = min(entry.atk_mon.dyn_mon.status_counters.badpoison + 1, 15)
			damage := max(entry.atk_mon.stat_mon.actual_stats.hp * int(entry.atk_mon.dyn_mon.status_counters.badpoison) / 16, 1)
			if damage < entry.atk_mon.stat_mon.current_hp {
				fmt.printfln("%s was hurt by poison!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp -= damage
				fmt.printfln("%s's current HP: %d", entry.atk_mon.stat_mon.species, entry.atk_mon.stat_mon.current_hp)
			} else {
				fmt.printfln("%s was hurt by poison!", entry.atk_mon.stat_mon.species)
				entry.atk_mon.stat_mon.current_hp = 0
				entry.atk_mon.stat_mon.status1 = .fainted
				fmt.printfln("%s fainted!", entry.atk_mon.stat_mon.species)
			}
		}
		if .yawned1 in entry.atk_mon.dyn_mon.status2 {
			entry.atk_mon.dyn_mon.status2 = entry.atk_mon.dyn_mon.status2 - Status2{.yawned1} + Status2{.yawned2}
		} else if .yawned2 in entry.atk_mon.dyn_mon.status2 {
			if entry.atk_mon.stat_mon.status1 == .none {
				entry.atk_mon.stat_mon.status1 = .asleep
				entry.atk_mon.dyn_mon.status_counters.sleep = u8(2 + rand.int_max(4))
				entry.atk_mon.dyn_mon.status2 = entry.atk_mon.dyn_mon.status2 - Status2{.yawned2}
				fmt.printfln("%s fell asleep!", mon_2.stat_mon.species)
			}
		}
		entry.atk_mon.dyn_mon.status2 = entry.atk_mon.dyn_mon.status2 - Status2{.flinched}
	}
	fmt.println()
}

update_stats :: proc(using mon: ^Mon) {
	// HP = floor((2*stat+IV+floor(EV/4))*lv/100)+lv+10
	// others = floor(floor(2*stat+IV*floor(EV/4)/100+5)*nature)
	actual_stats.hp = (2 * base_stats.hp + ivs.hp + evs.hp / 4) * level / 100 + level + 10
	actual_stats.atk = ((2 * base_stats.atk + ivs.atk + evs.atk / 4) * level / 100 + 5) * (100 + int(nature_chart[nature].atk)) / 100
	actual_stats.def = ((2 * base_stats.def + ivs.def + evs.def / 4) * level / 100 + 5) * (100 + int(nature_chart[nature].def)) / 100
	actual_stats.spa = ((2 * base_stats.spa + ivs.spa + evs.spa / 4) * level / 100 + 5) * (100 + int(nature_chart[nature].spa)) / 100
	actual_stats.spd = ((2 * base_stats.spd + ivs.spd + evs.spd / 4) * level / 100 + 5) * (100 + int(nature_chart[nature].spd)) / 100
	actual_stats.spe = ((2 * base_stats.spe + ivs.spe + evs.spe / 4) * level / 100 + 5) * (100 + int(nature_chart[nature].spe)) / 100
}

init_mon :: proc(species: string, level: int, nature: Natures, types: Types, base_stats, ivs, evs: Stats6, moves: MovePool, status1 := Status1.none) -> (mon: Mon) {
	mon.species = species
	mon.level = level
	mon.types = types
	mon.base_stats = base_stats
	mon.ivs = ivs
	mon.evs = evs
	mon.moves = moves
	mon.status1 = status1
	update_stats(&mon)
	mon.current_hp = mon.actual_stats.hp
	return mon
}

// main
main :: proc() {
	my_mon := init_mon("Pikachu", 50, .adamant, {"Electric", "None"}, {35, 55, 40, 50, 50, 90}, {31, 31, 31, 31, 31, 31}, {4, 252, 0, 0, 0, 252}, {"Volt Tackle", "Iron Tail", "Quick Attack", "Thunderbolt"})
	enemy_mon := init_mon("Charizard", 50, .hasty, {"Fire", "Flying"}, {78, 84, 78, 109, 85, 100}, {31, 31, 31, 31, 31, 31}, {4, 0, 0, 252, 0, 252}, {"Flare Blitz", "Air Slash", "Blast Burn", "Dragon Pulse"})
	my_battle_mon := BattleMon{&my_mon, {my_mon.types, {}, {}, {}}}
	enemy_battle_mon := BattleMon{&enemy_mon, {enemy_mon.types, {}, {}, {}}}

	// Multiple rounds of battle: both Pikachu and Charizard use a random attack from their movepool
	my_move: MoveName
	enemy_move: MoveName
	for i in 0..=5 {
		my_move = rand.choice(my_mon.moves[:])
		enemy_move = rand.choice(enemy_mon.moves[:])
		full_round(&my_battle_mon, &enemy_battle_mon, &my_move, &enemy_move)
	}
}
