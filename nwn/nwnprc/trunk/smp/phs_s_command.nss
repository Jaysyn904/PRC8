/*:://////////////////////////////////////////////
//:: Spell Name Command
//:: Spell FileName PHS_S_Command
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Mind affecting, close range, 1 living creature target, 1 round duration,
    will negates, SR applies.

    You give the subject a single command, which it obeys to the best of its
    ability at its earliest opportunity. You may select from the following options.

    - Approach: On its turn, the subject moves toward you as quickly and directly
    as possible for 1 round. The creature may do nothing but move during its
    turn, and it provokes attacks of opportunity for this movement as normal.

    - Drop: On its turn, the subject drops whatever it is holding. It can’t pick
    up any dropped item until its next turn.

    - Fall: On its turn, the subject falls to the ground and remains prone for 1
    round. It may act normally while prone but takes any appropriate penalties.

    - Flee: On its turn, the subject moves away from you as quickly as possible
    for 1 round. It may do nothing but move during its turn, and it provokes
    attacks of opportunity for this movement as normal.

    - Halt: The subject stands in place for 1 round. It may not take any actions
    but is not considered helpless.

    If the subject can’t carry out your command on its next turn, the spell
    automatically fails.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can set what the effect will be before the spell is cast, or use a sub-dial
    menu for the spell (does it work right with SR and Globes though?)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_COMMAND)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration is 1 round (6 seconds)
    float fDuration = RoundsToSeconds(1);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eKnockdown = EffectKnockdown();;

    // Get what one we will do
    int nCommandType = GetLocalInt(oCaster, "PHS_SPELL_COMMAND");

    // Types (keep as integers):
    // 0 - Approach
    // 1 - Drop
    // 2 - Fall
    // 3 - Flee
    // 4 - Halt

    // Check PvP settings
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check if they can be commanded
        if(GetCommandable(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_COMMAND);

            // Check against mind spells
            if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
            {
                // Check spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Will Saving throw versus fear negates
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR))
                    {
                        // Do the different things
                        switch(nCommandType)
                        {
                            case 0: // Approach
                            {
                                DelayCommand(fDuration, SetCommandable(TRUE, oTarget));
                                AssignCommand(oTarget, ClearAllActions());
                                AssignCommand(oTarget, ActionMoveToObject(oCaster, TRUE));
                                SetCommandable(FALSE, oTarget);
                            }
                            break;
                            case 1: // Drop
                            {
                                // Check if the items are droppable - if not, they don't drop!
                                object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                                object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                                if(GetDroppableFlag(oItem1) || GetDroppableFlag(oItem2))
                                {
                                    // Drop it
                                    AssignCommand(oTarget, ClearAllActions());
                                    if(GetDroppableFlag(oItem1))
                                    {
                                        AssignCommand(oTarget, ActionPutDownItem(oItem1));
                                    }
                                    if(GetDroppableFlag(oItem1))
                                    {
                                        AssignCommand(oTarget, ActionPutDownItem(oItem2));
                                    }
                                }
                            }
                            break;
                            case 2: // Fall
                            {
                                // Knockdown
                                PHS_ApplyDuration(oTarget, eKnockdown, fDuration);
                            }
                            break;
                            case 3: // Flee
                            {
                                // Run away from us
                                DelayCommand(fDuration, SetCommandable(TRUE, oTarget));
                                AssignCommand(oTarget, ClearAllActions());
                                AssignCommand(oTarget, ActionMoveAwayFromObject(oCaster, TRUE));
                                SetCommandable(FALSE, oTarget);
                            }
                            break;
                            case 4: // Halt
                            {
                                // Just stop
                                DelayCommand(fDuration, SetCommandable(TRUE, oTarget));
                                AssignCommand(oTarget, ClearAllActions());
                                SetCommandable(FALSE, oTarget);
                            }
                            break;
                        }
                    }
                }
            }
        }
    }
}
