if ((activatedAddons find "cba_common") != -1) then 
{
	[
		"EXP_Killstreaks_enabled", 
		"CHECKBOX", 
		["Killstreaks Toggle", "On (checked) / Off (unchecked)"], 
		"Killstreaks", 
		true,
		true,  //nil
		{
			params ["_value"];
		} // function that will be executed once on mission start and every time the setting is changed. */
	] call CBA_fnc_addSetting;
		
	[
		"EXP_Killstreak_count", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"LIST", // setting type
		["Number of killstreaks to use", "1-3"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		["Killstreaks"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
		[[1, 2, 3],[1, 2, 3], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
		true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			params ["_value"];
		} 
	] call CBA_fnc_addSetting;		
		
	[
		"EXP_Killstreak1", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"SLIDER", // setting type
		["Killstreak 1: # of kills", "Number of consecutive kills to activate this reward"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		"Killstreaks", // Pretty name of the category where the setting can be found. Can be stringtable entry.
		[3, 50, 3, 0, false], // data for this setting: [min, max, default, number of shown trailing decimals]
		true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			params ["_value"];
		} 
	] call CBA_fnc_addSetting;

			[
				"EXP_Killstreak1_slot", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Killstreak 1 slot"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Rewards"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[0, 1, 2, 3, 4, 5],["UAV", "PREDATOR", "AIRSTRIKE", "CHOPPER", "AC130", "NUKE"], 0], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
	


	[
		"EXP_Killstreak2", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"SLIDER", // setting type
		["Killstreak 2: # of kills", "Number of consecutive kills to activate this reward"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		"Killstreaks", // Pretty name of the category where the setting can be found. Can be stringtable entry.
		[5, 50, 5, 0, false], // data for this setting: [min, max, default, number of shown trailing decimals]
		true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			params ["_value"];
		} 
	] call CBA_fnc_addSetting;
	
			[
				"EXP_Killstreak2_slot", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Killstreak 2 slot"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Rewards"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[0, 1, 2, 3, 4, 5],["UAV", "PREDATOR", "AIRSTRIKE", "CHOPPER", "AC130", "NUKE"], 1], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
	
	
	[
		"EXP_Killstreak3", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"SLIDER", // setting type
		["Killstreak 3: # of kills", "Number of consecutive kills to activate this reward"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		"Killstreaks", // Pretty name of the category where the setting can be found. Can be stringtable entry.
		[7, 50, 7, 0, false], // data for this setting: [min, max, default, number of shown trailing decimals]
		true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			params ["_value"];
		} 
	] call CBA_fnc_addSetting;
	
	
			[
				"EXP_Killstreak3_slot", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Killstreak 3 slot"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Rewards"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[0, 1, 2, 3, 4, 5],["UAV", "PREDATOR", "AIRSTRIKE", "CHOPPER", "AC130", "NUKE"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
	
	
	
	
	
	
	
	/////////////////// KILLSTREAK SPECIFIC SETTTINGS
			[
				"EXP_uavRadius", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["UAV: spot radius", "Radius of the search area (2x radius = diameter)"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[400, 500, 750, 1000, 1250, 1500],["400 Meters", "500 Meters", "750 Meters", "1000 Meters", "1250 Meters", "1500 Meters"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
			[
				"EXP_uavDuration", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["UAV: Killstreak max duration", "Max lifetime of this killstreak while active"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[60, 120, 180, 240, 300, 360],["1 minute", "2 minutes", "3 minutes", "4 minutes", "5 minutes", "6 minutes"], 1], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
			[
				"EXP_uavUpdateTick", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["UAV: Position update rate", "how often map markers are updated"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[3, 5, 10, 15, 30, 60, 120, 180, 240],["3 Seconds", "5 Seconds", "10 Seconds", "15 Seconds", "30 Seconds", "1 Minute", "2 minutes", "3 minutes", "4 minutes"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
			
			[
				"EXP_predatorMissileCount", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Predator Missile: Missile count", "Each strike vessel contains 4x/8x GBU-12 LGBs"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[1, 2],["1 Missile", "2 Missiles"], 0], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
			[
				"EXP_predatorDuration", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Predator Missile: Killstreak max duration", "Max lifetime of this killstreak while active"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[60, 120, 180, 240, 300, 360],["1 minute", "2 minutes", "3 minutes", "4 minutes", "5 minutes", "6 minutes"], 0], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
	

			[
				"EXP_airstrikeJetCount", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Precision airstrike: jet count", "Each strike vessel contains 4x/8x GBU-12 LGBs"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[1, 2, 3, 4, 5],["1 Jet", "2 Jets", "3 Jets", "4 Jets", "5 Jets"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			

			[
				"EXP_airstrikeRadius", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Precision airstrike: bomb dispersion radius", "1 Bomb per-jet is guarenteed to hit center of target"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[15, 25, 50, 100, 150, 200, 350],["15 Meters", "25 Meters", "50 Meters", "100 Meters", "150 Meters", "200 Meters", "350 Meters"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;


			[
				"EXP_airstrikeFlyHeight", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Precision airstrike: aircraft flight altitude", "override jet altitute"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[250, 300, 400, 500, 650, 800],["250 Meters", "300 Meters", "400 Meters", "500 Meters", "650 Meters", "800 Meters"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
			[
				"EXP_airstrikeBombCount", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Precision airstrike: bombs per jet", "override to prevent jets from hitting tall mountains"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[["PylonMissile_Bomb_GBU12_x1", "PylonRack_Bomb_GBU12_x2"],["4 bombs", "8 bombs"], 0], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;
			
				
			[
				"EXP_nukeYield", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
				"LIST", // setting type
				["Nuke: yield strength kilo tons"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
				["Killstreaks", "Killstreak Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
				[[0.2, 0.5, 1.0, 1.500, 2.0, 5.0, 10.0, 20.0, 50.0],["0.2 kT", "0.5 kT", "1.0 kT", "1.5 kT", "2.0 kT", "5.0 kT", "10.0 kT", "20.0 kT", "50.0 kT :LAG LOL:"], 2], // data for this setting: [min, max, default, number of shown trailing decimals]
				true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
				{  
					params ["_value"];
				} 
			] call CBA_fnc_addSetting;

}; 