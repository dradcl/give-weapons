void PluginInit()
{
    g_Module.ScriptInfo.SetAuthor("Karma Kitten");
    g_Module.ScriptInfo.SetContactInfo("@karmakittenx - Twitter");

    g_Hooks.RegisterHook( Hooks::Player::ClientSay, @ClientSay );
}

// Define console commands
CConCommand give("givewep", "Grants the player a weapon of their choice", @CnsCmd);

array<string> weapons = { // * - Special weapon, not included in 'all' command
    "weapon_crowbar",
	"weapon_9mmhandgun",
	"weapon_357",
	"weapon_9mmAR",
    "weapon_mp5",
    "weapon_handgrenade",
	"weapon_crossbow",
	"weapon_shotgun",
	"weapon_rpg",
	"weapon_gauss",
	"weapon_egon",
    "weapon_hornetgun",
    "weapon_satchel",
	"weapon_uzi",
    "weapon_uziakimbo",
	"weapon_medkit",
	"weapon_pipewrench",
	"weapon_grapple",
	"weapon_sniperrifle",
	"weapon_m249",
    "weapon_tripmine",
    "weapon_snark",
	"weapon_m16",
	"weapon_sporelauncher",
	"weapon_eagle",
	"weapon_displacer",
    "weapon_minigun", // * Does not grant however
    "weapon_shockrifle" // *
};

bool GiveWeapon(CBasePlayer@ player, string weapon)
{
    if (weapon == "all")
    {
        for(uint i = 0; i < weapons.length() - 2; i++)
        {
            player.GiveNamedItem(weapons[i], 0, 200);
        }
        return true; // All weapons successfully given
    }

    if(IsValidWeapon(weapon))
    {
        player.GiveNamedItem(weapon, 0, 200);
        return true; // Weapon was successfully given
    }
    
    return false; // Weapon was not successfully given
}

bool IsValidWeapon(string weapon)
{
    if (weapons.find(weapon) > 0)
    {
        return true; // If the weapon is found (>0, valid in the game)
    }
    return false; // If the weapon is not found (-1, not in the game or typo)
}

void CnsCmd(const CCommand@ args)
{
    CBasePlayer@ player = g_ConCommandSystem.GetCurrentPlayer();

    if (args.ArgC() > 0) // Has at least 1 argument (the weapon identifier)
    {
        GiveWeapon(player, args[1]);
    }
}

HookReturnCode ClientSay(SayParameters@ sp)
{
    const CCommand@ args = sp.GetArguments(); // Get arguments from the user message
    CBasePlayer@ player = sp.GetPlayer();
    
    if (args.ArgC() > 0 && GiveWeapon(player, args[1])) // Same logic as CnsCmd(), true if args are valid and the weapon was successfully given to the player
    {
        return HOOK_HANDLED;
    }
    return HOOK_CONTINUE;
}