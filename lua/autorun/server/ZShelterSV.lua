--[[

	Alright, seems you just decompiled the addon, feel free to check this 4000+ line crap lua script


	-- WARNING --

	If you edit anything and reuploaded to workshop, please post the original addon and original creator name, or I'll force you to take it down!

	-----------------
	
	Anyway enjoy!
]]

util.AddNetworkString("SyncData")
util.AddNetworkString("SanityHurt")
util.AddNetworkString("SyncDataReturn")
util.AddNetworkString("ResourceNotify")
util.AddNetworkString("FullNotify")
util.AddNetworkString("OpenStorage")
util.AddNetworkString("TransferStorage")
util.AddNetworkString("BuildNetworking")
util.AddNetworkString("BlockMenuKey")
util.AddNetworkString("NightNotify")
util.AddNetworkString("BaseAlert")
util.AddNetworkString("StartNotify")
util.AddNetworkString("OpenWorkStation")
util.AddNetworkString("WorkStationNetWorking")
util.AddNetworkString("SkillTreeNetworking")
util.AddNetworkString("SyncSkill")
util.AddNetworkString("CloseMenu")
util.AddNetworkString("SpawnTimer")
util.AddNetworkString("GoalNotify")
util.AddNetworkString("SyncItems")
util.AddNetworkString("SyncItemsReturn")
util.AddNetworkString("SyncItemsFromClient")
util.AddNetworkString("SyncEnemys")
util.AddNetworkString("SyncEnemysReturn")
util.AddNetworkString("SyncEnemysFromClient")
util.AddNetworkString("SendAirStrike")
util.AddNetworkString("ResetBrightness")
util.AddNetworkString("SendCloak")

CreateConVar( "horde_zshelter_friendly_fire", 0, 256, "Enable friendly fire", 0, 1 )
CreateConVar( "horde_zshelter_allow_damage_shelter", 0, 256, "Prevent player damaging base", 0, 1 )
CreateConVar( "horde_zshelter_snap_to_grid", 0, 256, "Make building move by 24 * 24 unit", 0, 1 )
CreateConVar( "horde_zshelter_block_spawning_near_base", 1, 256, "Make zombies don't spawn near the base", 0, 1 )
CreateConVar( "horde_zshelter_disable_sanity", 0, 256, "Disable damage when running out of sanity", 0, 1 )

CreateConVar( "horde_zshelter_hardcore_mode", 0, 256, "Enable hardcore mode, everything gets harder when this enabled", 0, 1 )

CreateConVar( "horde_zshelter_custom_day_time", 0, 256, "Custom day time length, 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_night_time", 0, 256, "Custom night time length, 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_starting_wood", 0, 256, "Start with X amount of wood (Capped with max amount of storage), 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_starting_iron", 0, 256, "Start with X amount of iron (Capped with max amount of storage), 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_starting_skillpoints", 3, 256, "Start with X amount of skillpoints, 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_max_enemies", 0, 256, "Maximum amount of enemies, 0 = Disabled", 0, 1024 )
CreateConVar( "horde_zshelter_custom_ultimate_cooldown_airstrike", 40, 256, "Cooldown time of airstrike", 0, 1024 )
CreateConVar( "horde_zshelter_custom_ultimate_cooldown_cloak", 20, 256, "Cooldown time of cloak (unused)", 0, 1024 )

CreateConVar( "horde_zshelter_custom_enemyhp_increase_day", 10, 256, "How many hp enemy increase everyday, this won't effect enemy with [Scale with max number] enabled", 0, 1024 )

CreateConVar( "horde_zshelter_debug_nostart", 0, 256, "Prevent game start", 0, 1 )
CreateConVar( "horde_zshelter_debug_nozombie", 0, 256, "Prevent zombie spawning", 0, 1 )
CreateConVar( "horde_zshelter_debug_disable_requirments", 0, 256, "Don't need resources to build everything", 0, 1 )
CreateConVar( "horde_zshelter_debug_infinite_power", 0, 256, "Infinity powers", 0, 1 )
CreateConVar( "horde_zshelter_debug_infinite_skillpoints", 0, 256, "Infinity skillpoints", 0, 1 )
CreateConVar( "horde_zshelter_debug_infinite_resources", 0, 256, "Infinity resources", 0, 1 )

print("Path check -> | horde/shelter_mode | ->",file.IsDir("horde/shelter_mode", "DATA"))
if (!file.IsDir("horde/shelter_mode", "DATA")) then
    file.CreateDir("horde/shelter_mode")
end

print("Path check -> | horde/shelter_mode/default | ->",file.IsDir("horde/shelter_mode/default", "DATA"))
if (!file.IsDir("horde/shelter_mode/default", "DATA")) then
    file.CreateDir("horde/shelter_mode/default")
end

print("Path check -> | horde/shelter_mode/output | ->",file.IsDir("horde/shelter_mode/output", "DATA"))
if (!file.IsDir("horde/shelter_mode/output", "DATA")) then
    file.CreateDir("horde/shelter_mode/output")
end

print("Default config check (items) ->",file.Exists("horde/shelter_mode/items.txt", "DATA"))
if (!file.Exists("horde/shelter_mode/items.txt", "DATA")) then
	file.Write( "horde/shelter_mode/items.txt", "" )
	print("File Created -> horde/shelter_mode/items.txt")
end

print("Custom config check (items) ->", file.Exists("horde/shelter_mode/default/items.txt", "DATA"))
if (!file.Exists("horde/shelter_mode/default/items.txt", "DATA")) then
	file.Write( "horde/shelter_mode/default/items.txt", "" )
	print("File Created -> horde/shelter_mode/default/items.txt")
end

print("Default config check (enemy) ->",file.Exists("horde/shelter_mode/enemies.txt", "DATA"))
if (!file.Exists("horde/shelter_mode/enemies.txt", "DATA")) then
	file.Write( "horde/shelter_mode/enemies.txt", "" )
	print("File Created -> horde/shelter_mode/enemies.txt")
end

print("Custom config check (enemy) ->", file.Exists("horde/shelter_mode/default/enemies.txt", "DATA"))
if (!file.Exists("horde/shelter_mode/default/enemies.txt", "DATA")) then
	file.Write( "horde/shelter_mode/default/enemies.txt", "" )
	print("File Created -> horde/shelter_mode/default/enemies.txt")
end

function CheckMapEntities()
	local EnemySpawn = false
	local TreasureArea = false
	local Shelter = false
	local Storage = false
	local BossSpawn = false

	for k,v in pairs(ents.FindByClass("info_zshelter_enemy_spawn")) do EnemySpawn = true end 
	for k,v in pairs(ents.FindByClass("info_zshelter_storage_position")) do Storage = true end 
	for k,v in pairs(ents.FindByClass("info_zshelter_treasure_area")) do TreasureArea = true end 
	for k,v in pairs(ents.FindByClass("info_zshelter_boss_spawn")) do BossSpawn = true end 
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do Shelter = true end

	if(EnemySpawn && TreasureArea && Shelter && Storage && BossSpawn) then
		return true
	else
		return false
	end
end

function ShouldLoad()
	if(engine.ActiveGamemode() == "horde") then
		if(CheckMapEntities()) then
			return true
		end
	end
end

function GiveGunFromTable(player, nID)

	for k,v in next,CurrentItems do

		if(nID == v[8]) then

			player:Give(v[5])

		end

	end

end

MaxBuildHeight = -1
MaxResourceSpawnHeight = -1

CurrentItems = {}
CurrentEnemies = {}
RemoveGibList = {}
AirStrikeTable = {}
AirStrikeAttackTable = {}
PlayerCloakTable = {}

-- Define Items in workstation (Pretty dumb way to do this but whatever)

--> Index, Type, Technology, Displayname, ID, Wood Req, Iron Req
--> Technology IDs
----> 0 = None
----> 1 = SMG, Shotgun
----> 2 = Rifle
----> 3 = LMG
--> These are default items, if you're watching this, DO NOT EDIT, USE CUSTOM CONFIG INSTEAD

i_data = nil
e_data = nil

 -- Another ugly shit :P

function HandlePlayerRespawn(ply)
	local RespawnTime = 0

		if(GetConVar("horde_zshelter_hardcore_mode"):GetInt() == 1) then
			RespawnTime = GlobalTime
		else
			RespawnTime = 15 + (GlobalDay - 1)
		end

		net.Start("SpawnTimer")
		net.WriteInt(RespawnTime, 32)
		net.Send(ply)
		table.insert(SpawnTable, {ply, CurTime() + RespawnTime})

		HORDE:SendNotification("You will respawn after "..RespawnTime.." seconds", 1, ply)
end

function LoadEnemyConfig()
	if(GetConVar("horde_default_enemy_config"):GetInt() == 1) then
		e_data = util.JSONToTable(file.Read("horde/shelter_mode/default/enemies.txt", "DATA"))

		if(e_data != nil) then

			if(table.Count(e_data) < 32) then

				table.insert(CurrentEnemies, {"Miniboss","npc_vj_horde_lesion",3250,100,0,0.1})
				table.insert(CurrentEnemies, {0,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {1,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {2,"npc_vj_horde_crawler",45,100,0,0.1})
				table.insert(CurrentEnemies, {3,"npc_vj_horde_exploder",525,30,0,0.1})
				table.insert(CurrentEnemies, {4,"npc_vj_horde_vomitter",150,50,0,0.1})
				table.insert(CurrentEnemies, {5,"npc_vj_horde_screecher",250,35,0,0.1})
				table.insert(CurrentEnemies, {6,"npc_vj_horde_zombine",200,50,0,0.1})
				table.insert(CurrentEnemies, {7,"npc_vj_horde_hulk",1800,15,0,0.1})
				table.insert(CurrentEnemies, {8,"npc_vj_horde_charred_zombine",300,35,0,0.1})
				table.insert(CurrentEnemies, {9,"npc_vj_horde_weeper",200,35,0,0.1})
				table.insert(CurrentEnemies, {10,"npc_vj_horde_scorcher",250,35,0,0.1})
				table.insert(CurrentEnemies, {11,"npc_vj_horde_blight",700,20,0,0.1})
				table.insert(CurrentEnemies, {12,"npc_vj_horde_yeti",1200,20,0,0.1})
				table.insert(CurrentEnemies, {13,"npc_vj_horde_lesion",1300,20,0,0.1})
				table.insert(CurrentEnemies, {14,"npc_vj_horde_plague_soldier",400,35,0,0.1})
				table.insert(CurrentEnemies, {15,"npc_vj_horde_plague_elite",1200,10,0,0.1})
				table.insert(CurrentEnemies, {16, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {17, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {18, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {19, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {20, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {21, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {22, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {23, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {24, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {25, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {26, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {27, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {28, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {29, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {30, "", 0, 0, 0, 0.1})

				file.Write("horde/shelter_mode/default/enemies.txt", util.TableToJSON(CurrentEnemies))

				PrintMessage( HUD_PRINTTALK, "Default enemy config seems to be broken, Rewriting..")
			else

				table.insert(CurrentEnemies, {"Miniboss","npc_vj_horde_lesion",3250,100,0,0.1})
				table.insert(CurrentEnemies, {0,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {1,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {2,"npc_vj_horde_crawler",45,100,0,0.1})
				table.insert(CurrentEnemies, {3,"npc_vj_horde_exploder",525,30,0,0.1})
				table.insert(CurrentEnemies, {4,"npc_vj_horde_vomitter",150,50,0,0.1})
				table.insert(CurrentEnemies, {5,"npc_vj_horde_screecher",250,35,0,0.1})
				table.insert(CurrentEnemies, {6,"npc_vj_horde_zombine",200,50,0,0.1})
				table.insert(CurrentEnemies, {7,"npc_vj_horde_hulk",1800,15,0,0.1})
				table.insert(CurrentEnemies, {8,"npc_vj_horde_charred_zombine",300,35,0,0.1})
				table.insert(CurrentEnemies, {9,"npc_vj_horde_weeper",200,35,0,0.1})
				table.insert(CurrentEnemies, {10,"npc_vj_horde_scorcher",250,35,0,0.1})
				table.insert(CurrentEnemies, {11,"npc_vj_horde_blight",700,20,0,0.1})
				table.insert(CurrentEnemies, {12,"npc_vj_horde_yeti",1200,20,0,0.1})
				table.insert(CurrentEnemies, {13,"npc_vj_horde_lesion",1300,20,0,0.1})
				table.insert(CurrentEnemies, {14,"npc_vj_horde_plague_soldier",400,35,0,0.1})
				table.insert(CurrentEnemies, {15,"npc_vj_horde_plague_elite",1200,10,0,0.1})
				table.insert(CurrentEnemies, {16, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {17, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {18, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {19, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {20, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {21, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {22, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {23, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {24, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {25, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {26, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {27, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {28, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {29, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {30, "", 0, 0, 0, 0.1})

				file.Write("horde/shelter_mode/default/enemies.txt", util.TableToJSON(CurrentEnemies))

				PrintMessage( HUD_PRINTTALK, "Default enemy config loaded!")
			end
		else

				table.insert(CurrentEnemies, {"Miniboss","npc_vj_horde_lesion",3250,100,0,0.1})
				table.insert(CurrentEnemies, {0,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {1,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {2,"npc_vj_horde_crawler",45,100,0,0.1})
				table.insert(CurrentEnemies, {3,"npc_vj_horde_exploder",525,30,0,0.1})
				table.insert(CurrentEnemies, {4,"npc_vj_horde_vomitter",150,50,0,0.1})
				table.insert(CurrentEnemies, {5,"npc_vj_horde_screecher",250,35,0,0.1})
				table.insert(CurrentEnemies, {6,"npc_vj_horde_zombine",200,50,0,0.1})
				table.insert(CurrentEnemies, {7,"npc_vj_horde_hulk",1800,15,0,0.1})
				table.insert(CurrentEnemies, {8,"npc_vj_horde_charred_zombine",300,35,0,0.1})
				table.insert(CurrentEnemies, {9,"npc_vj_horde_weeper",200,35,0,0.1})
				table.insert(CurrentEnemies, {10,"npc_vj_horde_scorcher",250,35,0,0.1})
				table.insert(CurrentEnemies, {11,"npc_vj_horde_blight",700,20,0,0.1})
				table.insert(CurrentEnemies, {12,"npc_vj_horde_yeti",1200,20,0,0.1})
				table.insert(CurrentEnemies, {13,"npc_vj_horde_lesion",1300,20,0,0.1})
				table.insert(CurrentEnemies, {14,"npc_vj_horde_plague_soldier",400,35,0,0.1})
				table.insert(CurrentEnemies, {15,"npc_vj_horde_plague_elite",1200,10,0,0.1})
				table.insert(CurrentEnemies, {16, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {17, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {18, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {19, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {20, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {21, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {22, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {23, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {24, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {25, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {26, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {27, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {28, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {29, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {30, "", 0, 0, 0, 0.1})

				file.Write("horde/shelter_mode/default/enemies.txt", util.TableToJSON(CurrentEnemies))

			PrintMessage( HUD_PRINTTALK, "Default enemy config isn't valid! Rewriting..")
		end
	else
		e_data = util.JSONToTable(file.Read("horde/shelter_mode/enemies.txt", "DATA"))

		if(e_data != nil) then

			if(table.Count(e_data) < 32) then

				table.insert(CurrentEnemies, {"Miniboss","npc_vj_horde_lesion",3250,100,0,0.1})
				table.insert(CurrentEnemies, {0,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {1,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {2,"npc_vj_horde_crawler",45,100,0,0.1})
				table.insert(CurrentEnemies, {3,"npc_vj_horde_exploder",525,30,0,0.1})
				table.insert(CurrentEnemies, {4,"npc_vj_horde_vomitter",150,50,0,0.1})
				table.insert(CurrentEnemies, {5,"npc_vj_horde_screecher",250,35,0,0.1})
				table.insert(CurrentEnemies, {6,"npc_vj_horde_zombine",200,50,0,0.1})
				table.insert(CurrentEnemies, {7,"npc_vj_horde_hulk",1800,15,0,0.1})
				table.insert(CurrentEnemies, {8,"npc_vj_horde_charred_zombine",300,35,0,0.1})
				table.insert(CurrentEnemies, {9,"npc_vj_horde_weeper",200,35,0,0.1})
				table.insert(CurrentEnemies, {10,"npc_vj_horde_scorcher",250,35,0,0.1})
				table.insert(CurrentEnemies, {11,"npc_vj_horde_blight",700,20,0,0.1})
				table.insert(CurrentEnemies, {12,"npc_vj_horde_yeti",1200,20,0,0.1})
				table.insert(CurrentEnemies, {13,"npc_vj_horde_lesion",1300,20,0,0.1})
				table.insert(CurrentEnemies, {14,"npc_vj_horde_plague_soldier",400,35,0,0.1})
				table.insert(CurrentEnemies, {15,"npc_vj_horde_plague_elite",1200,10,0,0.1})
				table.insert(CurrentEnemies, {16, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {17, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {18, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {19, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {20, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {21, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {22, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {23, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {24, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {25, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {26, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {27, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {28, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {29, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {30, "", 0, 0, 0, 0.1})

				file.Write("horde/shelter_mode/enemies.txt", util.TableToJSON(CurrentEnemies))

				PrintMessage( HUD_PRINTTALK, "Custom enemy config isn't valid! Rewriting..")

			else

					CurrentEnemies = util.JSONToTable(file.Read("horde/shelter_mode/enemies.txt", "DATA"))
					PrintMessage( HUD_PRINTTALK, "Custom enemy config loaded.")

			end

		else

				table.insert(CurrentEnemies, {"Miniboss","npc_vj_horde_lesion",3250,100,0,0.1})
				table.insert(CurrentEnemies, {0,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {1,"npc_vj_horde_sprinter",135,100,0,0.1})
				table.insert(CurrentEnemies, {2,"npc_vj_horde_crawler",45,100,0,0.1})
				table.insert(CurrentEnemies, {3,"npc_vj_horde_exploder",525,30,0,0.1})
				table.insert(CurrentEnemies, {4,"npc_vj_horde_vomitter",150,50,0,0.1})
				table.insert(CurrentEnemies, {5,"npc_vj_horde_screecher",250,35,0,0.1})
				table.insert(CurrentEnemies, {6,"npc_vj_horde_zombine",200,50,0,0.1})
				table.insert(CurrentEnemies, {7,"npc_vj_horde_hulk",1800,15,0,0.1})
				table.insert(CurrentEnemies, {8,"npc_vj_horde_charred_zombine",300,35,0,0.1})
				table.insert(CurrentEnemies, {9,"npc_vj_horde_weeper",200,35,0,0.1})
				table.insert(CurrentEnemies, {10,"npc_vj_horde_scorcher",250,35,0,0.1})
				table.insert(CurrentEnemies, {11,"npc_vj_horde_blight",700,20,0,0.1})
				table.insert(CurrentEnemies, {12,"npc_vj_horde_yeti",1200,20,0,0.1})
				table.insert(CurrentEnemies, {13,"npc_vj_horde_lesion",1300,20,0,0.1})
				table.insert(CurrentEnemies, {14,"npc_vj_horde_plague_soldier",400,35,0,0.1})
				table.insert(CurrentEnemies, {15,"npc_vj_horde_plague_elite",1200,10,0,0.1})
				table.insert(CurrentEnemies, {16, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {17, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {18, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {19, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {20, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {21, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {22, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {23, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {24, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {25, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {26, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {27, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {28, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {29, "", 0, 0, 0, 0.1})
				table.insert(CurrentEnemies, {30, "", 0, 0, 0, 0.1})

				file.Write("horde/shelter_mode/enemies.txt", util.TableToJSON(CurrentEnemies))

			PrintMessage( HUD_PRINTTALK, "Custom enemy config isn't valid! Rewriting..")

		end

	end
end

function LoadItemConfig()
	if(GetConVar("horde_default_item_config"):GetInt() == 1) then
		i_data = util.JSONToTable(file.Read("horde/shelter_mode/default/items.txt", "DATA"))

		if(i_data != nil) then
			for k,v in next, i_data do
				if(table.Count(i_data) < 12) then
					table.insert(CurrentItems, {1, "Pistol", 0, "Maria", "arccw_bo2_browninghp", 2, 3, 4})
					table.insert(CurrentItems, {2, "Pistol", 0, "Five-Seven", "arccw_bo2_fiveseven", 5, 5, 15})
					table.insert(CurrentItems, {3, "Pistol", 0, "Kard", "arccw_bo2_kard", 6, 6, 16})
					table.insert(CurrentItems, {4, "SMG / SG", 1, "MPL", "arccw_bo1_mpl", 7, 5, 5})
					table.insert(CurrentItems, {5, "SMG / SG", 1, "MP7", "arccw_bo2_mp7", 7, 7, 17})
					table.insert(CurrentItems, {6, "SMG / SG", 1, "Peacekeeper", "arccw_bo2_peacekeeper", 8, 9, 18})
					table.insert(CurrentItems, {7, "Rifle", 2, "HK416", "arccw_bo2_m27", 10, 10, 19})
					table.insert(CurrentItems, {8, "Rifle", 2, "SG556", "arccw_bo2_sig556", 12, 10, 20})
					table.insert(CurrentItems, {9, "Rifle", 2, "SMI .308", "arccw_bo2_smr", 13, 11, 21})
					table.insert(CurrentItems, {10, "LMG", 3, "LSAT", "arccw_bo2_lsat", 15, 13, 22})
					table.insert(CurrentItems, {11, "LMG", 3, "None", "", 0, 0, 23})
					table.insert(CurrentItems, {12, "LMG", 3, "None", "", 0, 0, 24})

					file.Write("horde/shelter_mode/default/items.txt", util.TableToJSON(CurrentItems))
					PrintMessage( HUD_PRINTTALK, "Default items config seems to be broken, Rewriting..")
					return
				else
					table.insert(CurrentItems, {1, "Pistol", 0, "Maria", "arccw_bo2_browninghp", 2, 3, 4})
					table.insert(CurrentItems, {2, "Pistol", 0, "Five-Seven", "arccw_bo2_fiveseven", 5, 5, 15})
					table.insert(CurrentItems, {3, "Pistol", 0, "Kard", "arccw_bo2_kard", 6, 6, 16})
					table.insert(CurrentItems, {4, "SMG / SG", 1, "MPL", "arccw_bo1_mpl", 7, 5, 5})
					table.insert(CurrentItems, {5, "SMG / SG", 1, "MP7", "arccw_bo2_mp7", 7, 7, 17})
					table.insert(CurrentItems, {6, "SMG / SG", 1, "Peacekeeper", "arccw_bo2_peacekeeper", 8, 9, 18})
					table.insert(CurrentItems, {7, "Rifle", 2, "HK416", "arccw_bo2_m27", 10, 10, 19})
					table.insert(CurrentItems, {8, "Rifle", 2, "SG556", "arccw_bo2_sig556", 12, 10, 20})
					table.insert(CurrentItems, {9, "Rifle", 2, "SMI .308", "arccw_bo2_smr", 13, 11, 21})
					table.insert(CurrentItems, {10, "LMG", 3, "LSAT", "arccw_bo2_lsat", 15, 13, 22})
					table.insert(CurrentItems, {11, "LMG", 3, "None", "", 0, 0, 23})
					table.insert(CurrentItems, {12, "LMG", 3, "None", "", 0, 0, 24})
					PrintMessage( HUD_PRINTTALK, "Default items config loaded!")
					return
				end
			end
		else
			table.insert(CurrentItems, {1, "Pistol", 0, "Maria", "arccw_bo2_browninghp", 2, 3, 4})
			table.insert(CurrentItems, {2, "Pistol", 0, "Five-Seven", "arccw_bo2_fiveseven", 5, 5, 15})
			table.insert(CurrentItems, {3, "Pistol", 0, "Kard", "arccw_bo2_kard", 6, 6, 16})
			table.insert(CurrentItems, {4, "SMG / SG", 1, "MPL", "arccw_bo1_mpl", 7, 5, 5})
			table.insert(CurrentItems, {5, "SMG / SG", 1, "MP7", "arccw_bo2_mp7", 7, 7, 17})
			table.insert(CurrentItems, {6, "SMG / SG", 1, "Peacekeeper", "arccw_bo2_peacekeeper", 8, 9, 18})
			table.insert(CurrentItems, {7, "Rifle", 2, "HK416", "arccw_bo2_m27", 10, 10, 19})
			table.insert(CurrentItems, {8, "Rifle", 2, "SG556", "arccw_bo2_sig556", 12, 10, 20})
			table.insert(CurrentItems, {9, "Rifle", 2, "SMI .308", "arccw_bo2_smr", 13, 11, 21})
			table.insert(CurrentItems, {10, "LMG", 3, "LSAT", "arccw_bo2_lsat", 15, 13, 22})
			table.insert(CurrentItems, {11, "LMG", 3, "None", "", 0, 0, 23})
			table.insert(CurrentItems, {12, "LMG", 3, "None", "", 0, 0, 24})

			file.Write("horde/shelter_mode/default/items.txt", util.TableToJSON(CurrentItems))
			PrintMessage( HUD_PRINTTALK, "Default items config isn't valid! Rewriting..")
		end
	else
		i_data = util.JSONToTable(file.Read("horde/shelter_mode/items.txt", "DATA"))
		if(i_data != nil) then
			for k,v in next, i_data do
				if(table.Count(i_data) < 12) then
						table.insert(CurrentItems, {1, "Pistol", 0, "Maria", "arccw_bo2_browninghp", 2, 3, 4})
						table.insert(CurrentItems, {2, "Pistol", 0, "Five-Seven", "arccw_bo2_fiveseven", 5, 5, 15})
						table.insert(CurrentItems, {3, "Pistol", 0, "Kard", "arccw_bo2_kard", 6, 6, 16})
						table.insert(CurrentItems, {4, "SMG / SG", 1, "MPL", "arccw_bo1_mpl", 7, 5, 5})
						table.insert(CurrentItems, {5, "SMG / SG", 1, "MP7", "arccw_bo2_mp7", 7, 7, 17})
						table.insert(CurrentItems, {6, "SMG / SG", 1, "Peacekeeper", "arccw_bo2_peacekeeper", 8, 9, 18})
						table.insert(CurrentItems, {7, "Rifle", 2, "HK416", "arccw_bo2_m27", 10, 10, 19})
						table.insert(CurrentItems, {8, "Rifle", 2, "SG556", "arccw_bo2_sig556", 12, 10, 20})
						table.insert(CurrentItems, {9, "Rifle", 2, "SMI .308", "arccw_bo2_smr", 13, 11, 21})
						table.insert(CurrentItems, {10, "LMG", 3, "LSAT", "arccw_bo2_lsat", 15, 13, 22})
						table.insert(CurrentItems, {11, "LMG", 3, "None", "", 0, 0, 23})
						table.insert(CurrentItems, {12, "LMG", 3, "None", "", 0, 0, 24})
					file.Write("horde/shelter_mode/items.txt", util.TableToJSON(CurrentItems))
					PrintMessage( HUD_PRINTTALK, "Custom config seems to be broken, Rewriting..")
					return
				else
					CurrentItems = util.JSONToTable(file.Read("horde/shelter_mode/items.txt", "DATA"))
					PrintMessage( HUD_PRINTTALK, "Custom items config loaded.")
					return
				end
			end
		else
			table.insert(CurrentItems, {1, "Pistol", 0, "Maria", "arccw_bo2_browninghp", 2, 3, 4})
			table.insert(CurrentItems, {2, "Pistol", 0, "Five-Seven", "arccw_bo2_fiveseven", 5, 5, 15})
			table.insert(CurrentItems, {3, "Pistol", 0, "Kard", "arccw_bo2_kard", 6, 6, 16})
			table.insert(CurrentItems, {4, "SMG / SG", 1, "MPL", "arccw_bo1_mpl", 7, 5, 5})
			table.insert(CurrentItems, {5, "SMG / SG", 1, "MP7", "arccw_bo2_mp7", 7, 7, 17})
			table.insert(CurrentItems, {6, "SMG / SG", 1, "Peacekeeper", "arccw_bo2_peacekeeper", 8, 9, 18})
			table.insert(CurrentItems, {7, "Rifle", 2, "HK416", "arccw_bo2_m27", 10, 10, 19})
			table.insert(CurrentItems, {8, "Rifle", 2, "SG556", "arccw_bo2_sig556", 12, 10, 20})
			table.insert(CurrentItems, {9, "Rifle", 2, "SMI .308", "arccw_bo2_smr", 13, 11, 21})
			table.insert(CurrentItems, {10, "LMG", 3, "LSAT", "arccw_bo2_lsat", 15, 13, 22})
			table.insert(CurrentItems, {11, "LMG", 3, "None", "", 0, 0, 23})
			table.insert(CurrentItems, {12, "LMG", 3, "None", "", 0, 0, 24})

			file.Write("horde/shelter_mode/items.txt", util.TableToJSON(CurrentItems))

			PrintMessage( HUD_PRINTTALK, "Custom items config isn't valid! Rewriting..")
		end
	end
end

MapEntitiesWarnInterval = 0

InvalidTableCache = true
InvalidTableCache_ = true
CachedWSList = nil
CachedESList = nil

function GetCachedWorkstationItems()
	if(InvalidTableCache) then
		local tab = util.TableToJSON(CurrentItems)
		local str = util.Compress(tab)
		CachedESList = str
		InvalidTableCache = false
	end
	InvalidTableCache = true
	return CachedESList
end

function GetCachedEnemies()
	if(InvalidTableCache_) then
		local tab = util.TableToJSON(CurrentEnemies)
		local str = util.Compress(tab)
		CachedWSList = str
		InvalidTableCache_ = false
	end
	InvalidTableCache_ = true
	return CachedWSList
end

function SyncShelterItems()
		local str = GetCachedWorkstationItems()
		net.Start("SyncItemsReturn")
			 net.WriteUInt(string.len(str), 32)
             net.WriteData(str, string.len(str))
		net.Broadcast()
end

function SyncShelterEnemies()
		local str = GetCachedEnemies()
		net.Start("SyncEnemysReturn")
			 net.WriteUInt(string.len(str), 32)
             net.WriteData(str, string.len(str))
		net.Broadcast()
end

	net.Receive("SyncItemsFromClient", function(len, ply)
		if(IsValid(ply)) then
   			 local len = net.ReadUInt(32)
    		local data = net.ReadData(len)
    		local str = util.Decompress(data)
    		CurrentItems = util.JSONToTable(str)

    		if(GetConVar("horde_default_item_config"):GetInt() == 0) then
    			file.Write("horde/shelter_mode/items.txt", util.TableToJSON(CurrentItems))
    		end

    		SyncShelterItems()
		end
	end)

	net.Receive("SyncEnemysFromClient", function(len, ply)
		if(IsValid(ply)) then
   			local len = net.ReadUInt(32)
    		local data = net.ReadData(len)
    		local str = util.Decompress(data)
    		CurrentEnemies = util.JSONToTable(str)

    		if(GetConVar("horde_default_enemy_config"):GetInt() == 0) then
    			file.Write("horde/shelter_mode/enemies.txt", util.TableToJSON(CurrentEnemies))
    		end

    		SyncShelterEnemies()
    		CEnemyToList()
		end
	end)

	net.Receive("SendAirStrike", function(len, ply)
		if(IsValid(ply)) then
			table.insert(AirStrikeTable, {CurTime() + 9.3, CurTime() + 2.3, true, 0, 0, ply:GetEyeTrace().HitPos, ply:EyePos(), ply})
		end
	end)

	net.Receive("SendCloak", function(len, ply)
		if(IsValid(ply)) then
			table.insert(PlayerCloakTable, {ply, CurTime() + 10, false, 0, true, 255})
			for k,idx in next, PlayerDataTable do
				if(idx[17] != ply) then continue end
				idx[40] = true
			end
		end
	end)

PlayerScaling = 1
PlayerEnemyScaling = 4

EntTable = {}
AttackTable = {}

DoorTable = {} -- Yeah I'm lazy xD

SpawnTable = {}

SpawnList = {}

if(PlayerDataTable == nil) then
	PlayerDataTable = {}
end

PlayerBuildTable = {}

PlayerStartTable = {}

DeathPackpackTable = {}

PlayerCheckTimer = 0

ResourceSpawnTimer = 0

MaterialsSpawnTimer = 0

HealingStationTimer = 0

ShouldEnableAI = false

ShelterTurret = 0

Eletronic = 0
GlobalWood = 0
GlobalIron = 0
GlobalWoodLimit = 20
GlobalIronLimit = 20

CheckBuildStateTimer = 0

AttackNotifyTimer = 0

ZombieAttackTicker = 0

TauZombieTicker = 0

Victory = false

BossSpawned = false

Started = false
StartTimer = 0

SpawnTicker = 3
SpawnInterval = 0
SpawnAmout = 0

GoalNotifyed = false

GlobalDay = 1
GlobalTime = 300
NightOrDay = false -- False = day, True = night
ZombieWaveTimer = 0

HelpSent = 0

RescueStarted = false

Res_SpawnInterval = 0

TickTicker = 0

MaxCount = 0

FeedbackPrinted = false

HordeDiff = GetConVar("horde_difficulty"):GetInt()

CheckCustomLuaConfig = 0

GasTankLoop = 0 -- Less lag for server I guess

CluaItemLoaded = false
CluaEnemyLoaded = false

local math_random = math.random
function VJ_EmitSound_(ent, sdFile, sdLevel, sdPitch, sdVolume, sdChannel) -- Replace turret sound to CSN:Z's turret sound
	if not sdFile then return end
	if istable(sdFile) then
		if #sdFile < 1 then return end
		sdFile = sdFile[math_random(1, #sdFile)]
	end
	if ent.OnCreateSound then
		sdFile = ent:OnCreateSound(sdFile)
	end
	if(sdFile != "vj_hlr/hl1_npc/turret/tu_fire1.wav") then
		ent:EmitSound(sdFile, sdLevel, sdPitch, sdVolume, sdChannel)
		ent.LastPlayedVJSound = sdFile
		if ent.OnPlayEmitSound then ent:OnPlayEmitSound(sdFile) end
	else
		sdFile = "shigure/turretfire.wav"
		sound.Play( sdFile, ent:GetPos(), 80, 100, 1)
	end
end

function IsBase(v)
	local str = ""
	if(v:GetModel() != nil) then
		str = v:GetModel()
	end
	if(string.Left(str, 32) == "models/shigure/shelter_b_shelter") then
		return true
	else
		return false
	end
end

function DoCheckLuaItemConfig()
	if(CustomItemConfig != nil) then
		if(table.Count(CustomItemConfig) == 12) then
			for k,v in next, CustomItemConfig do
				if(v[1] == nil || v[2] == nil || v[3] == nil || v[4] == nil || v[5] == nil || v[6] == nil || v[7] == nil || v[8] == nil) then
					for x,y in pairs(player.GetAll()) do if(!IsValid(y)) then continue end HORDE:SendNotification("Lua config (Item) seems not valid! Config will not load!", 1, y) end
					return
				end
			end
			CurrentItems = CustomItemConfig
			CluaItemLoaded = true
			SyncShelterItems()
		else
			for x,y in pairs(player.GetAll()) do if(!IsValid(y)) then continue end HORDE:SendNotification("Lua config (Item) seems not valid! Config will not load!", 1, y) end
		end
	end 
end

function DoCheckLuaEnemyConfig()
	if(CustomEnemyConfig != nil) then
		if(table.Count(CustomEnemyConfig) == 32) then
			for k,v in next, CustomEnemyConfig do
				if(v[1] == nil || v[2] == nil || v[3] == nil || v[4] == nil || v[5] == nil || v[6] == nil) then
					for x,y in pairs(player.GetAll()) do if(!IsValid(y)) then continue end HORDE:SendNotification("Lua config (Enemy) seems not valid! Config will not load!", 1, y) end
					return
				end
			end
			CurrentEnemies = CustomEnemyConfig
			CluaEnemyLoaded = true
			SyncShelterEnemies()
			CEnemyToList()
		else
			for x,y in pairs(player.GetAll()) do if(!IsValid(y)) then continue end HORDE:SendNotification("Lua config (Enemy) seems not valid! Config will not load!", 1, y) end
		end
	end 
end

function GetShelterAngle()
	local Ang = Angle(0,0,0)
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		Ang = v:GetAngles()
	end
	return Ang
end

SpawnPosTable = {}
function CacheEnemySpawn()
	SpawnPosTable = {}
	for k,v in pairs(ents.FindByClass("info_zshelter_enemy_spawn")) do
		if(!IsValid(v)) then continue end
		if(v.day <= GlobalDay) then
			table.insert(SpawnPosTable, {v:GetPos(), v:GetAngles():Forward() * v.pvel})
		end
	end
end

function SpawnEnemies()
	if(NPCCount() > MaxCount) then return end
	for k,v in next, SpawnPosTable do
		SpawnManager(v[1], 1, v[2])
	end
end

SpawnList = {}
function CEnemyToList()
    SpawnList = {}
    local num = 0
    if(GetConVar("horde_zshelter_hardcore_mode"):GetInt() == 1) then
    	num = 3
    end
    for k,v in next, CurrentEnemies do
    	if(v[1] == "Miniboss") then
    		FreezeAIClass = v[2]
    	end
    	if(tonumber(v[1]) == nil) then continue end
        if(GlobalDay >= (v[1] + num)) then
        	if(v[2] != "" && string.Left(v[2], 4) == "npc_") then
            	table.insert(SpawnList, {v[2], tonumber(v[3]), tonumber(v[4]), tonumber(v[5]), tonumber(v[6])})
            else
            	print("Invalid or empty class detected!, discarding.. | Day : "..v[1].." | nID : "..v[2].."")
        	end
        end
    end
end

function GetSpawnPos()
	local vec = Vector(0,0,0)
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		vec = v:GetPos() + GetShelterAngle():Forward() * -160
	end
	return vec
end

function GameStarted()

	if(GetConVar("horde_zshelter_debug_nostart"):GetInt() == 1) then return false end

	return HORDE.start_game

end

function GetShelterCenter()
	local Pos = Vector(0,0,0) -- So it won't error out
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		Pos = v:GetPos() + GetShelterAngle():Forward() * -160
	end
	return Pos
end

function GetChasePos()
	local Pos = Vector(0,0,0) -- So it won't error out
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		Pos = v:GetPos()
	end
	return Pos
end

function GetBuildingZOffset(idx1, idx2)
	if(idx1 == 1) then -- idx1 = Object Type, idx2 = Object Index

		if(idx2 == 1) then return 0 end
		if(idx2 == 2) then return 0 end
		if(idx2 == 3) then return 0 end
		if(idx2 == 4) then return 0 end
		if(idx2 == 5) then return 0 end
		if(idx2 == 6) then return 0 end
		if(idx2 == 7) then return 50 end
		if(idx2 == 8) then return 0 end
		if(idx2 == 9) then return 0 end
		if(idx2 == 10) then return 0 end
		if(idx2 == 11) then return 0 end
		if(idx2 == 12) then return 0 end
		if(idx2 == 32) then return 0 end
		if(idx2 == 33) then return 0 end
		if(idx2 == 34) then return 0 end
		if(idx2 == 35) then return 0 end
		if(idx2 == 36) then return 0 end
		if(idx2 == 37) then return 0 end

		if(idx2 == 38) then return 5 end
		if(idx2 == 39) then return 0 end

	end

	if(idx1 == 2) then

		if(idx2 == 1) then return 0 end
		if(idx2 == 2) then return 0 end
		if(idx2 == 3) then return 0 end
		if(idx2 == 4) then return 0 end

	end

	if(idx1 == 3) then

		if(idx2 == 1) then return 15 end
		if(idx2 == 2) then return 0 end
		if(idx2 == 3) then return 0 end
		if(idx2 == 4) then return 0 end
		

		if(idx2 == 10) then return 0 end
		if(idx2 == 11) then return 75 end
		if(idx2 == 12) then return 0 end
		if(idx2 == 13) then return -17 end

	end

	if(idx1 == 4) then

		if(idx2 == 1) then return 0 end
		if(idx2 == 2) then return 0 end
		if(idx2 == 3) then return 0 end
		if(idx2 == 4) then return 0 end
		if(idx2 == 5) then return 0 end

	end

end

function GetBuildingHealth(idx1, idx2)
	if(idx1 == 1) then -- idx1 = Object Type, idx2 = Object Index

		if(idx2 == 1) then return 500 end
		if(idx2 == 2) then return 650 end
		if(idx2 == 3) then return 850 end
		if(idx2 == 4) then return 1150 end
		if(idx2 == 5) then return 1150 end
		if(idx2 == 6) then return 850 end
		if(idx2 == 7) then return 2250 end
		if(idx2 == 8) then return 2250 end
		if(idx2 == 9) then return 500 end
		if(idx2 == 10) then return 500 end
		if(idx2 == 11) then return 500 end
		if(idx2 == 12) then return 1350 end
		if(idx2 == 32) then return 30 end
		if(idx2 == 33) then return 875 end
		if(idx2 == 34) then return 825 end
		if(idx2 == 35) then return 100 end
		if(idx2 == 36) then return 2850 end
		if(idx2 == 37) then return 2500 end

		if(idx2 == 38) then return 100 end
		if(idx2 == 39) then return 350 end

	end

	if(idx1 == 2) then

		if(idx2 == 1) then return 300 end
		if(idx2 == 2) then return 375 end
		if(idx2 == 3) then return 450 end
		if(idx2 == 4) then return 525 end

	end

	if(idx1 == 3) then

		if(idx2 == 1) then return 500 end
		if(idx2 == 2) then return 1250 end
		if(idx2 == 3) then return 1500 end
		if(idx2 == 4) then return 500 end
		

		if(idx2 == 10) then return 750 end
		if(idx2 == 11) then return 1000 end
		if(idx2 == 12) then return 1750 end
		if(idx2 == 13) then return 1500 end


	end

	if(idx1 == 4) then

		if(idx2 == 1) then return 400 end
		if(idx2 == 2) then return 525 end
		if(idx2 == 3) then return 700 end
		if(idx2 == 4) then return 850 end
		if(idx2 == 5) then return 1050 end

	end

end

function GetBuildingName(idx1, idx2)

	if(idx1 == 1) then -- idx1 = Object Type, idx2 = Object Index

		if(idx2 == 1) then return "Wooden wall" end
		if(idx2 == 2) then return "Spike wall" end
		if(idx2 == 3) then return "Large spike wall" end
		if(idx2 == 4) then return "Metal wall" end
		if(idx2 == 5) then return "Windowed metal wall" end
		if(idx2 == 6) then return "Metal stair" end
		if(idx2 == 7) then return "Concrete wall" end
		if(idx2 == 8) then return "Concrete floor" end
		if(idx2 == 9) then return "Wooden ramp" end
		if(idx2 == 10) then return "Wooden ramp" end
		if(idx2 == 11) then return "Wooden stair" end
		if(idx2 == 12) then return "Metal fence" end
		if(idx2 == 32) then return "Campfire" end
		if(idx2 == 33) then return "Wooden platform" end
		if(idx2 == 34) then return "Mortar Cannon" end
		if(idx2 == 35) then return "Freeze Bomb" end
		if(idx2 == 36) then return "Reinforced concrete wall" end
		if(idx2 == 37) then return "Metal gate" end

		if(idx2 == 38) then return "Landmine" end
		if(idx2 == 39) then return "Spike trap" end

	end

	if(idx1 == 2) then

		if(idx2 == 1) then return "Basic generator" end
		if(idx2 == 2) then return "Medium generator" end
		if(idx2 == 3) then return "Large generator" end
		if(idx2 == 4) then return "Mega generator" end

	end

	if(idx1 == 3) then

		if(idx2 == 1) then return "Basic storage" end
		if(idx2 == 2) then return "Workstation" end
		if(idx2 == 3) then return "Cement Mixer" end
		if(idx2 == 4) then return "Healing station" end

		if(idx2 == 10) then return "Medium storage" end
		if(idx2 == 11) then return "Large storage" end
		if(idx2 == 12) then return "Telecommunications tower" end
		if(idx2 == 13) then return "Watch tower" end

	end

	if(idx1 == 4) then

		if(idx2 == 1) then return "Basic turret" end
		if(idx2 == 2) then return "Advanced turret" end
		if(idx2 == 3) then return "Minigun turret" end
		if(idx2 == 4) then return "Blast turret" end
		if(idx2 == 5) then return "Railgun turret" end

	end

end

function GetModelType(idx1, idx2)

	if(idx1 == 1) then -- idx1 = Object Type, idx2 = Object Index

		if(idx2 == 1) then return "models/galaxy/rust/wood_wall.mdl" end
		if(idx2 == 2) then return "models/galaxy/rust/spike_wall.mdl" end
		if(idx2 == 3) then return "models/galaxy/rust/spike_wall_large.mdl" end
		if(idx2 == 4) then return "models/galaxy/rust/metal_wall.mdl" end
		if(idx2 == 5) then return "models/galaxy/rust/metal_window.mdl" end
		if(idx2 == 6) then return "models/galaxy/rust/metal_stairs.mdl" end
		if(idx2 == 7) then return "models/nickmaps/rostok/bar_parede_uniq.mdl" end
		if(idx2 == 8) then return "models/galaxy/rust/metal_ceiling.mdl" end
		if(idx2 == 9) then return "models/galaxy/rust/wood_ramp.mdl" end
		if(idx2 == 10) then return "models/galaxy/rust/wood_ramp.mdl" end
		if(idx2 == 11) then return "models/galaxy/rust/wood_stairs.mdl" end
		if(idx2 == 12) then return "models/z-o-m-b-i-e/st/musor/st_zabor_rabica_01.mdl" end
		if(idx2 == 32) then return "models/galaxy/rust/campfire.mdl" end
		if(idx2 == 33) then return "models/galaxy/rust/wood_foundation.mdl" end
		if(idx2 == 34) then return "models/props_combine/combinethumper002.mdl" end
		if(idx2 == 35) then return "models/shigure/gastank.mdl" end
		if(idx2 == 36) then return "models/shigure/shelter_b_wall03.mdl" end
		if(idx2 == 37) then return "models/props_lab/blastdoor001c.mdl" end

		if(idx2 == 38) then return "models/lambda/traps/zsht_landmine.mdl" end
		if(idx2 == 39) then return "models/lambda/traps/zsht_spiketrap.mdl" end

	end

	if(idx1 == 2) then

		if(idx2 == 1) then return "models/shigure/shelter_b_generator01.mdl" end
		if(idx2 == 2) then return "models/shigure/shelter_b_generator02.mdl" end
		if(idx2 == 3) then return "models/shigure/shelter_b_generator03.mdl" end
		if(idx2 == 4) then return "models/shigure/shelter_b_generator04.mdl" end

	end

	if(idx1 == 3) then

		if(idx2 == 1) then return "models/items/ammocrate_ar2.mdl" end
		if(idx2 == 2) then return "models/props_lab/workspace004.mdl" end
		if(idx2 == 3) then return "models/shigure/shelter_b_concrete01.mdl" end
		if(idx2 == 4) then return "models/galaxy/rust/bed.mdl" end
		if(idx2 == 10) then return "models/shigure/shelter_b_warehouse01.mdl" end
		if(idx2 == 11) then return "models/nickmaps/rostok/p19_casa2.mdl" end
		if(idx2 == 12) then return "models/shigure/shelter_b_antenna01.mdl" end
		if(idx2 == 13) then return "models/z-o-m-b-i-e/st/vishka/st_vishka_broken_01_1.mdl" end

	end

	if(idx1 == 4) then

		if(idx2 == 1) then return "models/vj_hlr/hl1/gturret_mini.mdl" end
		if(idx2 == 2) then return "models/vj_hlr/decay/sentry.mdl" end
		if(idx2 == 3) then return "models/vj_hlr/hl1/gturret.mdl" end
		if(idx2 == 4) then return "models/vj_hlr/hl1/sentry.mdl" end
		if(idx2 == 5) then return "models/vj_hlr/hl1/alien_cannon.mdl" end

	end

end

function DoCheckResources(ply, req1, req2, Typ_)

	if(!IsValid(ply)) then return end
	if(GetConVar("horde_zshelter_debug_disable_requirments"):GetInt() == 1) then return true end
	if(Typ_ == 3) then

		for k,idx in next, PlayerDataTable do

			if(idx[1] == ply:SteamID()) then

				if(idx[2] >= req1 && idx[3] >= req2) then

					return true

				else

					if(GlobalWood >= req1 && GlobalIron >= req2) then

						return true

					else

						return false

					end

				end

			end

		end

	elseif(Typ_ == 7) then

		for k, idx in next, PlayerDataTable do

			if(idx[1] == ply:SteamID()) then

				if(idx[10] >= 1) then

					return true

				else

					return false

				end

			end

		end

	else

		for k, idx in next, PlayerDataTable do

			if(idx[1] == ply:SteamID()) then

				if(idx[18] == 0) then

					if(idx[2] >= req1 && idx[3] >= req2) then

						return true

					else

						return false

					end

				else

					if(idx[2] >= req1 && idx[3] >= req2) then
						return true

					else

						if(GlobalWood >= req1 && GlobalIron >= req2) then

							return true

						else

							return false

						end

					end

				end

			end

		end

	end

end

function ResourceType(ent)

	if(ent:GetModel() == "models/galaxy/rust/woodpile1.mdl") then
		return 1
	end
	if(ent:GetModel() == "models/props_junk/ibeam01a_cluster01.mdl") then
		return 2
	end
	if(ent:GetModel() == "models/galaxy/rust/rockore4.mdl") then
		return 3
	end

end

function IsTurret(ent)

	if(!IsValid(ent)) then return false end

	if(ent:GetClass() == "npc_vj_hlr1_gturret_mini" || ent:GetClass() == "npc_vj_hlr1_gturret" || ent:GetClass() == "npc_vj_hlrdc_sentry" || ent:GetClass() == "npc_vj_hlr1_sentry" || ent:GetClass() == "npc_vj_hlr1_xen_cannon" || ent:GetClass() == "npc_vj_hlr1_cturret"  || ent:GetClass() == "npc_vj_hlr1_cturret_mini") then
		return true
	else
		return false
	end

end

function IsResource(ent)

	if(ent:GetModel() == "models/galaxy/rust/woodpile1.mdl" || ent:GetModel() == "models/props_junk/ibeam01a_cluster01.mdl" || ent:GetModel() == "models/galaxy/rust/rockore4.mdl") then
		return true
	else
		return false
	end

end

function GetPowerCost()

	local PCount = 0

	for k,v in pairs(ents.FindByClass("npc_vj_hl*")) do

		if(!IsValid(v)) then continue end

		if(v:GetClass() == "npc_vj_hlr1_gturret_mini" && v:GetMaxHealth() < 10000) then PCount = PCount + 15 end
		if(v:GetClass() == "npc_vj_hlrdc_sentry") then PCount = PCount + 20 end
		if(v:GetClass() == "npc_vj_hlr1_gturret") then PCount = PCount + 30 end
		if(v:GetClass() == "npc_vj_hlr1_sentry") then PCount = PCount + 40 end
		if(v:GetClass() == "npc_vj_hlr1_xen_cannon") then PCount = PCount + 55 end

	end

	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do

		if(!IsValid(v)) then continue end

		if(v:GetModel() == "models/items/ammocrate_ar2.mdl") then PCount = PCount + 15 end
		if(v:GetModel() == "models/shigure/shelter_b_warehouse01.mdl") then PCount = PCount + 20 end
		if(v:GetModel() == "models/nickmaps/rostok/p19_casa2.mdl") then PCount = PCount + 35 end
		if(v:GetModel() == "models/galaxy/rust/bed.mdl") then PCount = PCount + 20 end
		if(v:GetModel() == "models/props_lab/workspace004.mdl") then PCount = PCount + 65 end
		if(v:GetModel() == "models/shigure/shelter_b_concrete01.mdl") then PCount = PCount + 100 end
		if(v:GetModel() == "models/props/house_pack_2/gas_station.mdl") then PCount = PCount + 100 end
		if(v:GetModel() == "models/props/building_area/build_1.mdl") then PCount = PCount + 100 end
		if(v:GetModel() == "models/shigure/shelter_b_antenna01.mdl") then PCount = PCount + 120 end
		if(v:GetModel() == "models/props_combine/combinethumper002.mdl") then PCount = PCount + 40 end

	end

	return PCount

end

function CalcTotalPower()

	local PCount = 0

	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do

		if(!IsValid(v)) then continue end

		if(v:GetColor().a != 255) then continue end

		if(v:GetModel() == "models/shigure/shelter_b_generator01.mdl") then PCount = PCount + 30 end
		if(v:GetModel() == "models/shigure/shelter_b_generator02.mdl") then PCount = PCount + 50 end
		if(v:GetModel() == "models/shigure/shelter_b_generator03.mdl") then PCount = PCount + 75 end
		if(v:GetModel() == "models/shigure/shelter_b_generator04.mdl") then PCount = PCount + 110 end

	end

	return PCount

end


function GetStorageCount(idx)

	local vCount = 1

	if(idx == 1) then

		for k,v in pairs(ents.FindByModel("models/items/ammocrate_ar2.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 13

			end

		end

		for k,v in pairs(ents.FindByModel("models/shigure/shelter_b_warehouse01.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 21

			end

		end

		for k,v in pairs(ents.FindByModel("models/nickmaps/rostok/p19_casa2.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 33

			end

		end

	else

		for k,v in pairs(ents.FindByModel("models/items/ammocrate_ar2.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 11

			end

		end

		for k,v in pairs(ents.FindByModel("models/shigure/shelter_b_warehouse01.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 18

			end

		end

		for k,v in pairs(ents.FindByModel("models/nickmaps/rostok/p19_casa2.mdl")) do

			if(IsValid(v) && v:GetColor().a == 255) then

				vCount = vCount + 27

			end

		end

	end

	return vCount

end

FreezeAIClass = ""

function CheckEntTable(ents_, ply)

	local vCount = 0

	for k,v in ipairs(ents_.VJ_AddCertainEntityAsEnemy) do
		if v:IsPlayer() && v:GetName() == ply:GetName() then
			table.remove(ents_.VJ_AddCertainEntityAsEnemy,k)
		end
	end

	for x, y in ipairs(ents_.VJ_AddCertainEntityAsFriendly) do

		if(y == ply) then

			vCount = vCount + 1

		end

	end

	if(vCount == 0) then
		table.insert(ents_.VJ_AddCertainEntityAsFriendly,ply)
	end

end
function AddHook12()
hook.Add( "EntityTakeDamage", "TakeDamageHandler", function( target, dmginfo )
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local aClass = "NULL"
	local aHP = 0
	local aWep = NULL
	local aWClass = "NULL"

	local vSeq = 0



	if(IsValid(attacker)) then
		aClass = attacker:GetClass()
		aHP = attacker:Health()

		if(attacker:IsPlayer())	 then

			if(IsValid(attacker:GetActiveWeapon())) then

				aWep = attacker:GetActiveWeapon()
				aWClass = aWep:GetClass()

			end

		end

	end
	local damage = dmginfo:GetDamage()

	local tClass = "NULL"
	local tHP = 0
	if(IsValid(target)) then
		tClass = target:GetClass()
		tHP = target:Health()
	end

	if(IsValid(attacker) && IsValid(target)) then

		if(target:GetClass() == "prop_physics_multiplayer") then
			if(target.IsObstacle) then
				if(target:Health() < damage) then
					target:Remove()
				end
				target:SetHealth(target:Health() - damage)
			end
		end

		if(attacker:IsPlayer()) then
			for k,v in next, PlayerCloakTable do
				if(v[1] == attacker) then
					if(target:IsNPC() && !IsTurret(target)) then
						dmginfo:ScaleDamage(5)
						damage = damage * 5
					end
				end
				if(!inflictor:IsNPC()) then
					for x,idx in next, PlayerDataTable do
						if(idx[17] != v[1]) then continue end
						idx[40] = false
					end
					v[1]:SetColor(Color(255, 255, 255, 255))
					v[1]:RemoveFlags(65536)
					table.remove(PlayerCloakTable, k)
				end
			end
		end

		if(aClass == "npc_vj_hlr1_cturret_mini" || aClass == "npc_vj_hlr1_cturret") then
			dmginfo:ScaleDamage(2.25)
		end

		if(tClass == "npc_vj_hlr1_cturret_mini" || tClass == "npc_vj_hlr1_cturret") then
			dmginfo:ScaleDamage(0)
			return false
		end

		if(IsTurret(attacker) && target:IsPlayer()) then
			dmginfo:ScaleDamage(0)
			return false
		end

		if(attacker:IsPlayer()) then

			if(tClass == FreezeAIClass) then
				ShouldEnableAI = true
			end

			if(aWClass == "arccw_horde_crowbar") then
				vSeq = attacker:GetViewModel(0):GetSequence()
			end

		end

		if(attacker:IsPlayer() && IsTurret(inflictor) && IsTurret(target)) then
			damage = 0
			dmginfo:ScaleDamage(0)
			return false
		end

		if(IsTurret(inflictor) && target:IsPlayer()) then
			damage = 0
			dmginfo:ScaleDamage(0)
			return false
		end

		if(IsTurret(attacker) && IsTurret(target)) then
			damage = 0
			dmginfo:ScaleDamage(0)
			return false
		end

		if(attacker:IsPlayer() && IsTurret(target) && aWClass != "arccw_horde_crowbar") then
			damage = 0
			dmginfo:ScaleDamage(0)
		end

		if(attacker:IsPlayer() && target:IsPlayer() && GetConVar("horde_zshelter_friendly_fire"):GetInt() == 0) then dmginfo:ScaleDamage(0) damage = 0 return false end

		if(target:IsNPC()) then
			if(IsTurret(target)) then
				dmginfo:SetDamageType(8192) -- Make turret receive blast damage, so they'll explode on kill
			end
		end

		if(attacker:IsPlayer()) then

			if(tClass == "npc_vj_hlrof_geneworm") then

				if(attacker:GetPos().z <= 110) then

					if(tHP < damage) then

						for x,y in pairs(player.GetAll()) do

						if(!IsValid(y)) then continue end
						y:Horde_SetExp(y:Horde_GetCurrentSubclass(), y:Horde_GetExp(y:Horde_GetCurrentSubclass()) + 500)

						y:Say("!rtv")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
						end

						BroadcastLua("  sound.PlayFile( 'sound/music/HL2_song23_SuitSong3.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end) ")

						target:Remove()

					else

						target:SetHealth(tHP - damage)

					end

				end

			end

		end

		if(inflictor:IsNPC()) then

			if(IsTurret(inflictor)) then

				if(tClass == "prop_physics_multiplayer") then

					dmginfo:ScaleDamage(0)
					damage = 0

				end

				if(IsTurret(target)) then

					dmginfo:ScaleDamage(0)
					damage = 0

				end

			end

		end

		if(attacker:IsPlayer() && inflictor:GetClass() == "arccw_horde_crowbar") then

			if(target:IsNPC()) then

				dmginfo:ScaleDamage(1.5)

			end

		end

		if(attacker:IsNPC()) then

			if(IsBase(target)) then
				if(!IsTurret(attacker)) then
					if(AttackNotifyTimer < CurTime()) then

						net.Start("BaseAlert")
						net.Broadcast()

						AttackNotifyTimer = CurTime() + 6

					end
				end
			end

			if(tClass == "prop_physics_multiplayer" && target:GetMaxHealth() != 1) then

			if(GetConVar("horde_zshelter_hardcore_mode"):GetInt() == 1) then
				damage = damage * 2
			end

				if(IsResource(target)) then
					dmginfo:ScaleDamage(0)
				else
					if(tHP <= damage) then
						if(IsBase(target)) then

							BroadcastLua("  sound.PlayFile( 'sound/music/HL2_song28.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end) ")

							for x,y in pairs(player.GetAll()) do

							if(!IsValid(y)) then continue end

								y:Say("!rtv")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
								PrintMessage( HUD_PRINTTALK, " ")
							end
						end
						target:Remove()
					else
						target:SetHealth(tHP - damage * 1.5)
					end
				end

				local Phys = target:GetPhysicsObject()

				if(IsValid(Phys)) then

					Phys:EnableMotion(false)

				end

			end

		end

		if(attacker:IsPlayer()) then

			local DamageScale = 1

			for k, idx in next, PlayerDataTable do
				if(idx[1] == attacker:SteamID()) then
					DamageScale = idx[15]
				end
			end

			local FixedDamageScale = 1

			if(damage <= 3) then -- Fuck VJ's damage reducing
				FixedDamageScale = math.floor(12 / damage) * 0.55
			end

			if(inflictor:GetClass() == "npc_vj_hlr1_gturret_mini") then
				dmginfo:SetDamage(12 * DamageScale)
			end
			if(inflictor:GetClass() == "npc_vj_hlrdc_sentry") then
				dmginfo:SetDamage(5 +(damage * FixedDamageScale) * DamageScale)
			end
			if(inflictor:GetClass() == "npc_vj_hlr1_gturret") then
				dmginfo:SetDamage(5 +(damage * FixedDamageScale) * DamageScale)
			end
			if(inflictor:GetClass() == "npc_vj_hlr1_xen_cannon") then
				dmginfo:ScaleDamage(3.5)
				inflictor:NextThink(CurTime() + 2)

				local effectdata = EffectData()
					effectdata:SetOrigin(target:GetPos())
					effectdata:SetMagnitude(7)
					effectdata:SetScale(2)
					effectdata:SetNormal(Vector(0, 0, 90))
					effectdata:SetRadius(10)

				util.Effect( "ElectricSpark", effectdata )
				sound.Play( "ambient/energy/zap6.wav", target:GetPos(), 70, 90, 1)

				for k,v in pairs(ents.FindByClass("npc_*")) do
					if(IsTurret(v)) then continue end
					if(v:GetPos():Distance(dmginfo:GetDamagePosition()) > 256) then continue end
						local dInfo = DamageInfo()
							dInfo:SetDamage( 40 )
							dInfo:SetAttacker( attacker )
							dInfo:SetInflictor( attacker )
							dInfo:SetDamageType( 256 ) 
							dInfo:SetDamagePosition(v:GetPos())

						v:TakeDamageInfo(dInfo)
				end
			end
		end

		if(tClass == "prop_physics_multiplayer") then
			if(!IsTurret(inflictor) && dmginfo:GetDamageType() == 2) then
				if(target:GetModel() == "models/shigure/gastank.mdl") then
						local effectdata = EffectData()
							effectdata:SetOrigin( target:GetPos() + Vector(0, 0, 7) )
							util.Effect( "Explosion", effectdata )

						local effectdata = EffectData()
							effectdata:SetOrigin(target:GetPos())
							effectdata:SetMagnitude(5)
							effectdata:SetScale(3)
							effectdata:SetNormal(Vector(0, 0, 90))
							effectdata:SetRadius(7)

						util.Effect( "ElectricSpark", effectdata )

						local dInfo = DamageInfo()
							dInfo:SetDamage( 60 )
							dInfo:SetAttacker( target )
							dInfo:SetDamageType( 256 ) 

						sound.Play( "npc/roller/mine/rmine_explode_shock1.wav", target:GetPos(), 160, 95, 1)
						sound.Play( "ambient/explosions/explode_5.wav", target:GetPos(), 160, 100, 1)
					for x, y in pairs(ents.FindByClass("npc_*")) do
						if(!IsValid(y)) then continue end
						if(IsTurret(y)) then continue end
						if(y:GetPos():Distance(target:GetPos()) > 300) then continue end

							y:TakeDamageInfo( dInfo )

							y:SetColor(Color(60, 60, 255))
							y:NextThink(CurTime() + 8)

							timer.Create( "Unfreeze"..math.random(-1024, 1024).."", 8, 1, function() if(!IsValid(y)) then return end y:SetColor(Color(255, 255, 255)) end )

					end
					for x, y in pairs(player.GetAll()) do

						if(!IsValid(y)) then continue end
						if(!y:Alive()) then continue end
						if(y:GetPos():Distance(target:GetPos()) > 300) then continue end

						y:Freeze(true)
						y:SetColor(Color(60, 60, 255))

						timer.Create( "Unfreeze"..math.random(-1024, 1024).."", 3, 1, function() if(!IsValid(y)) then return end y:Freeze(false) y:SetColor(Color(255, 255, 255)) end )

					end
					target:Remove()
				end
			end
		end

		if(attacker:IsPlayer() && aWClass == "arccw_horde_crowbar" && inflictor:GetClass() == "arccw_horde_crowbar") then

			local FixSpeed = 1

			for k, idx in next, PlayerDataTable do
				if(idx[1] == attacker:SteamID()) then
					FixSpeed = idx[9]
				end
			end

			if(dmginfo:GetDamageType() != 2) then
				aWep:SetNextPrimaryFire(CurTime() + 0.415)
			end

			if(IsTurret(target)) then

				if(IsTurret(inflictor) && IsTurret(target)) then
					damage = 0
					return false
				end

			dmginfo:ScaleDamage(0)

				if(vSeq <= 3) then

					if(tHP > damage) then

						if(tClass == "npc_vj_hlr1_gturret" || tClass == "npc_vj_hlr1_gturret_mini") then
							target:SetHealth(tHP - damage * 4)
						else
							target:SetHealth(tHP - damage * 2)
						end

					else

						target:Remove()

					end

				else

					if(tClass == "npc_vj_hlr1_gturret" || tClass == "npc_vj_hlr1_gturret_mini") then
						target:SetHealth(math.Clamp(tHP + ((damage * 4) * FixSpeed ), 0, target:GetMaxHealth()))
					else
						target:SetHealth(math.Clamp(tHP + (damage * FixSpeed ), 0, target:GetMaxHealth()))
					end

				end

			end

			if(tClass == "prop_physics_multiplayer") then

				if(IsResource(target)) then

					damage = 50

					for k, idx in next, PlayerDataTable do

						if(idx[1] == attacker:SteamID()) then

							if(ResourceType(target) == 1) then

								if(idx[2] < idx[4]) then

									if(math.fmod(tHP - damage, 100) == 0) then
										net.Start("ResourceNotify")
										net.WriteInt(ResourceType(target), 4)
										net.Send(attacker)
										idx[2] = math.Clamp(idx[2] + idx[7], 0, idx[4])
									end

									if(tHP <= damage) then

										target:Remove()

									else

										target:SetHealth(tHP - damage)

									end

								else

									if(idx[8] == 1) then

										if(GlobalWood < GlobalWoodLimit) then

											if(math.fmod(tHP - damage, 100) == 0) then
												net.Start("ResourceNotify")
												net.WriteInt(ResourceType(target), 4)
												net.Send(attacker)
												GlobalWood = math.Clamp(GlobalWood + idx[7], 0, GlobalWoodLimit)
											end

										else

											net.Start("FullNotify")
											net.Send(attacker)

											damage = 0

										end

									if(tHP <= damage) then

										target:Remove()

									else

										target:SetHealth(tHP - damage)

									end

									else

										net.Start("FullNotify")
										net.Send(attacker)

										damage = 0

									end

								end

							end
							if(ResourceType(target) == 2) then

								if(idx[3] < idx[5]) then

									if(math.fmod(tHP - damage, 100) == 0) then
										net.Start("ResourceNotify")
										net.WriteInt(ResourceType(target), 4)
										net.Send(attacker)
										idx[3] = math.Clamp(idx[3] + idx[7], 0, idx[5])
									end

									if(tHP <= damage) then

										target:Remove()

									else

										target:SetHealth(tHP - damage)

									end

								else

									if(idx[8] == 1) then

										if(GlobalIron < GlobalIronLimit) then

											if(math.fmod(tHP - damage, 100) == 0) then
												net.Start("ResourceNotify")
												net.WriteInt(ResourceType(target), 4)
												net.Send(attacker)
												GlobalIron = math.Clamp(GlobalIron + idx[7], 0, GlobalIronLimit)
											end

										else

											net.Start("FullNotify")
											net.Send(attacker)

											damage = 0

										end

									if(tHP <= damage) then

										target:Remove()

									else

										target:SetHealth(tHP - damage)

									end

									else

										net.Start("FullNotify")
										net.Send(attacker)

										damage = 0

									end

								end

							end

							if(ResourceType(target) == 3) then

									damage = 25

									if(tHP <= damage) then

										idx[20] = idx[20] + 1

										target:Remove()

									else

										target:SetHealth(tHP - damage)


								end

							end

						end

					end

				else

				if(target:GetMaxHealth() != 1) then

					if(vSeq <= 3) then

						if(tHP > damage) then

							if(!IsBase(target)) then

								target:SetHealth(tHP - (damage * 0.5))

							else

								if(GetConVar("horde_zshelter_allow_damage_shelter"):GetInt() == 1) then

									target:SetHealth(tHP - (damage * 0.5))

								end

							end

						else

							target:Remove()

						end

					else

						if(!target.IsObstacle) then

							target:SetHealth(math.Clamp(tHP + ((damage * 0.5) * FixSpeed ), 0, target:GetMaxHealth()))

						end

					end

				end

				end

			end

		end

	end

end)
end


function GetResourceCount()

	local vCount = 0

	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do

		if(!IsValid(v)) then continue end

		if(IsResource(v)) then

			vCount = vCount + 1

		end

	end

	return vCount

end

function SetupTreasureArea()
	for k,v in pairs(ents.FindByClass("info_zshelter_treasure_area")) do
		local pos = v:GetPos() + Vector(0,0,2)
		ResourceCenter(20 + (player.GetCount() * 2), pos)
		SpawnMiniBoss(pos, 1)
	end
end

function ResourceCenter(count, vec)

	for i = count, 1, -1 do 

		local AmoutRand = math.random(1, 5)
		local Type = math.random(1, 2)

		local pos = util.QuickTrace( vec + Vector(math.random(-768, 768),math.random(-768, 768),40), Vector(0,0,-128), COLLISION_GROUP_DEBRIS).HitPos

		if(!util.IsInWorld(pos)) then continue end

		local ent = ents.Create("prop_physics_multiplayer")

		if(Type == 1) then
			ent:SetModel("models/galaxy/rust/woodpile1.mdl")
			ent:SetPos(pos)
		else

			if(AmoutRand > 4) then
				AmoutRand = 4
			end

			ent:SetModel("models/props_junk/ibeam01a_cluster01.mdl")
			ent:SetModelScale(0.7, 0)
			ent:SetCollisionBounds(ent:GetModelRenderBounds())
			ent:SetPos(pos + Vector(0,0,7))
		end

		ent:Spawn()

		ent:SetAngles(Angle(0,math.random(-180, 180),0))
		ent:SetMaxHealth(100 * AmoutRand)
		ent:SetHealth(100 * AmoutRand)

		ent:SetCollisionGroup(20)

		local Phys = ent:GetPhysicsObject()

		if(IsValid(Phys)) then

			Phys:EnableMotion(false)

		end		

	end

end

function SpawnMaterials(count)
	for i = count, 1, -1 do 

		local nodes = navmesh.GetAllNavAreas()
		local node = nodes[math.random(#nodes)]
		local pos = node:GetRandomPoint()
		local ent = ents.Create("prop_physics_multiplayer")

		if(pos.z >= 300) then  i = i +1 continue end

		ent:SetModel("models/galaxy/rust/rockore4.mdl")
		ent:SetModelScale(1, 0)
		ent:SetCollisionBounds(ent:GetModelRenderBounds())
		ent:SetPos(pos + Vector(0,0,7))

		ent:Spawn()

		ent:SetAngles(Angle(0,math.random(-180, 180),0))
		ent:SetMaxHealth(400)
		ent:SetHealth(400)

		ent:SetCollisionGroup(20)

		local Phys = ent:GetPhysicsObject()

		if(IsValid(Phys)) then

			Phys:EnableMotion(false)

		end		

	end
end

function ResourceManager_Looting(vec)

		local Type = math.random(0, 1)
		local AmoutRand = math.random(1, 5)
		local pos = vec
		local ent = ents.Create("prop_physics_multiplayer")

		if(Type == 1) then
			ent:SetModel("models/galaxy/rust/woodpile1.mdl")
			ent:SetPos(pos)
		else

			if(AmoutRand > 4) then
				AmoutRand = 4
			end

			ent:SetModel("models/props_junk/ibeam01a_cluster01.mdl")
			ent:SetModelScale(0.7, 0)
			ent:SetCollisionBounds(ent:GetModelRenderBounds())
			ent:SetPos(pos + Vector(0,0,7))
			ent:SetCollisionGroup(11)
		end

		ent:Spawn()

		ent:SetAngles(Angle(0,math.random(-180, 180),0))
		ent:SetMaxHealth(100)
		ent:SetHealth(100)

		ent:SetCollisionGroup(20)

		local Phys = ent:GetPhysicsObject()

		if(IsValid(Phys)) then

			Phys:EnableMotion(false)

		end		

	end

function ResourceManager(count)

	for i = count, 1, -1 do 

		local Type = math.random(0, 1)
		local AmoutRand = math.random(1, 5)

		local nodes = navmesh.GetAllNavAreas()
		local node = nodes[math.random(#nodes)]
		local pos = node:GetRandomPoint()
		local ent = ents.Create("prop_physics_multiplayer")

		if(game.GetMap() == "hr_zsht_desertplant" && pos.z <= 115) then return end 
		if(game.GetMap() == "hr_zsht_desertplant" && pos.z >= 300) then return end 

		if(Type == 1) then
			ent:SetModel("models/galaxy/rust/woodpile1.mdl")
			ent:SetPos(pos)
		else

			if(AmoutRand > 4) then
				AmoutRand = 4
			end

			ent:SetModel("models/props_junk/ibeam01a_cluster01.mdl")
			ent:SetModelScale(0.7, 0)
			ent:SetCollisionBounds(ent:GetModelRenderBounds())
			ent:SetPos(pos + Vector(0,0,7))
			ent:SetCollisionGroup(11)
		end

		ent:Spawn()

		ent:SetAngles(Angle(0,math.random(-180, 180),0))
		ent:SetMaxHealth(100 * AmoutRand)
		ent:SetHealth(100 * AmoutRand)

		ent:SetCollisionGroup(20)

		local Phys = ent:GetPhysicsObject()

		if(IsValid(Phys)) then

			Phys:EnableMotion(false)

		end		

	end

end

function ShouldAddTable(ent)
	local vCount = 0

	for k,v in next, PlayerDataTable do

		if(v[1] == ent:SteamID()) then

			vCount = vCount + 1

		end

	end

	if(vCount == 0) then
		table.insert(PlayerDataTable, {ent:SteamID(), 0, 0, 12, 10, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, ent, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, 0, 0, 0, 0, 0, 0, false}) -- Data Table, Contains Skilltree stuff
		return true
	else
		return false
	end

end

function CreateObject(idx, mdl, pos, ang)
		local Wall = ents.Create(idx)
			Wall:SetModel(mdl)
			Wall:SetPos(pos)
			Wall:SetAngles(ang)
			Wall:Spawn()

		Wall:GetPhysicsObject():EnableMotion(false)
end

function CreateDestructible(idx, mdl, pos, ang, hp, scale)
		local Wall = ents.Create(idx)
			Wall:SetModel(mdl)
			Wall:SetPos(pos)
			Wall:SetAngles(ang)
			Wall:Spawn()

		Wall:SetMaxHealth(hp)
		Wall:SetHealth(hp)

		Wall:SetModelScale(scale, 0)

		Wall:GetPhysicsObject():EnableMotion(false)
end

function CreateObstacle(vec, ang, hp)
		local Wall = ents.Create("prop_physics_multiplayer")
			Wall:SetModel("models/props_wasteland/cargo_container01.mdl")
			Wall:SetPos(vec)
			Wall:SetAngles(ang)
			Wall:Spawn()

		Wall:SetMaxHealth(hp * 3)
		Wall:SetHealth(hp * 3)

		Wall:GetPhysicsObject():EnableMotion(false)

		Wall.IsObstacle = true
end

function GetTele()

	local vCount = 0

	for k,v in pairs(ents.FindByModel("models/shigure/shelter_b_antenna01.mdl")) do

		if(!IsValid(v)) then continue end

		vCount = vCount + 1

	end

	if(vCount == 0) then
		return false
	else
		return true
	end

end

function GetWorkStation()

	local vCount = 0

	for k,v in pairs(ents.FindByModel("models/props_lab/workspace004.mdl")) do

		if(!IsValid(v)) then continue end

		vCount = vCount + 1

	end

	if(vCount == 0) then
		return false
	else
		return true
	end

end

function GetWorkCM()

	local vCount = 0

	for k,v in pairs(ents.FindByModel("models/shigure/shelter_b_concrete01.mdl")) do

		if(!IsValid(v)) then continue end

		vCount = vCount + 1

	end

	if(vCount == 0) then
		return false
	else
		return true
	end

end

function ResetResource()
	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
		if(!IsValid(v)) then continue end
		if(!IsResource(v)) then continue end
		v:Remove()
	end
end

function GetPublicBuildingReq(x)
	if(x == 0) then return true end
	if(x == 1) then return GetWorkStation() end
	if(x == 2) then return GetWorkCM() end
end

function SpawnMiniBoss(vec, amout)

	if(GetConVar("horde_zshelter_debug_nozombie"):GetInt() == 1) then return end

	for i = amout, 1, -1 do 

		for k,v in next, CurrentEnemies do

			if(v[1] == "Miniboss") then

				if(v[2] == "" || string.Left(v[2], 4) != "npc_") then PrintMessage( HUD_PRINTTALK, "Something went wrong! Please check console!") print("Miniboss's class ID is invalid!") continue end
				vec = util.QuickTrace( vec + Vector(0, 0, 40), Vector(0,0,-128), COLLISION_GROUP_DEBRIS).HitPos
				local SpawnedEnemy = ents.Create(v[2])
					SpawnedEnemy:SetPos(vec)
					SpawnedEnemy:Spawn()
					SpawnedEnemy:SetCollisionGroup(0)

				local HPScaling = (GetConVar("horde_zshelter_custom_enemyhp_increase_day"):GetInt() + (HordeDiff * 6)) * GlobalDay
				local HPScalingMHP = ((v[3] * v[6]) * GlobalDay) * (1 + ((HordeDiff * 2) / 10))

				if(tonumber(v[5]) == 0) then
					SpawnedEnemy:SetMaxHealth(v[3] + HPScaling)
					SpawnedEnemy:SetHealth(v[3] + HPScaling)
				else
					SpawnedEnemy:SetMaxHealth(v[3] + HPScalingMHP)
					SpawnedEnemy:SetHealth(v[3] + HPScalingMHP)
				end

				return

			end

		end

	end

end

function SpawnManager(vec, amout, vel)

	if(GetConVar("horde_zshelter_debug_nozombie"):GetInt() == 1) then return end

	for i = amout, 1, -1 do 

		local Index = math.floor(math.random(1, table.Count(SpawnList)))
		local RandNum = math.random(1, 100)

		if(SpawnList[Index][3] < RandNum) then
			Index = 1
		end 

		local ExtraHealth = 1 + GetConVar("horde_zshelter_hardcore_mode"):GetInt()

		local SpawnedEnemy = ents.Create(SpawnList[Index][1])
			SpawnedEnemy:SetPos(vec)
			SpawnedEnemy:Spawn()
			SpawnedEnemy:SetCollisionGroup(0)

		SpawnedEnemy:SetVelocity(vel)
		SpawnedEnemy:SetLastPosition( GetChasePos() )
		SpawnedEnemy:SetSchedule( SCHED_FORCED_GO_RUN )
		SpawnedEnemy:SetCustomCollisionCheck( true )

		local HPScaling = (GetConVar("horde_zshelter_custom_enemyhp_increase_day"):GetInt() + (HordeDiff * 6)) * GlobalDay
		local HPScalingMHP = ((SpawnList[Index][2] * SpawnList[Index][5]) * GlobalDay) * (1 + ((HordeDiff * 2) / 10))

		if(tonumber(SpawnList[Index][4]) == 0) then
			SpawnedEnemy:SetMaxHealth((SpawnList[Index][2] + HPScaling) * ExtraHealth)
			SpawnedEnemy:SetHealth((SpawnList[Index][2] + HPScaling) * ExtraHealth)
		else
			SpawnedEnemy:SetMaxHealth((SpawnList[Index][2] + HPScalingMHP) * ExtraHealth)
			SpawnedEnemy:SetHealth((SpawnList[Index][2] + HPScalingMHP) * ExtraHealth)
		end

	end

end

function CreateShelter()
	for k,v in pairs(ents.FindByClass("info_zshelter_shelter_position")) do
		CreateDestructible("prop_physics_multiplayer",	"models/shigure/shelter_b_shelter02.mdl",	v:GetPos() - Vector(0,0,17) ,v:GetAngles(), 2500, 1)
	end
	for k,v in pairs(ents.FindByClass("info_zshelter_storage_position")) do
		CreateObject("prop_physics_multiplayer",	"models/nickmaps/rostok/p20_tank_pumps.mdl",	v:GetPos() + Vector(0,0,15) ,v:GetAngles() ,Angle(0,90,0))
	end
end

Init = false

NPCChaseTimer = 0

function NPCCount()
	local vCount = 0

	for k,v in pairs(ents.FindByClass("npc_*")) do
		if(!IsValid(v)) then continue end

		if(!v:IsNPC()) then continue end

		if(v:GetClass() == "npc_vj_hlr1_gturret_mini") then continue end
		if(v:GetClass() == "npc_vj_hlr1_gturret") then continue end
		if(v:GetClass() == "npc_vj_hlrdc_sentry") then continue end
		if(v:GetClass() == "npc_vj_hlr1_sentry") then continue end
		if(v:GetClass() == "npc_helicopter") then continue end
		if(v:GetClass() == "npc_vj_horde_lesion") then continue end
		if(v:GetClass() == "npc_vj_hlr1_garg") then continue end

		vCount = vCount + 1

	end

	return vCount
end

function GetTurretIDX(idx)
	if(idx == 1) then return "npc_vj_hlr1_gturret_mini" end
	if(idx == 2) then return "npc_vj_hlrdc_sentry" end
	if(idx == 3) then return "npc_vj_hlr1_gturret" end
	if(idx == 4) then return "npc_vj_hlr1_sentry" end
	if(idx == 5) then return "npc_vj_hlr1_xen_cannon" end
	if(idx == 6) then return "prop_physics_multiplayer" end
end

ResetTurretEnemyTimer = 0
ShouldNotify = false
VJRelationShipTBL = nil
ShouldReset = false
OldWoodCache = 0
OldIronCache = 0

CheckEntityValidTimer = 0

function AddHook11()
hook.Add( "Tick", "TickHandler_", function()

	HORDE.total_enemies_this_wave = 2000
	HORDE.killed_enemies_this_wave = 0
	HORDE.total_enemies_this_wave_fixed = 2000

	HORDE:BroadcastEnemiesCountMessage(false, " | Shelter Mode", 1024)

	local ExtraAmount_ = 0

	if(GetConVar("horde_zshelter_debug_infinite_resources"):GetInt() == 1) then
		ExtraAmount_ = 1000
	end

	if(GetConVar("horde_zshelter_debug_infinite_resources"):GetInt() == 1) then
		ShouldReset = true
		GlobalWoodLimit = 15 + GetStorageCount(1) + ExtraAmount_
		GlobalIronLimit = 15 + GetStorageCount(2) + ExtraAmount_
		GlobalWood = GlobalWoodLimit
		GlobalIron = GlobalIronLimit
		for k, idx in next, PlayerDataTable do
			idx[2] = idx[4]
			idx[3] = idx[5]
		end
	else
		if(ShouldReset) then
			GlobalWood = OldWoodCache
			GlobalIron = OldIronCache
			ShouldReset = false
		end
		GlobalWoodLimit = 15 + GetStorageCount(1)
		GlobalIronLimit = 15 + GetStorageCount(2)
		OldWoodCache = GlobalWood
		OldIronCache = GlobalIron
	end

	if(GetConVar("horde_zshelter_debug_infinite_skillpoints"):GetInt() == 1) then
		for k, idx in next, PlayerDataTable do
			idx[20] = 1
		end
	end

	if(VJ_EmitSound != VJ_EmitSound_) then
		VJ_EmitSound = VJ_EmitSound_
	end

	-- Setup

	if(!Init) then

		NightOrDay = false -- Set to day
		GlobalTime = 300

		CreateShelter()

		local Turret = ents.Create("npc_vj_hlr1_gturret_mini") -- So zombies will run to base and attack
			Turret:SetPos(GetShelterCenter() + Vector(0,0,100))
			Turret:SetAngles(Angle(0,0,0)) 

			Turret:Spawn()

			Turret:SetColor(Color(0, 0, 0, 0))


			Turret:SetRenderMode( RENDERMODE_TRANSCOLOR )
			Turret:SetMaxHealth(1800000)
			Turret:SetHealth(1800000)

		Init = true
	end

	-- End of Setup

	--->>>>>>>>>>>>>>>>>> Start of building system

	for k, v in next, PlayerBuildTable do -- ply, mdl, ent

		if(!IsValid(v[1])) then

			if(IsValid(v[3])) then
				v[3]:Remove()
			end
			table.remove(PlayerBuildTable, k)
		end

		if(!v[1]:Alive()) then

			if(IsValid(v[3])) then
				v[3]:Remove()
			end
			table.remove(PlayerBuildTable, k)
		end

		if(!IsValid(v[1]:GetActiveWeapon())) then

			if(IsValid(v[3])) then
				v[3]:Remove()
			end

			table.remove(PlayerBuildTable, k)
		end

		if(v[1]:GetActiveWeapon():GetClass() != "arccw_horde_crowbar") then

			if(IsValid(v[3])) then
				v[3]:Remove()
			end
			
			table.remove(PlayerBuildTable, k)
		end

		if(v[1]:KeyDown(2048)) then

			if(IsValid(v[3])) then
				v[3]:Remove()
			end

			table.remove(PlayerBuildTable, k)
		end

		if(v[4] < CurTime()) then
			net.Start("BlockMenuKey")
			net.Send(v[1])
			v[4] = CurTime() + 0.5
		end

		local OriginalPos = util.QuickTrace( v[1]:GetEyeTrace().HitPos, Vector(0,0,-3072), COLLISION_GROUP_DEBRIS).HitPos

		local XPos = math.floor(OriginalPos.x / 16) * 16
		local YPos = math.floor(OriginalPos.y / 16) * 16
		if(GetConVar("horde_zshelter_snap_to_grid"):GetInt() == 1) then
			v[17] = Vector(XPos, YPos, OriginalPos.z)
		else
			v[17] = OriginalPos
		end

		local BuildingHP = GetBuildingHealth(v[5], v[6])
		local BuildingAngle = Angle(0, v[9], 0)
		local BuildingZOffset = GetBuildingZOffset(v[5], v[6])
		local CanBuild = false

		if(!IsValid(v[3])) then

			v[3] = ents.Create("prop_dynamic")
				v[3]:SetModel(v[2])
				v[3]:SetColor(Color(255, 255, 255, 180))
				v[3]:SetRenderMode( RENDERMODE_TRANSCOLOR )

				if(v[6] == 34) then
					v[3]:SetModelScale(0.65, 0)
				end

			else

			if(v[5] == 3 && v[6] == 13) then
				v[3]:SetAngles(Angle(2,BuildingAngle.y,3))
			else
				v[3]:SetAngles(BuildingAngle)
			end
			v[3]:SetPos(v[17] + Vector(0, 0, BuildingZOffset))

		end

		if(v[1]:KeyPressed(8192)) then
			v[9] = v[9] + 45
		end

		if(v[17]:Distance(v[1]:GetPos()) < 400) then
			v[3]:SetColor(Color(255, 255, 255, 170))
			if(v[5] == 1 && v[6] == 32) then
				v[3]:SetColor(Color(255, 255, 255, 255))
			end
			CanBuild = true
		else
			v[3]:SetColor(Color(255, 95, 95, 180))
		end

		if(v[1]:KeyDown(1) && CanBuild) then

			sound.Play( "shigure/Build.mp3", v[17], 120, 100, 1)

			local effectdata = EffectData()
				effectdata:SetOrigin( v[17] )
				effectdata:SetScale(85)
				util.Effect( "ThumperDust", effectdata )
				util.Effect( "ThumperDust", effectdata )
				util.Effect( "ThumperDust", effectdata )

		if(v[5] != 4) then
				local Building = ents.Create("prop_physics_multiplayer")
				Building:SetModel(v[2])
				Building:SetColor(Color(255, 255, 255, 170))
				Building:SetRenderMode( RENDERMODE_TRANSCOLOR )
				Building:SetPos(v[17] + Vector(0, 0, BuildingZOffset))
				if(v[5] == 3 && v[6] == 13) then
					Building:SetAngles(Angle(2,BuildingAngle.y,3))
				else
					Building:SetAngles(BuildingAngle)
				end

				Building:Spawn()

				Building:SetMaxHealth(BuildingHP * (1 + (v[10] / 2)))
				Building:SetHealth(10)

				if(v[6] == 34) then
					if(v[10] > 1) then
						Building:SetColor(Color(235, 82, 52, 170))
					else
						Building:SetColor(Color(255, 255, 255, 170))
					end
					Building:SetOwner(v[1])
				end

				if(v[6] == 38 || v[6] == 39) then
					Building:SetCustomCollisionCheck(true)
					Building.CurTime = 0
				end

				if(v[5] == 1 && v[6] == 32) then
					Building:SetHealth(BuildingHP + 1)
				end

			local Phys = Building:GetPhysicsObject()

			if(IsValid(Phys)) then
				Phys:EnableMotion(false)
			end
		else

			local Turret = ents.Create(GetTurretIDX(v[6]))
				Turret:SetPos(v[17] + Vector(0, 0, BuildingZOffset))

				Turret:Spawn()
				if(v[11] > 1) then
					Turret:SetColor(Color(235, 82, 52, 170))
				else
					Turret:SetColor(Color(255, 255, 255, 170))
				end

				Turret:SetRenderMode( RENDERMODE_TRANSCOLOR )
				Turret:SetMaxHealth(BuildingHP * (1 + (v[10] / 2)))
				Turret:SetHealth(10)

				Turret:SetOwner(v[1])

				Turret:SetAngles(BuildingAngle)

		end

			if(IsValid(v[3])) then
				v[3]:Remove()
			end

			if(v[5] == 3) then

				for x, idx in next, PlayerDataTable do

					if(idx[1] == v[1]:SteamID()) then

						if(idx[2] >= v[7] && idx[3] >= v[8]) then
							idx[2] = math.Clamp(idx[2] - v[7], 0, idx[4])
							idx[3] = math.Clamp(idx[3] - v[8], 0, idx[5])
						else
							GlobalWood = math.Clamp(GlobalWood - v[7], 0, GlobalIronLimit)
							GlobalIron = math.Clamp(GlobalIron - v[8], 0, GlobalIronLimit)
						end

					end

				end

			else

				for x, idx in next, PlayerDataTable do

					if(idx[1] == v[1]:SteamID()) then

						if(idx[18] == 0) then

							idx[2] = math.Clamp(idx[2] - v[7], 0, idx[4])
							idx[3] = math.Clamp(idx[3] - v[8], 0, idx[5])

						else

							if(idx[2] >= v[7] && idx[3] >= v[8]) then
								idx[2] = math.Clamp(idx[2] - v[7], 0, idx[4])
								idx[3] = math.Clamp(idx[3] - v[8], 0, idx[5])
							else
								GlobalWood = math.Clamp(GlobalWood - v[7], 0, GlobalIronLimit)
								GlobalIron = math.Clamp(GlobalIron - v[8], 0, GlobalIronLimit)
							end

						end

					end

				end

			end

			PrintMessage( HUD_PRINTTALK, ""..v[1]:Nick().." is building a ["..GetBuildingName(v[5], v[6]).."]")
			table.remove(PlayerBuildTable, k)

		end

	end

	--->>>>>>>>>>>>>>>>>> End of building system

	--->>>>>>>>>>>>>>>>>> Start of sub functions

	PlayerScaling = 1 + (player.GetCount() / 10)
	PlayerEnemyScaling = 5 * player.GetCount()

	if(!GameStarted() && Started) then
		print("Horde wave ended or server is empty!, reset to default..")
		PrintMessage( HUD_PRINTTALK, "Reset to default..")
		NightOrDay = false
		net.Start("ResetBrightness")
		net.Broadcast()
		for k,v in pairs(ents.FindByClass("npc*")) do v:Remove() end
		for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
		if(!IsValid(v)) then continue end
		if(!IsBase(v)) then
			if(v:GetMaxHealth() != 1) then 
				v:Remove()
			end
			continue
		end

		local NewBase = ents.Create("prop_physics_multiplayer")
		NewBase:SetModel("models/shigure/shelter_b_shelter02.mdl")
		NewBase:SetPos(v:GetPos())

		NewBase:Spawn()

		NewBase:SetAngles(v:GetAngles())
		NewBase:SetMaxHealth(2500)
		NewBase:SetHealth(v:Health())
		NewBase:SetColor(Color(255, 255, 255, 255))
		NewBase:SetRenderMode( RENDERMODE_TRANSCOLOR )

		local Phys = NewBase:GetPhysicsObject()

		if(IsValid(Phys)) then
		Phys:EnableMotion(false)
		end

		v:Remove()
		end
		PlayerDataTable = {} -- Reset all datas
		for k,v in pairs(player.GetAll()) do
			table.insert(PlayerDataTable, {v:SteamID(), 0, 0, 12, 10, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, v, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, 0, 0, 0, 0, 0, 0, false})
		end

		Started = false
	end

	if(!Started && CheckCustomLuaConfig < CurTime()) then

		if(CustomEnemyConfig != nil && GetConVar("horde_default_enemy_config"):GetInt() == 0) then
			if(!CluaEnemyLoaded) then
				DoCheckLuaEnemyConfig()
			end
		end

		if(CustomItemConfig != nil && GetConVar("horde_default_item_config"):GetInt() == 0) then
			if(!CluaItemLoaded) then
				DoCheckLuaItemConfig()
			end
		end

		CheckCustomLuaConfig = CurTime() + 1
	end

	if(HelpSent >= player.GetCount() && Started) then
		if(!RescueStarted) then
			net.Start("GoalNotify")
			net.WriteString( "Rescue will come in 4 minutes! Defend the base!" )
			net.Broadcast()
			GlobalTime = 240
			RescueStarted = true
		end
	end

	if(CheckEntityValidTimer < CurTime()) then

		for k, idx in next, PlayerDataTable do
		
			if(!IsValid(idx[17])) then

				for x, y in pairs(player.GetAll()) do

				if(!IsValid(y)) then continue end

					if(y:SteamID() == idx[1]) then

						idx[17] = y

					end

				end

			end

		end

		CheckEntityValidTimer = CurTime() + 0.4
	end

	if(GasTankLoop < CurTime()) then

		for k,v in pairs(ents.FindByModel("models/shigure/gastank.mdl")) do

			if(!IsValid(v)) then continue end
			if(v:GetColor().a != 255) then continue end

			local ShouldExplode = false

			for x,y in pairs(ents.FindByClass("npc_*")) do

				if(!IsValid(y)) then continue end
				if(IsTurret(y)) then continue end

				if(v:GetPos():Distance(y:GetPos()) <= 256) then -- the damage rad

					if(v:GetPos():Distance(y:GetPos()) <= 128) then

						ShouldExplode = true

					end

					if(ShouldExplode) then

						local effectdata = EffectData()
							effectdata:SetOrigin( v:GetPos() + Vector(0, 0, 7) )
							util.Effect( "Explosion", effectdata )

						local effectdata = EffectData()
							effectdata:SetOrigin(v:GetPos())
							effectdata:SetMagnitude(5)
							effectdata:SetScale(3)
							effectdata:SetNormal(Vector(0, 0, 90))
							effectdata:SetRadius(7)

						util.Effect( "ElectricSpark", effectdata )

						local dInfo = DamageInfo()
							dInfo:SetDamage( 60 )
							dInfo:SetAttacker( v )
							dInfo:SetDamageType( 256 ) 

						sound.Play( "npc/roller/mine/rmine_explode_shock1.wav", v:GetPos(), 160, 95, 1)
						sound.Play( "ambient/explosions/explode_5.wav", v:GetPos(), 160, 100, 1)

						y:TakeDamageInfo( dInfo )

						y:SetColor(Color(60, 60, 255))
						y:NextThink(CurTime() + 8)

						timer.Create( "Unfreeze"..math.random(-1024, 1024).."", 8, 1, function() if(!IsValid(y)) then return end y:SetColor(Color(255, 255, 255)) end )

						v:Remove()

					end

				end

			end

		end

		GasTankLoop = CurTime() + 0.1
	end

	if(!ShouldEnableAI) then

		for k,v in pairs(ents.FindByClass(FreezeAIClass)) do
			if(!IsValid(v)) then continue end

			for x, y in pairs(player.GetAll()) do

				if(!IsValid(y)) then continue end

				if(!y:Alive()) then continue end

				if(y:GetPos():Distance(v:GetPos()) <= 530) then
					ShouldEnableAI = true
				end

			end

			v:NextThink(CurTime() + 0.1)
		end

	end

	if(ResetTurretEnemyTimer < CurTime()) then

		for m,n in pairs(ents.FindByClass("npc_*")) do

			if(!IsValid(n)) then continue end

			local vClass = n:GetClass()

			if(!IsTurret(n)) then continue end

			if(VJRelationShipTBL == nil) then
				VJRelationShipTBL = n.VJ_NPC_Class
			end

			n.PoseParameterLooking_TurningSpeed = 15

			if(vClass == "npc_vj_hlr1_gturret_mini" && n:GetMaxHealth() >= 15000) then
				n.Sentry_NextAlarmT = CurTime() + 64

				if(IsValid(n:GetEnemy())) then
					n.Sentry_StandDown = true
					n:NextThink(CurTime() + 10)
					n:SetEnemy(nil)
				end
			end

			n.Sentry_NextAlarmT = CurTime() + 5

			if(n.SightDistance < 2048) then
				n.SightDistance = 2048
			end

			if(vClass == "npc_vj_hlr1_gturret" || vClass == "npc_vj_hlr1_cturret") then

				n.Sentry_SpunUp = true -- to fix turret not firing, it's stupid tbh

				if(IsValid(n:GetEnemy())) then
					n.Sentry_StandDown = false
				end
			end

			if(n:GetColor().a != 255 && n:GetMaxHealth() < 10000) then
				n:NextThink(CurTime() + 1)
				if(n:Health() >= n:GetMaxHealth()) then
					sound.Play( "shigure/BuildC.mp3", n:GetPos(), 150, 100, 1)

					local CLR = n:GetColor()

					n:SetColor(Color(CLR.r, CLR.g, CLR.b, 255))
				end
			end

			n.VJ_NPC_Class = VJRelationShipTBL -- Fuck the VJ base relationship sys

			for k,v in pairs(player.GetAll()) do

			if(!IsValid(v)) then continue end

				CheckEntTable(n, v)

			end

		end

		ResetTurretEnemyTimer = CurTime() + 0.33
	end

	if(HealingStationTimer < CurTime()) then

		for k, idx in next, PlayerDataTable do
			if(idx[14] != 0) then if(IsValid(idx[17])) then idx[17]:SetMaxHealth(100 + math.floor(GlobalDay * (idx[14] * 6) )) end end
			if(idx[16] == 1) then if(IsValid(idx[17])) then if(idx[17]:Alive()) then idx[17]:SetHealth(math.Clamp(idx[17]:Health() + 1,0,idx[17]:GetMaxHealth())) end end end
			if(idx[23] != 0) then if(IsValid(idx[17])) then if(idx[17]:Alive()) then idx[17]:SetMaxArmor(100 + (15 * idx[23])) end end end
			if(idx[11] == 1) then
				if(IsValid(idx[17])) then
					for x, y in pairs(ents.FindByClass("prop_physics_multiplayer")) do
						if(!IsValid(y)) then continue end
						if(IsResource(y)) then continue end
						if(y:GetPos():Distance(idx[17]:GetPos()) >= 425) then continue end
						if(y:GetMaxHealth() < 100) then continue end -- not going to fix campfire
						y:SetHealth(math.Clamp(y:Health() + math.random(25, 60), 0, y:GetMaxHealth()))
					end
					for x, y in pairs(ents.FindByClass("npc_*")) do
						if(!IsValid(y)) then continue end
						if(IsResource(y)) then continue end
						if(!IsTurret(y)) then continue end
						if(y:GetPos():Distance(idx[17]:GetPos()) >= 425) then continue end
						y:SetHealth(math.Clamp(y:Health() + math.random(25, 60), 0, y:GetMaxHealth()))
					end
				end
			end
		end

		for x, y in pairs(ents.FindByModel("models/galaxy/rust/campfire.mdl")) do

			if(!IsValid(y)) then continue end

			if(y:Health() > 0) then

				y:SetHealth(y:Health() - 2)

			else

				y:Remove()

			end

		end

		for x, y in pairs(ents.FindByModel("models/galaxy/rust/bed.mdl")) do

			if(y:GetColor().a != 255) then continue end

			for k,v in pairs(player.GetAll()) do

				if(y:GetPos():Distance(v:GetPos()) >= 300) then continue end

				if(!IsValid(v)) then continue end

				if(!v:Alive()) then continue end

				v:SetHealth(math.Clamp(v:Health() + 5, 0, v:GetMaxHealth()))

			end

		end

		hook.Remove("OnNPCKilled", "Horde_EnemyKilled")
		hook.Remove("PlayerCanPickupWeapon", "Horde_Economy_Pickup")
		hook.Remove("EntityTakeDamage", "Horde_EntityTakeDamage")
		hook.Remove("Move", "Horde_PlayerMove")

		HealingStationTimer = CurTime() + 1
	end

	for k, v in next, RemoveGibList do
		if(!IsValid(v[1])) then
			table.remove(RemoveGibList, k)
		end

		if(v[2] <= CurTime()) then
			if(IsValid(v[1])) then
				if(v[1]:GetColor().a <= 10) then
					v[1]:Remove()
					table.remove(RemoveGibList, k)
				else
					v[1]:SetColor(Color(v[1]:GetColor().r, v[1]:GetColor().g, v[1]:GetColor().b, v[1]:GetColor().a - 3))
				end
			else
				table.remove(RemoveGibList, k)
			end
		end
	end

	for k,v in next, DoorTable do

		if(!IsValid(v[1])) then

			table.remove(DoorTable, k)

		else

			if(v[1]:GetModel() != "models/props_lab/blastdoor001c.mdl") then

				table.remove(DoorTable, k)

			end

		end

		if(v[1]:GetModel() == "models/props_lab/blastdoor001c.mdl" && v[1]:GetColor().a == 255) then

			if(v[5]) then

				v[4] = v[1]:GetPos()

				v[5] = false

				else

				if(v[2] > CurTime()) then
						v[3] = math.Clamp(v[3] - 5, 0, 103)
					else
						local Block = false

						for x,y in pairs(player.GetAll()) do
							if(v[3] == 103) then continue end
							if(!IsValid(y)) then continue end
							if(!y:Alive()) then continue end
							if(y:GetPos():Distance(v[1]:GetPos() + Vector(0, 0, (103 - v[3]))) > 86) then continue end
							Block = true
						end
						if(!Block) then
							v[3] = math.Clamp(v[3] + 5, 0, 103)
						else
							v[3] = math.Clamp(v[3] - 5, 0, 103)
						end
				end

				v[1]:SetPos(v[4] - Vector(0, 0, (103 - v[3])))

			end

		end

	end

	for k,v in next, EntTable do

		if(!IsValid(v[1])) then

			table.remove(EntTable, k)

			if(IsValid(v[8])) then

				v[8]:Remove()

			end

		end

		if(IsValid(v[1])) then
		if(v[1]:GetModel() != "models/props_combine/combinethumper002.mdl") then

			table.remove(EntTable, k)

			if(IsValid(v[8])) then

				v[8]:Remove()

			end

		else

			if(v[9]) then

				v[1]:SetModelScale(0.65, 0)

				v[9] = false
			end

		end
		end

		if(IsValid(v[1])) then
		if(!IsValid(v[1]:GetOwner())) then

			table.remove(EntTable, k)

			if(IsValid(v[8])) then

				v[8]:Remove()

			end

		end
		end

		if(v[1]:GetColor().a != 255) then continue end

		local sPos = v[1]:GetPos()
		local tPos = Vector(0,0,0)
		local TargetTable = {}

		if(IsValid(v[8])) then

			v[8]:SetPos(v[8]:GetPos() + Vector(0,0,30))

			if(math.abs(v[8]:GetPos().z - sPos.z) > 1300) then

				v[8]:Remove()

			end

		end

		if(v[4] < CurTime()) then

			if(!v[6]) then -- Not attacking

				if(v[2] < CurTime()) then

					for x, y in pairs(ents.FindByClass("npc_*")) do

						if(!IsValid(y)) then continue end
						if(y:Health() <= 0) then continue end 
						if(IsTurret(y)) then continue end
						if(y:GetClass() == "npc_vj_hlrof_geneworm") then continue end
						if(sPos:Distance(y:GetPos()) > 3096) then continue end

						v[6] = true -- Set Attackint Status(v[6]) status to true if found a target 

					end

				end

			else -- Attacking

				if(v[5] >= 4) then
					v[6] = false
					v[2] = CurTime() + 7.5
					v[5] = 0
				end

				if(v[3] < CurTime()) then

					if(IsValid(v[8])) then
						v[8]:Remove()
					end

					for x, y in pairs(ents.FindByClass("npc_*")) do

						if(!IsValid(y)) then continue end
						if(y:Health() <= 0) then continue end 
						if(IsTurret(y)) then continue end
						if(y:GetClass() == "npc_vj_hlrof_geneworm") then continue end
						if(sPos:Distance(y:GetPos()) > 3096) then continue end

						table.insert(TargetTable, y)

					end

					if(IsValid(v[7])) then

						if(!IsValid(v[8])) then

						sound.Play( "shigure/mortarfire.wav",  sPos, 120, 100, 1)

						v[10] = v[7]:GetPos()

						table.insert(AttackTable, {CurTime() + 0.75, v[7], NULL, false, CurTime() + 10, v[1]:GetOwner(), v[7]:GetPos() + Vector(0,0,1200), v[7]:GetPos()})

							v[8] = ents.Create("prop_dynamic")
								v[8]:SetModel("models/items/ar2_grenade.mdl")
								v[8]:Spawn()

								v[8]:SetModelScale(3, 0)
								v[8]:SetPos(sPos)
								v[8]:SetAngles(Angle(-90,0,0))

								if(IsValid(v[8])) then
									util.SpriteTrail( v[8], 0, Color( 255, 255, 255 ), false, 30, 2, 0.2, 0, "trails/plasma" )
								end

						v[5] = v[5] + 1

						end

					v[3] = CurTime() + 0.5

				else

						if(table.Count(TargetTable) >= 1) then

							v[7] = TargetTable[math.random(table.Count(TargetTable))]

						else

							if(v[10] != Vector(0, 0, 0)) then

								if(v[5] != 0 && v[3] < CurTime()) then

									if(!IsValid(v[8])) then

										sound.Play( "shigure/mortarfire.wav",  sPos, 120, 100, 1)

										v[8] = ents.Create("prop_dynamic")
											v[8]:SetModel("models/items/ar2_grenade.mdl")
											v[8]:Spawn()

											v[8]:SetModelScale(3, 0)
											v[8]:SetPos(sPos)
											v[8]:SetAngles(Angle(-90,0,0))

											if(IsValid(v[8])) then
												util.SpriteTrail( v[8], 0, Color( 255, 255, 255 ), false, 30, 2, 0.2, 0, "trails/plasma" )
											end

											table.insert(AttackTable, {CurTime() + 0.75, NULL, NULL, false, CurTime() + 10, v[1]:GetOwner(), v[10] + Vector(0,0,1200), v[10]})

										v[5] = v[5] + 1

									end

									v[3] = CurTime() + 0.5

								end

							end

						end

					end

				end

			end

			v[4] = CurTime() + 0.1
		end

	end

	for k,v in next, AirStrikeTable do -- {CurTime() + 8, CurTime() + 2.2, true, 0, 0}
		if(v[1] < CurTime()) then
			table.remove(AirStrikeTable, k)
		end
		if(v[3]) then
			sound.Play("shigure/airstrike.mp3", v[6], 140, 100, 10)
			sound.Play("shigure/airstrike.mp3", v[7], 140, 100, 10)
			v[3] = false
		end
		if(v[2] < CurTime()) then
			if(v[4] < CurTime()) then
				sound.Play("shigure/airstrikehit.mp3", v[6], 160, 100, 10)
				v[4] = CurTime() + 2.8
			end
			if(v[5] < CurTime()) then
				local AttackPos = v[6] + Vector(math.random(-512, 512), math.random(-512, 512), 0)
				table.insert(AirStrikeAttackTable, {0, NULL, NULL, false, CurTime() + 10, v[8], AttackPos + Vector(0,0,1200), AttackPos})
				v[5] = CurTime() + 0.15
			end
		else
			local edata = EffectData()
				edata:SetOrigin(v[6])
				edata:SetStart(v[7])
				edata:SetFlags(1)
				util.Effect( "HL1GaussBeamReflect", edata )
		end
	end

	for k,v in next, AirStrikeAttackTable do

		if(v[5] < CurTime()) then
			table.remove(AttackTable, k)
			if(IsValid(v[3])) then
				v[3]:Remove()
			end
		end

		if(!v[4]) then

			if(!IsValid(v[3])) then

				v[3] = ents.Create("prop_dynamic")
					v[3]:SetModel("models/items/ar2_grenade.mdl")
					v[3]:Spawn()

					v[3]:SetModelScale(3, 0)
					v[3]:SetPos(v[7])
					v[3]:SetAngles(Angle(90,0,0))

					if(IsValid(v[3])) then
						util.SpriteTrail( v[3], 0, Color( 255, 255, 255 ), false, 30, 1, 0.2, 0, "trails/plasma" )
					end

			end

			v[4] = true
		end

		if(v[1] < CurTime()) then

			if(IsValid(v[3])) then

				if(IsValid(v[2])) then

					local vPos = v[2]:GetPos()
					v[8] = vPos
					v[3]:SetPos(Vector(vPos.x, vPos.y, v[3]:GetPos().z))
				end

				v[3]:SetPos(v[3]:GetPos() - Vector(0,0,32))

				local dst = v[3]:GetPos():Distance(v[8])

				if(dst < 256) then

				local effectdata = EffectData()
					effectdata:SetOrigin( v[8] )
					effectdata:SetMagnitude(64)
					effectdata:SetScale(128)
					effectdata:SetFlags(5)
					util.Effect( "Explosion", effectdata )

					sound.Play( "ambient/explosions/explode_"..math.random(1, 5)..".wav", v[8], 80, 100, 1)

					for x,y in pairs(ents.FindByClass("npc_*")) do
						
						if(!IsValid(y)) then continue end
						if(y:Health() <= 0) then continue end
						if(IsTurret(y)) then continue end
						if(y:GetPos():Distance(v[8]) > 180) then continue end

						local dInfo = DamageInfo()
							dInfo:SetDamage(math.random(80, 130))
							dInfo:SetAttacker(v[6])
							dInfo:SetInflictor(v[6])
							dInfo:SetDamagePosition(y:GetPos())
							dInfo:SetDamageType(64) 

							y:TakeDamageInfo(dInfo)

					end

					if(IsValid(v[3])) then
						v[3]:Remove()
					end

					table.remove(AttackTable, k)

				end

			end

		end

	end

	for k,v in next, AttackTable do

		if(v[5] < CurTime()) then
			table.remove(AttackTable, k)
			if(IsValid(v[3])) then
				v[3]:Remove()
			end
		end

		if(!v[4]) then

			if(!IsValid(v[3])) then

				v[3] = ents.Create("prop_dynamic")
					v[3]:SetModel("models/items/ar2_grenade.mdl")
					v[3]:Spawn()

					v[3]:SetModelScale(3, 0)
					v[3]:SetPos(v[7])
					v[3]:SetAngles(Angle(90,0,0))

					if(IsValid(v[3])) then
						util.SpriteTrail( v[3], 0, Color( 255, 255, 255 ), false, 30, 2, 0.2, 0, "trails/plasma" )
					end

			end

			v[4] = true
		end

		if(v[1] < CurTime()) then

			if(IsValid(v[3])) then

				if(IsValid(v[2])) then

					local vPos = v[2]:GetPos()
					v[8] = vPos
					v[3]:SetPos(Vector(vPos.x, vPos.y, v[3]:GetPos().z))
				end

				v[3]:SetPos(v[3]:GetPos() - Vector(0,0,32))

				local dst = v[3]:GetPos():Distance(v[8])

				if(dst < 256) then

				local effectdata = EffectData()
					effectdata:SetOrigin( v[8] )
					effectdata:SetMagnitude(64)
					effectdata:SetScale(128)
					effectdata:SetFlags(5)
					util.Effect( "Explosion", effectdata )

					sound.Play( "ambient/explosions/explode_1.wav", v[8], 100, 100, 1)

					for x,y in pairs(ents.FindByClass("npc_*")) do
						
						if(!IsValid(y)) then continue end
						if(y:Health() <= 0) then continue end
						if(IsTurret(y)) then continue end
						if(y:GetPos():Distance(v[8]) > 155) then continue end

						local dInfo = DamageInfo()
							dInfo:SetDamage(math.random(55, 85))
							dInfo:SetAttacker(v[6])
							dInfo:SetInflictor(v[6])
							dInfo:SetDamagePosition(y:GetPos())
							dInfo:SetDamageType(64) 

							y:TakeDamageInfo(dInfo)

					end

					if(IsValid(v[3])) then
						v[3]:Remove()
					end

					table.remove(AttackTable, k)

				end

			end

		end

	end

	for k,v in next, PlayerCloakTable do
		if(!IsValid(v[1])) then
			table.remove(PlayerCloakTable, k)
		end
		if(v[5]) then
			v[1]:SetRenderMode( RENDERMODE_TRANSCOLOR )
			sound.Play( "shigure/cloak.mp3", v[1]:GetPos(), 130, 100, 1)
			v[5] = false
			v[6] = 255
			v[1]:AddFlags(65536)
		end
		if(v[2] < CurTime()) then
			for x,idx in next, PlayerDataTable do
				if(idx[17] != v[1]) then continue end
				idx[40] = false
			end
			v[1]:SetColor(Color(255, 255, 255, 255))
			v[1]:RemoveFlags(65536)
			table.remove(PlayerCloakTable, k)
		else
			v[6] = math.Clamp(v[6] - 15, 30, 255)
			v[1]:SetColor(Color(255, 255, 255, v[6]))
		end
		if(v[1]:KeyDown(IN_ATTACK)) then
			if(!v[3]) then -- Give server some time to process damage
				v[4] = CurTime() + 0.22
				v[3] = true
			end
		end
		if(v[3]) then
			if(v[4] < CurTime()) then
				for x,idx in next, PlayerDataTable do
					if(idx[17] != v[1]) then continue end
					idx[40] = false
				end
				table.remove(PlayerCloakTable, k)
				v[1]:SetColor(Color(255, 255, 255, 255))
				v[1]:RemoveFlags(65536)
			end
		end
	end

	for k, v in next, SpawnTable do

		if(!v[1]:IsValid()) then
			table.remove(SpawnTable, k)
		end

		if(v[1]:Alive()) then
			table.remove(SpawnTable, k)
		end

		if(v[2] < CurTime()) then
			v[1]:Spawn()
			if(CurSpawnPos != 0) then
				v[1]:SetPos(GetSpawnPos())
			end
			table.remove(SpawnTable, k)
		end
	end

	for k,v in pairs(player.GetAll()) do
		if(!IsValid(v)) then continue end
		if(v:IsBot()) then continue end
		if(!v:Alive()) then continue end

		if(!v:HasWeapon("arccw_horde_crowbar")) then
			v:Give("arccw_horde_crowbar")
		end

	end

	for k,v in pairs(ents.FindByClass("arccw_horde_crowbar")) do if(!IsValid(v)) then continue end if(!IsValid(v:GetOwner())) then v:Remove() end end

	if(!RescueStarted) then
		SpawnInterval = 11.77 - math.Clamp((math.Round(GlobalDay * (0.535 + (player.GetCount() * 0.015) + (HordeDiff * 0.185)), 10)), 0.8 / player.GetCount(), 10.77)
	else
		SpawnInterval = math.Clamp(0.5 - (player.GetCount() * 0.1), 0.15, 1)
	end
	SpawnAmout = 1

	if(!Started) then
		local StartDayTime = 300
		if(GetConVar("horde_zshelter_custom_day_time"):GetInt() != 0) then
			StartDayTime = GetConVar("horde_zshelter_custom_day_time"):GetInt()
		end
		GlobalTime = StartDayTime
		if(GameStarted() && HORDE.current_break_time <= 0) then

			if(CheckMapEntities()) then
				for k,v in pairs(ents.GetAll()) do  if(v:IsWeapon()) then v:Remove() end end
				local startpos = util.QuickTrace( GetShelterCenter() + Vector(0, 0, 10), Vector(0,0,-128), COLLISION_GROUP_DEBRIS).HitPos
				for x,y in pairs(player.GetAll()) do if(!IsValid(y)) then continue end table.insert(PlayerStartTable, {y, Vector(startpos  + Vector(math.random(-90, 90), math.random(-90, 90),0))})  end 

				for k, idx in next, PlayerDataTable do
					idx[20] = GetConVar("horde_zshelter_custom_starting_skillpoints"):GetInt()
				end

				if(GetConVar("horde_zshelter_custom_starting_wood"):GetInt() != 0) then
					GlobalWood = math.Clamp(GetConVar("horde_zshelter_custom_starting_wood"):GetInt(), 0, GlobalWoodLimit)
				end

				if(GetConVar("horde_zshelter_custom_starting_iron"):GetInt() != 0) then
					GlobalIron = math.Clamp(GetConVar("horde_zshelter_custom_starting_iron"):GetInt(), 0, GlobalIronLimit)
				end

				SetupTreasureArea()

				ShouldEnableAI = false
				StartTimer = CurTime() + 8
				net.Start("StartNotify")
				net.Broadcast()
				CEnemyToList()
				Started = true
			else
				if(MapEntitiesWarnInterval < CurTime()) then
					PrintMessage( HUD_PRINTTALK, "Map entity missing!, please contact map creator!")
					MapEntitiesWarnInterval = CurTime() + 8
				end
			end
		end
	end

	if(StartTimer > CurTime()) then
		for k,v in next, PlayerStartTable do
			if(!IsValid(v[1])) then
				table.remove(PlayerStartTable, k)
			end

			v[1]:SetPos(v[2])
			v[1]:SetVelocity(v[1]:GetVelocity() * -1)
		end
		ShouldNotify = true
	else
		for k,v in next, PlayerStartTable do
			table.remove(PlayerStartTable, k)
		end
		if(!GoalNotifyed && ShouldNotify) then
			net.Start("GoalNotify")
			net.WriteString( "Goal : Survive to 30 Day, or call the rescue on 15 Day" )
			net.Broadcast()
			GoalNotifyed = true
		end
	end

	if(!NightOrDay) then
		SpawnTicker = 0
		NPCChaseTimer = 0
		ZombieAttackTicker = 0
	end

	if(!RescueStarted) then
		if(GetConVar("horde_zshelter_custom_max_enemies"):GetInt() == 0) then
			MaxCount = math.floor(5 + ((GlobalDay * 2.5) + (player.GetCount() * 4))) + (HordeDiff * 13)
		else
			MaxCount = GetConVar("horde_zshelter_custom_max_enemies"):GetInt()
		end
	else

		if(GlobalTime <= 1) then
			if(!Victory) then

					local Helicopter = ents.Create("npc_helicopter")
						Helicopter:SetModel("models/props_vehicles/tanker001a.mdl")
						Helicopter:SetPos(GetChasePos() - Vector(0, 0, 128))
						Helicopter:SetAngles(Angle(0, 0, 0))
						Helicopter:Spawn()

						for x,y in pairs(player.GetAll()) do

							if(!IsValid(y)) then continue end
						y:Horde_SetExp(y:Horde_GetCurrentSubclass(), y:Horde_GetExp(y:Horde_GetCurrentSubclass()) + 500)

						y:Say("!rtv")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
						end

						BroadcastLua("  sound.PlayFile( 'sound/music/HL2_song23_SuitSong3.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end) ")

				RescueStarted = false
				Victory = true
			end
		end

		if(GetConVar("horde_zshelter_custom_max_enemies"):GetInt() == 0) then
			MaxCount = 50
		else
			MaxCount = GetConVar("horde_zshelter_custom_max_enemies"):GetInt()
		end

		if(Res_SpawnInterval < CurTime()) then

			SpawnEnemies()

			Res_SpawnInterval = CurTime() + 0.2

		end

	end

	if(SpawnTicker < CurTime() && NightOrDay) then

		SpawnEnemies()

		SpawnTicker = CurTime() + SpawnInterval + 0.1
	end

	if(TickTicker < CurTime()) then

		HordeDiff = GetConVar("horde_difficulty"):GetInt() -- Update once per sec
		local ExtraPower = 0

		if(GetConVar("horde_zshelter_debug_infinite_power"):GetInt() == 1) then
			ExtraPower = 99999
		end

		Eletronic = math.Clamp(CalcTotalPower() - GetPowerCost(), 0, 32767) + ExtraPower

		GlobalTime = GlobalTime - 1
		TickTicker = CurTime() + 1
	end

	if(NightOrDay) then ShouldEnableAI = true end

	if(GlobalTime <= 0) then -- L
		if(!NightOrDay) then
			CacheEnemySpawn()
			for k,v in pairs(ents.FindByClass("npc*")) do
				if(!IsValid(v)) then continue end
				if(IsTurret(v)) then continue end
				v:TakeDamage(8000)
			end
			ShouldEnableAI = true
			net.Start("NightNotify")
			net.Broadcast()
			if(GetConVar("horde_zshelter_custom_night_time"):GetInt() == 0) then
				GlobalTime = 90 + (HordeDiff * 8)
			else
				GlobalTime = GetConVar("horde_zshelter_custom_night_time"):GetInt()
			end
			if(GetConVar("horde_zshelter_hardcore_mode"):GetInt() == 1) then
				GlobalTime = GlobalTime * 1.5
			end
			NightOrDay = true
		else
			ResetResource()
			CEnemyToList()
			CacheEnemySpawn()
			SetupTreasureArea()
			local DayString = "Day "..tostring(GlobalDay + 1)..""
			net.Start("GoalNotify")
			net.WriteString(DayString)
			net.Broadcast()

			for k, idx in next, PlayerDataTable do
				idx[20] = idx[20] + 1
			end

			if(GlobalDay >= 25) then
				if(GetTele()) then
						for x,y in pairs(player.GetAll()) do

							if(!IsValid(y)) then continue end
						y:Horde_SetExp(y:Horde_GetCurrentSubclass(), y:Horde_GetExp(y:Horde_GetCurrentSubclass()) + 500)

						y:Say("!rtv")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
							PrintMessage( HUD_PRINTTALK, " ")
						end

						BroadcastLua("  sound.PlayFile( 'sound/music/HL2_song23_SuitSong3.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end) ")
				end
			end
			ShouldEnableAI = false
			GlobalDay = GlobalDay + 1
			if(GetConVar("horde_zshelter_custom_day_time"):GetInt() == 0) then
				GlobalTime = 240 - (HordeDiff * 15)
			else
				GlobalTime = GetConVar("horde_zshelter_custom_day_time"):GetInt()
			end
			if(GetConVar("horde_zshelter_hardcore_mode"):GetInt() == 1) then
				GlobalTime = GlobalTime * 0.8
			end
			NightOrDay = false
		end
	end

	if(CheckBuildStateTimer < CurTime()) then

		for k,v in next, DeathPackpackTable do

			if(!IsValid(v[3])) then
				table.remove(DeathPackpackTable, k)
			end

			for x, y in pairs(player.GetAll()) do

				if(!IsValid(y)) then continue end
				if(!y:Alive()) then continue end
				if(y:GetPos():Distance(v[5]) > 64) then continue end

				for _, idx in next, PlayerDataTable do

					if(y == idx[17]) then

						idx[2] = math.Clamp(idx[2] + v[1], 0, idx[4])
						idx[3] = math.Clamp(idx[3] + v[2], 0, idx[5])

						PrintMessage( HUD_PRINTTALK, ""..y:Nick().." Just picked up "..v[1].." woods and "..v[2].." irons")

					end

					table.remove(DeathPackpackTable, k)

				end

				if(IsValid(v[3])) then
					v[3]:Remove()
				end

			end

		end

		for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do

			if(!IsValid(v)) then continue end

			if(!IsResource(v)) then
				v:SetCollisionGroup(0)
			end

			if(v:GetColor().a == 255) then continue end

			if(v:Health() >= v:GetMaxHealth()) then

				sound.Play( "shigure/BuildC.mp3", v:GetPos(), 150, 100, 1)

				local vColor = v:GetColor()

				v:SetColor(Color(vColor.r,vColor.g,vColor.b,255))

			end

		end

		CheckBuildStateTimer = CurTime() + 0.1
	end

	if(ResourceSpawnTimer < CurTime() && GetResourceCount() < 60 && Started) then

		ResourceManager(13 + (player.GetCount() * 2))

		if(MaterialsSpawnTimer < CurTime()) then

			if(GlobalDay > 5) then
				SpawnMaterials(1)
			end

			MaterialsSpawnTimer = CurTime() + 800
		end

		ResourceSpawnTimer = CurTime() + 30
	end

	--->>>>>>>>>>>>>>>>>> End of sub functions

	--->>>>>>>>>>>>>>>>>> Networking

	net.Receive("SyncItems", function(len, ply)
		if(IsValid(ply)) then
			SyncShelterItems()
		end
	end)

	net.Receive("SyncEnemys", function(len, ply)
		if(IsValid(ply)) then
			SyncShelterEnemies()
		end
	end)

	net.Receive("BuildNetworking", function(len, ply)
		if(IsValid(ply)) then
			local Type = net.ReadInt(6)
			local Unk = net.ReadInt(32)
			local ReqWood = net.ReadInt(10)
			local ReqIron = net.ReadInt(10)
			local ReqPower = net.ReadInt(32)
			local BuildReq = net.ReadInt(3)

			print(ReqWood, ReqIron, ReqPower, BuildReq, Type, Unk)

			if(ReqPower == nil) then
				ReqPower = 0
			end

			if(BuildReq == nil || BuildReq <= -1) then
				BuildReq = 0
			end

			if (DoCheckResources(ply, ReqWood, ReqIron, Type) && Eletronic >= ReqPower && GetPublicBuildingReq(BuildReq)) then

				local Model = GetModelType(Type, Unk)

				net.Start("CloseMenu") net.Send(ply)

				local BuildingHPS = 1

				for k, idx in next, PlayerDataTable do
					if(idx[1] == ply:SteamID()) then
						BuildingHPS = idx[13]
						TurretUpgrade = idx[15]
					end
				end

				local XPosCheck_A = 0 --Unused
				local XPosCheck_B = 0
				local YPosCheck_A = 0
				local YPosCheck_B = 0

				table.insert(PlayerBuildTable, {ply, Model, NULL, 0, Type, Unk, ReqWood, ReqIron, 0, BuildingHPS, TurretUpgrade, XPosCheck_A, XPosCheck_B, YPosCheck_A, YPosCheck_B, false, Vector(0,0,0)})

			else

				HORDE:SendNotification("Requirement(s) not meet.", 1, ply)

			end

		end
	end)

	net.Receive("SkillTreeNetworking", function(len, ply)

		if(IsValid(ply)) then

			local Type = net.ReadInt(6)
			local SubType = net.ReadInt(8)

			for k, idx in next, PlayerDataTable do

				if(idx[1] == ply:SteamID()) then

					if(idx[20] >= 1) then

						if(Type == 1) then

							if(SubType == 1) then idx[14] = idx[14] + 0.7 idx[21] = idx[21] + 1 end
							if(SubType == 2) then idx[16] = 1 end
							if(SubType == 3) then idx[22] = 1 end
							if(SubType == 4) then idx[23] = idx[23] + 1 end
							if(SubType == 5) then idx[24] = 1 end
							if(SubType == 6) then idx[26] = idx[26] + 1 idx[6] = idx[6] + 1 end
							if(SubType == 7) then idx[25] = idx[25] + 1 idx[7] = idx[7] + 1 end
							if(SubType == 8) then idx[19] = idx[19] + 1 end
							if(SubType == 9) then idx[8] = 1 end
							if(SubType == 10) then idx[27] = idx[27] + 1 idx[9] = idx[9] + 1.25 end
							if(SubType == 11) then idx[28] = idx[28] + 1 idx[13] = idx[13] + 1.2 end
							if(SubType == 12) then idx[29] = idx[29] + 1 idx[15] = idx[15] + 0.5 end
							if(SubType == 13) then idx[30] = idx[30] + 1 end
							if(SubType == 14) then idx[31] = idx[31] + 1 idx[18] = 1 end
							if(SubType == 15) then idx[32] = idx[32] + 1 end
							if(SubType == 16) then idx[11] = 1 end
							if(SubType == 17) then idx[34] = 1 end
							if(SubType == 18) then idx[35] = idx[35] + 1 end
							if(SubType == 19) then idx[36] = idx[36] + 1 end
							if(SubType == 20) then idx[37] = idx[37] + 1 end
							if(SubType == 21) then idx[38] = 1 end
							if(SubType == 22) then idx[39] = 1 end

						end

						net.Start("CloseMenu") net.Send(ply)

						if(Type != 0 && SubType != 0) then -- Prevent point being used when syncing data on script loaded
							idx[20] = math.Clamp(idx[20] - 1, 0, 128)
						end

					else

						HORDE:SendNotification("No Points Remain.", 1, ply)

					end

					net.Start("SyncSkill")
					net.WriteInt(idx[21], 8)
					net.WriteInt(idx[16], 8)
					net.WriteInt(idx[22], 8)
					net.WriteInt(idx[23], 8)
					net.WriteInt(idx[24], 8)
					net.WriteInt(idx[25], 8)
					net.WriteInt(idx[26], 8)
					net.WriteInt(idx[8], 8)
					net.WriteInt(idx[19], 8)
					net.WriteInt(idx[27], 8)
					net.WriteInt(idx[28], 8)
					net.WriteInt(idx[29], 8)
					net.WriteInt(idx[30], 8)
					net.WriteInt(idx[31], 8)
					net.WriteInt(idx[32], 8)
					net.WriteInt(idx[11], 8)
					net.WriteInt(idx[34], 8)
					net.WriteInt(idx[35], 8)
					net.WriteInt(idx[36], 8)
					net.WriteInt(idx[37], 8)
					net.WriteInt(idx[38], 8)
					net.WriteInt(idx[39], 8)
					net.Send(ply)

				end

			end

		end

	end)

	net.Receive("WorkStationNetWorking", function(len, ply)
		if(IsValid(ply)) then
			local Type = net.ReadInt(6)
			local Unk = net.ReadInt(32)
			local ReqWood = net.ReadInt(10)
			local ReqIron = net.ReadInt(10)
			local ReqPower = net.ReadInt(32)
			local BuildReq = net.ReadInt(3)

			print(Type, Unk, ReqWood, ReqIron, ReqPower, BuildReq)

			if(ReqPower == nil) then
				ReqPower = 0
			end
			if(BuildReq == nil || BuildReq == -1) then
				BuildReq = 0
			end

			if (DoCheckResources(ply, ReqWood, ReqIron, Type) && Eletronic >= ReqPower && GetPublicBuildingReq(BuildReq)) then

				print(DoCheckResources())

				net.Start("CloseMenu") net.Send(ply)

				for k, idx in next, PlayerDataTable do

					if(idx[1] == ply:SteamID()) then

						if(Type == 7) then
							if(Unk == 1) then idx[11] = 1 end
							if(Unk == 2) then idx[14] = 1 end
							if(Unk == 3) then idx[16] = 1 end
							if(Unk == 4) then idx[18] = 1 end

							idx[10] = 0
						end

						if(Type == 5) then
							if(Unk == 1) then idx[6] = idx[6]  + 1 end
							if(Unk == 2) then idx[7] = idx[7]  + 1 end
							if(Unk == 3) then idx[8] = 1 end
							if(Unk == 6) then for _, wep in ipairs( ply:GetWeapons() ) do if(!IsValid(wep)) then continue end ply:SetAmmo(ply:GetAmmoCount(wep:GetPrimaryAmmoType()) + wep:GetMaxClip1() * 3, wep:GetPrimaryAmmoType()) end end
							if(Unk == 7) then idx[9] = idx[9] + 0.5 end
							if(Unk == 8) then idx[17]:SetArmor(math.Clamp(idx[17]:Armor() + 15, 0, 100)) end
							if(Unk == 9) then idx[17]:SetArmor(100) end
							if(Unk == 10) then idx[13] = idx[13] + 0.5 end
							if(Unk == 12) then idx[15] = idx[15] + 0.25 end
							if(Unk == 13) then idx[19] = idx[19] + 0.5 end

							GiveGunFromTable(ply, Unk)

						end

						if(Type == 3 && Unk == 36) then for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do if(!IsValid(v)) then continue end if(!IsBase(v)) then continue end v:SetMaxHealth(v:GetMaxHealth() + 475) end end
						if(Type == 3 && Unk == 37) then
							for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
								if(!IsValid(v)) then continue end
								if(!IsBase(v)) then continue end

								local NewBase = ents.Create("prop_physics_multiplayer")
								NewBase:SetModel("models/shigure/shelter_b_shelter03.mdl")
								NewBase:SetPos(v:GetPos())

								NewBase:Spawn()

								NewBase:SetAngles(v:GetAngles())
								NewBase:SetMaxHealth(v:GetMaxHealth() * 1.5)
								NewBase:SetHealth(v:Health())
								NewBase:SetColor(Color(255, 255, 255, 180))
								NewBase:SetRenderMode( RENDERMODE_TRANSCOLOR )

								local Phys = NewBase:GetPhysicsObject()

								if(IsValid(Phys)) then
									Phys:EnableMotion(false)
								end

								v:Remove()
							end
						end

						if(Type == 3 && Unk == 38) then
							for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
								if(!IsValid(v)) then continue end
								if(!IsBase(v)) then continue end

								local NewBase = ents.Create("prop_physics_multiplayer")
								NewBase:SetModel("models/shigure/shelter_b_shelter04.mdl")
								NewBase:SetPos(v:GetPos())

								NewBase:Spawn()

								NewBase:SetAngles(v:GetAngles())
								NewBase:SetMaxHealth(v:GetMaxHealth() * 1.5)
								NewBase:SetHealth(v:Health())
								NewBase:SetColor(Color(255, 255, 255, 180))
								NewBase:SetRenderMode( RENDERMODE_TRANSCOLOR )

								local Phys = NewBase:GetPhysicsObject()

								if(IsValid(Phys)) then
									Phys:EnableMotion(false)
								end

								v:Remove()
							end
						end

						if(Type == 3 && Unk == 39) then
							for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
								if(!IsValid(v)) then continue end
								if(!IsBase(v)) then continue end

								local NewBase = ents.Create("prop_physics_multiplayer")
								NewBase:SetModel("models/shigure/shelter_b_shelter05.mdl")
								NewBase:SetPos(v:GetPos())

								NewBase:Spawn()

								NewBase:SetAngles(v:GetAngles())
								NewBase:SetMaxHealth(v:GetMaxHealth() * 1.5)
								NewBase:SetHealth(v:Health())
								NewBase:SetColor(Color(255, 255, 255, 180))
								NewBase:SetRenderMode( RENDERMODE_TRANSCOLOR )

								local Phys = NewBase:GetPhysicsObject()

								if(IsValid(Phys)) then
									Phys:EnableMotion(false)
								end

								v:Remove()
							end
						end

							if(Type == 3 && Unk == 40) then

								for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
									if(!IsBase(v)) then continue end
									local vMin, vMax = v:GetModelBounds()
									local SizeX = (math.floor(math.abs(vMin.x) + math.abs(vMax.x)) / 2) * -1
									local SizeZ = vMax.z - 5
									local AngleForward = Angle(0, v:GetAngles().y ,0):Forward() * SizeX
									local AngleSide = Angle(0, v:GetAngles().y + 90 ,0):Forward() * 20

									local Turret = NULL
									if(ShelterTurret == 0) then
										Turret = ents.Create("npc_vj_hlr1_cturret_mini")
									else
										for k,v in pairs(ents.FindByClass("npc_vj_hlr1_cturret_mini")) do if(!IsValid(v)) then continue end v:Remove() end
										Turret = ents.Create("npc_vj_hlr1_cturret")
									end
										Turret:SetMaxHealth(65536)
										Turret:SetHealth(65536)

										Turret:SetPos(v:GetPos() + Vector(AngleForward.x, AngleForward.y, v:GetPos().z) + AngleSide)

									Turret:Spawn()
								end
								ShelterTurret = ShelterTurret + 1
							end

						if(Unk < 35) then
							if(idx[2] >= ReqWood && idx[3] >= ReqIron) then
								idx[2] = math.Clamp(idx[2] - ReqWood, 0, idx[4])
								idx[3] = math.Clamp(idx[3] - ReqIron, 0, idx[5])
							else
								GlobalWood = math.Clamp(GlobalWood - ReqWood, 0, GlobalWoodLimit)
								GlobalIron = math.Clamp(GlobalIron - ReqIron, 0, GlobalIronLimit)
							end
						else
							GlobalWood = math.Clamp(GlobalWood - ReqWood, 0, GlobalWoodLimit)
							GlobalIron = math.Clamp(GlobalIron - ReqIron, 0, GlobalIronLimit)
						end

					end

				end

			else

				HORDE:SendNotification("Requirement(s) not meet.", 1, ply)

			end

		end
	end)

	net.Receive("SanityHurt", function(len, ply)
		if(IsValid(ply)) then
			if(GetConVar("horde_zshelter_disable_sanity"):GetInt() == 0) then
				ply:TakeDamage(2, NULL)
			end
		end
	end)

	net.Receive("SyncData", function(len, ply)

		if(IsValid(ply)) then

			net.Start("SyncDataReturn")
				for k,idx in next, PlayerDataTable do
					if(idx[1] == ply:SteamID()) then

						idx[4] = 12 + math.floor(( 12 *idx[6]) / 2.5) - math.floor(idx[32] * 1.3)
						idx[5] = 10 + math.floor(( 10 *idx[6]) / 2.5) - math.floor(idx[32])


						net.WriteInt(idx[2], 16)
						net.WriteInt(idx[3], 16) 
						net.WriteInt(idx[4], 16)
						net.WriteInt(idx[5], 16)
						net.WriteInt(GlobalWood, 16)
						net.WriteInt(GlobalIron, 16) 
						net.WriteInt(GlobalWoodLimit, 16)
						net.WriteInt(GlobalIronLimit, 16)
						net.WriteInt(Eletronic, 32)
						net.WriteInt(GlobalTime, 32)
						net.WriteInt(GlobalDay, 32)
						net.WriteBool(NightOrDay)
						net.WriteInt(StartTimer, 32)
						net.WriteInt(idx[7], 32)
						net.WriteInt(idx[10], 4)
						net.WriteFloat(idx[9])
						net.WriteFloat(idx[13])
						net.WriteFloat(idx[15])
						net.WriteFloat(idx[19])
						net.WriteInt(idx[20], 8)
						net.WriteBool(RescueStarted)
						net.WriteInt(ShelterTurret, 8)
						net.WriteBool(idx[40])

					end
				end
			net.Send(ply)

		end

	net.Receive("TransferStorage", function(len, ply)

		local Take = net.ReadInt(8) -- Take or put
		local Type = net.ReadInt(8) -- Wood or iron
		local Amout = net.ReadInt(8) -- amout

		if(IsValid(ply)) then

			for k,idx in next, PlayerDataTable do

				if(idx[1] == ply:SteamID()) then

					if(Take == 1) then -- if take

						if(Type == 1) then -- if wood

							if(GlobalWood > 0 && GlobalWood >= Amout && idx[2] + Amout <= idx[4]) then

								idx[2] = math.Clamp(idx[2] + Amout, 0, idx[4])

								GlobalWood = math.Clamp(GlobalWood - Amout, 0, GlobalWoodLimit)

							else

								if(GlobalWood > 0) then

									if(idx[4] - idx[2] > 0) then

										local Amount_ = idx[4] - idx[2]

										if(GlobalWood >= Amount_) then

											idx[2] = math.Clamp(idx[2] + Amount_, 0, idx[4])

											GlobalWood = math.Clamp(GlobalWood - Amount_, 0, GlobalWoodLimit)

										else

											idx[2] = math.Clamp(idx[2] + GlobalWood, 0, idx[4])

											GlobalWood = 0

										end

									end

								end

							end

						else -- if iron

							if(GlobalIron > 0 && GlobalIron >= Amout && idx[3] + Amout <= idx[5]) then

								idx[3] = math.Clamp(idx[3] + Amout, 0, idx[5])

								GlobalIron = math.Clamp(GlobalIron - Amout, 0, GlobalIronLimit)

							else

								if(GlobalIron > 0) then

									if(idx[5] - idx[3] > 0) then

										local Amount_ = idx[5] - idx[3]

										if(GlobalIron >= Amount_) then

											idx[3] = math.Clamp(idx[3] + Amount_, 0, idx[5])

											GlobalIron = math.Clamp(GlobalIron - Amount_, 0, GlobalIronLimit)

										else

											idx[3] = math.Clamp(idx[3] + GlobalIron, 0, idx[5])

											GlobalIron = 0

										end

									end

								end

							end

						end

					else -- if put

						local WMaxDiff = GlobalWoodLimit - GlobalWood
						local IMaxDiff = GlobalIronLimit - GlobalIron

						if(Type == 1) then -- if wood

							if(idx[2] >= Amout && WMaxDiff >= Amout) then

								idx[2] = math.Clamp(idx[2] - Amout, 0, idx[4])

								GlobalWood = math.Clamp(GlobalWood + Amout, 0, GlobalWoodLimit)

							else

								if(idx[2] > 0) then

									if(GlobalWoodLimit - GlobalWood > 0) then

										local Amount_ = GlobalWoodLimit - GlobalWood

										if(idx[2] >= Amount_) then

											idx[2] = math.Clamp(idx[2] - Amount_, 0, idx[4])

											GlobalWood = math.Clamp(GlobalWood + Amount_, 0, GlobalWoodLimit)

										else

											GlobalWood = math.Clamp(GlobalWood + idx[2], 0, GlobalWoodLimit)

											idx[2] = 0

										end

									end

								end

							end

						else -- if iron

							if(idx[3] >= Amout && IMaxDiff >= Amout) then

								idx[3] = math.Clamp(idx[3] - Amout, 0, idx[5])

								GlobalIron = math.Clamp(GlobalIron + Amout, 0, GlobalIronLimit)

							else

								if(idx[3] > 0) then

									if(GlobalIronLimit - GlobalIron > 0) then

										local Amount_ = GlobalIronLimit - GlobalIron

										if(idx[3] >= Amount_) then

											idx[3] = math.Clamp(idx[3] - Amount_, 0, idx[5])

											GlobalIron = math.Clamp(GlobalIron + Amount_, 0, GlobalIronLimit)

										else

											GlobalIron = math.Clamp(GlobalIron + idx[3], 0, GlobalIronLimit)

											idx[3] = 0

										end

									end

								end

							end

						end

					end

				end

			end

		end

	end)

	end)

	--->>>>>>>>>>>>>>>>>> End of Networking


	--->>>>>>>>>>>>>>>>>> Start of player data table check

	if(PlayerCheckTimer < CurTime()) then

		for k,v in pairs(player.GetAll()) do

			if(!IsValid(v)) then continue end

			ShouldAddTable(v)

		end

		PlayerCheckTimer = CurTime() + 0.2

	end

	--->>>>>>>>>>>>>>>>>> End of player data table check

end)
end

function AddHook10()

hook.Add("Move", "MoveHandler", function(ply, mv)
	if(IsValid(ply)) then
		local Boost = 0
		for k,v in next, PlayerCloakTable do
			if(v[1] == ply) then
				Boost = 100
			end
		end
		ply:SetWalkSpeed(270 + Boost)
		ply:SetRunSpeed(270 + Boost)
		ply:SetJumpPower(150)
	end
end)

hook.Add("OnNPCKilled", "NKilledHandler", function(npc, attacker, inflictor)
	if(IsValid(npc) && IsValid(attacker)) then
		if(attacker:IsPlayer()) then
			for k, idx in next, PlayerDataTable do

				local RandNum = math.random(1, 100)

				if(attacker:SteamID() == idx[1]) then

					if(idx[22] == 1) then

						attacker:SetHealth(math.Clamp(attacker:Health() + (attacker:GetMaxHealth() * 0.03), 0, attacker:GetMaxHealth()))

					end

					if(idx[24] == 1) then

						attacker:SetArmor(math.Clamp(attacker:Armor() + 4, 0, attacker:GetMaxArmor()))

					end

					if(RandNum <= (idx[36] * 10)) then

						ResourceManager_Looting(npc:GetPos())

					end

				end

			end
		end
	end
end)
end

function AddHook9()
hook.Add( "PlayerUse", "UseHandler", function( ply, ent )
	if(IsValid(ply) && IsValid(ent)) then
		if(ent:GetColor().a == 255) then
			if(ent:GetModel() == "models/nickmaps/rostok/p20_tank_pumps.mdl" || ent:GetModel() == "models/nickmaps/rostok/p19_casa2.mdl" || ent:GetModel() == "models/items/ammocrate_ar2.mdl"  || ent:GetModel() == "models/shigure/shelter_b_warehouse01.mdl") then
				net.Start("OpenStorage")
				net.Send(ply)
			end
			if(ent:GetModel() == "models/props_lab/workspace004.mdl") then
				net.Start("OpenWorkStation")
				net.Send(ply)
			end
			if(ent:GetModel() == "models/z-o-m-b-i-e/st/vishka/st_vishka_broken_01_1.mdl") then
				if(Vector(0, ply:GetPos().z, 0):Distance(Vector(0, ent:GetPos().z, 0)) < 250) then
					ply:SetPos(ent:GetPos() + Vector(0,0,600))
				else
					ply:SetPos(ent:GetPos() + Vector(0,0,15))
				end
			end
			if(ent:GetModel() == "models/props_lab/blastdoor001c.mdl") then
				for k,v in next, DoorTable do
					if(v[1] == ent) then
						v[2] = CurTime() + 3
					end
				end
			end
		end
		if(ent:GetModel() == "models/shigure/shelter_b_antenna01.mdl") then
			for k ,idx in next, PlayerDataTable do

				if(idx[17] == ply) then

					if(!idx[33]) then

						if(GlobalDay >= 15) then

						HelpSent = HelpSent + 1

						local string_ = ""..ply:Nick().." Called for rescue!          "..HelpSent.." / "..player.GetCount()..""

						net.Start("GoalNotify")
						net.WriteString( string_ )
						net.Broadcast()

						idx[33] = true

					else

						net.Start("GoalNotify")
						net.WriteString( "Tele tower only works after Day 15" )
						net.Send(ply)

						end

						
					end

				end

			end
		end
	end
end )
end

function AddHook8()
hook.Add( "PlayerSay", "SayHandler", function( ply, text ) -- Used for debugging
	if(!ply:IsAdmin()) then return end
	if ( string.lower( text ) == "/giveres" ) then
		GlobalWood = GlobalWoodLimit
		GlobalIron = GlobalIronLimit
		for k,idx in next, PlayerDataTable do

				idx[2] = idx[4]
				idx[3] = idx[5]
				idx[10] = 1

		end
	end
	if ( string.lower( text ) == "/spawnres" ) then
		ResourceManager(30)
	end
end)
end

function AddHook7()
hook.Add( "DoPlayerDeath", "DeathHandler", function( victim, inflictor, attacker )

		HandlePlayerRespawn(victim)

		for k, idx in next, PlayerDataTable do

			if(idx[1] == victim:SteamID()) then

				if(idx[2] != 0 || idx[3] != 0) then

					table.insert(DeathPackpackTable, {idx[2], idx[3], NULL, false, util.QuickTrace( victim:GetPos(), Vector(0,0,-512), COLLISION_GROUP_DEBRIS).HitPos, idx[17]:EyeAngles().y})

					idx[2] = 0
					idx[3] = 0

				end

			end

		end

		for k,v in next, DeathPackpackTable do

			if(!v[4]) then

				if(!IsValid(v[3])) then

					v[3] = ents.Create("prop_dynamic")
					v[3]:SetModel("models/galaxy/rust/backpack.mdl")

					v[3]:SetPos(v[5])
					v[3]:SetAngles(Angle(0, v[6], 0))

				end

				v[4] = true
			end

		end

end)
end

function AddHook6()
hook.Add( "OnNPCKilled", "NPCKillHandler", function( npc, attacker, inflictor )
	if(IsValid(npc) && IsValid(attacker)) then

		if(attacker:IsPlayer()) then

			attacker:Horde_SetExp(attacker:Horde_GetCurrentSubclass(), attacker:Horde_GetExp(attacker:Horde_GetCurrentSubclass()) + 1)

			for k, v in pairs(player.GetAll()) do
			if(!IsValid(v) || !v:Alive()) then continue end
				HORDE:SaveRank(v)
				v:Horde_SyncExp()
			end
		end

		if(npc:GetClass() == "npc_vj_lnr_fatso") then

			sound.Play( "ambient/explosions/explode_9.wav", npc:GetPos(), 100, 100, 1)
			sound.Play( "ambient/explosions/explode_9.wav", npc:GetPos(), 100, 100, 1)
			sound.Play( "weapons/underwater_explode3.wav", npc:GetPos(), 100, 100, 1)
			sound.Play( "weapons/underwater_explode4.wav", npc:GetPos(), 100, 100, 1)
			sound.Play( "ambient/explosions/explode_9.wav", npc:GetPos(), 100, 100, 1)

			local bPos = npc:GetPos()

			local eData = EffectData()
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
				eData:SetNormal(Vector(0,0,90))
				eData:SetMagnitude(5)
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos+ Vector(math.random(-128, 128), math.random(-128, 128), math.random(-32, 64)))
			util.Effect( "AntlionGib", eData )
				eData:SetOrigin(bPos)
				eData:SetScale(32)
			util.Effect( "watersplash", eData )

			for k,v in pairs(ents.FindByClass("npc_vj_hl*")) do
				if(v:GetPos():Distance(npc:GetPos()) <= 400) then
					v:TakeDamage(math.random(150, 300), npc)
				end
			end

			for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
				if(v:GetPos():Distance(npc:GetPos()) <= 400) then
					v:TakeDamage(math.random(150, 300), npc)
				end
			end

			for k,v in pairs(player.GetAll()) do

				if(!IsValid(v)) then continue end

				if(!v:Alive()) then continue end

				if(v:GetPos():Distance(npc:GetPos()) <= 180) then

					local pVec = v:GetPos()
					local eVec = npc:GetPos()

					local PushAng = Vector(Vector(pVec) - Vector(eVec)):Angle()

					local dInfo = DamageInfo()
						dInfo:SetDamage( (v:Health() / 3) + math.random(5, 15) )
						dInfo:SetAttacker( npc )
						dInfo:SetDamageType( 1048576 ) 

					v:SetVelocity(Angle(-45, PushAng.y, 0):Forward() * 750)

					v:TakeDamageInfo( dInfo )

				end

			end

		end

	end
end)
end

function AddHook5()
hook.Add( "EntityFireBullets", "FireBulletsHandler", function( entity, data )
	if(IsValid(entity)) then

		local eClass = entity:GetClass()

		if(eClass == "npc_vj_hlr1_cturret_mini") then
			entity:NextThink(CurTime() + 0.25)
		end

		if(eClass == "npc_vj_hlr1_gturret_mini") then
			entity:NextThink(CurTime() + 0.25)
		end

		if(eClass == "npc_vj_hlr1_gturret") then
			entity:NextThink(CurTime() + 0.025)
		end

		if(eClass == "npc_vj_hlrdc_sentry") then
			entity:NextThink(CurTime() + 0.1)
		end

		if(eClass == "npc_vj_hlr1_sentry") then
			entity:NextThink(CurTime() + 2)

			local Hvec = util.QuickTrace( entity:GetPos() + Vector(0,0,35), (entity:GetPos() + Vector(0,0,35)) + data.Dir * 3096, entity ).HitPos

			local edata = EffectData()
				edata:SetOrigin(Hvec)
				edata:SetMagnitude(3)
				edata:SetScale(5)
				edata:SetNormal(Vector(0, 0, 0))
				edata:SetRadius(3)

				util.Effect( "ElectricSpark", edata )
				util.Effect( "HelicopterMegaBomb", edata )

			sound.Play( "ambient/explosions/explode_3.wav", Hvec, 100, 110, 1)

			for k, v in pairs(ents.FindByClass("npc_*")) do

				if(!IsValid(v)) then continue end

				if(v:GetPos():Distance(Hvec) > 150) then continue end

				local dInfo = DamageInfo()
					dInfo:SetDamage( math.random(30, 50) )
					if(IsValid( entity:GetOwner() )) then
						dInfo:SetAttacker( entity:GetOwner() )
					else
						dInfo:SetAttacker( entity )
					end
					dInfo:SetInflictor( entity )
					dInfo:SetDamagePosition( v:GetPos() )
					dInfo:SetDamageType( 64 ) 

					v:TakeDamageInfo( dInfo )

			end

		end

	end

end)
end

function AddHook4()
SpikeHurtInterval = 0
hook.Add( "OnEntityCreated", "EntityCreateHandler", function( ent )

	if(IsValid(ent)) then

		local eClass = ent:GetClass()

		if(eClass == "npc_vj_hlr1_gturret") then
			ent:NextThink(CurTime() + 5)
		end

		local BaseEnt = nil

		for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
			if(!IsValid(v)) then continue end
			if(!IsBase(v)) then continue end
			BaseEnt = v
		end

		if(GetConVar("horde_zshelter_block_spawning_near_base"):GetInt() == 1) then
			timer.Create( "Remove"..math.random(-1024, 1024).."", 0.1, 1, function() if(!IsValid(ent)) then return end
				if(ent:IsNPC()) then
					if(!IsTurret(ent)) then
						if(ent:GetPos():Distance(BaseEnt:GetPos()) < 1024) then
							ent:Remove()
						end
					end
				end
			end )
		end

		if(eClass == "prop_physics_multiplayer") then

			table.insert(EntTable, {ent, 0, 0, 0, 0, false, NULL, NULL, true, Vector(0,0,0)})
			table.insert(DoorTable, {ent, 0, 103, ent:GetPos(), true})

		end

	end

end)
end


--[[
		"models/lambda/traps/zsht_landmine.mdl"
		"models/lambda/traps/zsht_spiketrap.mdl"
	]]
function AddHook3()
hook.Add( "ShouldCollide", "CollideHandler", function( ent1, ent2 )

	if(ent1:IsValid() && ent2:IsValid()) then

		if(IsTurret(ent1) && IsTurret(ent2)) then
			return false
		end

		if(ent1:IsNPC() && ent2:IsNPC()) then

			if(IsTurret(ent1) || IsTurret(ent2)) then

				return true

			else

				return false

			end

		end

		if(ent1:IsNPC() && ent2:GetModel() == "models/lambda/traps/zsht_landmine.mdl" && ent1:GetPos():Distance(ent2:GetPos()) < 64) then
			for k,v in pairs(ents.FindByClass("npc*")) do
				if(!IsValid(v)) then continue end
				if(IsTurret(v)) then continue end
				if(v:GetPos():Distance(ent2:GetPos()) > 128) then continue end
				v:TakeDamage(120)
			end
			ent2:Remove()
			local eData = EffectData()
				eData:SetOrigin(ent2:GetPos())
			util.Effect("HelicopterMegaBomb", eData)
			sound.Play( "ambient/explosions/explode_3.wav", ent2:GetPos(), 100, 100, 1)
		end

		if(ent2:IsNPC() && ent1:GetModel() == "models/lambda/traps/zsht_landmine.mdl" && ent1:GetPos():Distance(ent2:GetPos()) < 64) then
			for k,v in pairs(ents.FindByClass("npc*")) do
				if(!IsValid(v)) then continue end
				if(IsTurret(v)) then continue end
				if(v:GetPos():Distance(ent1:GetPos()) > 128) then continue end
				v:TakeDamage(120)
			end
			ent1:Remove()
			local eData = EffectData()
				eData:SetOrigin(ent1:GetPos())
			util.Effect("HelicopterMegaBomb", eData)
			sound.Play( "ambient/explosions/explode_3.wav", ent1:GetPos(), 100, 100, 1)
		end


		if(ent1:IsNPC() && ent2:GetModel() == "models/lambda/traps/zsht_spiketrap.mdl" && ent1:GetPos():Distance(ent2:GetPos()) < 64) then
				
				if(ent2.CurTime == nil) then
					ent2.CurTime = 0
				else
					if(ent2.CurTime < CurTime()) then
						ent1:TakeDamage(5)
						ent2.CurTime = CurTime() + 0.25
					end
				end

		end

		if(ent2:IsNPC() && ent1:GetModel() == "models/lambda/traps/zsht_spiketrap.mdl" && ent1:GetPos():Distance(ent2:GetPos()) < 64) then

				if(ent1.CurTime == nil) then
					ent1.CurTime = 0
				else
					if(ent1.CurTime < CurTime()) then
						ent2:TakeDamage(5)
						ent1.CurTime = CurTime() + 0.25
					end
				end

		end

	end

end )
end

function AddHook2()
hook.Add( "PlayerSpawn", "PSpawnHandler", function(ply)
	if(IsValid(ply)) then
		ply:SetPos(GetSpawnPos())
	end
end)
end

function CreateGibEntity_(class, models, sound, pos)
	local gib = ents.Create(class)
	gib:SetModel(models)
	gib:SetPos(pos + Vector(math.random(-32, 32), math.random(-32, 32), math.random(10, 36)))
	gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	gib.CollideSound = sound.CollideSound[math.random(#sound.CollideSound)]
	gib.BloodType = nil
	gib:Spawn()
	gib:Activate()
	gib:SetColor(Color(255, 255, 255, 255))
	gib:SetRenderMode( RENDERMODE_TRANSCOLOR )

	local phys = gib:GetPhysicsObject()
	if(IsValid(phys)) then
		phys:SetVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(0, 200)))
	end
	table.insert(RemoveGibList, {gib, CurTime() + 5})
end

local gibsCollideSd = {"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}
local upPos = 20
function AddHook1()
hook.Add( "EntityRemoved", "EntityRemovedHandler", function( ent )
	if(!IsValid(ent)) then return end
	if(ent:GetClass() == "prop_physics_multiplayer" && !IsResource(ent)) then
		if(ent:GetMaxHealth() != 1) then
			sound.Play( "shigure/break.mp3", ent:GetPos(), 100, 100, 1)
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
			CreateGibEntity_("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8.mdl",{CollideSound=gibsCollideSd}, ent:GetPos())
		end
	end
end)
end

CEnemyToList()
CacheEnemySpawn()

ShouldInit = true
hook.Add("PlayerInitialSpawn", "EnableGamemode", function(ply) -- Since gmod run this script before map entities being created, I had to do this.
	if(ShouldInit) then
		timer.Simple(6, function() -- I don't like the delay but whatever
			if(ShouldLoad()) then
				AddHook1()
				AddHook2()
				AddHook3()
				AddHook4()
				AddHook5()
				AddHook6()
				AddHook7()
				AddHook8()
				AddHook9()
				AddHook10()
				AddHook11()
				AddHook12()
				PrintMessage( HUD_PRINTTALK, "Loaded Successfully")

				hook.Add("Horde_ShouldContinueGameWhenAllPlayersAreDead", "ContinueGame", function() return true end) -- Thanks Gorlami <3
				hook.Add("Horde_OnPlayerShouldRespawnDuringWave", "AllowSpawn", function() return true end)

				hook.Remove("OnNPCKilled", "Horde_EnemyKilled")
				hook.Remove("PlayerCanPickupWeapon", "Horde_Economy_Pickup")
				hook.Remove("EntityTakeDamage", "Horde_EntityTakeDamage")

				for k,v in pairs(ents.FindByClass("prop_zshelter_obstacle")) do
					if(!IsValid(v)) then continue end
					CreateObstacle(v:GetPos(), v:GetAngles(), v.iHealth)
				end

				SyncShelterItems()
				SyncShelterEnemies()
			else
				PrintMessage( HUD_PRINTTALK, "Missing map entities! Please contact map creator!")
			end
		end)
		PrintMessage( HUD_PRINTTALK, "Starting HORDE : Shelter Mode..")
		ShouldInit = false
	end
end)

LoadItemConfig()
LoadEnemyConfig()