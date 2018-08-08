/*
	Author: ServiusHack

	Description:
	Command an AI unit to revive the nearest player using farooq's Revive.


  Parameters:
    _this select: 0 - OBJECT - Object that the module was placed upon

  Returns:
    Nothing
*/

#include "\achilles\modules_f_ares\module_header.hpp"

// Gets the object that the module was placed upon
private _object = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

// Displays error message if no object or unit has been selected.
if (isNull _object) exitWith {[localize "STR_AMAE_NO_UNIT_SELECTED"] call Achilles_fnc_ShowZeusErrorMessage};

// Displays error message if the module has been placed on top of a player.
if (isPlayer _object || isPlayer driver _object) exitWith {[localize "STR_AMAE_NO_UNIT_SELECTED"] call Achilles_fnc_ShowZeusErrorMessage};

// Make sure we use a unit. Vehicles support kicks in later.
_object = driver _object;

// find all unconsious players
private _unconsiousPlayers  = allPlayers select { _x getVariable ["FAR_isUnconscious", 0] == 1 };

// find nearest player to revive
private _sortedPlayers = [_unconsiousPlayers, [], {_x distance _object}, "ASCEND"] call BIS_fnc_sortBy;
private _nearestPlayer = _sortedPlayers select 0;

if (isNil "_nearestPlayer") exitWith { [localize "STR_AMAE_NO_PLAYER_UNCONSIOUS"] call Achilles_fnc_ShowZeusErrorMessage; };

// Let Zeus know what will happen
[format [localize "STR_AMAE_REVIVE_PLAYER", name _nearestPlayer]] call Ares_fnc_ShowZeusMessage;

// spawn off movement and revive action
[_object, _nearestPlayer] spawn {
  private _object = _this select 0;
  private _nearestPlayer = _this select 1;

  if (vehicle _object == _object) then {
    // move unit to perform the revive
    _object doMove (getPos _nearestPlayer);
  } else {
    private _vehicle = vehicle _object;

    // make vehicle drive to the player
    driver _vehicle doMove (getPos _nearestPlayer);

    // wait for vehicle to be close enough
    // Make sure we're close to get off when the vehicle stands still.
    waitUntil{(speed _vehicle) < 0.1 and (_object distance _nearestPlayer) < 20};

    // make sure the vehicle stops
    doStop driver _vehicle;

    // make the unit leave the vehicle
    _object action ["GetOut", _vehicle];
    _object leaveVehicle _vehicle;

    // finally move unit to perform the revive
    _object doMove (getPos _nearestPlayer);
  };

  waitUntil{(_object distance _nearestPlayer) < 2};

  // make it look nice
  _object lookAt _nearestPlayer;
  sleep 2;
  _object playMove "AinvPknlMstpSlayWrflDnon_medic";

  // do the actual revive
  _nearestPlayer setVariable ["FAR_isUnconscious", 0, true];
  _nearestPlayer setVariable ["FAR_isDragged", 0, true];
};

#include "\achilles\modules_f_ares\module_footer.hpp"
