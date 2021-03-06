/*
	Author: CreepPork_LV

	Description:
	 Adds a variable to a vehicle that allows the jamming of IEDs

  Parameters:
    _this select: 0 - OBJECT - Object that the module was placed upon

  Returns:
    Nothing
*/

#include "\achilles\modules_f_ares\module_header.hpp"

private _object = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

if (isNull _object) exitWith {[localize "STR_AMAE_ENYO_NO_VEHICLE_SELECTED"] call Achilles_fnc_ShowZeusErrorMessage};

if (isPlayer _object || isPlayer driver _object) exitWith {[localize "STR_AMAE_ENYO_NO_VEHICLE_SELECTED"] call Achilles_fnc_ShowZeusErrorMessage};

if (_object isKindOf "Car" || _object isKindOf "Tank") then
{
    private _dialogResult =
    [
        localize "STR_AMAE_ENYO_ADD_ECM_TO_VEHICLE",
        [
          [localize "STR_AMAE_ENYO_ADD_ECM", [localize "STR_AMAE_YES", localize "STR_AMAE_NO"]]
        ]
    ] call Ares_fnc_showChooseDialog;

    if (isNil "_dialogResult") exitWith {};
    if (_dialogResult isEqualTo []) exitWith {};

    private _isECM = _dialogResult select 0;

    if (_isECM == 0) then {_object setVariable ["isECM", true, true]} else {_object setVariable ["isECM", false, true]};
}
else
{
  [localize "STR_AMAE_ENYO_NO_VEHICLE_SELECTED"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F";
};

#include "\achilles\modules_f_ares\module_footer.hpp"
