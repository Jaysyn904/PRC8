/*:://////////////////////////////////////////////
//:: Spell Name Shillelagh
//:: Spell FileName PHS_S_Shillelagh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Touch, Target: One touched nonmagical oak club or quarterstaff
    Duration: 1 min./level

    Your own nonmagical club or quarterstaff becomes a weapon with a +1
    enhancement bonus on attack and damage rolls. It deals extra damage as if it
    were two size categories larger (a club would add 1d4 damage, a quarterstaff
    adds 1d6 points of damage), and +1 for its enhancement bonus. These effects
    only occur when the weapon is wielded by you, and if you drop the weapon or
    it is disarmed, it loses its enchantment.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell states.

    It adds damage for:
    - Normal Club: +1d4 (minimum random)
    - Normal quarterstaff +1d6.

    Because club is small (and usually does 1d6) and quarterstaff is medium and
    2 handed.

    Also gets +1 enchantment bonus. Quite powerful, but only non-magical weapons
    work with it (and only 1 minute/level).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_SHILLELAGH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nItemType = GetBaseItemType(oTarget);

    // Duration is 1 minutes a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Duration effect for dispelling
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHILLELAGH, FALSE);

    // Make sure the target is a valid item
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // What sort of item is it? is it a valid one!
        if(nItemType == BASE_ITEM_CLUB ||
           nItemType == BASE_ITEM_QUARTERSTAFF)
        {
            // Cannot be enchanted
            if(!PHS_IP_GetIsEnchanted(oTarget))
            {
                // We add 1d4 for a club, and 1d6 for a quarterstaff damage, +1 enchatment each
                itemproperty IP_Damage;
                if(nItemType == BASE_ITEM_CLUB)
                {
                    IP_Damage = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_1d4, IP_CONST_DAMAGETYPE_BLUDGEONING);
                }
                else
                {
                    IP_Damage = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_1d6, IP_CONST_DAMAGETYPE_BLUDGEONING);
                }
                itemproperty IP_Enchantment = ItemPropertyEnhancementBonus(1);

                // Apply effects
                PHS_ApplyDuration(oTarget, eDur, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Damage, oTarget, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Damage, oTarget, fDuration);
            }
        }
    }
}
