/*
	Author: ServiusHack

	Description:
	Instantly revive a player using farooq's Revive.


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

// Let Zeus know what will happen
[localize "STR_AMAE_REVIVE_FEW_SECONDS"] call Ares_fnc_ShowZeusMessage;

// Revive
_object setVariable ["FAR_isUnconscious", 0, true];
_object setVariable ["FAR_isDragged", 0, true];

#include "\achilles\modules_f_ares\module_footer.hpp"
