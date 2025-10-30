//need to do list:
//predator missile handle event when player pauses, and goes into spectator / camera mode, view of the missile camera is removeDiaryRecord (when camera mode is used missile goes into 3rd person can swap with 'enter')

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
	player setvariable ["EXP_missileControlling", 0];
	((finddisplay 46) setvariable ["PredatorFiredEH" ,nil]);
	((findDisplay 46) setVariable ["droneKilledEH", nil]);
	((findDisplay 46) setVariable ["CameraLockEH", nil]);
	((findDisplay 46) setVariable ["MouseEH", nil]);
	((findDisplay 46) setVariable ["MouseButtonDownEH", nil]);
	((findDisplay 46) setVariable ["ProjectileEH", nil]);
	((findDisplay 46) setVariable ["CameraOBJ", objNull]);
	
	
	//player setvariable ["#var", str ((units group player) select (units group player find player)) ,true];
	player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		if ((player getvariable "EXP_killstreakIsActive") == 1) then {
			//terminate all controlled killstreaks here
			[(finddisplay 46) getVariable "PredatorDroneOBJ"] call EXP_fnc_terminatePredatorStreak;
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
		["_rewardThreshold", 1, [0]],
		["_rewardSlot", 1, [0]],
		["_instigator", objNull, [objNull]]
	];
	
// Play sounds and give killstreak support action
//////////////// check that slot isnt already taken here after respawn  _slotAvailibility ????////////////////////////////////////////////////////////////////////////////////
//systemChat str [_rewardType, _rewardThreshold, _rewardSlot, _instigator];


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
				_commMenuID = [player, "Ac130" , nil, "[] call EXP_fnc_deployAC130;  player setVariable ['EXP_slotActivated', (_this select 4)]","killstreakAdded"] call BIS_fnc_addCommMenuItem;
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

};


EXP_fnc_deployPredatorMissile = {

	if ((player getvariable "EXP_killstreakIsActive") == 1) exitWith { systemChat "Another killstreak is currently in use";};
//Positional Event Handlers
	_clickEHID = addMissionEventHandler ["MapSingleClick",  //maybe get the green mw2 map cursor for this?
	{
		params ["_units", "_pos", "_alt", "_shift"];
		//need to set a maximum waypoint distance
		if ((_pos distance2D player) > 2000) then 
		{
			systemChat format ["Maximum distance from player: 2000 meters; Current distance: %1 meters",(_pos distance2D player)];
		}
		else
		{
			_kilstreakslots = (player getVariable "EXP_killstreakSlots");
			_commMenuID = 0;
/* 			{
				if ((_x find "PREDATOR") != -1) then 
				{
					_commMenuID = ((_kilstreakslots select _forEachIndex) select 0);
					//systemChat str _commMenuID
				};
				
			} forEach _kilstreakslots; */
			[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;  //_commMenuID
			openMap [false, false];
			
			[_pos] call EXP_fnc_spawnDrone;			
		};
	}, []];

	_mapEHID = addMissionEventHandler ["Map", 
	{
		params ["_mapIsOpened", "_mapIsForced"];
		if (_mapIsOpened == false) then 
		{
			removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
			removeMissionEventHandler ["Map" ,_thisEventHandler];		
		};
	}, [_clickEHID]];
	
	
//Main Script
	openMap [true, false];
	
	
//Functions
		EXP_fnc_spawnDrone = {
			params 
			[
				["_selectionPos", [], [[]]]
			];
			player setvariable ["EXP_killstreakIsActive", 1];
			_selectionPos set [2, 0];
			_spawnpos = [((_selectionPos select 0) - 707), ((_selectionPos select 1) - 707), 800];
		
	/// Drone initialize
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
			{_predatorDrone setPylonLoadout [_x, "PylonRack_1Rnd_Missile_AGM_02_F", true]} foreach [1,2];
			_predatorDrone removeWeaponTurret ["Missile_AGM_02_Plane_CAS_01_F", [0]];
			_predatorDrone removeWeaponTurret ["Laserdesignator_mounted", [0]];
			_predatorDrone removeWeaponTurret ["missiles_SCALPEL", [0]];
			_predatorDrone addMagazineTurret ["magazine_Missiles_Predator_x2", [0], 2];
			_predatorDrone addWeaponTurret ["predatorMissile", [0]];
			_predatorDrone selectWeaponTurret ["predatorMissile", [0], "", "Direct"];
			_predatorDrone setTurretLimits [[0], -135, 0, -55, 0];
			_predatorDrone lockDriver true;
			_predatorDrone lockTurret [[0,0], true];
			_predatorDrone lock 2;
			((findDisplay 46) setVariable ["CameraOBJ", objNull]); //redundant
			((finddisplay 46) setVariable ["PredatorDroneOBJ", _predatorDrone]); 	

			
	//Camera Switchover & smooth fading
			0 cutText ["", "BLACK OUT", 2, false, false];
			[_predatorDrone] spawn {
				params
				[
					["_predatorDrone", objNull, [objNull]]
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
				
	// Killstreak Lifetime limiter
			[_predatorDrone] spawn {
				params
				[
					["_predatorDrone", objNull, [objNull]]
				];	
				_startTime = time;
				_timeToLive = 240;
				while {((alive _predatorDrone) && (_timeToLive > 0))} do {
					sleep 1;
					_timeToLive = (240 - (time - _startTime));
					if (((round _timeToLive) % 10) == 0) then {systemChat format ["Drone killstreak time remaining: %1 seconds", round _timeToLive];};
					systemChat str (player getvariable "EXP_usedKillstreakSlot");
				};	
				[(finddisplay 46) getVariable "PredatorDroneOBJ"] call EXP_fnc_terminatePredatorStreak;	
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
						then {[((finddisplay 46) getVariable "PredatorDroneOBJ")] call EXP_fnc_terminatePredatorStreak; systemChat "Killstreak terminated"};	 
					}
					else {
					//missile in flight, force switch camera to missile camera here.
					if (((findDisplay 46) getVariable "CameraOBJ") isNotEqualTo objNull) then {
						_cam = ((findDisplay 46) getVariable "CameraOBJ");
						switchCamera _cam;  //when missile is destroyed causes cam to be stuck on old missile cam
					
					};
					
					};
					diag_log (str [_oldUnit, _newUnit, _vehicleIn, _oldCameraOn, _newCameraOn, _uav]);
				}];
				(findDisplay 46) setVariable ["killStreakLockEH", _killStreakLock];
				
				
				9 cutText["Predator drone connection:     *CONNECTED*", "BLACK IN", 2, false, false];
				systemChat ("Predator drone status:     *CONNECTED*");
			};

			
	// Predator Drone EventHandlers
			
			_droneKilled = _predatorDrone addEventHandler ["Killed", {
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				[_predatorDrone] call EXP_fnc_terminatePredatorStreak;
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
						
						
		//Event handler _cameraLock ^^ double firing of playerview changed happens up here somewhere
					
					_cameraLock = addMissionEventHandler ["PlayerViewChanged", {
						params [
							"_oldUnit", "_newUnit", "_vehicleIn",
							"_oldCameraOn", "_newCameraOn", "_uav"
						];
						//////////////////////////////////////////// THIS HAS NOT BEEN FULLY IMPLEMENTED //////////////////////////////////////////
						//systemChat str [_oldUnit, _newUnit, _vehicleIn, _oldCameraOn, _newCameraOn, _uav];
					}];
					(finddisplay 46) setvariable ["CameraLockEH", _cameraLock];   
					
					
					
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
						_cam = ((findDisplay 46) getVariable "CameraOBJ"); //predatorOBJ
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
						((findDisplay 46) setVariable ["ProjectileEH", nil]);
						removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "CameraLockEH")];		
						if ((_predatorDrone magazineTurretAmmo ["magazine_Missiles_Predator_x2", [0]]) == 0) then {[_predatorDrone] call EXP_fnc_terminatePredatorStreak;};
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
				["_predatorDrone", objNull, [objNull]]
			];	
			// If not spawned with added sleep delay the game will crash between remotecontrol being returned to player and previous camera being deleted,...
			[_predatorDrone] spawn {
				params 
				[
					["_predatorDrone", objNull, [objNull]]
				];	
			
				removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "killStreakLockEH")];
				if (cameraOn isNotEqualTo player) then {
					switchCamera Player;
					cameraon cameraEffect ["Terminate", "Back"];
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
				
				if (_predatorDrone isNotEqualTo objNull) then {
				
					_predatorDrone removeEventHandler ["Killed", ((findDisplay 46) getVariable "droneKilledEH")];
					_predatorDrone removeEventHandler ["Fired",((findDisplay 46) getVariable "PredatorFiredEH")];
					deleteVehicleCrew _predatorDrone;
					deleteVehicle _predatorDrone;	
				};

				if (!((findDisplay 46) isNil "MouseEH")) then {  //this might be redundant due to the 'deleted' EH already handling them
				
					(findDisplay 46) displayRemoveEventHandler ["MouseMoving", ((findDisplay 46) getVariable "MouseEH")];
					(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", ((findDisplay 46) getVariable "MouseButtonDownEH")];
					removeMissionEventHandler ["PlayerViewChanged", ((findDisplay 46) getVariable "CameraLockEH")];	
				};

				((finddisplay 46) setvariable ["PredatorFiredEH" ,nil]);
				((findDisplay 46) setVariable ["droneKilledEH", nil]);
				((findDisplay 46) setVariable ["CameraLockEH", nil]);
				((findDisplay 46) setVariable ["MouseEH", nil]);
				((findDisplay 46) setVariable ["MouseButtonDownEH", nil]);
				((findDisplay 46) setVariable ["ProjectileEH", nil]);
				player setvariable ["EXP_killstreakIsActive", 0];
				player setvariable ["EXP_missileControlling", 0];
				[] call bis_fnc_refreshCommMenu;
			
			};
		

		};
	
	};
EXP_fnc_deployPrecisionAirstrike = {};

EXP_fnc_deployChopperGunner = {};

EXP_fnc_deployAC130 = {};

EXP_fnc_deployNuke = {
		//if ((player getvariable "EXP_killstreakIsActive") == 1) exitWith { systemChat "Another killstreak is currently in use";};
	//Positional Event Handlers
		player setVariable ["EXP_mapPos1", nil];
		player setVariable ["EXP_mapPos2", nil];
		
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

		
		
		_clickEHID = addMissionEventHandler ["MapSingleClick",  //maybe get the green mw2 map cursor for this?
		{
			params ["_units", "_pos", "_alt", "_shift"];
			//need to set a maximum waypoint distance

			if (((_pos distance2D player) > 8000) && (player isNil "EXP_mapPos1")) then 
			{
				systemChat format ["Maximum distance from player: 8000 meters; Current distance: %1 meters",(_pos distance2D player)];
			}
			else
			{

				if (player isNil "EXP_mapPos1") then {
				
					player setVariable ["EXP_mapPos1", _pos];
				}
				else 
				{
					player setVariable ["EXP_mapPos2", _pos];
					_vectorDIF = _pos vectorDiff (player getVariable "EXP_mapPos1");
					_vectorDIR =  (player getVariable "EXP_mapPos1") vectorFromTo _pos;
					//_degreeDIR = (_vectorDIF select 1) atan2 (_vectorDIF select 0);
					//_degreeDIR = (_dir + 360) % 360;
					openMap [false, false];	
					_kilstreakslots = (player getVariable "EXP_killstreakSlots");
					((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", ((findDisplay 12) getVariable "EXP_drawEH")];
					[player, (player getVariable "EXP_slotActivated")] call BIS_fnc_removeCommMenuItem;		
					((findDisplay 12) displayCtrl 51) ctrlMapCursor ["Track", "Track"];					
					[_pos, _vectorDIR] call EXP_fnc_spawnNukeCarrier;	
					
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
			params 
			[
				["_TargetPos", [], [[]]],
				["_vectorDIR", [], [[]]]
			];

				_spawnDistance = [4000, 4000, 600] vectorMultiply [(-(_vectorDIR select 0)), (-(_vectorDIR select 1)), 1];
				_waypointPos = ([4000, 4000, 600] vectorMultiply [((_vectorDIR select 0)), ((_vectorDIR select 1)), 1]);
				_waypointPosASL = (_TargetPos vectorAdd _waypointPos);
				_waypointPosASL = (ATLToASL _waypointPosASL);
				hint str [_waypointPosASL];
				_spawnPos = _TargetPos vectorAdd _spawnDistance;
				_nukeDrone = createVehicle ["B_UAV_05_F", _spawnPos, [], 0, "CAN_COLLIDE"];
				(side player) createVehicleCrew _nukeDrone;
				_nukeDrone engineOn true;
				_degreeDIR = ((_vectorDIR select 1) atan2 (_vectorDIR select 0));
				_degreeDIR = (_degreeDIR + 360) % 360;
				_yaw = _degreeDIR; _pitch = 0; _roll = 0;
				_nukeDrone setVectorDirAndUp [
					[sin _yaw * cos _pitch, cos _yaw * cos _pitch, sin _pitch],
					[[sin _roll, -sin _pitch, cos _roll * cos _pitch], -_yaw] call BIS_fnc_rotateVector2D
				];
				_nukeDrone setVelocityModelSpace [0,150,0];
				//_nukeDrone setVectorDir [(_vectorDIR select 1), (_vectorDIR select 0), 1];
				
				//_selectionPosASL = (ATLToASL [_TargetPos select 0, _TargetPos select 1, 600]);
				_nukeDrone removeWeaponTurret ["Laserdesignator_mounted", [0]];
				_nukeDrone removeWeaponTurret ["weapon_GBU12Launcher", [0]];
				_nukeDrone removeMagazinesTurret ["PylonMissile_Bomb_GBU12_x1", [0]];
				//_nukeDrone addMagazinesTurret ["PylonMissile_Bomb_GBU12_x1", [0], 16]; // PylonMissile_Bomb_GBU12_x1 , "PylonMissile_1Rnd_BombCluster_03_F" //////////////////////// FSNB_B61_4_M,  FSNB_B61_4_Timed_M, FSNB_AGM_86B_M,  FSNB_AGM_86B_Cruise_M, FSNB_155mm_W48_Nuclear_M
				_nukeDrone addWeaponTurret ["FSNB_B61_4_W", [0]];    /// "weapon_GBU12Launcher", "BombCluster_03_F", //////////////////////////// FSNB_B61_4_W, FSNB_B61_4_Timed_W, FSNB_AGM_86B_W, FSNB_AGM_86B_Cruise_W
				{_nukeDrone setPylonLoadout [_x, "FSNB_B61_4_M", true];} foreach [1,2];
				//{_nukeDrone setAmmoOnPylon [_x, 2];} foreach [1,2];
				//_nukeDrone selectWeaponTurret ["predatorMissile", [0], "", "Direct"];
				
				_waypoint = group(_nukeDrone) addWaypoint [_waypointPosASL, -1, 1];  //_selectionPosASL
				group(_nukeDrone) setCombatMode "BLUE";
				group(_nukeDrone) setCombatBehaviour "Careless"; //CARELESS
				_waypoint setWaypointBehaviour "Careless";
				_waypoint setWaypointSpeed "FULL";  //LIMITED
				_nukeDrone forceSpeed 150; //500 km/h
				_waypoint setWaypointType "MOVE";
				_waypoint setWaypointForceBehaviour true;
				group(_nukeDrone) setCurrentWaypoint _waypoint;
				//_nukeDrone lockDriver true;
				//_nukeDrone lockTurret [[0,0], true];
				//_nukeDrone lock 2;
				_nukeDrone flyInHeightASL [600, 600, 600];
				((findDisplay 46) setVariable ["CameraOBJ", objNull]); //redundant
				((finddisplay 46) setVariable ["PredatorDroneOBJ", _nukeDrone]); 	

				[_nukeDrone, _TargetPos] spawn {
					params 
					[
						["_nukeDrone", objNull, [objNull]],
						["_TargetPos", [], [[]]]
					];
					while {alive _nukeDrone} do 
					{
						 sleep 0.3;
						if (((getPosATL _nukeDrone) distance2D _TargetPos) <= 2325) then 
						{
							{_nukeDrone animatebay [_x, 1];} foreach [1,2];
							(gunner _nukeDrone) forceWeaponFire ["FSNB_B61_4_W", "FSNB_YIELD_300"]; //FSNB_YIELD_300, FSNB_YIELD_1500, FSNB_YIELD_10000, FSNB_YIELD_50000
						
						};
					
					};
				
				
				};
			
				_NukeFiredEH = _nukeDrone addEventHandler ["Fired", {
					
					params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

				}];
			
			
		
		};
	

	};
	

		
};