/*
	Description:
	Land, wait for players to enter and hover again.

	Parameters:
		0: GROUP
		1: ARRAY - waypoint position
		2: OBJECT - target to which waypoint is attached to

	Returns:
	BOOL
*/

params [["_group", grpNull, [grpNull]], ["_pos", [], [[]], 3], ["_target", objNull, [objNull]]];
private _wp = [_group,currentwaypoint _group];
_wp setwaypointdescription localize "STR_A3_CfgWaypoints_Land";

private _vehsMove = [];
private _vehsLand = [];

// Kex: create LZ
private _lz = "Land_HelipadEmpty_F" createVehicleLocal _pos;
_group setVariable ["Achilles_WP_LZobject", _lz];

// Kex: prevent pilot from being stupid
_group allowFleeing 0;

waituntil
{
	private _countReady = 0;
	private _vehsGroup = [];

	//--- Check state of group members
	{
		private _veh = vehicle _x;
		if (_x == effectivecommander _x) then {
			if (!(_veh in _vehsMove)) then {

				//--- Move to landing position
				_veh domove _pos;

				// Kex: prevent pilot from being stupid
				private _pilot = driver _veh;
				_pilot setSkill 1;

				_vehsMove set [count _vehsMove,_veh];
			} else {
				if !(istouchingground _veh) then {
					if (unitready _veh && !(_veh in _vehsLand)) then {

						//--- van 't Land
						_veh land "land";
						_vehsLand set [count _vehsLand,_veh];
					};
				} else {
					//--- Ready (keep the engine running)
					_veh engineon true;
					_countReady = _countReady + 1;
				};
			};
			_vehsGroup set [count _vehsGroup,_veh];
		};
	} foreach units _group;

	// adjust LZ position
	_lz setPos (waypointPosition _wp);

	//--- Remove vehicles which are no longer in the group
	_vehsMove = _vehsMove - (_vehsMove - _vehsGroup);
	_vehsLand = _vehsLand - (_vehsLand - _vehsGroup);

	sleep 1;
	count _vehsGroup == _countReady
};

// Kex: delete LZ
deleteVehicle _lz;
_group setVariable ["Achilles_WP_LZ_object", nil];

// Landed, now pick up some people
private _heli = _vehsLand select 0; // We assume there is only one heli in the group. TODO: Can there be many? How?
hint format ["_vehsLand: %1, _vehsMove: %2, _heli: %3", count _vehsLand, count _vehsMove, _heli];
private _atLeastOneChange = false;
private _previousCount = count crew _heli;
private _waiting = true;
private _stableCountdown = 0;

while {_waiting} do {
  sleep 1;
  private _newCount = count crew _heli;

  if (_previousCount != _newCount) then {
    _previousCount = _newCount;
    _stableCountdown = 10;
     _atLeastOneChange = true;
  } else {
    if (_atLeastOneChange) then {
      if (_stableCountdown == 0) then {
        _waiting = false;
      } else {
        switch (_stableCountdown) do {
          case 10: {
            [_heli, "Waiting for 10 more seconds"] remoteExec ["vehicleChat", crew _heli, false];
          };
          case 5: {
            [_heli, "5 seconds to takeoff"] remoteExec ["vehicleChat", crew _heli, false];
          };
          case 1: {
            [_heli, "About to take off"] remoteExec ["vehicleChat", crew _heli, false];
          };
          case 0: {
            _waiting = false;
          };
        };
        _stableCountdown = _stableCountdown - 1;
      };
    };
  };
};

true
