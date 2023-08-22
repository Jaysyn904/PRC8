//::///////////////////////////////////////////////
//:: Planar Ally
//:: X0_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Modified from Planar binding
//:: Hold ability removed for cleric version of spell

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nSpellID = PRCGetSpellId();

    int nDuration = nCasterLvl;
    effect eSummon;
    //effect eGate;


    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nDuration == 0)
    {
        nDuration == 1;
    }
    //Check for metamagic extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    //Set the summon effect based on the alignment of the caster
    float fDelay = 3.0;
    switch (nAlign)
    {
        case ALIGNMENT_EVIL:
        {
            if(nSpellID == SPELL_GREATER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, fDelay);
            else if(nSpellID == SPELL_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_SUCCUBUS", VFX_FNF_SUMMON_GATE, fDelay);
            else if(nSpellID == SPELL_LESSER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_IMP", VFX_FNF_SUMMON_GATE, fDelay);
            //eGate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
        }
        break;
        case ALIGNMENT_GOOD:
        {
            if(nSpellID == SPELL_GREATER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_CTRUMPET", VFX_FNF_SUMMON_CELESTIAL, fDelay);
            else if(nSpellID == SPELL_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_CHOUND", VFX_FNF_SUMMON_CELESTIAL, fDelay);
            else if(nSpellID == SPELL_LESSER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_CLANTERN", VFX_FNF_SUMMON_CELESTIAL, fDelay);
            //eGate = EffectVisualEffect(219);
        }
        break;
        case ALIGNMENT_NEUTRAL:
        {
            if(nSpellID == SPELL_GREATER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_SLAADDETH", VFX_FNF_SUMMON_MONSTER_3, 1.0);
            else if(nSpellID == SPELL_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_SLAADGRN", VFX_FNF_SUMMON_MONSTER_3, 1.0);
            else if(nSpellID == SPELL_LESSER_PLANAR_ALLY)
                eSummon = EffectSummonCreature("NW_S_SLAADRED", VFX_FNF_SUMMON_MONSTER_3, 1.0);
            //eGate = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
        }
        break;
    }
    //Apply the summon effect and VFX impact
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, PRCGetSpellTargetLocation());
    MultisummonPreSummon();

    float fDuration = HoursToSeconds(nDuration);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

