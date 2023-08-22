//::///////////////////////////////////////////////
//:: Hellish Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    NPC only spell for yaron

    like normal inferno but lasts only 5 rounds,
    ticks twice per round, adds attack and damage
    penalty.

*/
//:://////////////////////////////////////////////
// Georg Z, 19-10-2003
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"


void RunImpact(object oTarget, object oCaster);

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    object oTarget = PRCGetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = CasterLvl/2;

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration * 2;
    }
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    if (nDuration >6)
    {
        nDuration= 6;
    }

    CasterLvl +=SPGetPenetr();

    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

    if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl))
    {
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f);
        effect eAttackDec = EffectAttackDecrease(4);
        effect eDamageDec = EffectDamageDecrease(4, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
        effect eLink = EffectLinkEffects(eAttackDec, eDamageDec);
        effect eDur = EffectVisualEffect(498);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)));
        object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
        DelayCommand(fDelay,RunImpact(oTarget, oSelf));
    }
    else
    {
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


void RunImpact(object oTarget, object oCaster)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (PRCGetDelayedSpellEffectsExpired(762,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //* GZ: Removed Meta magic, does not work in delayed functions
        effect eDam  = PRCEffectDamage(oTarget, d6(2), ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE));
        effect eDam2 = PRCEffectDamage(oTarget, d6(1), DAMAGE_TYPE_DIVINE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam2,oTarget);
        DelayCommand(3.0f,RunImpact(oTarget,oCaster));
    }
}

