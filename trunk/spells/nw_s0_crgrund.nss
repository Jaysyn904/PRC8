//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an undead type pegged to the character's
    level.
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
    int nDuration = nCasterLevel;
    nDuration = 24;
    string sResRef;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    //Make metamagic extend check
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Determine undead to summon based on level
    if (nCasterLevel <= 15)
        sResRef = "NW_S_VAMPIRE";
    else if ((nCasterLevel >= 16) && (nCasterLevel <= 17))
        sResRef = "NW_S_DOOMKGHT";
    else if ((nCasterLevel >= 18) && (nCasterLevel <= 19))
        sResRef = "NW_S_LICH";
    else
        sResRef = "NW_S_MUMCLERIC";
    effect eSummon = EffectSummonCreature(sResRef,VFX_FNF_SUMMON_UNDEAD);
    //Apply summon effect and VFX impact.
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_CREATE_UNDEAD_UNCONTROLLED))
    {
        object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sResRef, PRCGetSpellTargetLocation());
        //make it hostile
        ChangeToStandardFaction(oSummon, STANDARD_FACTION_HOSTILE);
        //this is to
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

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

