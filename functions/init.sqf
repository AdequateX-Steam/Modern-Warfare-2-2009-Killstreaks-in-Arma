//need to do list:


// fix any buggsssss:
	//when more of the same killstreaks (that are unused) are added, the previous one(s) should be removed first (as this causes stacked versions of the same killstreak to be added... (more than the limit of 3 killstreaks))
	//predator missile handle event when player pauses, and goes into spectator / camera mode, view of the missile camera is removeD (when camera mode is used missile goes into 3rd person can swap with 'enter')
	// SLOTS -> MULTIPLE OF THE SAME KILLSTREAK OCCUPYING SAME 'SLOT' CREATE MORE KILLSTREAKS IN THE COMMUNICATION MENU FOR USE... SHOULD BE 1 PER 'SLOT' (THAT MIGHT JUST BE )
		//------CHECK IF SLOT IS OCCUPIED IF NOT OVERRIDE IT USEING THIS "_unit setvariable ["BIS_fnc_addCommMenuItem_menu",_menu];"  
		/* 	 _menu set [
				count _menu,
				[
					_itemID,
					_text,
					_submenu,
					_expression,
					_enable,
					_cursor,
					_icon,
					_iconText
				]
			]; */
	// MULTIPLE NUKES CAN BE ACTIVE AT ONCE.... SOUND BUG LOL //remote exec a global variable? 
//tips:
	// [] call bis_fnc_refreshCommMenu; >>> for when changing camera view to refresh killstreak comm menu display.
//

if (hasInterface) then  //Run on all players + SP host
{
	waitUntil {Alive Player};
	
//killstreak init & handling
	player setvariable ["EXP_killstreakIsActive", 0];
	player setvariable ["EXP_Killstreak", 0];
	player setvariable ["EXP_killstreakSlots", [
			[],
			[],
			[]
		]
	];
	
	player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		if ((player getvariable "EXP_killstreakIsActive") == 1) then {
			//terminate all controlled killstreaks here
			[(finddisplay 46) getVariable "PredatorDroneOBJ", false] call EXP_fnc_terminatePredatorStreak;
		};
		player setvariable ["EXP_Killstreak", 0];
		player setvariable ["EXP_killstreakIsActive", 0];
		player setvariable ["EXP_missileControlling", 0];
		[] call bis_fnc_refreshCommMenu;

	}];
	

	addMissionEventHandler ["EntityKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
		if ((isPlayer _instigator) && (((side _instigator) getFriend (side group _unit)) < 0.6)) then {
			if ((missionNamespace getVariable "EXP_Killstreaks_enabled")) then 
			{
				_curKillstreak = ((_instigator getVariable "EXP_Killstreak") + 1);
				_instigator setVariable ["EXP_Killstreak", _curKillstreak];
				
			
				_numKillstreaks = [
					[1],
					[1,2],
					[1,2,3]
				] select ((missionNamespace getVariable "EXP_Killstreak_count") - 1);
			
			
				{
					_rewardThreshold = floor (missionNamespace getVariable ("EXP_Killstreak" + (str _x)));  ///floor?
					if (_curKillstreak == _rewardThreshold) then {						
						_rewardType = [
						"UAV", 
						"PREDATOR", 
						"AIRSTRIKE", 
						"CHOPPER", 
						"AC130", 
						"NUKE"
						] select (missionNamespace getVariable (("EXP_Killstreak" + (str _x)) + "_slot"));
						//give killstreak reward here! /////////////////////////////////////////////////////////////////////////
						[_rewardType, _rewardThreshold, _forEachIndex ,_instigator] call EXP_fnc_killstreakHandler;
						
					};	 
				} foreach _numKillstreaks;
		
			};
		};
	}];

EXP_fnc_killstreakHandler = 
{
	params
	[
		["_rewardType", "", [""]],
		["_rewardThreshold", 1, [0]],   //unused
		["_rewardSlot", 1, [0]],
		["_instigator", objNull, [objNull]] //unused
	];
	
// Play sounds and give killstreak support action
//////////////// check that slot isnt already taken here after respawn  _slotAvailibility ????////////////////////////////////////////////////////////////////////////////////


	switch (_rewardType) do 
	{
		case "UAV" : {
			
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_radar.wav", 1.0, 1.0];
				_commMenuID = [player, "Uav" , nil, "[] call EXP_fnc_deployUav; player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_01.wav", 
							"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_03.wav",							
							"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_achieve_uav_01.wav",
							"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_achieve_uav_03.wav",
							"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_achieve_uav_01.wav",
							"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_achieve_uav_03.wav"							
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_achieve_uav_01.wav", 
							"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_achieve_uav_03.wav",							
							"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_achieve_uav_01.wav",
							"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_achieve_uav_03.wav"
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_achieve_uav_01.wav", 
							"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_achieve_uav_02.wav",
							"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_achieve_uav_03.wav"
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};	
		
		};
		
		
		
		case "PREDATOR" : {
		
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_hellfire.wav", 1.0, 1.0];
				_commMenuID = [player, "predatorMissile" , nil, "[] call EXP_fnc_deployPredatorMissile; player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_achieve_predator_01.wav", 
							"\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_achieve_predator_02.wav", 
							"\Killstreaks\data\Sounds\PredatorMissile\Rangers\US_1mc_achieve_predator_01.wav",
							"\Killstreaks\data\Sounds\PredatorMissile\Rangers\US_1mc_achieve_predator_02.wav",
							"\Killstreaks\data\Sounds\PredatorMissile\NS\NS_1mc_achieve_predator_01.wav",
							"\Killstreaks\data\Sounds\PredatorMissile\NS\NS_1mc_achieve_predator_02.wav"	
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PredatorMissile\Russian\RU_1mc_achieve_predator_01.wav", 
							"\Killstreaks\data\Sounds\PredatorMissile\Russian\RU_1mc_achieve_predator_02.wav", 
							"\Killstreaks\data\Sounds\PredatorMissile\PG\PG_1mc_achieve_predator_01.wav",
							"\Killstreaks\data\Sounds\PredatorMissile\PG\PG_1mc_achieve_predator_02.wav"	
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PredatorMissile\Arabic\AB_1mc_achieve_predator_01.wav", 
							"\Killstreaks\data\Sounds\PredatorMissile\Arabic\AB_1mc_achieve_predator_02.wav" 
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_achieve_predator_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};	
		};
		
		
		
		case "AIRSTRIKE" : {
		
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_jetstart.wav", 1.0, 1.0];
				_commMenuID = [player, "precisionAirstrike" , nil, "[] call EXP_fnc_deployPrecisionAirstrike; player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_achieve_airstrike_01.wav", 
							"\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_achieve_airstrike_02.wav",							
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Rangers\US_1mc_achieve_airstrike_01.wav",
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Rangers\US_1mc_achieve_airstrike_02.wav",
							"\Killstreaks\data\Sounds\PrecisionAirstrike\NS\NS_1mc_achieve_airstrike_01.wav",
							"\Killstreaks\data\Sounds\PrecisionAirstrike\NS\NS_1mc_achieve_airstrike_02.wav"					
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Russian\RU_1mc_achieve_airstrike_01.wav", 
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Russian\RU_1mc_achieve_airstrike_02.wav",							
							"\Killstreaks\data\Sounds\PrecisionAirstrike\PG\PG_1mc_achieve_airstrike_01.wav",
							"\Killstreaks\data\Sounds\PrecisionAirstrike\PG\PG_1mc_achieve_airstrike_02.wav"
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Arabic\AB_1mc_achieve_airstrike_01.wav", 
							"\Killstreaks\data\Sounds\PrecisionAirstrike\Arabic\AB_1mc_achieve_airstrike_02.wav"
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_achieve_airstrike_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};	
		};
		
		
		
		case "CHOPPER" : {
		
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_heliaway.wav", 1.0, 1.0];
				_commMenuID = [player, "chopperGunner" , nil, "[] call EXP_fnc_deployChopperGunner;  player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_achieve_apache_01.wav", 
							"\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_achieve_apache_02.wav",							
							"\Killstreaks\data\Sounds\ChopperGunner\Rangers\US_1mc_achieve_apache_01.wav",
							"\Killstreaks\data\Sounds\ChopperGunner\Rangers\US_1mc_achieve_apache_02.wav",
							"\Killstreaks\data\Sounds\ChopperGunner\NS\NS_1mc_achieve_apache_01.wav",
							"\Killstreaks\data\Sounds\ChopperGunner\NS\NS_1mc_achieve_apache_02.wav"						
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\ChopperGunner\Russian\RU_1mc_achieve_apache_01.wav", 
							"\Killstreaks\data\Sounds\ChopperGunner\Russian\RU_1mc_achieve_apache_02.wav",						
							"\Killstreaks\data\Sounds\ChopperGunner\PG\PG_1mc_achieve_apache_01.wav",
							"\Killstreaks\data\Sounds\ChopperGunner\PG\PG_1mc_achieve_apache_02.wav"
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\ChopperGunner\Arabic\AB_1mc_achieve_apache_01.wav", 
							"\Killstreaks\data\Sounds\ChopperGunner\Arabic\AB_1mc_achieve_apache_02.wav"
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_achieve_apache_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};	
		
		};
		
		
		
		case "AC130" : {
		
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_ac130.wav", 1.0, 1.0];
				_commMenuID = [player, "AC130" , nil, "[] call EXP_fnc_deployAC130;  player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_achieve_ac130_01.wav", 
							"\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_achieve_ac130_02.wav",						
							"\Killstreaks\data\Sounds\AC130\Rangers\US_1mc_achieve_ac130_01.wav",
							"\Killstreaks\data\Sounds\AC130\Rangers\US_1mc_achieve_ac130_02.wav",
							"\Killstreaks\data\Sounds\AC130\NS\NS_1mc_achieve_ac130_01.wav",
							"\Killstreaks\data\Sounds\AC130\NS\NS_1mc_achieve_ac130_02.wav"						
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\AC130\Russian\RU_1mc_achieve_ac130_01.wav", 
							"\Killstreaks\data\Sounds\AC130\Russian\RU_1mc_achieve_ac130_02.wav",							
							"\Killstreaks\data\Sounds\AC130\PG\PG_1mc_achieve_ac130_01.wav",
							"\Killstreaks\data\Sounds\AC130\PG\PG_1mc_achieve_ac130_02.wav"
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\AC130\Arabic\AB_1mc_achieve_ac130_01.wav", 
							"\Killstreaks\data\Sounds\AC130\Arabic\AB_1mc_achieve_ac130_02.wav"
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_achieve_ac130_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};	
		
		};
		
		
		
		case "NUKE" : {
			[_rewardType, _rewardSlot] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_rewardSlot", 0, [0]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				sleep 0.5;
				playSoundUI ["\Killstreaks\data\Sounds\killstreakAcquired\mp_killstrk_nuclearstrike.wav", 1.0, 1.0];	
				_commMenuID = [player, "Nuke" , nil, "[] call EXP_fnc_deployNuke; player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
				sleep 0.75;
				switch (playerSide) do {
					case blufor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_achieve_tnuke_01.wav", 
							"\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_achieve_tnuke_02.wav",						
							"\Killstreaks\data\Sounds\Nuke\Rangers\US_1mc_achieve_tnuke_01.wav",
							"\Killstreaks\data\Sounds\Nuke\Rangers\US_1mc_achieve_tnuke_02.wav",
							"\Killstreaks\data\Sounds\Nuke\NS\NS_1mc_achieve_tnuke_01.wav",
							"\Killstreaks\data\Sounds\Nuke\NS\NS_1mc_achieve_tnuke_02.wav"						
						];
					};
					case opfor: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\Nuke\Russian\RU_1mc_achieve_tnuke_01.wav", 						
							"\Killstreaks\data\Sounds\Nuke\PG\PG_1mc_achieve_tnuke_01.wav",
							"\Killstreaks\data\Sounds\Nuke\PG\PG_1mc_achieve_tnuke_02.wav"
						];
					};
					case independent: {
						_initSound = selectRandom [
							"\Killstreaks\data\Sounds\Nuke\Arabic\AB_1mc_achieve_tnuke_01.wav", 
							"\Killstreaks\data\Sounds\Nuke\Arabic\AB_1mc_achieve_tnuke_02.wav"
			
						];
					};
					default {_initSound = "\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_achieve_tnuke_02.wav"};
				};
				playSoundUI [_initSound, 1.0, 1.0];	
				//systemChat str [_rewardSlot, [_commMenuID, _rewardType]];
				_slotAvailibility set [_rewardSlot, [_commMenuID, _rewardType]];
				player setvariable ["EXP_killstreakSlots", _slotAvailibility];
			
			};
		
		};				
	};
};


EXP_fnc_deployUav = {
	//BUGS FOR UAV
		// ENEMY POSITIONS DO NOT UPDATE FOR THE FRIENDLY TEAM
	//suggestions:
		//do oneachFrame, with split (tick-tock) updates for all (enemy units array /2)
			//custom 2d markers 
				//arrow pointer for better UAV killstreak (realtime update) ??
	openMap [false, false];  //prevent 2 streaks from being used at same time
	
	//Map Event Handlers
	_drawEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", { 
		((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], ((findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition), 60, 60, 0, "", 2, 0.1];
	}];
	(findDisplay 12) setVariable ["EXP_drawEH", _drawEH];

	
	
	_clickEHID = addMissionEventHandler ["MapSingleClick", 
	{
		params ["_units", "_pos", "_alt", "_shift"];
		//need to set a maximum distance
		if (((_pos distance2D player) > 2000)) then 
		{
			systemChat format ["Maximum distance from player: 2000 meters; Current distance: %1 meters",(_pos distance2D player)];
		}
		else
		{
			openMap [false, false];	
			_kilstreakslots = (player getVariable "EXP_killstreakSlots");
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", ((findDisplay 12) getVariable "EXP_drawEH")];
			[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;		
			((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
			[_pos] call EXP_fnc_spawnUAV ;						
		};
	}, []];

	_mapEHID = addMissionEventHandler ["Map", 
	{
		params ["_mapIsOpened", "_mapIsForced"];
		if (_mapIsOpened == false) then 
		{
			removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
			removeMissionEventHandler ["Map" ,_thisEventHandler];	
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", (_thisArgs select 1)];
			((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
		};
	}, [_clickEHID, _drawEH]];


	//Main Script
	openMap [true, false];
	((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "blankTrack"];

	//Functions
	EXP_fnc_spawnUAV = {
		params 
		[
			["_TargetPos", [], [[]]]
		];
		//Settings
		_searchRadius = (missionNamespace getVariable ["EXP_uavRadius", 750]);
		_TimeToLive = (missionNamespace getVariable ["EXP_uavDuration", 120]);
		_tickTime = (missionNamespace getVariable ["EXP_uavUpdateTick", 30]);
		
		// Variable invalidation
		((finddisplay 46) setVariable ["UavEntities", nil]);
		
		/// Drone initialize
		_TargetPos set [2, 0];
		_spawnpos = [((_TargetPos select 0) - 707), ((_TargetPos select 1) - 707), 800];
		_uavDrone= createVehicle ["B_UAV_02_dynamicLoadout_F", _spawnpos , [], 0, "CAN_COLLIDE"];
		(side player) createVehicleCrew _uavDrone;
		_uavDrone engineOn true;
		_uavDrone setVelocityModelSpace [0,66,0];
		_waypoint = group(_uavDrone) addWaypoint [_TargetPos, -1, 1];
		group(_uavDrone) setCurrentWaypoint _waypoint;
		group(_uavDrone) setCombatMode "BLUE";
		group(_uavDrone) setCombatBehaviour "COMBAT"; //CARELESS
		_waypoint setWaypointBehaviour "COMBAT";
		_waypoint setWaypointSpeed "NORMAL";  //LIMITED
		_uavDrone forceSpeed 66;
		_waypoint setWaypointType "LOITER";
		_waypoint setWaypointForceBehaviour true;
		_waypoint setWaypointLoiterRadius (_searchRadius * 1.1);
		_waypoint setWaypointLoiterAltitude 800;
		_waypoint setWaypointLoiterType "CIRCLE";
		{[_uavDrone , [_x, "", true]] remoteExec ["setPylonLoadout", _uavDrone];} foreach [1,2];
		//{_uavDrone setPylonLoadout [_x, "", true]} foreach [1,2];
		removeAllMagazines _uavDrone;
		{_uavDrone removeweapon _x} forEach (weapons _bomberPlane);
		_uavDrone lockDriver true;
		_uavDrone lockTurret [[0,0], true];
		_uavDrone lock 2;
		
		//Target marker
		_uavMarker = createMarker ["UAVTargetArea", _TargetPos, 1, player];	
		_uavMarker setMarkerText "UAV: Search area";
		_uavMarker setMarkerShape "ELLIPSE";
		_uavMarker setMarkerSize [_searchRadius, _searchRadius];
		_uavMarker setMarkerBrush "DiagGrid";
		_uavMarker setMarkerAlpha 1.0;
		_uavMarker setMarkerAlphaLocal 1.0;
		_uavMarker setMarkerColor "#(0.7,1,0.75,1)";
		
		((finddisplay 46) setVariable ["UavOBJ", _uavDrone]);
		((finddisplay 46) setVariable ["UavMarker", _uavMarker]);
		
		
		//EventHandlers here
		_uavDrone addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			systemChat "UAV destroyed";
			[_unit, ((finddisplay 46) getVariable "UavMarker"), true, ((finddisplay 46) getVariable "UavEntities")] call EXP_fnc_terminateUavStreak;
		}];
				
		// Play announcer sound here
		["UAV", (side Player)] remoteExec ["EXP_fnc_announcerHandler"];
		
		//this should be a seperate function to remote exec on all friendly computers
		[_uavDrone, _tickTime, _TimeToLive, _searchRadius, _TargetPos] spawn {
			params [
				["_uavDrone", objNull, [objNull]],
				["_tickTime", 15, [0]],
				["_TimeToLive", 120, [0]],
				["_searchRadius", 750, [0]],
				["_TargetPos", [], [[]]]
			];
			//variable declaration
			_allEntities = [];
			_entityTypes = ["Man", "CAR", "Wheeled_APC_F", "Tank"];
			_friendlyPlayers = [];
			_startTime = time;
			_endTime = _timeToLive;
			_allEntities = [];
			_updateEntities = [];
			_sortedEntities = [];
			_friendlyPlayers = [];
			
			//Search loop
			while {((alive _uavDrone) && (!(_endTime <= 0)))} do {
			
				{
					if ((side player getFriend side _x) > 0.6) then {_friendlyPlayers pushBack _x;}; //might need to be >=
				} forEach allPlayers;
			
			
				_updateEntities = _TargetPos nearEntities [_entityTypes, _searchRadius];
				if (((_updateEntities arrayIntersect _allEntities)) isNotEqualTo _updateEntities) then {
					
					_allEntities = _updateEntities;
				
				};
				{
					if (((side player getFriend side _x) < 0.6) && (alive _x)) then {
						_marker = createMarkerLocal [(str _x), getPosATL _x];
						_marker setMarkerTypeLocal "uav_Ping";
						_marker setMarkerColorLocal "#(1,1,1,1)";
						_marker setMarkerSizeLocal [0.45,0.45];
						_sortedEntities append [[_x, _marker]];
					};
				} forEach _allEntities;	
				
				for "_i" from 0 to ((count _sortedEntities) - 1) step 1 do
				{			
					if ((((_sortedEntities select _i) select 0) in _allEntities) == False) then {
						//delete from public variable here first? then local variable below
						deleteMarkerLocal ((_sortedEntities select _i) select 1);
						_sortedEntities deleteAt _i;
					
					}
					else 
					{
						((_sortedEntities select _i) select 1) setMarkerPos (getPosATL ((_sortedEntities select _i) select 0));
					};
				};
						
				((finddisplay 46) setVariable ["UavEntities", _sortedEntities]);
				sleep _tickTime;
				_endTime = _timeToLive - (time - _startTime);
				if ((round _endTime) % 10 == 0) then { systemChat ("UAV: " + (str (round _endTime)) + " Seconds remaining");};
			};
			if ((alive _uavDrone)) then {
				systemChat "UAV timed-out";
				[_uavDrone, ((finddisplay 46) getVariable "UavMarker"), false, ((finddisplay 46) getVariable "UavEntities")] call EXP_fnc_terminateUavStreak;
			};
		};
	};
	
	
	EXP_fnc_uavRemoteUpdate = {
	//run on and update other client machines with _sortedEntities;
		//need to determine if multiple concurrent UAVs are running (use public variable and add to and deleteAT as necessary for all concurrent scripts, ^^^^^ above)
		params [
			["_sortedEntities", objNull, [objNull]],
			["_tickTime", 15, [0]],
			["_TimeToLive", 120, [0]]
		];	
				
				
	};
	
	
	/* 	
	addMissionEventHandler ["EachFrame", {
		// no params
		}]; 
	*/
	EXP_fnc_terminateUavStreak = {
		params [
			["_uavDrone", objNull, [objNull]],
			["_uavMarker", "", [""]],
			["_shotDown", false, [false]],
			["_entitiesArray", [], [[]]]
		];
		if (_shotdown isEqualTo false) then {
			deleteVehicleCrew _uavDrone;
			deleteVehicle _uavDrone;
		};
		deleteMarker _uavMarker;
		{
			(deleteMarkerLocal (_x select 1));
		}forEach _entitiesArray
	};
};


EXP_fnc_deployPredatorMissile = {
	//TODO:

	//BUGS:
		// Drone should have a 5 second period before being targetted by AI
		
	if ((player getvariable "EXP_killstreakIsActive") == 1) exitWith { systemChat "Another killstreak is currently in use";};
	
	openMap [false, false];  //prevent 2 streaks from being used at same time
	
	//Initialize player and display variableNames
	player setvariable ["EXP_missileControlling", 0];
	((finddisplay 46) setvariable ["PredatorFiredEH" ,nil]);
	((findDisplay 46) setVariable ["droneKilledEH", nil]);
	//((findDisplay 46) setVariable ["CameraLockEH", nil]);
	((findDisplay 46) setVariable ["MouseEH", nil]);
	((findDisplay 46) setVariable ["MouseButtonDownEH", nil]);
	((findDisplay 46) setVariable ["ProjectileEH", nil]);
	((findDisplay 46) setVariable ["CameraOBJ", objNull]);
	((finddisplay 46)setVariable ["ppEffects", nil]);
	((findDisplay 46) setVariable ["killStreakLockEH", nil]);

	
//Map Event Handlers
	_drawEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", { 
		((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], ((findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition), 60, 60, 0, "", 2, 0.1];
	}];
	(findDisplay 12) setVariable ["EXP_drawEH", _drawEH];

	
	
	_clickEHID = addMissionEventHandler ["MapSingleClick", 
	{
		params ["_units", "_pos", "_alt", "_shift"];
		//need to set a maximum distance
		if (((_pos distance2D player) > 2500)) then 
		{
			systemChat format ["Maximum distance from player: 2500 meters; Current distance: %1 meters",(_pos distance2D player)];
		}
		else
		{
			openMap [false, false];	
			_kilstreakslots = (player getVariable "EXP_killstreakSlots");
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", ((findDisplay 12) getVariable "EXP_drawEH")];
			[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;		
			((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
			[_pos] call EXP_fnc_spawnDrone ;						
		};
	}, []];

	_mapEHID = addMissionEventHandler ["Map", 
	{
		params ["_mapIsOpened", "_mapIsForced"];
		if (_mapIsOpened == false) then 
		{
			removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
			removeMissionEventHandler ["Map" ,_thisEventHandler];	
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", (_thisArgs select 1)];
			((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
		};
	}, [_clickEHID, _drawEH]];


//Main Script
	openMap [true, false];
	((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "blankTrack"];
	
	
//Functions
	EXP_fnc_spawnDrone = {
		params 
		[
			["_selectionPos", [], [[]]]
		];
		player setvariable ["EXP_killstreakIsActive", 1];
	// Settings:
		_timeToLive = (missionNamespace getVariable ["EXP_predatorDuration", 180]);
		_missileCount = (missionNamespace getVariable ["EXP_predatorMissileCount", 1]);
	// Drone initialize
		_selectionPos set [2, 0];
		_spawnpos = [((_selectionPos select 0) - 707), ((_selectionPos select 1) - 707), 800];
		
		_predatorDrone = createVehicle ["B_UAV_02_dynamicLoadout_F", _spawnpos , [], 0, "CAN_COLLIDE"];
		(side player) createVehicleCrew _predatorDrone;
		_predatorDrone engineOn true;
		_predatorDrone setVelocityModelSpace [0,66,0];
		_waypoint = group(_predatorDrone) addWaypoint [_selectionPos, -1, 1];
		group(_predatorDrone) setCurrentWaypoint _waypoint;
		group(_predatorDrone) setCombatMode "BLUE";
		group(_predatorDrone) setCombatBehaviour "COMBAT"; //CARELESS
		_waypoint setWaypointBehaviour "COMBAT";
		_waypoint setWaypointSpeed "NORMAL";  //LIMITED
		_predatorDrone forceSpeed 66;
		_waypoint setWaypointType "LOITER";
		_waypoint setWaypointForceBehaviour true;
		_waypoint setWaypointLoiterRadius 1000;
		_waypoint setWaypointLoiterAltitude 800;
		_waypoint setWaypointLoiterType "CIRCLE";
		{[_predatorDrone , [_x, "PylonRack_1Rnd_Missile_AGM_02_F", true]] remoteExec ["setPylonLoadout", _predatorDrone ];} foreach [1,2];
	//{_predatorDrone setPylonLoadout [_x, "PylonRack_1Rnd_Missile_AGM_02_F", true]} foreach [1,2];
		_predatorDrone removeWeaponTurret ["Missile_AGM_02_Plane_CAS_01_F", [0]];
		_predatorDrone removeWeaponTurret ["Laserdesignator_mounted", [0]];
		_predatorDrone removeWeaponTurret ["missiles_SCALPEL", [0]];
		_predatorDrone addMagazineTurret ["magazine_Missiles_Predator_x2", [0], 2];
		_predatorDrone addWeaponTurret ["predatorMissile", [0]];
		_predatorDrone selectWeaponTurret ["predatorMissile", [0], "", "Direct"];
		_predatorDrone setMagazineTurretAmmo ["magazine_Missiles_Predator_x2", _missileCount , [0]];
		_predatorDrone setTurretLimits [[0], -135, 0, -55, 0];
		_predatorDrone lockDriver true;
		_predatorDrone lockTurret [[0,0], true];
		_predatorDrone lock 2;
		((findDisplay 46) setVariable ["CameraOBJ", objNull]); //redundant
		((finddisplay 46) setVariable ["PredatorDroneOBJ", _predatorDrone]); 	
	//prevent predator drone from being shot at until player assumes control	
		_predatorDrone setCaptive true;	
		
	// Play Announcer Sounder here
		["PREDATOR", (side Player)] remoteExec ["EXP_fnc_announcerHandler"];
		
	//Camera Switchover & smooth fading
		0 cutText ["", "BLACK OUT", 2, false, false];
		[_predatorDrone, _timeToLive] spawn {
				params
				[
					["_predatorDrone", objNull, [objNull]],
					["_timeToLive", 60, [0]]
				];		
			sleep 2.25;			
			{
				
				(_forEachIndex + 1) cutText [("Predator drone connection:     *CONNECTING*\n" + _x), "BLACK OUT", 0, false, false];
				sleep 0.75;
				if (_forEachIndex >= 1) then {(_forEachIndex) cutText ["", "PLAIN"];}; 
			} foreach [" ."," .."," ..."," .....", " .....", " ......", " .......", " ........", " ........."];
			9 cutText [("Predator drone connection:     *CONNECTED*"), "BLACK OUT", 0, false, false];
			Sleep 2;
			8 cutText ["", "PLAIN"];
			0 cutText ["", "PLAIN"];
			_predatorDrone switchCamera "INTERNAL";
			player remoteControl gunner _predatorDrone;
			9 cutText["Predator drone connection:     *CONNECTED*", "BLACK IN", 2, false, false];
			systemChat ("Predator drone status:     *CONNECTED*");
			
			
	// Killstreak Lifetime limiter
			[_predatorDrone, _timeToLive] spawn {
				params
				[
					["_predatorDrone", objNull, [objNull]],
					["_timeToLiveStatic", 60, [0]]
				];	
				_startTime = time;
				_timeToLive = _timeToLiveStatic;
				while {((alive _predatorDrone) && (_timeToLive > 0))} do {
					sleep 1;
					_timeToLive = (_timeToLiveStatic - (time - _startTime));
					if (((round _timeToLive) % 10) == 0) then {systemChat format ["Drone killstreak time remaining: %1 seconds", round _timeToLive];};
					systemChat str (player getvariable "EXP_usedKillstreakSlot");
				};	
				if (!(alive _predatorDrone)) then {
					[(finddisplay 46) getVariable "PredatorDroneOBJ", true] call EXP_fnc_terminatePredatorStreak;
				}
				else {
					systemchat "Killstreak time expired";
					[(finddisplay 46) getVariable "PredatorDroneOBJ", false] call EXP_fnc_terminatePredatorStreak;
				};
					
			};
			
	//Use this to detect if player releases drone control -> terminate killstreak and remove menu item and 'killstreak in use' variable			
			_killStreakLock = addMissionEventHandler ["PlayerViewChanged", {
				params [
					"_oldUnit", "_newUnit", "_vehicleIn",
					"_oldCameraOn", "_newCameraOn", "_uav"
				];
				
				if ((player getvariable "EXP_missileControlling") == 0) then 
				{
					//check if predator has full ammo left and if player released controls - > force switch camera
					if 
					(
						(_newCameraOn isNotEqualTo ((finddisplay 46) getVariable "PredatorDroneOBJ"))
						&& 
						(_newCameraOn isNotEqualTo ((findDisplay 46) getVariable "CameraOBJ"))
					) 
					then {[((finddisplay 46) getVariable "PredatorDroneOBJ"), false] call EXP_fnc_terminatePredatorStreak; systemChat "Killstreak terminated"};	 
				}
				else {
					//missile in flight, force switch camera to missile camera here.
					if (((findDisplay 46) getVariable "CameraOBJ") isNotEqualTo objNull) then {
						_cam = ((findDisplay 46) getVariable "CameraOBJ");
						switchCamera _cam;  //when missile is destroyed causes cam to be stuck on old missile cam
					
					};
				};
			}];
			(findDisplay 46) setVariable ["killStreakLockEH", _killStreakLock];
			
			sleep 4;
			_predatorDrone setCaptive false;
		};
	//END OF Spawned transitionAnimation
		
		
	// Predator Drone EventHandlers
		_droneKilled = _predatorDrone addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			removeMissionEventHandler ["PlayerViewChanged" ,((findDisplay 46) getVariable "killStreakLockEH")]; //prevents double firing of EXP_fnc_terminatePredatorStreak from the killstreakLOCK EH above^^^
			[_unit, true] call EXP_fnc_terminatePredatorStreak;
			_unit removeEventHandler [_thisEvent, _thisEventHandler];
		}];
		(findDisplay 46) setVariable ["droneKilledEH", _droneKilled];

		_predatorFiredEH = _predatorDrone addEventHandler ["Fired", {
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
		
			if (_ammo isKindOf "ammo_Missile_Predator_01") then {
			
				{
					if ((_unit ammoOnPylon (_forEachIndex + 1)) == 1) exitWith {_unit setAmmoOnPylon [(_forEachIndex + 1), 0]};
				} foreach (getPylonMagazines _unit);
	//Missile init
				_initialPOS = (_unit modelToWorld (_unit selectionPosition "usti hlavne"));
				_projectile setPosATL _initialPOS;
				_Seekerpos = screenToWorld [0.5,0.5];		
				_initVectorUP = [0, 0, (tan ((_initialPOS select 2) / (_initialPOS distance2D _Seekerpos)))];
				_initDIR = _initialPOS vectorFromTo _Seekerpos;
				_projectile setVectorDirAndUp [_initDIR, _initVectorUP];		
				_projectile setMissileTargetPos _Seekerpos;
				[_projectile, -45, 0] call BIS_fnc_setPitchBank;	
				(finddisplay 46) setVariable ["PredatorOBJ", _projectile];			
				(finddisplay 46) setVariable ["PredatorInitYaw", (getDir _projectile)]; 
				player setvariable ["EXP_missileControlling", 1];
				
	//Camera init
				_cam = "camera" camCreate (getPosATL _projectile);
				((findDisplay 46) setVariable ["CameraOBJ", _cam]);
				_cam hideObject true;
				_cam attachTo [_projectile, [0,5,0]];
				_cam cameraEffect ["Internal", "Back"];
				showCinemaBorder false;
				_cam camSetFov 0.25;
				_cam camCommit 0;
				0 cutRsc ["RscMissionScreen", "BLACK IN", 4, false, true];
				1 cutRsc ["RscPredatorMissile", "PLAIN", 2, false, true];
				switchCamera _cam;
				//disableUserInput false;

				//ppEffects
				_ppFilm = ppEffectCreate ["FilmGrain", 2000];
				_ppFilm ppEffectAdjust 
				[
					0.15,  //intensity
					0.45, 	//sharpness
					2.25, 	//grain size
					0.425, 	//intensity X0
					0.425, 	//intensity x1
					0		//monochromatic noise color (0 = b/w, 1 = color)
				];
				_ppFilm ppEffectEnable true;
				_ppFilm ppEffectCommit 0;
				
				_ppGreyScale = ppEffectCreate ["ColorCorrections", 2001];
				_ppGreyScale ppEffectEnable true;
				_ppGreyScale ppEffectAdjust 
				[
					0.6,
					0.6,
					0,
					[0, 0, 0.2, 0.1],
					[1, 1, 1, 0],
					[1, 2, 1, 0]				
				];
				_ppGreyScale ppEffectCommit 0;
				(finddisplay 46) setVariable ["ppEffects", [_ppFilm, _ppGreyScale]]; 
			 
			 
				_opticsModeEH = _cam addEventHandler ["OpticsSwitch", {
					params ["_unit", "_isADS"];
					if (cameraOn == _unit && cameraView == "External") then {			
						_cam switchCamera "Internal";
					};
				}];
				(finddisplay 46) setVariable ["opticsModeEH", _opticsModeEH]; 	
					
					
	
				
/* //Event handler _cameraLock ^^ double firing of playerview changed happens up here somewhere
				_cameraLock = addMissionEventHandler ["PlayerViewChanged", {
					params [
						"_oldUnit", "_newUnit", "_vehicleIn",
						"_oldCameraOn", "_newCameraOn", "_uav"
					];
					//////////////////////////////////////////// THIS HAS NOT BEEN FULLY IMPLEMENTED //////////////////////////////////////////
					//systemChat str [_oldUnit, _newUnit, _vehicleIn, _oldCameraOn, _newCameraOn, _uav];
				}];
				(finddisplay 46) setvariable ["CameraLockEH", _cameraLock];    
*/
				
				
				
				_ppUpdate = addMissionEventHandler ["EachFrame", {
					if (alive (_thisArgs select 0) &&  ((_thisArgs select 1) isEqualType 0)) then {
						//systemChat str [alive (_thisArgs select 0), (((_thisArgs select 1) isEqualType 0))];
						
						_Zpos = (getPosATL (_thisArgs select 0) select 2);
						if (_Zpos <= 1) then {_Zpos = 1};
						_filmIntensity = (1 - ((25 * (sqrt (3.5*_Zpos))) / (_Zpos + 600))) + 0.15;
						_filmParams = [
							_filmIntensity,  //intensity
							0.45, 	//sharpness 0.45
							(_filmIntensity * 4), 	//grain size 2.25
							(_filmIntensity * 0.85), 	//intensity X0 .425
							(_filmIntensity * 0.85), 	//intensity x1	.425
							0 		//monochromatic noise color (0 = b/w, 1 = color)
						];
						(_thisArgs select 1) ppEffectAdjust _filmParams;
						(_thisArgs select 1) ppEffectCommit 0;						
						_Xpos = (getPosATL (_thisArgs select 0) select 0);
						_Ypos = (getPosATL (_thisArgs select 0) select 1);
						// add HUD UI updating world pos & systemTime here
						((uiNamespace getVariable "RscPredatorDisplay") displayCtrl 1120) ctrlSetStructuredText parseText format ["<t align='left' font='EtelkaMonospaceProBold' size='0.7'>%1<br />%2<br />%3</t>", _Xpos, _Ypos, _Zpos];
						
						
					}
					else
					{
						ppEffectDestroy (_thisArgs select 1);
						ppEffectDestroy (_thisArgs select 2);
						removeMissionEventHandler ["EachFrame", _thisEventHandler];
					};
				}, [_projectile, _ppFilm, _ppGreyScale]];
			
			
				
				_XYmouse = (findDisplay 46) displayAddEventHandler ["MouseMoving",{
					params ["_display", "_xDeltaPos", "_yDeltaPos"];	
					_projectile = ((findDisplay 46) getVariable "PredatorOBJ");
					_initYaw = ((findDisplay 46) getVariable "PredatorInitYaw");
					_aspectRatio = (getResolution select 4);
					_curYaw = (getDir _projectile);		
					_pitch = ((_projectile call BIS_fnc_getPitchBank) select 0);
					_xDeltaPos = (_xDeltaPos / _aspectRatio) / 30;
						
					if 
					(
						((_pitch < -22.5) || (_yDeltaPos > 0))
						&&
						((_pitch > -77.75) || (_yDeltaPos < 0))
					)
					then
					{
						_yDeltaPos = (_yDeltaPos / 40);	
					}
					else
					{
						_yDeltaPos = 0;
					};
					_newMissilePos = screenToWorld ([0.5, 0.5] vectorAdd [_xDeltaPos, _yDeltaPos]);
					_projectile setMissileTargetPos _newMissilePos;
					[_projectile, _pitch, 0] call BIS_fnc_setPitchBank;
				}];  
				(finddisplay 46) setvariable ["MouseEH", _XYmouse];
				
				_mouseButtonBoost = (findDisplay 46) displayAddEventHandler ["MouseButtonDown",{
					params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
					_projectile = ((findDisplay 46) getVariable "PredatorOBJ");
					if (((velocityModelSpace _projectile) select 1) < 350) then {
						_projectile setVelocityModelSpace [0,425,0];
						playSoundUI ["\Killstreaks\data\Sounds\PredatorMissile\exp_40mm_distant_impact2.wav", 2.0, 0.6];
					
					};
				}];
				(finddisplay 46) setvariable ["MouseButtonDownEH", _mouseButtonBoost];
			
			

				_projectileEH = _projectile addEventHandler ["Deleted", {
					params ["_projectile"];
					playSoundUI ["\Killstreaks\data\Sounds\PredatorMissile\scn_predator_static_burst.wav", 0.50 , 0.65];
					//order of camera being deleted and switchcamera to predator drone is important for (player spectator/camera handling EH above when retutning camera to missile camera)
					_cam = ((findDisplay 46) getVariable "CameraOBJ");
					_cam cameraEffect ["Terminate", "Back"];
					camDestroy _cam;
					((findDisplay 46) setVariable ["CameraOBJ", objNull]);
					_predatorDrone = (finddisplay 46) getVariable "PredatorDroneOBJ"; 
					_predatorDrone switchCamera "Internal";
					player remoteControl (gunner _predatorDrone);
					0 cutText ["", "PLAIN"];
					1 cutText ["", "PLAIN"];
					player setvariable ["EXP_missileControlling", 0];
					if (!((findDisplay 46) isNil "MouseEH")) then {
						(findDisplay 46) displayRemoveEventHandler ["MouseMoving", ((findDisplay 46) getVariable "MouseEH")];
						(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", ((findDisplay 46) getVariable "MouseButtonDownEH")];
					};
					((findDisplay 46) setVariable ["MouseEH", nil]);
					((findDisplay 46) setVariable ["MouseButtonDownEH", nil]);
					//if (!((findDisplay 46) isNil "CameraLockEH")) then {removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "CameraLockEH")];};
					((findDisplay 46) setVariable ["ProjectileEH", nil]);	
					if ((_predatorDrone magazineTurretAmmo ["magazine_Missiles_Predator_x2", [0]]) == 0) then {[_predatorDrone, false] call EXP_fnc_terminatePredatorStreak;};
					_projectile removeEventHandler ["Deleted", _thisEventHandler];
				}]; 
				(findDisplay 46) setVariable ["ProjectileEH", _projectileEH];
			};	
		}];
		(finddisplay 46) setvariable ["PredatorFiredEH" ,_predatorFiredEH];
	};
	
	
	EXP_fnc_terminatePredatorStreak = {
		params 
		[
			["_predatorDrone", objNull, [objNull]],
			["_shotDown", false, [false]]
		];	
		// If not spawned with added sleep delay the game will crash between remotecontrol being returned to player and previous camera being deleted,...
		[_predatorDrone, _shotdown] spawn {
			params 
			[
				["_predatorDrone", objNull, [objNull]],
				["_shotDown", false, [false]]
			];	
			
			if ((_predatorDrone isNotEqualTo objNull) && (_shotDown isEqualTo false)) then {
				removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "killStreakLockEH")];
				_predatorDrone removeEventHandler ["Killed", ((findDisplay 46) getVariable "droneKilledEH")];
				_predatorDrone removeEventHandler ["Fired",((findDisplay 46) getVariable "PredatorFiredEH")];
				deleteVehicleCrew _predatorDrone;
				deleteVehicle _predatorDrone;	
			};

			if (cameraOn isNotEqualTo player) then {
				switchCamera Player;
				cameraon cameraEffect ["Terminate", "Back"];
				{ppEffectDestroy _x;} foreach ((finddisplay 46) getVariable "ppEffects");
			};
			
			if (isRemoteControlling player) then {player remoteControl objNull;};
			0 cutText ["", "PLAIN"];
			1 cutText ["", "PLAIN"];
			sleep 0.1;
			_cam = ((findDisplay 46) getVariable "CameraOBJ");
			
			if (_cam isNotEqualTo objNull) then {
				_cam removeEventHandler ["OpticsSwitch", ((finddisplay 46) getVariable "opticsModeEH")];
				camDestroy _cam;
				((findDisplay 46) setVariable ["CameraOBJ", objNull]);
			};
			{deleteWaypoint [(group _predatorDrone), (_x select 1)];} forEach (waypoints _predatorDrone);
			

			if (!((findDisplay 46) isNil "MouseEH")) then {  //this might be redundant due to the 'deleted' EH already handling them
			
				(findDisplay 46) displayRemoveEventHandler ["MouseMoving", ((findDisplay 46) getVariable "MouseEH")];
				(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", ((findDisplay 46) getVariable "MouseButtonDownEH")];
				//removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "CameraLockEH")];	
			};
			
			if (((findDisplay 46) getVariable "PredatorOBJ") isNotEqualTo objNull) then {triggerAmmo ((findDisplay 46) getVariable "PredatorOBJ");};
			((finddisplay 46) setvariable ["PredatorFiredEH" ,nil]);
			((findDisplay 46) setVariable ["droneKilledEH", nil]);
			//((findDisplay 46) setVariable ["CameraLockEH", nil]);
			((findDisplay 46) setVariable ["killStreakLockEH", nil]);
			((findDisplay 46) setVariable ["MouseEH", nil]);
			((findDisplay 46) setVariable ["MouseButtonDownEH", nil]);
			((findDisplay 46) setVariable ["ProjectileEH", nil]);
			((finddisplay 46)setVariable ["ppEffects", nil]);
			player setvariable ["EXP_killstreakIsActive", 0];
			player setvariable ["EXP_missileControlling", 0];
			[] call bis_fnc_refreshCommMenu;
		
		};
	};
	
};


EXP_fnc_deployPrecisionAirstrike = {
	//Bugs for Precision Airstrike:

	//Debug for precision airstrike:
	//switchcamera (((finddisplay 46) getVariable "airstrikePlanesOBJ") select 0); player remoteControl (((finddisplay 46) getVariable "airstrikePlanesOBJ") select 0); 

	openMap [false, false];  //prevent 2 streaks from being used at same time

	//Map Event Handlers
	player setVariable ["EXP_mapPos1", nil];
	
	_drawEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", { 
		
		if ((player isNil "EXP_mapPos1")) then { 
			((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], ((findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition), 60, 60, 0, "", 2, 0.1];
		};
					
		if (!(player isNil "EXP_mapPos1")) then {
			_worldPos2 = (findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition;
			_worldpos1 = (player getVariable "EXP_mapPos1");
			((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], _worldpos1, 75, 75, 0, "Airstrike Target", 2, 0.075, "PuristaMedium", "right"];
			((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\ui_tickring.paa", [1,1,1,1], _worldpos1, 70, 70, 0, "", 2, 0.1];
			((findDisplay 12) displayCtrl 51) drawArrow [_worldpos1, _worldPos2, [1,0,0,1]];
			((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], _worldPos2, 35, 35, 0, ":: Aircraft Direction ::", 2, 0.075, "PuristaMedium", "left"];

		};

	}];
	(findDisplay 12) setVariable ["EXP_drawEH", _drawEH];

	
	
	_clickEHID = addMissionEventHandler ["MapSingleClick", 
	{
		params ["_units", "_pos", "_alt", "_shift"];
		//need to set a maximum distance
		if (((_pos distance2D player) > 3500) && (player isNil "EXP_mapPos1")) then 
		{
			systemChat format ["Maximum distance from player: 4000 meters; Current distance: %1 meters",(_pos distance2D player)];
		}
		else
		{

			if (player isNil "EXP_mapPos1") then {
			
				player setVariable ["EXP_mapPos1", _pos];
			}
			else 
			{
				_vectorDIF = _pos vectorDiff (player getVariable "EXP_mapPos1");
				_vectorDIR =  (player getVariable "EXP_mapPos1") vectorFromTo _pos;
				openMap [false, false];	
				_kilstreakslots = (player getVariable "EXP_killstreakSlots");
				((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", ((findDisplay 12) getVariable "EXP_drawEH")];
				[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;		
				((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
				[(player getVariable "EXP_mapPos1"), _vectorDIR] call EXP_fnc_spawnAirstrikeBombers;	
				
			};
			
		};
	}, []];

	_mapEHID = addMissionEventHandler ["Map", 
	{
		params ["_mapIsOpened", "_mapIsForced"];
		if (_mapIsOpened == false) then 
		{
			removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
			removeMissionEventHandler ["Map" ,_thisEventHandler];	
			((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", (_thisArgs select 1)];
			((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
		};
	}, [_clickEHID, _drawEH]];


	//Main Script
	openMap [true, false];
	((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "blankTrack"];

	EXP_fnc_spawnAirstrikeBombers = {
		//USAGE:
		//_TargetPos: DATATYPE = 2D vector [x,x,0]  WHAT: ATLpos Array of the location chosen on the map.
		// _vectorDIR: DATATYPE = 2D vector  [x,x,0]  WHAT:	vectorDIR between (target position) & (plane flight direction) chosen on map.

		params 
		[
			["_TargetPos", [], [[]]],
			["_vectorDIR", [], [[]]]
		];
		//Configurable settings
		_spawnDistance = 8000;
		_flyHeight = (missionNamespace getVariable ["EXP_airstrikeFlyHeight", 400]);  
		_laserDispersionRadius = (missionNamespace getVariable ["EXP_airstrikeRadius", 25]);
		_bombPylonRack = (missionNamespace getVariable ["EXP_airstrikeBombCount", "PylonMissile_Bomb_GBU12_x1"]);
		//_numLaserAvailibleTargets = ((1.75 * (missionNamespace getVariable "EXP_airstrikeJetCount")) + ((_laserDispersionRadius * 0.01) * ((missionNamespace getVariable "EXP_airstrikeJetCount")/2)));
		_numLaserAvailibleTargets = 35;
		_flightspeed = 250;

		["AIRSTRIKE", (side Player)] remoteExec ["EXP_fnc_announcerHandler"];

		//Target marker
		_airStrikeMarker = createMarker ["AirstrikeTargetArea", _TargetPos, 1, player];	
		_airStrikeMarker setMarkerText "Precision Airstrike: Target area";
		_airStrikeMarker setMarkerShape "ELLIPSE";
		_airStrikeMarker setMarkerSize [_laserDispersionRadius, _laserDispersionRadius];
		_airStrikeMarker setMarkerBrush "DiagGrid";
		_airStrikeMarker setMarkerAlpha 1.0;
		_airStrikeMarker setMarkerAlphaLocal 1.0;
		_airStrikeMarker setMarkerColor "#(1,0,0,1)";
		
		
		//Initial static variable declaration and formatting
		_strikeAircraftList = [];
		_lasersList = [];
		_degreeDIR = ((_vectorDIR select 0) atan2 (_vectorDIR select 1));
		_degreeDIR = (_degreeDIR + 360) % 360;
		//_TargetPos //unmodified 'static' initial target POS Clamp
		_spawnPos = ([(-(sin _degreeDIR)), (-(cos _degreeDIR)), _flyHeight] vectorMultiply [_spawnDistance, _spawnDistance, 1]) vectorAdd _TargetPos;  //unmodified 'static' spawn POS Clamp
		_waypointPosASL = (ATLToASL (([((sin _degreeDIR)), ((cos _degreeDIR)), _flyHeight] vectorMultiply [_spawnDistance, _spawnDistance, 1]) vectorAdd _TargetPos)); //unmodified 'static' waypoint POS Clamp
		_laserType = (["LaserTargetW", "LaserTargetE", "LaserTargetC"] select ([west, east, independent] find playerSide));
		
		//Dynamic Variables for initial locations for first strike aircraft
		_veeDIR = 0;
		_randomOffsetMultiplier = 1;
		_distributedTargetPos = _TargetPos; 
		_distributedSpawnPos = _spawnPos;
		_distributedWaypointPosASL = _waypointPosASL;
		_distributedTargetOffset = [0,0];
		_laserOffset = [0, 0, 6];//5 to prevent ground clipping issues
		
		//Primary laser carrier to prevent laser TimeToLive expiry
		_laserCarrier = createVehicle ["Land_CanisterPlastic_F" , _TargetPos, [], 0, "CAN_COLLIDE"]; 	
		_laserCarrier enableSimulationGlobal false; //should be forced to remain static
		_laserCarrier hideObject true;
		
		
		for "_i" from 0 to _numLaserAvailibleTargets step 1 do {
			///Laser target spawning
			_laser = createVehicle [_laserType , [0,0], [], 0, "CAN_COLLIDE"];
			if (_i > 0) then {_laserOffset = [ (random [(-_laserDispersionRadius), 0, _laserDispersionRadius]), (random [(-_laserDispersionRadius), 0, _laserDispersionRadius]), 6];};  //6m to prevent ground clipping issues
			_laser attachTo [_laserCarrier, _laserOffset];
			_laser confirmSensorTarget [(playerSide), true];
			_lasersList pushBack _laser;
		};
		

	
		for "_i" from 1 to ((missionNamespace getVariable "EXP_airstrikeJetCount")) step 1 do {
			
			if (_i > 1) then {
			//Positional Data Configuration
				_veeDIR = selectRandom [(_degreeDIR + 135), (_degreeDIR - 135)];
				_randomOffsetMultiplier = ([100,100] vectorMultiply [cos _veeDIR, sin _veeDIR]);	//multiplier of 15 times the square of the plane count
				_randomOffsetMultiplier = _randomOffsetMultiplier vectorMultiply ((_i ^ 1.25));  ///scales with the square of plane count
				_distributedTargetPos = (_TargetPos vectorAdd _randomOffsetMultiplier);
				_distributedSpawnPos = (_spawnPos vectorAdd (_randomOffsetMultiplier vectorMultiply [(-(sin _degreeDIR)), (-(cos _degreeDIR))]));
				_distributedWaypointPosASL = (_waypointPosASL vectorAdd _randomOffsetMultiplier);
				_distributedTargetOffset = [0,0];			
			};
			
			//Aircraft spawning and Waypoints handling
			_bomberPlane = createVehicle ["B_Plane_Fighter_01_F", _distributedSpawnPos, [], 0, "CAN_COLLIDE"];
			(side player) createVehicleCrew _bomberPlane;	
			_yaw = _degreeDIR; _pitch = 0; _roll = 0;
			_bomberPlane setVectorDirAndUp [
				[sin _yaw * cos _pitch, cos _yaw * cos _pitch, sin _pitch],
				[[sin _roll, -sin _pitch, cos _roll * cos _pitch], -_yaw] call BIS_fnc_rotateVector2D
			];
			_bomberPlane engineOn true;
			_bomberPlane allowDamage false; //this might need to be remoteexec'd on server / sp host
			_bomberPlane setVelocityModelSpace [0,_flightspeed,0];
			removeAllMagazines _bomberPlane;
			{_bomberPlane removeweapon _x} forEach (weapons _bomberPlane);
			_bomberPlane addWeapon "weapon_GBU12Launcher";  //"weapon_SDBLauncher", "Mk82BombLauncher"
			
			
			{[_bomberPlane, [_x, _bombPylonRack, true]] remoteExec ["setPylonLoadout",_bomberPlane];} forEach [1,2,3,4];
			//{_bomberPlane setPylonLoadout [_x, _bombPylonRack, true];} foreach [1,2,3,4]; // "PylonRack_Bomb_SDB_x4", "PylonMissile_1Rnd_Mk82_F"    //should be remoteexecd by server???
			_bomberPlane setAmmoOnPylon [1,4];
			_bomberPlane addWeapon "CMFlareLauncher";
			_bomberPlane addMagazine "240Rnd_CMFlareMagazine";	
			_bomberPlane forceSpeed _flightspeed; 
			_bomberPlane lockDriver true;
			_bomberPlane lock 2;
			_bomberPlane flyInHeightASL [_flyHeight, _flyHeight, _flyHeight];

			_waypoint1 = group(_bomberPlane) addWaypoint [(ATLToASL _distributedTargetPos), -1, 1, "airstrikeTarget"];  //_selectionPosASL
			group(_bomberPlane) setCombatMode "BLUE";
			group(_bomberPlane) setCombatBehaviour "Careless"; 
			_waypoint1 setWaypointBehaviour "Careless";
			_waypoint1 setWaypointSpeed "FULL";  
			_waypoint1 setWaypointType "MOVE";
			_waypoint1 setWaypointForceBehaviour true;
			_waypoint1 setWaypointCompletionRadius 25;
			group(_bomberPlane) setCurrentWaypoint _waypoint1;
			_waypoint1 setWaypointVisible true;
			_waypoint1 showWaypoint "ALWAYS";
			_waypoint2 = group(_bomberPlane) addWaypoint [_distributedWaypointPosASL, -1, 2, "airstrikeExtract"];
			
			_strikeAircraftList pushBack _bomberPlane;
			

			[_bomberPlane, _TargetPos, _lasersList] spawn {
				params 
				[
					["_bomberPlane", objNull, [objNull]],
					["_TargetPos", [], [[]]],
					["_lasersList", [], [[]]]
				];
			
				_selectedTarget = (_lasersList select 0); //first round hit of target center
				(driver _bomberPlane) doTarget (_selectedTarget);
				
				_randomFlareBursts = (round (random [2,3,6]));
				while {(alive _bomberPlane)} do 
				{
					 sleep 0.10;
					if ((((getPosATL _bomberPlane) distance2D _TargetPos) <= 2260) && ((_bomberPlane ammoOnPylon 4) isNotEqualTo 0)) then
					{
						{
							for "_i" from 0 to (_bomberPlane ammoOnPylon _x) step 1 do {
								//driver _bomberPlane forceWeaponFire ["weapon_GBU12Launcher", "LoalAltitude"];  //sdblauncher is ["weapon_SDBLauncher", "weapon_SDBLauncher"] //////"LoalAltitude"
								driver _bomberPlane fireAtTarget [_selectedTarget];
								_selectedTarget = selectRandom _lasersList;
								(driver _bomberPlane) doTarget _selectedTarget;
								sleep random [0.35, 0.55, 0.80];
							};
							
						}foreach [1,2,3,4];
					};
					
					if (((getPosATL _bomberPlane) distance2D _TargetPos) <= 700) exitWith {
					
						for "_i" from 0 to _randomFlareBursts step 1 do {
						
							sleep (random 4);
							(driver _bomberPlane) forceWeaponFire ["CMFlareLauncher", "Burst"];
						
						};
					};
					
				};
			};
		};
		((finddisplay 46) setVariable ["airstrikePlanesOBJ", _strikeAircraftList]);
		((finddisplay 46) setVariable ["airstrikeMarker", _airStrikeMarker]);
		((finddisplay 46) setVariable ["airstrikeLasers", _lasersList]);  	
		
		//waypoint EH to delete all resources
		(group (_strikeAircraftList select 0)) addEventHandler ["WaypointComplete", {
			params ["_group", "_waypointIndex"];
			if (_waypointIndex isEqualTo 2) then {
				
				{
					if (((attachedTo _x) isNotEqualTo objNull)) then {deleteVehicle (attachedto _x);};
					deleteVehicle _x;
				} forEach ((finddisplay 46) getVariable "airstrikeLasers");
				{deleteVehicleCrew _x; deleteVehicle _x;} forEach ((finddisplay 46) getVariable "airstrikePlanesOBJ");
				deleteMarker ((finddisplay 46) getVariable "airstrikeMarker");
			
			};

		}];

	};
};


EXP_fnc_deployChopperGunner = {};


EXP_fnc_deployAC130 = {};


EXP_fnc_deployNuke = {

/*
Debug for NUKE:
	switchcamera ((finddisplay 46) getVariable "NukeDroneOBJ"); player remoteControl ((finddisplay 46) getVariable "NukeDroneOBJ"); 
*/

//BUGS FOR NUKE KS / To-Do:
	//if another controlled KS is used during nuke sequence the rsctitle clock and animatedPAA no longer show (predator drone eg.), might change from rsctitle to createdisplay?
	// Precaching PAAs might be pointless
	// delete markers
	// delete UCAV + crew

	openMap [false, false];  //prevent 2 streaks from being used at same time
//if ((player getvariable "EXP_killstreakIsActive") == 1) exitWith { systemChat "Another killstreak is currently in use";};
//Map Event Handlers
		player setVariable ["EXP_mapPos1", nil];
		
		_drawEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", { 
			
			if ((player isNil "EXP_mapPos1")) then { 
				((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], ((findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition), 60, 60, 0, "", 2, 0.1];
			};
						
			if (!(player isNil "EXP_mapPos1")) then {
				_worldPos2 = (findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition;
				_worldpos1 = (player getVariable "EXP_mapPos1");
				((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], _worldpos1, 75, 75, 0, "Airstrike Target", 2, 0.075, "PuristaMedium", "right"];
				((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\ui_tickring.paa", [1,1,1,1], _worldpos1, 70, 70, 0, "", 2, 0.1];
				((findDisplay 12) displayCtrl 51) drawArrow [_worldpos1, _worldPos2, [1,0,0,1]];
				((findDisplay 12) displayCtrl 51) drawIcon ["\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa", [1,1,1,1], _worldPos2, 35, 35, 0, ":: Aircraft Direction ::", 2, 0.075, "PuristaMedium", "left"];

			};

		}];
		(findDisplay 12) setVariable ["EXP_drawEH", _drawEH];

		
		
		_clickEHID = addMissionEventHandler ["MapSingleClick", 
		{
			params ["_units", "_pos", "_alt", "_shift"];
			//need to set a maximum distance
			if (((_pos distance2D player) > 6000) && (player isNil "EXP_mapPos1")) then 
			{
				systemChat format ["Maximum distance from player: 6000 meters; Current distance: %1 meters",(_pos distance2D player)];
			}
			else
			{

				if (player isNil "EXP_mapPos1") then {
				
					player setVariable ["EXP_mapPos1", _pos];
				}
				else 
				{
					_vectorDIF = _pos vectorDiff (player getVariable "EXP_mapPos1");
					_vectorDIR =  (player getVariable "EXP_mapPos1") vectorFromTo _pos;
					openMap [false, false];	
					_kilstreakslots = (player getVariable "EXP_killstreakSlots");
					((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", ((findDisplay 12) getVariable "EXP_drawEH")];
					[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;		
					((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
					[(player getVariable "EXP_mapPos1"), _vectorDIR] call EXP_fnc_spawnNukeCarrier;	
					
				};
				
			};
		}, []];

		_mapEHID = addMissionEventHandler ["Map", 
		{
			params ["_mapIsOpened", "_mapIsForced"];
			if (_mapIsOpened == false) then 
			{
				removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
				removeMissionEventHandler ["Map" ,_thisEventHandler];	
				((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", (_thisArgs select 1)];
				((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
			};
		}, [_clickEHID, _drawEH]];
	
	
	
	
	
		//Main Script
		openMap [true, false];
		((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "blankTrack"];
	
	
	

		//Functions
		EXP_fnc_spawnNukeCarrier = {
			//USAGE:
			//_TargetPos: DATATYPE = 2D vector [x,x,0]  WHAT: ATLpos Array of the location chosen on the map.
			// _vectorDIR: DATATYPE = 2D vector  [x,x,0]  WHAT:	vectorDIR between (target position) & (plane flight direction) chosen on map.
			params 
			[
				["_TargetPos", [], [[]]],
				["_vectorDIR", [], [[]]]
			];
			_nuclearMarker = createMarker ["NuclearStrikeTarget", _TargetPos, 1, player];	
			_nuclearMarker setMarkerSize [4,4];
			_nuclearMarker setMarkerAlpha 1.0;
			_nuclearMarker setMarkerAlphaLocal 1.0;
			_nuclearMarker setMarkerShape "ICON";
			_nuclearMarker setMarkerType "nuclear_Target";
			
			_degreeDIR = ((_vectorDIR select 0) atan2 (_vectorDIR select 1));
			_degreeDIR = (_degreeDIR + 360) % 360;
			
			_spawnDistance = 6000;
			_flyHeight = 800;
			_spawnPos = ([(-(sin _degreeDIR)), (-(cos _degreeDIR)), _flyHeight] vectorMultiply [_spawnDistance, _spawnDistance, 1]) vectorAdd _TargetPos;
			_waypointPos = ([((sin _degreeDIR)), ((cos _degreeDIR)), _flyHeight] vectorMultiply [_spawnDistance, _spawnDistance, 1]) vectorAdd _TargetPos;
			_waypointPosASL = (ATLToASL _waypointPos);
			

			_nukeDrone = createVehicle ["B_UAV_05_F", _spawnPos, [], 0, "CAN_COLLIDE"];
			(side player) createVehicleCrew _nukeDrone;	
			_yaw = _degreeDIR; _pitch = 0; _roll = 0;
			_nukeDrone setVectorDirAndUp [
				[sin _yaw * cos _pitch, cos _yaw * cos _pitch, sin _pitch],
				[[sin _roll, -sin _pitch, cos _roll * cos _pitch], -_yaw] call BIS_fnc_rotateVector2D
			];
			
			_nukeDrone engineOn true;
			_nukeDrone allowDamage false; //this might need to be remoteexec'd on server / sp host
			_nukeDrone setVelocityModelSpace [0,150,0];
			_nukeDrone removeWeaponTurret ["Laserdesignator_mounted", [0]];
			_nukeDrone removeWeaponTurret ["weapon_GBU12Launcher", [0]];
			_nukeDrone removeMagazinesTurret ["PylonMissile_Bomb_GBU12_x1", [0]];
			//_nukeDrone addMagazinesTurret ["PylonMissile_Bomb_GBU12_x1", [0], 16]; // PylonMissile_Bomb_GBU12_x1, "2Rnd_GBU12_LGB", "PylonMissile_1Rnd_BombCluster_03_F" //////////////////////// FSNB_B61_4_M,  FSNB_B61_4_Timed_M, FSNB_AGM_86B_M,  FSNB_AGM_86B_Cruise_M, FSNB_155mm_W48_Nuclear_M
			//_nukeDrone addWeaponTurret ["FSNB_B61_4_W", [0]];    /// "weapon_GBU12Launcher", "BombCluster_03_F", //////////////////////////// FSNB_B61_4_W, FSNB_B61_4_Timed_W, FSNB_AGM_86B_W, FSNB_AGM_86B_Cruise_W
			//{_nukeDrone setPylonLoadout [_x, "FSNB_B61_4_M", true];} foreach [1];
			_nukeDrone addWeaponTurret ["weapon_GBU12Launcher", [0]];    /// "weapon_GBU12Launcher", "GBU12BombLauncher","BombCluster_03_F", //////////////////////////// FSNB_B61_4_W, FSNB_B61_4_Timed_W, FSNB_AGM_86B_W, FSNB_AGM_86B_Cruise_W
			
			{[_nukeDrone, [_x, "PylonMissile_Bomb_GBU12_x1", true]] remoteExec ["setPylonLoadout", _nukeDrone];} foreach [1];
			//{_nukeDrone setPylonLoadout [_x, "PylonMissile_Bomb_GBU12_x1", true];} foreach [1];  //should be remoteexecd by server???
			_nukeDrone setAmmoOnPylon [1,1];
			_nukeDrone forceSpeed 150; //500 km/h
			_nukeDrone lockDriver true;
			_nukeDrone lockTurret [[0,0], true];
			_nukeDrone lock 2;
			_nukeDrone flyInHeightASL [_flyHeight, _flyHeight, _flyHeight];
			
			_waypoint1 = group(_nukeDrone) addWaypoint [(ATLToASL _TargetPos), -1, 1, "nukeTarget"];  //_selectionPosASL
			group(_nukeDrone) setCombatMode "BLUE";
			group(_nukeDrone) setCombatBehaviour "Careless"; //CARELESS
			_waypoint1 setWaypointBehaviour "Careless";
			_waypoint1 setWaypointSpeed "FULL";  //LIMITED
			_waypoint1 setWaypointType "MOVE";
			_waypoint1 setWaypointForceBehaviour true;
			_waypoint1 setWaypointCompletionRadius 25;
			//_waypoint1 setWaypointScript "";
			group(_nukeDrone) setCurrentWaypoint _waypoint1;
			_waypoint1 setWaypointVisible true;
			_waypoint1 showWaypoint "ALWAYS";
			_waypoint2 = group(_nukeDrone) addWaypoint [_waypointPosASL, -1, 2, "nukeExtract"];
			
			_laserType = (["LaserTargetW", "LaserTargetE", "LaserTargetC"] select ([west, east, independent] find playerSide));
			_laserCarrier = createVehicle ["Land_CanisterPlastic_F" , _TargetPos, [], 0, "CAN_COLLIDE"]; 
			hideObject _laserCarrier;
			_laser = createVehicle [_laserType , [0,0], [], 0, "CAN_COLLIDE"]; //_TargetPos -> [0,0]
			_laser attachTo [_laserCarrier,[0,0,0]];
			_laser confirmSensorTarget [(playerSide), true];
			
/* 			_droneMarker2 = createMarker [("INFNIL"), _spawnPos, 1, player];
			_droneMarker2 setMarkerType "mil_objective_noShadow";
			_droneMarker2 setMarkerText "INFNIL";
			_droneMarker2 setMarkerColor "ColorBlack";
			_droneMarker2 setMarkerAlpha 1;
			_droneMarker3 = createMarker [("EXFIL"), _waypointPosASL, 1, player];
			_droneMarker3 setMarkerType "mil_objective_noShadow";
			_droneMarker3 setMarkerText "EXFIL";
			_droneMarker3 setMarkerColor "ColorBlack";
			_droneMarker3 setMarkerAlpha 1; 
*/
			
			
			((finddisplay 46) setVariable ["NukeMarker", _nuclearMarker]);
			((finddisplay 46) setVariable ["NukeLaserOBJ", _laser]); 
			((finddisplay 46) setVariable ["NukeDroneOBJ", _nukeDrone]); 	
			
			[_nukeDrone, _TargetPos, _laser] spawn {
				params 
				[
					["_nukeDrone", objNull, [objNull]],
					["_TargetPos", [], [[]]],
					["_laser", objNull, [objNull]]
				];
			
				(driver _nukeDrone) doTarget _laser;
				while {alive _nukeDrone} do 
				{
					 sleep 0.10;
					if (((getPosATL _nukeDrone) distance2D _TargetPos) <= 2020) exitWith
					{
						{_nukeDrone animatebay [_x, 1];} foreach [1,2];
						(driver _nukeDrone) fireAtTarget [_laser];
					};
				};
			};
				
			//play killstreak announcer incoming effect here
			["NUKE", (side Player)] remoteExec ["EXP_fnc_announcerHandler"];
			[_nukeDrone] remoteExec ["EXP_fnc_nukeCountdown"];
				
			
			_NukeFiredEH = _nukeDrone addEventHandler ["Fired", {
				
				params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
				
				_projectileEH = _projectile addEventHandler ["Deleted", {
					params ["_projectile"];
					_projectilePOS = getPosASL _projectile;
					_yield = (missionNamespace getVariable "EXP_nukeYield");
					[_projectilePOS, _yield, false, [true, true, false, true, true, true, true, true, true, true], -1, -1] spawn freestylesNuclearBlast_fnc_initBlast;
					//things to do on activation of nuke (delete marker, end timer & sound)
					

					deleteMarker ((finddisplay 46) getVariable "NukeMarker");
					deleteVehicle (attachedTo ((finddisplay 46) getVariable "NukeLaserOBJ"));
					deleteVehicle ((finddisplay 46) getVariable "NukeLaserOBJ"); 
					//deleteVehicleCrew ((finddisplay 46) getVariable "NukeDroneOBJ"); 	
					//deleteVehicle ((finddisplay 46) getVariable "NukeDroneOBJ");
					
					
				}]; 
				
				(findDisplay 46) setVariable ["ProjectileEH", _projectileEH];	
			}];

		};
		
		

		
		
		//function for alert noise, and countdown timer (time is set in the config.cpp rscNukecountdown onload/unload)
		EXP_fnc_nukeCountdown = {
			params 
			[
				["_nukeDrone", objNull, [objNull]]
			];

			"nuke" cutRsc ["rscNukeCountdown", "PLAIN", 2, false, true];
			(findDisplay 46) setVariable ["EXP_precache", 1];
			//((uiNamespace getVariable "rscNukeCountdown") displayCtrl 1130) ctrlSetTextColor [1,1,1,0];
			
			addMissionEventHandler ["EachFrame", {
				//precache PAAs into memory???
				_control = ((uiNamespace getVariable "rscNukeCountdown") displayCtrl 1130);
				_precache = (findDisplay 46 getVariable "EXP_precache");
				if (_precache <= 32) then {
					if ((diag_frameNo % 2) == 0) then {
						_control ctrlSetScale (0.001);
						_control ctrlSetText (("\Killstreaks\data\UI\Nuke\") + ((str _precache) + ".paa"));
						//_control ctrlSetTextColor [1,1,1,0];
						_control ctrlCommit 0;
						(findDisplay 46 setVariable ["EXP_precache", (_precache + 1)]);
					};
				}
				else {
					_control ctrlSetScale (1);
					_control ctrlCommit 0;
					_control ctrlSetTextColor [1,1,1,1];
					if ((diag_frameNo % 3) == 0) then {
						_IMGcount = (uiNamespace getVariable "rscNukePAA");
						if ((_IMGcount == 0) || (_IMGcount == 32)) then {
							_IMGcount = 1;
							uiNamespace setVariable ["rscNukePAA", _IMGcount];
						}
						else 
						{
							_IMGcount = ((uiNamespace getVariable "rscNukePAA") + 1);
							uiNamespace setVariable ["rscNukePAA", _IMGcount];
						};
						_control ctrlSetText (("\Killstreaks\data\UI\Nuke\") + ((str _IMGcount) + ".paa"));
						
						_Timer = ((uinamespace getVariable "rscNukeTimer") - (diag_deltaTime * 3));
						if (!(isGamePaused)) then {
							uinamespace setVariable ["rscNukeTimer", _Timer];
						};

						if (_Timer >= 0) then {
							if (round _Timer >= 10) then {
								((uiNamespace getVariable "rscNukeCountdown") displayCtrl 1131) ctrlSetText ("00:00:" + (str (round _Timer)));
							}
							else {
								((uiNamespace getVariable "rscNukeCountdown") displayCtrl 1131) ctrlSetText ("00:00:0" + (str (round _Timer)));
							};
						}
						else 
						{
							"nuke" cutText ["", "PLAIN"];
						};
					};	
				};
			}];	

			[_nukeDrone] spawn {
				params 
				[
					["_nukeDrone", objNull, [objNull]]
				];
				waitUntil {alive _nukeDrone};
				sleep 0.5;
				while {(alive _nukeDrone) && !(((uiNamespace getVariable "rscNukeCountdown") displayCtrl 1131) isEqualTo controlNull)} do 
				{	
					playSoundUI ["\Killstreaks\data\Sounds\Nuke\ui_mp_nukebomb_v2.wav", 4, 1];
					sleep 1.60;
				
				};

			};
			
			
		};

	};

};




////////////////////////////   END OF KILLSTREAK SPAWNERS //////////////////////////////////


EXP_fnc_unitPlayPlanes = {


};


EXP_fnc_announcerHandler = {
	params 
	[
		["_rewardType", "", [""]],
		["_initiatorSide", sideEmpty, [sideEmpty]]
	];
	//playSoundUI ["\Killstreaks\data\Sounds\Nuke\Russian\RU_1mc_achieve_tnuke_01.wav",1 ,1];


	switch (_rewardType) do 
	{
		case "UAV" : {
			
			[_rewardType, _initiatorSide] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_initiatorSide", sideEmpty, [sideEmpty]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				switch (playerSide isEqualTo _initiatorSide) do {
					case true: {
					
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_use_uav_01.wav",
									"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_use_uav_01.wav",
									"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_use_uav_01.wav"				
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_use_uav_01.wav", 							
									"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_use_uav_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_use_uav_01.wav" 	
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_02.wav"};
						};
					};
					case false: {
						
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_enemy_uav_02.wav",
									"\Killstreaks\data\Sounds\UAV\Rangers\US_1mc_enemy_uav_03.wav",
									"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_enemy_uav_02.wav",
									"\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_enemy_uav_03.wav",
									"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_enemy_uav_02.wav",
									"\Killstreaks\data\Sounds\UAV\NS\NS_1mc_enemy_uav_03.wav"									
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_enemy_uav_01.wav", 
									"\Killstreaks\data\Sounds\UAV\Russian\RU_1mc_enemy_uav_02.wav",							
									"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_enemy_uav_01.wav",
									"\Killstreaks\data\Sounds\UAV\PG\PG_1mc_enemy_uav_02.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_enemy_uav_02.wav", 
									"\Killstreaks\data\Sounds\UAV\Arabic\AB_1mc_enemy_uav_03.wav"
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\UAV\TF141\UK_1mc_achieve_uav_02.wav"};
						};

					};
				};
				playSoundUI [_initSound, 1.0, 1.0];		
			};		
		};
				
		case "PREDATOR" : {
			[_rewardType, _initiatorSide] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_initiatorSide", sideEmpty, [sideEmpty]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				switch (playerSide isEqualTo _initiatorSide) do {
					case true: {
					
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Rangers\US_1mc_use_predator_01.wav",
									"\Killstreaks\data\Sounds\PredatorMissile\Rangers\US_1mc_use_predator_02.wav",
									"\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_use_predator_02.wav",
									"\Killstreaks\data\Sounds\PredatorMissile\NS\NS_1mc_use_predator_02.wav"				
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Russian\RU_1mc_use_predator_01.wav", 							
									"\Killstreaks\data\Sounds\PredatorMissile\PG\PG_1mc_use_predator_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Arabic\AB_1mc_use_predator_02.wav" 	
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_use_predator_02.wav"};
						};
					};
					case false: {
						
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Rangers\US_1mc_enemy_predator_01.wav",
									"\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_enemy_predator_01.wav",
									"\Killstreaks\data\Sounds\PredatorMissile\NS\NS_1mc_enemy_predator_01.wav"									
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Russian\RU_1mc_enemy_predator_01.wav",							
									"\Killstreaks\data\Sounds\PredatorMissile\PG\PG_1mc_enemy_predator_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PredatorMissile\Arabic\AB_1mc_enemy_predator_01.wav"
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\PredatorMissile\TF141\UK_1mc_enemy_predator_01.wav"};
						};

					};
				};
				playSoundUI [_initSound, 1.0, 1.0];		
			};
			
		};
		
		case "AIRSTRIKE" : {
			[_rewardType, _initiatorSide] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_initiatorSide", sideEmpty, [sideEmpty]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				switch (playerSide isEqualTo _initiatorSide) do {
					case true: {
					
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Rangers\US_1mc_use_airstrike_01.wav",
									"\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_use_airstrike_01.wav",
									"\Killstreaks\data\Sounds\PrecisionAirstrike\NS\NS_1mc_use_airstrike_01.wav"				
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Russian\RU_1mc_use_airstrike_01.wav", 							
									"\Killstreaks\data\Sounds\PrecisionAirstrike\PG\PG_1mc_use_airstrike_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Arabic\AB_1mc_use_airstrike_01.wav" 	
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_use_airstrike_01.wav"};
						};
					};
					case false: {
						
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Rangers\US_1mc_enemy_airstrike_01.wav",
									"\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_enemy_airstrike_01.wav",
									"\Killstreaks\data\Sounds\PrecisionAirstrike\NS\NS_1mc_enemy_airstrike_01.wav"									
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Russian\RU_1mc_enemy_airstrike_01.wav",							
									"\Killstreaks\data\Sounds\PrecisionAirstrike\PG\PG_1mc_enemy_airstrike_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\PrecisionAirstrike\Arabic\AB_1mc_enemy_airstrike_01.wav"
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\PrecisionAirstrike\TF141\UK_1mc_enemy_airstrike_01.wav"};
						};

					};
				};
				playSoundUI [_initSound, 1.0, 1.0];		
			};
			
		};
			
		case "CHOPPER" : {
		
			[_rewardType, _initiatorSide] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_initiatorSide", sideEmpty, [sideEmpty]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				switch (playerSide isEqualTo _initiatorSide) do {
					case true: {
					
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Rangers\US_1mc_use_apache_01.wav",
									"\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_use_apache_01.wav",
									"\Killstreaks\data\Sounds\ChopperGunner\NS\NS_1mc_use_apache_01.wav"				
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Russian\RU_1mc_use_apache_01.wav", 							
									"\Killstreaks\data\Sounds\ChopperGunner\PG\PG_1mc_use_apache_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Arabic\AB_1mc_use_apache_01.wav" 	
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_use_apache_01.wav"};
						};
					};
					case false: {
						
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Rangers\US_1mc_enemy_apache_01.wav",
									"\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_enemy_apache_01.wav",
									"\Killstreaks\data\Sounds\ChopperGunner\NS\NS_1mc_enemy_apache_01.wav"									
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Russian\RU_1mc_enemy_apache_01.wav",							
									"\Killstreaks\data\Sounds\ChopperGunner\PG\PG_1mc_enemy_apache_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\ChopperGunner\Arabic\AB_1mc_enemy_apache_01.wav"
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\ChopperGunner\TF141\UK_1mc_enemy_apache_01.wav"};
						};

					};
				};
				playSoundUI [_initSound, 1.0, 1.0];		
			};
		
			
		};
					
		case "AC130" : {
		
		[_rewardType, _initiatorSide] spawn {
			params 
			[
				["_rewardType", "", [""]],
				["_initiatorSide", sideEmpty, [sideEmpty]]
			];
			_initSound = "";
			_slotAvailibility = (player getVariable "EXP_killstreakSlots");
			switch (playerSide isEqualTo _initiatorSide) do {
				case true: {
				
					switch (playerSide) do {
						case blufor: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Rangers\US_1mc_use_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\Rangers\US_1mc_use_ac130_02.wav",
								"\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_use_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_use_ac130_02.wav",
								"\Killstreaks\data\Sounds\AC130\NS\NS_1mc_use_ac130_01.wav",	
								"\Killstreaks\data\Sounds\AC130\NS\NS_1mc_use_ac130_02.wav"								
							];
						};
						case opfor: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Russian\RU_1mc_use_ac130_01.wav", 
								"\Killstreaks\data\Sounds\AC130\Russian\RU_1mc_use_ac130_02.wav",								
								"\Killstreaks\data\Sounds\AC130\PG\PG_1mc_use_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\PG\PG_1mc_use_ac130_02.wav"
							];
						};
						case independent: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Arabic\AB_1mc_use_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\Arabic\AB_1mc_use_ac130_02.wav"								
							];
						};
						default {_initSound = "\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_use_ac130_01.wav"};
					};
				};
				case false: {
					
					switch (playerSide) do {
						case blufor: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Rangers\US_1mc_enemy_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_enemy_ac130_01.wav",
								"\Killstreaks\data\Sounds\AC130\NS\NS_1mc_enemy_ac130_01.wav"									
							];
						};
						case opfor: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Russian\RU_1mc_enemy_ac130_01.wav",							
								"\Killstreaks\data\Sounds\AC130\PG\PG_1mc_enemy_ac130_01.wav"
							];
						};
						case independent: {
							_initSound = selectRandom [
								"\Killstreaks\data\Sounds\AC130\Arabic\AB_1mc_enemy_ac130_01.wav"
							];
						};
						default {_initSound = "\Killstreaks\data\Sounds\AC130\TF141\UK_1mc_enemy_ac130_01.wav"};
					};

				};
			};
			playSoundUI [_initSound, 1.0, 1.0];		
		};

	};
			
		case "NUKE" : {
			[_rewardType, _initiatorSide] spawn {
				params 
				[
					["_rewardType", "", [""]],
					["_initiatorSide", sideEmpty, [sideEmpty]]
				];
				_initSound = "";
				_slotAvailibility = (player getVariable "EXP_killstreakSlots");
				switch (playerSide isEqualTo _initiatorSide) do {
					case true: {
					
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Rangers\US_1mc_use_tnuke_02.wav",
									"\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_use_tnuke_02.wav",
									"\Killstreaks\data\Sounds\Nuke\NS\NS_1mc_use_tnuke_02.wav"				
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Russian\RU_1mc_use_tnuke_01.wav", 							
									"\Killstreaks\data\Sounds\Nuke\PG\PG_1mc_use_tnuke_01.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Arabic\AB_1mc_use_tnuke_01.wav" 	
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_use_tnuke_02.wav"};
						};
					};
					case false: {
						
						switch (playerSide) do {
							case blufor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Rangers\US_1mc_enemy_tinuke_02.wav",
									"\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_enemy_tinuke_02.wav",
									"\Killstreaks\data\Sounds\Nuke\NS\NS_1mc_enemy_tinuke_02.wav"									
								];
							};
							case opfor: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Russian\RU_1mc_enemy_tinuke_01.wav",							
									"\Killstreaks\data\Sounds\Nuke\PG\PG_1mc_enemy_tinuke_02.wav"
								];
							};
							case independent: {
								_initSound = selectRandom [
									"\Killstreaks\data\Sounds\Nuke\Arabic\AB_1mc_enemy_tinuke_02.wav"
								];
							};
							default {_initSound = "\Killstreaks\data\Sounds\Nuke\TF141\UK_1mc_enemy_tinuke_02.wav"};
						};

					};
				};
				playSoundUI [_initSound, 1.0, 1.0];		
			};
		
		};				
	};
};