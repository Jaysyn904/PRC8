//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell summons a Ghoul, Shadow, Ghast, Wight or
    Wraith
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
	int bIsPC = GetIsPC(OBJECT_SELF);
    int nDuration = nCasterLevel;
    nDuration = 24;
    string sResRef;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    //Check for metamagic extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 11)
        sResRef = "NW_S_GHOUL";
    else if ((nCasterLevel >= 12) && (nCasterLevel <= 13))
        sResRef = "NW_S_GHAST";
    else if ((nCasterLevel >= 14) && (nCasterLevel <= 15))
        sResRef = "NW_S_WIGHT";
    else if ((nCasterLevel >= 16))
        sResRef = "NW_S_SPECTRE";
    effect eSummon = EffectSummonCreature(sResRef,VFX_FNF_SUMMON_UNDEAD);

    //Apply VFX impact and summon effect
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_CREATE_UNDEAD_UNCONTROLLED) && bIsPC)
    {
        object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sResRef, PRCGetSpellTargetLocation());
        //this is to 
        //make it hostile
        ChangeToStandardFaction(oSummon, STANDARD_FACTION_HOSTILE);
        //A) allow time to dominate properly 
        //B) allow time for corpsecrafter to run
        effect eDom = EffectCutsceneDominated();
        eDom = SupernaturalEffect(EffectLinkEffects(eDom, EffectCutsceneImmobilize()));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDom, oSummon, 3.0);
        //visual
        effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, PRCGetSpellTargetLocation());
    }
    else
    {
        if(GetPRCSwitch(PRC_CREATE_UNDEAD_PERMANENT))
        {
            eSummon = SupernaturalEffect(eSummon);
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
        }
        else
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(nDuration));
    }
//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
//   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
//   DelayCommand(0.5, CorpseCrafter(OBJECT_SELF, oSummon)); 

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

