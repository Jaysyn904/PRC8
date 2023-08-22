/*:://////////////////////////////////////////////
//:: Spell Name Mislead - Heartbeat
//:: Spell FileName PHS_S_Mislead_x
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Actions you can give it as a henchmen is "Follow" "Do nothing (stand ground)"
    "Attack (Pretend to attack)".

    As the spell says. This can be done in part (but never perfectly, it is
    a real-time computer game).

    The illusion is a CopyObject() of the person. It has full consealment against
    attacks and is plotted.

    A temp effect is added so the illusion can be dispelled.

    An additional, a heartbeat is added to the copy so it can do actions (fake ones).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare Major Variables
    object oSelf = OBJECT_SELF;
    object oCaster = GetMaster(oSelf);
    int nCategory;

    // If we don't have a master, or the spells effects, we have to go
    // The concentration thingy done in other scripts will remove PHS_SPELL_MISLEAD
    // and so this is a good check
    if(!GetHasSpellEffect(PHS_SPELL_MISLEAD, oSelf) ||
       !GetIsObjectValid(oCaster))
    {
        SetPlotFlag(oSelf, FALSE);
        DestroyObject(oSelf);
    }

    // We check what action we were given
    int nAction = GetLastAssociateCommand(oSelf);
    int nToDo = 0;

    switch(nAction)
    {
        case ASSOCIATE_COMMAND_ATTACKNEAREST:
        {
            nToDo = 1;
        }
        break;
        case ASSOCIATE_COMMAND_FOLLOWMASTER:
        {
            nToDo = 2;
        }
        break;
        case ASSOCIATE_COMMAND_STANDGROUND:
        {
            nToDo = 0;
        }
        break;
        default:
        {
            nToDo = GetLocalInt(oSelf, "PHS_ACTION");
        }
        break;
    }
    // Continue nToDo's action.
    SetLocalInt(oSelf, "PHS_ACTION", nToDo);

    // Check nToDo action
    if(nToDo == 0)
    {
        // Do nothing
        ClearAllActions();
    }
    else if(nToDo == 1)
    {
        // Attack!
        ClearAllActions();

        // Get enemy
        object oTarget = GetNearestCreature(
                         CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oSelf, 1,
                         CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                         CREATURE_TYPE_IS_ALIVE, TRUE);
        // Are they valid?
        if(GetIsObjectValid(oTarget))
        {
            // Randomly do a defensive or an offensive spell
            // or attack.
            talent tDo;
            int nId;

            if(d10() <= 4)
            {
                // Hostile
                switch(Random(5))
                {
                    case 0: nCategory = TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT; break;
                    case 1: nCategory = TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT; break;
                    case 2: nCategory = TALENT_CATEGORY_HARMFUL_MELEE; break;
                    case 3: nCategory = TALENT_CATEGORY_HARMFUL_RANGED; break;
                    case 4: nCategory = TALENT_CATEGORY_HARMFUL_TOUCH; break;
                }
                tDo = GetCreatureTalentRandom(nCategory, oSelf);
                // Check if a spell
                if(GetIsTalentValid(tDo) && GetTypeFromTalent(tDo) == TALENT_TYPE_SPELL)
                {
                    nId = GetIdFromTalent(tDo);
                    ActionCastFakeSpellAtObject(nId, oTarget);
                    DecrementRemainingSpellUses(oTarget, nId);
                }
                else
                {
                    // Attack
                    ActionEquipMostDamagingRanged(oTarget);
                    ActionAttack(oTarget);
                }
            }
            else
            {
                // Defensive
                switch(Random(6))
                {
                    case 0: nCategory = TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT; break;
                    case 1: nCategory = TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF; break;
                    case 2: nCategory = TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE; break;
                    case 3: nCategory = TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT; break;
                    case 4: nCategory = TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF; break;
                    case 5: nCategory = TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE; break;
                }
                tDo = GetCreatureTalentRandom(nCategory, oSelf);
                // Check if a spell
                if(GetIsTalentValid(tDo) && GetTypeFromTalent(tDo) == TALENT_TYPE_SPELL)
                {
                    nId = GetIdFromTalent(tDo);
                    ActionCastFakeSpellAtObject(nId, oTarget);
                    DecrementRemainingSpellUses(oTarget, nId);
                }
                else
                {
                    // Attack
                    ActionEquipMostDamagingRanged(oTarget);
                    ActionAttack(oTarget);
                }
            }
        }
    }
    else if(nToDo == 2)
    {
        // Go to masters location
        ClearAllActions();
        ActionMoveToLocation(GetLocation(oCaster), TRUE);
    }

    // We will start the heartbeat
    DelayCommand(6.0, ExecuteScript("phs_s_mislead_x", oSelf));
}
