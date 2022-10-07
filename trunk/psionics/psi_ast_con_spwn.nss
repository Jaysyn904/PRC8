//::///////////////////////////////////////////////
//:: Astral Construct OnSpawn eventscript
//:: psi_ast_con_spwn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.01.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_ac_spawn"
#include "psi_inc_ac_manif"

void BiobugsSuck(object oSpawn)
{
    // Grab the locals for the slot manifested from and copy them onto the construct
    object oManifester = GetMaster(oSpawn);
    string sSlot       = GetLocalString(oManifester, MANIFESTED_SLOT);
    int nACLevel       = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_LEVEL              + sSlot);
    int nOptionFlags   = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_OPTION_FLAGS       + sSlot);
    int nResElemFlags  = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + sSlot);
    int nETchElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + sSlot);
    int nEBltElemFlags = GetLocalInt(oManifester, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + sSlot);
    SetLocalInt(oSpawn, ASTRAL_CONSTRUCT_LEVEL,              nACLevel);
    SetLocalInt(oSpawn, ASTRAL_CONSTRUCT_OPTION_FLAGS,       nOptionFlags);
    SetLocalInt(oSpawn, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS,   nResElemFlags);
    SetLocalInt(oSpawn, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS, nETchElemFlags);
    SetLocalInt(oSpawn, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS,  nEBltElemFlags);

    // Do appearance switching
    int nCraft = GetHighestCraftSkillValue(oManifester);
    int nCheck = d20() + nCraft;

    int nAppearance = GetAppearanceForConstruct(nACLevel, nOptionFlags, nCheck);
    SetCreatureAppearanceType(oSpawn, nAppearance);

    HandleAstralConstructSpawn(oSpawn);

    // Execute other OnSpawn stuff
    ExecuteScript("nw_ch_acani9", oSpawn);
}

void main()
{
    //SpawnScriptDebugger();

    object oSpawn = OBJECT_SELF;

    // Set AI level
    SetAILevel(oSpawn, AI_LEVEL_HIGH);

    DelayCommand(0.5f, BiobugsSuck(oSpawn));
/* Uncomment if AC is ever moved to be a henchman
    // Handle the main Astral Construct spawn stuff
    // Farmed out to an include file. This one is just to link it
    // and the default spawn handling
    HandleAstralConstructSpawn(oSpawn);

    // Execute other OnSpawn stuff
    ExecuteScript("nw_ch_acani9", oSpawn);
*/
}
