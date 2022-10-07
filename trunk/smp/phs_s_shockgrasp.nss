/*:://////////////////////////////////////////////
//:: Spell Name Shocking Grasp
//:: Spell FileName PHS_S_ShockGrasp
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Creature or object touched will deal 1d8 + 1 damage (Max +20) (electrical)
    and gets a +3 attack bonus if the opponent is wearing metal armor. Level 1.
    No save!
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We make a melee attack (with a +3 modifier for 2 seconds if they have metal
    armor).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHOCKING_GRASP)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage;

    // Calculate max damage bonus
    int nBonusDamage = PHS_LimitInteger(nCasterLevel, 20); // Max of +20 damage

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    //Declare effects
    effect eAttack;
    // Special VFX
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_SHOCKING_GRASP);

    // Here, we make a check for armor - we add 3 to attack for a second if it is metal.
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    // Use function (checks for getarmor type >= 4)
    if(PHS_GetIsMetalArmor(oArmor))
    {
        // 1 second of it - max time needed really :-)
        eAttack = EffectAttackIncrease(3);
        PHS_ApplyDuration(oCaster, eAttack, 1.0);
    }

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHOCKING_GRASP);

    // Touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // Needs to hit.
    if(nTouch)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Spell resistance and globe check - no turning for touch attacks, however.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Damage - can critical
                nDamage = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, nBonusDamage, nTouch);

                // Do damage and VFX
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ELECTRICAL);
            }
        }
    }
}
