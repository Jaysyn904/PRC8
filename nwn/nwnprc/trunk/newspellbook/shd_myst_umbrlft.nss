/*
12/10/19 by Stratovarius

Umbral Fist

Apprentice, Night's Long Fingers 
Level/School: 3rd/Transmutation 
Range: Personal 
Target: You 
Duration: 1 minutes/level

Your hand turns jet black and seems to flicker as tiny wisps of shadow constantly leak from between your fingers and disappear.

For the duration of this mystery, you can, as a standard action, make a special attack against any foe within medium range (100 ft. + 10 ft./level). You must have line of sight to the target.
You can make any one of the following special attacks: bull rush, disarm, or trip. For purposes of adjudicating these attacks, make your touch attack as normal, if one is necessary. When actually 
resolving the opposed roll, however, substitute your caster level for your base attack bonus and either your Intelligence or Charisma modifier (your choice) for your Strength. Because the attack 
is made at a distance, it does not draw an attack of opportunity that such an attack would draw under normal circumstances, nor can your foe attempt to perform the same maneuver on you in turn, 
even if such is normally allowed.

This is the feat script
*/

#include "prc_inc_combmove"
#include "shd_inc_shdfunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    int nMoveType = PRCGetSpellId();
    
    if (oTarget == oPC) return; // No hitting yourself
    if (GetLocalInt(oPC, "CombatLoopProtection")) return; // Stop the damn loop
    
    int nAbi = max(GetAbilityModifier(ABILITY_INTELLIGENCE, oPC), GetAbilityModifier(ABILITY_CHARISMA, oPC));
    SetLocalInt(oPC, "BABOverride", GetShadowcasterLevel(oPC));
    DelayCommand(1.0, DeleteLocalInt(oPC, "BABOverride"));
   
    if (nMoveType == MYST_UMBRAL_FIST_BULL_RUSH)
        DoBullRush(oPC, oTarget, 0, FALSE, FALSE, TRUE, nAbi);   
    else if (nMoveType == MYST_UMBRAL_FIST_TRIP)
        DoTrip(oPC, oTarget, 0, FALSE, FALSE, FALSE, nAbi);     
    else if (nMoveType == MYST_UMBRAL_FIST_DISARM)
        DoDisarm(oPC, oTarget, 0, FALSE, FALSE);        
    
    SetLocalInt(oPC, "CombatLoopProtection", TRUE);
    DelayCommand(4.0, DeleteLocalInt(oPC, "CombatLoopProtection"));
}