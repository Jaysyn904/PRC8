//::///////////////////////////////////////////////
//:: Sihlbrane's Grove
//:: Spirit Worm
//:: 00_S0_WORM
//:://////////////////////////////////////////////
/*
    You create a lingering decay in the spirit and
    body of the target. If the target fails its saving
    throw, it takes 1 point of temporary Constitution
    damage each round while the spell lasts (maximum
    5 points of Constitution). If it makes its save,
    it does not lose any Constitution but take 1d2
    points of damage each round while the spell
    lasts (maximum 5).

    31.12 - Updated to reflect new scirpting.
    See melf's acid arrow for details.
*/
//:://////////////////////////////////////////////
//:: Created By: Yaballa
//:: Created On: 6/9/2003
//:://////////////////////////////////////////////

#include "pg_spell_CONST"
#include "x2_inc_spellhook"
//#include "x2_i0_spells"
#include "prc_inc_spells"

const int nSpellID = 1501;

void RunConImpact(object oTarget, object oCaster);
void RunDamImpact(object oTarget, object oCaster, int nMetamagic);

void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if(!X2PreSpellCastCode()) {
        return; }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(), oTarget))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }
    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int nTouch = TouchAttackMelee(oTarget);

    if(nDuration < 1) {
        nDuration = 1; }
    if(nDuration > 5) {
        nDuration = 5; }

    if(nMetaMagic == METAMAGIC_EXTEND) {
       nDuration = nDuration * 2; }
    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //--------------------------------------------------------------------------
    // Set the VFX to be non dispelable
    //--------------------------------------------------------------------------
    eDur = ExtraordinaryEffect(eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if(nTouch > 0)
        {
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget))
            {
                SetLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpellID), GetSpellSaveDC());
                int nDC = GetLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpellID));
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
                {
                    //----------------------------------------------------------------------
                    // Con decrease
                    //----------------------------------------------------------------------
                    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCon, oTarget);
                    //----------------------------------------------------------------------
                    // Apply the VFX that is used to track the spells duration
                    //----------------------------------------------------------------------
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
                    object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
                    DelayCommand(6.0f, RunConImpact(oTarget, oSelf));
                }
                //-----------------------------------
                // Magical damage
                //-----------------------------------
                else
                {
                    int nDam = d2();
                    //-----------------------------------
                    //max damage on critical hit, only once
                    //-----------------------------------
                    if(nTouch == 2) {
                        nDam = 2; }
                    effect eDam = EffectDamage(nDam);
                    //-----------------------------------
                    //update VFX
                    //-----------------------------------
                    eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    //----------------------------------------------------------------------
                    // Apply the VFX that is used to track the spells duration
                    //----------------------------------------------------------------------
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
                    object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
                    DelayCommand(6.0f, RunDamImpact(oTarget, oSelf, nMetaMagic));
                }
            }
        }
    }
}

void RunDamImpact(object oTarget, object oCaster, int nMetaMagic)
{
    if(!GetIsEnemy(oTarget, oCaster)){return;}
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if(PRCGetDelayedSpellEffectsExpired(SPELL_SPIRIT_WORM, oTarget, oCaster)) {
        return; }

    if(GetIsDead(oTarget) == FALSE)
    {
        int nDC = GetLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpellID));
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
        {
            //----------------------------------------------------------------------
            // Calculate Damage
            //----------------------------------------------------------------------
            int nDamage = PRCMaximizeOrEmpower(2, 1, nMetaMagic);
            effect eDam = EffectDamage(nDamage);
            effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
            eDam = EffectLinkEffects(eVis, eDam); // flare up
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);
            DelayCommand(6.0f, RunDamImpact(oTarget, oCaster, nMetaMagic));
        }
    }
}

void RunConImpact(object oTarget, object oCaster)
{
    if(!GetIsEnemy(oTarget, oCaster)){return;}
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if(PRCGetDelayedSpellEffectsExpired(SPELL_SPIRIT_WORM, oTarget, oCaster)) {
        return; }

    if(GetIsDead(oTarget) == FALSE)
    {
        int nDC = GetLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpellID));
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
        {
            //----------------------------------------------------------------------
            // Calculate Damage
            //----------------------------------------------------------------------
            effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
            effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            eCon = EffectLinkEffects(eVis, eCon); // flare up
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eCon, oTarget);
            DelayCommand(6.0f, RunConImpact(oTarget, oCaster));
        }
    }
}