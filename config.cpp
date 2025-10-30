class CfgPatches
{
	class PredatorMissile
	{
		name = "Predator Missile";
		author = "AdequateX";
		requiredVersion= 1.60;
		requiredAddons[] = {"A3_Ui_F", "A3_Ui_F_Data", "A3_Drones_F", "A3_weapons_f", "A3_weapons_f_beta", "A3_Sounds_F"};
		units[] = {};
		weapons[] = {"predatorMissile"};
	};
};
//enableDebugConsole = 2; ///FOR TESTING ONLY DELETE OR COMMENT OUT AFTER!!!!!


class CfgFunctions {
	class EXP {
		tag = "EXP";
		class functions {
				file = "\Killstreaks\functions";
				class CBA_settings{
					postInit = 1;
				};
		};
	};
}; 


class RscObject;
class RscFrame;
class RscText;
class RscStructuredTextUI;
class RscListBox;
class RscActiveText;
class RscProgress;
class RscPicture;
class RscCombo;
class RscButtonMenu;
class RscStructuredText;
class RscEdit;
class RscButton;
class RscCheckBox;
class RscSlider;
class RscXSliderH;


class RscTitles {
	
	class RscPredatorMissile {
		duration = 240;
		idd = -1;
		movingEnable = 0;
		fadein = 0;
		fadeout = 1;
		onLoad = "uinamespace setVariable ['RscPredatorDisplay', _this # 0]";
		onUnload = "uinamespace setVariable ['RscPredatorDisplay', displayNull]";
		class Controls {
			class predatorMissileUI : RscPicture
			{
				colorBackground[] = {0,0,0,0};
				colorText[] = {1,1,1,1};
				deletable = 0;
				fade = 0;
				fixedWidth = 0;
				font = "TahomaB";	
				idc = -1;
				lineSpacing = 0;
				shadow = 0;
				sizeEx = 1; //0
				style = 48;
				text = "\Killstreaks\data\UI\PredatorMissile\ac130_overlay_105mm.paa";
				tooltipColorBox[] = {1,1,1,1};
				tooltipColorShade[] = {0,0,0,0.65};
				tooltipColorText[] = {1,1,1,1};
				type = 0;
				h = "0.80 * safeZoneH";
				w = "0.80 * safeZoneW * 0.75";  // 0.5, 0.5625
				x = "((safeZoneW - (0.80 * safeZoneW * 0.75)) / 2 + safeZoneX)";
				y = "((safeZoneH - (0.80 * safeZoneH)) / 2 + safeZoneY)";
			};
			
			class worldPosATL: RscStructuredTextUI
			{
				idc = 1120;
				deletable = 0;
				type = 13;
				style = 0;
				FADE = 0;
				text = "fdafdsfdsf";
				font = "TahomaB";
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)"; //0.018
				shadow = 1;
				w = "safeZoneH * 0.1";
				h = "safeZoneW * 0.1";
				x = "safeZoneX + safeZoneW * 0.05";
				y = "safeZoneY + safeZoneH * 0.05";
				colorText[] = {1,1,1,1};
				colorBackground[] = {-1,-1,-1,0};
				class Attributes
				{
					font = "RobotoCondensed";
					color = "#ffffff";
					colorLink = "#D09B43";
					align = "center";
					shadow = 1;
					valign = "top";
				};
			};
			
		};
	};
	
	class rscNukeCountdown {
		duration = 240;
		idd = -1;
		movingEnable = 0;
		fadein = 0;
		fadeout = 0;
		onLoad = "uinamespace setVariable ['rscNukeCountdown', _this # 0]; uinamespace setVariable ['rscNukePAA', 0]; uinamespace setVariable ['rscNukeTimer', 41.0]";
		onUnload = "uinamespace setVariable ['rscNukeCountdown', displayNull]; uinamespace setVariable ['rscNukePAA', 0]; uinamespace setVariable ['rscNukeTimer', 41.0]";
		class Controls {
			class animatedNuclear: RscPicture
			{

				idc = 1130;
				//deletable = 0;
				//type = 13;
				//style = 0;
				//FADE = 0;
				text = "";
				//font = "TahomaB";
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)"; //0.018
				//shadow = 1;
				w = "safeZoneH * 0.04";  
				h = "safeZoneW * 0.04";
				x = "safeZoneX + safeZoneW * 0.030";  // 0.030
				y = "safeZoneY + safeZoneH * 0.0975";  // 0.045
				//colorText[] = {1,1,1,1};
				//colorBackground[] = {-1,-1,-1,0};
			};
			
			class nukeTimer: RscStructuredTextUI
			{
				idc = 1131;
				deletable = 0;
				type = 13;
				style = 0;
				FADE = 0;
				text = "";
				font = "TahomaB";
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)"; //0.018
				shadow = 1;
				w = "safeZoneH * 0.1";
				h = "safeZoneW * 0.1";
				x = "safeZoneX + safeZoneW * 0.0475";  //0.0475
				y = "safeZoneY + safeZoneH * 0.115";   // 0.060
				colorText[] = {1,1,1,0};
				colorBackground[] = {-1,-1,-1,0};
				class Attributes
				{
					font = "RobotoCondensed";
					color = "#ffffff";
					colorLink = "#D09B43";
					align = "center";
					shadow = 1;
					valign = "top";
				};
			};
			
			
			
		};	
	};	
};

class CfgMarkers {
	class Flag;
	class nuclear_Target : Flag
	{
		scope = 2;						// accessibility: 0 = private, 1 = protected, 2 = public
		name = "Nuclear Impact Target";			// name used in the Editor and other UIs
		icon = "\Killstreaks\data\UI\MapUI\map_nuke_selector.paa";		// marker icon
		texture = "\Killstreaks\data\UI\MapUI\map_nuke_selector.paa";	// ?
		color[] = { 1, 1, 1, 1 };		// Color used for the icon and text
		shadow = 0;						// 1 = shadow, 0 = no shadow
		//markerClass = "NATO_Respawn";	// ?
		//side = -1;						// side ID (0 = OPFOR, 1 = BLUFOR, 2 = INDFOR etc)
		size = 32;						// default icon size
		showEditorMarkerColor = 1;		// whether to show icon color in the editor
	};
	
	class uav_Ping : Flag
	{
		scope = 2;						// accessibility: 0 = private, 1 = protected, 2 = public
		name = "UAV Ping";			// name used in the Editor and other UIs
		icon = "\Killstreaks\data\UI\MapUI\motiontracker_ping_mp.paa";		// marker icon
		texture = "\Killstreaks\data\UI\MapUI\motiontracker_ping_mp.paa";	// ?
		color[] = { 1, 1, 1, 1 };		// Color used for the icon and text
		shadow = 0;						// 1 = shadow, 0 = no shadow
		//markerClass = "NATO_Respawn";	// ?
		//side = -1;						// side ID (0 = OPFOR, 1 = BLUFOR, 2 = INDFOR etc)
		size = 16;						// default icon size
		showEditorMarkerColor = 1;		// whether to show icon color in the editor
	};
	
	class directionArrow_Ping : Flag
	{
		scope = 2;						// accessibility: 0 = private, 1 = protected, 2 = public
		name = "Directional Player Marker";			// name used in the Editor and other UIs
		icon = "\Killstreaks\data\UI\MapUI\compassping_player.paa";		// marker icon
		texture = "\Killstreaks\data\UI\MapUI\compassping_player.paa";	// ?
		color[] = { 1, 1, 1, 1 };		// Color used for the icon and text
		shadow = 0;						// 1 = shadow, 0 = no shadow
		//markerClass = "NATO_Respawn";	// ?
		//side = -1;						// side ID (0 = OPFOR, 1 = BLUFOR, 2 = INDFOR etc)
		size = 16;						// default icon size
		showEditorMarkerColor = 1;		// whether to show icon color in the editor
	};
	
};

class CfgCommunicationMenu
{
	class Uav
	{
		text = "Recon UAV";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";	// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\UAV\specialty_uav.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected //\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};

	class predatorMissile
	{
		text = "Predator Missile";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";	// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\PredatorMissile\specialty_predator_missile.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};
	
	class precisionAirstrike
	{
		text = "Precision Airstrike";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";		// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\PrecisionAirstrike\specialty_precision_airstrike.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};
	
	class chopperGunner
	{
		text = "Chopper Gunner";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";		// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\ChopperGunner\specialty_cobra_gunner.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};
	
	class Ac130
	{
		text = "AC-130J Ghost Rider";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";		// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\AC130\specialty_ac130.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};
	
	class Nuke
	{
		text = "Tactical Nuke";		// Text displayed in the menu and in a notification
		submenu = "";					// Submenu opened upon activation (expression is ignored when submenu is not empty.)
		expression = "%1;";	;	// Code executed upon activation  systemchat 'activated killstreak'
		icon = "\Killstreaks\data\UI\Nuke\specialty_nuke.paa";				// Icon displayed permanently next to the command menu
		cursor = "";				// Custom cursor displayed when the item is selected
		enable = "1";					// Simple expression condition for enabling the item
		removeAfterExpressionCall = 0;	// 1 to remove the item after calling
	};
	
};

class CfgNotifications
{
	class killstreakAdded {
		
		title = "NEW KILLSTREAK ACQUIRED";				// Title displayed as text on black background. Filled by arguments.			
		iconPicture = "%2"; // Small icon displayed in left part. Colored by "color", filled by arguments.
		iconText = "%3"; // Short text displayed over the icon. Colored by "color", filled by arguments.
		description = "%1<br />(Press 0-8 to call Support)";		// Brief description displayed as structured text. Colored by "color", filled by arguments.
		//color[] = {1,1,1,1};	// Icon and text color
		duration = 3.5;			// How many seconds will the notification be displayed
		priority = 10;			// Priority; higher number = more important; tasks in queue are selected by priority
		//difficulty[] = {};		// Required difficulty settings. All listed difficulties has to be enabled
		sound = "communicationMenuItemAdded";
		
	};
};


class CfgWrapperUI
{
		class Cursors
	{
		class killstreakTrack
		{
			color[] = {0,1,0,1};
			texture = "\Killstreaks\data\UI\MapUI\remotemissile_target_friendly.paa";
			width = 32;
			height = 32;
			hotspotX = 0.5;
			hotspotY = 0.5;
		};
		class blankTrack
		{
			color[] = {1,1,1,0.01};
			texture = "\Killstreaks\data\UI\MapUI\blank.paa";
			width = 32;
			height = 32;
			hotspotX = 0.5;
			hotspotY = 0.5;
		};
	};
};

class Mode_SemiAuto;
class CfgWeapons 
{
	class weapon_VLS_01;
	class predatorMissile: weapon_VLS_01 
	{	
		displayName = "Predator Missile";	//venator cruise missile
		reloadTime = 15; ////////////
		magazineReloadTime = 1; //////
		magazines[] = {"magazine_Missiles_Predator_x2",};///////
		cursor = "EmptyCursor";		 //"EmptyCursor"; ....laserDesignator
		cursorAim = "missile"; 		//"missile";
		cursorAimOn = "CursorAimOn";			//"";
		initSpeed = 20; //0 ...80 //////////////////////////////////////////////////////////////////////////////
		lockAcquire = 0; //1  /////////////////////////////////////////////////////////////////////
		dexterity = 3; //0.5 ////////////////////////////////////////////////////////////////////
		weaponLockDelay = 2; //5  ///////////////////////////////////////////////////////////////
		aiRateOfFire = 15;  // 0.5     //////////////////////////////////////////////////////////////////////////////////////
		
		class Direct: Mode_SemiAuto
		{
			sounds[] = {"StandardSound"};
			class BaseSoundModeType{};
			class StandardSound: BaseSoundModeType
			{
				begin1[] = {"\Killstreaks\data\Sounds\PredatorMissile\mp_killstrk_hellfire.wav",1.9952624,1,1800}; // "A3\Sounds_F\arsenal\weapons\Launchers\NLAW\nlaw"
				soundBegin[] = {"begin1",1};
			};
			displayName = "Direct";
			textureType = "direct";
			reloadTime = 15;
		};
		class Overfly: Direct
		{
			textureType = "overfly";
			displayName = "Overfly Top Attack";
			reloadTime = 15;

		};
		class TopDown: Direct
		{
			textureType = "topDown";
			displayName = "Top-down Attack";
			reloadTime = 15;

		};
		class LoalDistance: Direct
		{
			textureType = "loaldistance";
			displayName = "Lock-on After Launch";
			reloadTime = 15;

		};
		class Cruise: Direct
		{
			textureType = "cruise";
			displayName = "Cruise";
			reloadTime = 15;

		};
		
		class GunParticles
		{
			class FirstEffect
			{
				effectName = "MLRSFired"; //
				positionName = "Konec hlavne";
				directionName = "Usti hlavne";
			};
		};

		modes[] = {"Direct"}; //cruise ......., "TopDown", "LoalDistance", "Overfly", "Cruise"
		canLock = 0;
	
		////////////////////////////////////
		
		aiDispersionCoefX = 1;
		aiDispersionCoefY = 1;
		aimTransitionSpeed = 1;
		aiRateOfFireDispersion = 0;
		aiRateOfFireDistance = 300;
		ammo = "";
		artilleryCharge = 1;
		artilleryDispersion = 1;
		autoFire = 0;
		autoReload = 1;
		backgroundReload = 0;
		ballisticsComputer = 0;		
		burst = 1;
		canDrop = 1;	
		canShootInWater = 0;
		cartridgePos = "nabojnicestart";
		cartridgeVel = "nabojniceend";
		changeFiremodeSound[] = {"",1,1};
		cmImmunity = 1;
		count = 1;
		cursorSize = 1;
		descriptionShort = "";
		detectRange = 0;		
		dispersion = 0.002;
		distanceZoomMax = 400;
		distanceZoomMin = 400;
		drySound[] = {"",1,1};
		emptySound[] = {"",1,1};
		enableAttack = 1;
		ffCount = 1;
		ffFrequency = 1;
		ffMagnitude = 0;
		fireAnims[] = {};
		fireLightAmbient[] = {0,0,0};
		fireLightDiffuse[] = {0.937,0.631,0.259};
		fireLightDuration = 0.05;
		fireLightIntensity = 0.2;
		fireSpreadAngle = 3;
		forceOptics = 0;
		handAnim[] = {};
		hiddenSelections[] = {};
		hiddenSelectionsTextures[] = {};
		hiddenUnderwaterSelections[] = {};
		hiddenUnderwaterSelectionsTextures[] = {};
		inertia = 1;
		irDistance = 0;
		irDotIntensity = 0.001;
		irLaserEnd = "laser dir";
		irLaserPos = "laser pos";
		laser = 0;	
		lockedTargetSound[] = {"A3\Sounds_F\weapons\Rockets\locked_3",0.562341,2.5};
		lockingTargetSound[] = {"\A3\Sounds_F\weapons\Rockets\locked_1",0.562341,1};
		magazineReloadSwitchPhase = 1;
		maxRange = 500;
		maxRangeProbab = 0.04;
		maxRecoilSway = 0.008;
		memoryPointCamera = "eye";
		midRange = 150;
		midRangeProbab = 0.58;	
		minRange = 1;
		minRangeProbab = 0.3;
		model = "";
		modelMagazine = "";
		modelOptics = "";
		modelSpecial = "";
		multiplier = 1;
		muzzleEnd = "konec hlavne";
		muzzlePos = "usti hlavne";
		muzzles[] = {"this"};
		nameSound = "MissileLauncher";
		optics = 1;
		opticsDisablePeripherialVision = 0.67;	
		opticsFlare = 1;
		opticsID = 0;
		opticsPPEffects[] = {};
		opticsZoomInit = 0.75;
		opticsZoomMax = 1.25;
		opticsZoomMin = 0.25;
		picture = "";
		primary = 10;
		recoil = "empty";
		recoilProne = "";
		reloadAction = "";
		reloadMagazineSound[] = {"",1,1};
		reloadSound[] = {"",1,1};	
		scope = 1;
		selectionFireAnim = "zasleh";
		showAimCursorInternal = 0;
		showEmpty = 1;
		shownUnderwaterSelections[] = {};
		showSwitchAction = 0;
		showToPlayer = 1;
		simulation = "Weapon";
		sound[] = {"",1,1};
		soundBegin[] = {"sound",1};
		soundBeginWater[] = {"sound",1};
		soundBullet[] = {"emptySound",1};
		soundBurst = 1;
		soundClosure[] = {"sound",1};
		soundContinuous = 0;
		soundEnd[] = {"sound",1};
		soundLoop[] = {"sound",1};	
		sounds[] = {"StandardSound"};
		swayDecaySpeed = 2;
		textureType = "fullAuto";
		type = 65536;
		uiPicture = "";	
		useAction = 0;
		useActionTitle = "";
		useAsBinocular = 0;
		useModelOptics = 1;
		value = 2;
		weaponLockSystem = 0;
		weaponSoundEffect = "";	
		weight = 0;
		zeroingSound[] = {"",1,1};
		};

		
};

class CfgMagazines 
{
	class magazine_Missiles_Cruise_01_x18;
	class magazine_Missiles_Predator_x2 : magazine_Missiles_Cruise_01_x18
	{
		
		
		ammo = "ammo_Missile_Predator_01";
		author = "AdequateX";
		count = 2;
		descriptionShort = "Long-range, data link guided, Air-to-surface missile with high-explosive warhead";
		displayName = "Predator Missile HE";
		displayNameShort = "High-explosive";
		initSpeed = 20; //12 ...30 ////////////////////////////////////////////////////////////////////////
		///////////////////////////
		mass = 8;
		maxLeadSpeed = 1.38889;
		maxThrowHoldTime = 2;
		maxThrowIntensityCoef = 1.4;
		minThrowIntensityCoef = 0.3;
		model = "\A3\weapons_F\ammo\mag_univ.p3d";
		modelSpecial = "";
		nameSound = "missiles";
		picture = "";
		quickReload = 0;
		reloadAction = "";
		scope = 2;
		selectionFireAnim = "zasleh";
		simulation = "ProxyMagazines";
		type = 0;
		useAction = 0;
		useActionTitle = "";
		value = 1;
		weaponPoolAvailable = 0;
		weight = 0;
	};
	
};


class CfgAmmo 
{ 
	class ammo_Missile_Cruise_01;
	class ammo_Missile_Predator_01 : ammo_Missile_Cruise_01
	{
		class Direct
		{
		};
		class TopDown : Direct
		{
		ascendHeight = 150.0;
		descendDistance = 200.0;
		minDistance = 150.0;
		ascendAngle = 70.0;
		};
		class LoalDistance : Direct
		{
		lockSeekDistanceFromParent = 300.0;
		};
		class Overfly : Direct
		{
		overflyElevation = 4.0;
		};
		class Cruise : Direct
		{
		preferredFlightAltitude = 50.0;
		};
		
		flightProfiles[] = {"Direct", "TopDown", "LoalDistance", "Overfly", "Cruise"}; //Cruise
		manualControl = 0; //0  //////////////////////////////////////////////////////////////////////////
		irLock = 0; // 0
		laserLock = 0; //0
		maneuvrability = 20; //16 .... 10 //lower makes missile less jittery, but slower to turn correct direction at spawn time (firing)
		thrust = 60; //35    .... 110 ///////////////////////////////////////////////////////////////////////
		thrustTime = 3.5; //200  .....35
		timeToLive = 15; //205
		lockSeekRadius = 2500; //1500
		lockType = 1; //0    
		autoSeekTarget = 0; //0
		effectsSmoke = "SmokeShellWhite"; //SmokeShellWhite
		effectsFire = "CannonFire"; //CannonFire
		effectsMissile = "missile4"; //CruiseMissile
		effectsMissileInit = ""; //RocketBackEffectsRPG ... PylonBackEffects
		muzzleEffect = "BIS_fnc_effectFiredHeliRocket"; //BIS_fnc_effectFiredCruiseMissile
		trackLead = 1;  //0.5
		trackOversteer = 0.1;  //1.2
		weaponType = "missileAT"; //"Default"
		missileManualControlCone = 360; /////////////////// newly added
		maxControlRange = 6000; //4000
		maxSpeed = 190.00; //194.444 
		sideAirFriction = 2; //0.5 //////////////////////////////////////////////////////////////////////
		initTime = 0; //0.3
		airFriction = 0.2; //0.45 //////////////////////////////////////////////////////////////////////
		canLock = 0; ////newly added unsure if does anything??
		indirectHit = 5000;  // 2000  //4000 damages severly tanks when around 2M away and injures troops inside them
		indirectHitRange = 18; //30   ///////////////////////////////////////////////////////////////////
		soundEngine[] = {"\Killstreaks\data\Sounds\PredatorMissile\veh_mig29_dist_loop.wav",1.0,1,1000}; //"A3\Sounds_F\weapons\Rockets\rocket_fly_2",1.58489,1.8,1000 /////////////////////////////////////////////////////////////////////
		soundFly[] = {"\Killstreaks\data\Sounds\PredatorMissile\veh_mig29_dist_loop.wav",1.0,1,1000}; //"A3\Sounds_F\weapons\Rockets\rocket_fly_2",1.58489,1.8,1000 /////////////////////////////////////////////////////////////////////
		explosionSoundEffect = "DefaultExplosion"; //"DefaultExplosion"
		soundHit[] = {"",100,1};	// ""
		soundHit1[] = {"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000}; //"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000
		soundHit2[] = {"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000}; //"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000
		soundHit3[] = {"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000}; //"A3\Sounds_F\arsenal\weapons\Launchers\Titan\Explosion_titan_missile_01",2.51189,1,2000
		soundSetExplosion[] = {"predatorHeavy_Exp_SoundSet","BombsHeavy_Tail_SoundSet","Explosion_Debris_SoundSet"}; // "BombsHeavy_Exp_SoundSet","BombsHeavy_Tail_SoundSet","Explosion_Debris_SoundSet" ////////////////////////////////////////////////////////////////////
		
		///////////////////////////////
		
		
		afMax = 200;
		aiAmmoUsageFlags = "128 + 512";
		airLock = 0;
		animated = 0;		
		artilleryCharge = 1;	
		artilleryDispersion = 1;
		artilleryLock = 0;
		audibleFire = 64;	
		caliber = 1;
		cameraViewAvailable = 1;
		cartridge = "";
		cmImmunity = 1;
		cost = 5000;
		craterEffects = "HeavyBombCrater";
		craterShape = "";
		craterWaterEffects = "ImpactEffectsWater";
		dangerRadiusBulletClose = -1;
		dangerRadiusHit = 2000;
		deflecting = 0;
		deflectionSlowDown = 0.8;
		directionalExplosion = 0;
		effectFlare = "FlareShell";
		effectFly = "";
		explosionAngle = 60;
		explosionDir = "explosionDir";
		explosionEffects = "HeavyBombExplosion";
		explosionEffectsDir = "explosionDir";
		explosionForceCoef = 1;
		explosionPos = "explosionPos";		
		explosionTime = 0;	
		explosionType = "explosive";
		explosive = 0.8;
		fuseDistance = 100;
		grenadeBurningSound[] = {};
		grenadeFireSound[] = {};
		hit = 6000;
		hitArmor[] = {"soundHit",1};
		hitBuilding[] = {"soundHit",1};
		hitConcrete[] = {"soundHit",1};
		hitDefault[] = {"soundHit",1};	
		hitFoliage[] = {"soundHit",1};
		hitGlass[] = {"soundHit",1};
		hitGlassArmored[] = {"soundHit",1};
		hitGroundHard[] = {"soundHit",1};
		hitGroundSoft[] = {"soundHit",1};
		hitIron[] = {"soundHit",1};
		hitMan[] = {"soundHit",1};
		hitMetal[] = {"soundHit",1};
		hitMetalplate[] = {"soundHit",1};
		hitOnWater = 0;
		hitPlastic[] = {"soundHit",1};
		hitRubber[] = {"soundHit",1};
		hitTyre[] = {"soundHit",1};
		hitWater[] = {"soundHit",1};
		hitWood[] = {"soundHit",1};
		htMax = 1800;
		htMin = 60;
		icon = "";
		impactArmor[] = {"soundImpact",1};
		impactBuilding[] = {"soundImpact",1};
		impactConcrete[] = {"soundImpact",1};
		impactDefault[] = {"soundImpact",1};
		impactFoliage[] = {"soundImpact",1};
		impactGlass[] = {"soundImpact",1};
		impactGlassArmored[] = {"soundImpact",1};		
		impactGroundHard[] = {"soundImpact",1};
		impactGroundSoft[] = {"soundImpact",1};
		impactIron[] = {"soundImpact",1};
		impactMan[] = {"soundImpact",1};
		impactMetal[] = {"soundImpact",1};
		impactMetalplate[] = {"soundImpact",1};
		impactPlastic[] = {"soundImpact",1};
		impactRubber[] = {"soundImpact",1};
		impactTyre[] = {"soundImpact",1};
		impactWater[] = {"soundImpact",1};
		impactWood[] = {"soundImpact",1};		
		isCraterOriented = 0;
		maneuvDependsOnSpeedCoef = 0.4;		
		maverickWeaponIndexOffset = 0;
		mFact = 0;
		mfMax = 100;
		minDamageForCamShakeHit = 0.55;
		mineBoundingDist = 3;
		mineBoundingTime = 3;
		mineDiveSpeed = 1;
		mineFloating = -1;
		mineInconspicuousness = 10;
		mineJumpEffects = "";
		minePlaceDist = 0.5;
		mineTrigger = "RangeTrigger";
		minimumSafeZone = 0.1;
		minTimeToLive = 0;
		missileKeepLockedCone = 360;
		missileLockCone = 360;
		missileLockMaxDistance = 32000;
		missileLockMaxSpeed = 1;
		missileLockMinDistance = 50;
		model = "\A3\Weapons_F_Destroyer\Ammo\Missile_Cruise_01_Fly_F";
		multiSoundHit[] = {"soundHit1",0.34,"soundHit2",0.33,"soundHit3",0.33};
		nvLock = 0;
		proxyShape = "\A3\Weapons_F_Destroyer\Ammo\Missile_Cruise_01_Fly_F";
		shadow = 0;
		shootDistraction = -1;
		simulation = "shotMissile";
		simulationStep = 0.002;
		soundActivation[] = {};
		soundDeactivation[] = {};
		soundFakeFall[] = {"soundFall",1};
		soundFall[] = {"",1,1};
		soundImpact[] = {"",1,1};		
		soundTrigger[] = {};
		submunitionAmmo = "";
		supersonicCrackFar[] = {"A3\Sounds_F\weapons\Explosion\supersonic_crack_50meters",0.316228,1,50};
		supersonicCrackNear[] = {"A3\Sounds_F\weapons\Explosion\supersonic_crack_close",0.398107,1,20};		
		suppressionRadiusBulletClose = -1;
		suppressionRadiusHit = 200;
		tBody = 0;
		tracerColor[] = {0.7,0.7,0.5,0.04};
		tracerColorR[] = {0.7,0.7,0.5,0.04};	
		typicalSpeed = 900;
		underwaterHitRangeCoef = 1;
		visibleFire = 40;
		visibleFireTime = 20;
		warheadName = "HE";
		waterEffectOffset = 0.45;
		weaponLockSystem = 16;
		whistleDist = 64;
		whistleOnFire = 0;	
	};

};


 class CfgSoundShaders
{
	class BombsHeavy_closeExp_SoundShader;
	class BombsHeavy_midExp_SoundShader;
	class BombsHeavy_distExp_SoundShader;
	
	class predatorHeavy_closeExp_SoundShader : BombsHeavy_closeExp_SoundShader {
		range = 350;
		rangeCurve = "CannonCloseShotCurve";
		samples[] = {{"\Killstreaks\data\Sounds\PredatorMissile\Mortar_dirt04.wav", 1}};  // "A3\Sounds_F\arsenal\explosives\shells\ShellHeavy_closeExp"
		volume = 3.0;
	};
	
	class predatorHeavy_midExp_SoundShader : BombsHeavy_midExp_SoundShader {
		range = 800;
		rangeCurve = "CannonMidShotCurve";
		samples[] = {{"\Killstreaks\data\Sounds\PredatorMissile\explo_distant05.wav", 1}}; // "A3\Sounds_F\arsenal\explosives\shells\ShellHeavyB_midExp"
		volume = 2.5;
	};
	
	class predatorHeavy_distExp_SoundShader : BombsHeavy_distExp_SoundShader {
		range = 3000;
		rangeCurve[] = {{0,0.3},{100,0.45},{500,0.5},{3000,1}};
		samples[] = {{"\Killstreaks\data\Sounds\PredatorMissile\elm_explosion_low_dist04.wav", 1}}; // "A3\Sounds_F\arsenal\explosives\shells\ShellHeavyB_distExp"
		volume = 1.5;
	};
	
	
};


class CfgSoundSets
{
	class BombsHeavy_Exp_SoundSet;
	class predatorHeavy_Exp_SoundSet : BombsHeavy_Exp_SoundSet {
		distanceFilter = "explosionDistanceFreqAttenuationFilter";
		doppler = 0;
		loop = 0;
		sound3DProcessingType = "ExplosionHeavy3DProcessingType";
		soundShaders[] = {"predatorHeavy_closeExp_SoundShader","predatorHeavy_midExp_SoundShader","predatorHeavy_distExp_SoundShader"};
		spatial = 1;
		volumeCurve = "LinearCurve";
		volumeFactor = 3.25;
	};
	
};