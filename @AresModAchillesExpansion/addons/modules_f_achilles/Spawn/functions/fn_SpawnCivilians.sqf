#include "\achilles\modules_f_ares\module_header.hpp"

//based on:
//https://forums.bohemia.net/forums/topic/158907-spawningremoving-a-civilian-using-a-script


// ask user for parameters
_dialogResult =
[
	localize "STR_AMAE_SPAWN_CIVILIANS",
	[
		[localize "STR_AMAE_SPAWN_CIVILIANS_AMOUNT", "", "30"],
		[localize "STR_AMAE_SPAWN_CIVILIANS_DISTANCE", "", "100"]
	]
] call Ares_fnc_ShowChooseDialog;

// exit of user aborts
if (_dialogResult isEqualTo []) exitWith {};

// set all required values
private _amountToSpawn = parseNumber (_dialogResult select 0);
private _searchDistance = parseNumber (_dialogResult select 1);
private _spawnPosition = position _logic;
private _civilianSide = 3; // The civilian side index.
// Get the CfgVehicles config.
private _cfgVehiclesConfig = configFile >> "CfgVehicles"; 
// Count how many entries there are in CfgVehicles.
private _cfgVehiclesConfigCount = count _cfgVehiclesConfig;

// initialize list of civilian types
private _CS_CivilianTypes = [];
for [{_i = 0}, {_i < _cfgVehiclesConfigCount}, {_i = _i + 1}] do
{
   private _config = _cfgVehiclesConfig select _i; // Get the vehicle at the current index.

   // We only want classes.
   if (isClass _config) then
   {
       private _isMan = getNumber (_config >> "isMan"); // Get the value of the isMan property.

       // If it ain't zero, this is a man (soldier or civilian).
       if (_isMan != 0) then
       {
           private _sideIndex = getNumber (_config >> "side"); // Get the index of the side the man belongs to.
           private _configName = configName _config;

           // If the man is on the civilian side, add him to CS_CivilianTypes.
           if (_sideIndex == _civilianSide 
             and not (_configName find "VirtualMan_F" == 0)
             and not (_configName find "CivilianPresence" == 0)
             and not (_configName find "C_Driver_" == 0)
             ) then
           {
               _CS_CivilianTypes set [count _CS_CivilianTypes, configName _config];
           };
       };
   };
};

// spawn

for [{_i = 0}, {_i < _amountToSpawn}, {_i = _i + 1}] do
{
  // Create a group for the civilian.
  private _civilianGroup = createGroup civilian;
  
  // Pick a random civilian type from the CS_CivilianTypes array.
  private _civilianType = _CS_CivilianTypes select (floor random count _CS_CivilianTypes);
  
  //private _objects = nearestObjects [_civilian, ["house"], _searchDistance];
  private _objects = nearestTerrainObjects [_spawnPosition, ["HOUSE", "QUAY", "FUELSTATION", "ROAD", "FOREST", "RUIN"], _searchDistance, false];

  private _initialPosition = getPos selectRandom _objects;
  
  // Spawn the civilian as part of the created group, at the spawn position.
  private _civilian = _civilianGroup createUnit [_civilianType, _initialPosition, [], 0, "NONE"];
  
  // Make the civilian stop moving.
  //doStop _civilian;
  
  private _wp1 = _civilianGroup addWaypoint [_initialPosition, 0];
  _wp1 setWaypointType "MOVE";
  _wp1 setWaypointTimeout [10, 20, 40];
  _wp1 setWaypointBehaviour "SAFE";
  _wp1 setWaypointSpeed "LIMITED";
  _wp1 setWaypointStatements ["this lookAt (selectRandom (this nearEntities 20)); true", ""];
  _wp2 = _civilianGroup addWaypoint [getPos selectRandom _objects, 0];
  _wp2 setWaypointType "MOVE";
  _wp2 setWaypointTimeout [10, 20, 40];
  _wp2 setWaypointBehaviour "SAFE";
  _wp2 setWaypointSpeed "LIMITED";
  _wp3 = _civilianGroup addWaypoint [getPos selectRandom _objects, 0];
  _wp3 setWaypointType "MOVE";
  _wp3 setWaypointTimeout [10, 20, 40];
  _wp3 setWaypointBehaviour "SAFE";
  _wp3 setWaypointSpeed "LIMITED";

  _wpC = _civilianGroup addWaypoint [_initialPosition, 0];
  _wpC setWaypointType "CYCLE";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
