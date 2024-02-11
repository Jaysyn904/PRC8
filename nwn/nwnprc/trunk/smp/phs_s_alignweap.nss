/*:://////////////////////////////////////////////
//:: Spell Name Align Weapon
//:: Spell FileName PHS_S_AlignWeap
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [see text]
    Level: Clr 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Weapon touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)

    Align weapon makes a weapon good, evil, lawful, or chaotic, as you choose.
    A weapon that is aligned gains a +1 attack bonus per 5 caster levels
    (maxium +3) against the chosen alignment (and can bypass that amount of
    damage reduction). This spell has no effect on a weapon that grants any
    form of attack bonus.

    You can’t cast this spell on a natural weapon, such as an unarmed strike.

    When you make a weapon good, evil, lawful, or chaotic, align weapon is a
    good, evil, lawful, or chaotic spell, respectively.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Basically, it gives +1 attack to the weapon affected, versus the alignment
    chosen. It goes up to a max of +3, every 5 levels.

    Only can be used on weapons with no attack bonus at all, and cannot be cast
    on ammo (as they cannot be given attack bonuses!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be an item
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellCast = GetSpellId();
    int nAlignment;
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // It is +1/5 levels, to a max of 3
    int nBonus = PHS_LimitInteger(nCasterLevel/5, 3);

    // Duration in turns (minutes)
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Get the alignment to be against
    if(nSpellCast == PHS_SPELL_ALIGN_WEAPON_GOOD)
    {
        nAlignment = IP_CONST_ALIGNMENTGROUP_GOOD;
    }
    else if(nSpellCast == PHS_SPELL_ALIGN_WEAPON_CHAOTIC)
    {
        nAlignment = IP_CONST_ALIGNMENTGROUP_CHAOTIC;
    }
    else if(nSpellCast == PHS_SPELL_ALIGN_WEAPON_LAWFUL)
    {
        nAlignment = IP_CONST_ALIGNMENTGROUP_LAWFUL;
    }
    // Default to evil
    else // if(nSpellCast == PHS_SPELL_ALIGN_WEAPON_EVIL)
    {
        nAlignment = IP_CONST_ALIGNMENTGROUP_EVIL;
    }

    // Declare effects
    itemproperty IP_Alignbonus = ItemPropertyAttackBonusVsAlign(nAlignment, nBonus);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    // Apply it to the item if it doens't have an attack bonus
    if(!GetItemHasItemProperty(oTarget, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP))
    {
        // Apply duration effect
        PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration);
        // Add it to the item
        AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Alignbonus, oTarget, fDuration);
    }
}
