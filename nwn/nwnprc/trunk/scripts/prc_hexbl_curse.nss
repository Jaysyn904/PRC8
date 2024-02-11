/*
    prc_hexbl_curse

    Afflicted creatures save or suffer a large penalty to stats.
*/

#include "prc_inc_combat"

void main()
{
    object oCaster = OBJECT_SELF; 
    object oTarget = PRCGetSpellTargetObject();

    if(GetHasFeatEffect(FEAT_HEXCURSE, oTarget))
    {
        FloatingTextStrRefOnCreature(100775, oCaster, FALSE);//"Target already has this effect!"
        IncrementRemainingFeatUses(oCaster, FEAT_HEXCURSE);
        return;
    }

    if(!TakeSwiftAction(oCaster))
    {
        FloatingTextStringOnCreature("You can use this ability only once per round!", oCaster, FALSE);
        IncrementRemainingFeatUses(oCaster, FEAT_HEXCURSE);
        return;
    }

    int nClass = GetLevelByClass(CLASS_TYPE_HEXBLADE, oCaster);
    int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oCaster) + (nClass / 2);
    int nDmgType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget));
    if(nDmgType == -1) nDmgType = DAMAGE_TYPE_BLUDGEONING;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    int nPen = 2;
    if      (nClass > 36) nPen = 8;
    else if (nClass > 18) nPen = 6;
    else if (nClass >= 6) nPen = 4;

    //if(GetHasFeat(FEAT_EMPOWER_CURSE, oCaster))
    //    nPen += 1;

    effect eLink = EffectLinkEffects(EffectAttackDecrease(nPen), EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen));
           eLink = EffectLinkEffects(eLink, EffectDamageDecrease(nPen, nDmgType));
           eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPen));
           eLink = SupernaturalEffect(eLink);

    //Make Will Save
    if(!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
    {
        //Apply Effect and VFX
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else // Doesn't count as used if the target makes their save
        IncrementRemainingFeatUses(oCaster, FEAT_HEXCURSE);
}