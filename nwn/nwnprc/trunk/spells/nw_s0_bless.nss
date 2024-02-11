//::///////////////////////////////////////////////
//:: Bless
//:: NW_S0_Bless.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Bless
Enchantment (Compulsion) [Mind-Affecting]
Level:            Clr 1, Pal 1
Components:       V, S, DF
Casting Time:     1 standard action
Range:            50 ft.
Area:             The caster and all allies within
                  a 50-ft. burst, centered on the caster
Duration:         1 min./level
Saving Throw:     None
Spell Resistance: Yes (harmless)


Bless fills your allies with courage. Each ally
gains a +1 morale bonus on attack rolls and on
saving throws against fear effects.

Bless counters and dispels bane.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Added Bless item ability: Georg Z, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(nCasterLvl);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // ---------------- TARGETED ON BOLT  -------------------
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) == BASE_ITEM_BOLT)
        {
           object oPossessor = GetItemPossessor(oTarget);
           SignalEvent(oPossessor, EventSpellCastAt(oCaster, SPELL_BLESS, FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_SLAYRAKSHASA, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPossessor);
           SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPossessor, fDuration, FALSE);
           PRCSetSchool();
           return;
        }
    }

    location lCaster = GetLocation(oCaster);
    float fRange = FeetToMeters(50.0);

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lCaster);

    //Get the first target in the radius around the caster
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lCaster);
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLESS, FALSE));

            float fDelay = PRCGetRandomDelay(0.4, 1.1);

            if(GetHasSpellEffect(SPELL_BANE, oTarget))
                //Remove Bane spell
                DelayCommand(fDelay, PRCRemoveEffectsFromSpell(oTarget, SPELL_BANE));
            else
            {
                effect eAttack = EffectAttackIncrease(1);
                effect eSave   = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
                effect eLink   = EffectLinkEffects(eAttack, eSave);
                       eLink   = EffectLinkEffects(eLink, eDur);

                //Apply bonus effects
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BLESS, nCasterLvl));
            }
            //Apply VFX impact
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lCaster);
    }
    PRCSetSchool();
}
