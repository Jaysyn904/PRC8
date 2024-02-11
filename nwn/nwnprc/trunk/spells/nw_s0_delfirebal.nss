//::///////////////////////////////////////////////
//:: Delayed Blast Fireball
//:: NW_S0_DelFirebal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a fiery explosion that does 1d6 per
    caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL);
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nDuration = CasterLvl / 2;
    //Make sure the duration is at least one round
    if(nDuration == 0)
        nDuration = 1;

    int nMetaMagic = PRCGetMetaMagicFeat();
    //Check Extend metamagic feat.
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_DELAY_BLAST_FIREBALL");
    SetAllAoEInts(SPELL_DELAYED_BLAST_FIREBALL, oAoE, PRCGetSpellSaveDC(SPELL_DELAYED_BLAST_FIREBALL, SPELL_SCHOOL_EVOCATION), 0, CasterLvl);
    SetLocalInt(oAoE, "DelayedBlastFireballDamage", ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE));

    PRCSetSchool();
}


