/**
 * @file
 * Spellscript for Lich touch attack
 */
#include "prc_inc_sp_tch"
#include "prc_inc_template"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nIsDemi = GetHasTemplate(TEMPLATE_DEMILICH,OBJECT_SELF);

    // Gotta hit first
    if(PRCDoMeleeTouchAttack(oTarget)<1)
        return;

    // Gotta be a living critter
    int nType = MyPRCGetRacialType(oTarget);
    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
        (nType == RACIAL_TYPE_UNDEAD) ||
        (nType == RACIAL_TYPE_ELEMENTAL))
        return;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    // Total character levels
    int nTotalHD = GetHitDice(OBJECT_SELF);
    // Save DC
    int nSaveDC = 10 + nTotalHD/2 + GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
    // Damage
    int nDam = d8()+5;
    if(nIsDemi)
        nDam = d6(10)+20;
    // Apply Damage 1/2 if they will save, Demiliches - no save
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    if(WillSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NEGATIVE) && !nIsDemi)
        nDam = nDam/2;

    effect eDamage = EffectDamage(nDam,DAMAGE_TYPE_NEGATIVE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
    // Apply paralyze touch
    if(FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_NONE,OBJECT_SELF))
        return;
    eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect ePara = EffectParalyze();
    ePara = EffectLinkEffects(eVis,ePara);
    // Cant be dispelled
    ePara = SupernaturalEffect(ePara);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePara,oTarget);
    eVis = EffectVisualEffect(VFX_IMP_STUN);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
}
