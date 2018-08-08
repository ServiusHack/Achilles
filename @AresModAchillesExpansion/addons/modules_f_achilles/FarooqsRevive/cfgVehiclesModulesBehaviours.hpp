class Achilles_FarooqsRevive_Module_Base : Achilles_Module_Base
{
	Category = "Achilles_fac_FarooqsRevive";
	icon = "\achilles\data_f_achilles\icons\icon_default_unit.paa";
	portrait = "\achilles\data_f_achilles\icons\icon_default_unit.paa";
};

class Achilles_FarooqsRevive_Instant_Module : Achilles_FarooqsRevive_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Achilles_InstantRevive_Module";
	displayName = "$STR_AMAE_INSTANT_REVIVE";
	function = "Achilles_fnc_FarooqsReviveInstant";
};

class Achilles_FarooqsRevive_Immersive_Module : Achilles_FarooqsRevive_Module_Base
{
	scopeCurator = 2;
	curatorCanAttach = 1;
	_generalMacro = "Achilles_ImmersiveRevive_Module";
	displayName = "$STR_AMAE_IMMERSIVE_REVIVE";
	function = "Achilles_fnc_FarooqsReviveImmersive";
};
