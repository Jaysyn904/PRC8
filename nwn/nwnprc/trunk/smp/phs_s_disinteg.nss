/*:://////////////////////////////////////////////
//:: Spell Name Disintegrate
//:: Spell FileName PHS_S_Disinteg
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, ray (ranged attack) and SR applies. Damage is 2d6 damage a caster
    level to 40d6, NPC's reduced to 0 or less HP are destroyed. A fort save
    makes the damage only 5d6, same rules for disintegration for NPC's
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses new green ray :-D

    Only NPC's are destroyed utterly by the ray (using cutseen invsibility,
    and damage, then destruction of body).

    Objects of the NPC's are placed randomly around (if droppable).

    Only affects destroyable things. Damage is in magical. Should bypass all
    reductions. (I hope!)

    The second script does the destroying of NPCs, as it is much easier to
    ExecuteScript rather then assign command (which won't work on a dead person!)

    It will:
    - Set destroyable status (OBJECT_SELF)
    - Create a dust thingy, move inventory.
    - Destroy self.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DISINTEGRATE)) return;

    // Declare major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam;

    // Do touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RANGED, oTarget, TRUE);

    // Do beam effect hit/miss
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_DISINTEGRATE, nTouch);

    // 2x x level, up to 40 (IE 20 caster levels)
    int nDice = PHS_LimitInteger(nCasterLevel * 2, 40);

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_DISINTEGRATION);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISINTEGRATE);

    // Touch attack
    if(nTouch)
    {
        // If it is a special thing only Disintegrate can be destroyed by, we
        // check it here
        if(GetTag(oTarget) == PHS_CREATURE_TAG_MAGES_SWORD)
        {
            // Removing all the effects will dispel it or remove it next heartbeat.
            PHS_RemoveAllEffects(oTarget);
        }
        // Reaction type and Destroyable check
        else if(!GetIsReactionTypeFriendly(oTarget) &&
                 PHS_CanCreatureBeDestroyed(oTarget))
        {
            // Spell resistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Check fortitude save.
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
                {
                    // Only 5d6 damage
                    nDam = PHS_MaximizeOrEmpower(6, 5, nMetaMagic, 0, nTouch);
                }
                else
                {
                    // Maximum damage
                    nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic, 0, nTouch);
                }

                // Use new function
                PHS_DisintegrateDamage(oTarget, eVis, nDam);
            }
        }
    }
}
