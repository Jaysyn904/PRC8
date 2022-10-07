/*:://////////////////////////////////////////////
//:: Spell Name Spiritual Weapon - On Heartbeat
//:: Spell FileName PHS_S_SpiritWeaC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will attack the nearest enemy to oCaster, the master (set on PHS_MASTER).

    Dispels ourself if we go.

    Equips most damaging, needs to be in sight of oCAster and within 20M of them.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_AI_INCLUDE"

void main()
{
    // Declare major variables
    object oSelf = OBJECT_SELF;
    object oCaster = GetLocalObject(oSelf, PHS_MASTER);

    // Need a valid caster
    if(!GetIsObjectValid(oCaster) ||
       !GetHasSpellEffect(PHS_SPELL_SPIRITUAL_WEAPON))
    {
        // Go
        PHSAI_DispelSelf();
        return;
    }

    // If the caster is > 20M away, or they cannot see us, we go.
    if(GetDistanceToObject(oCaster) > 20.0 || !GetObjectSeen(oSelf, oCaster))
    {
        // Return to caster
        ClearAllActions();
        ActionMoveToObject(oCaster, TRUE);
        return;
    }

    // Get the nearest enemy in a loop.
    // * Must be seen (IE: "Directed as a free action")
    // * Must be an enemy
    // * Must be within 20M of the caster (else we'll move out of range)
    int nCnt = 1;
    object oAttack;
    object oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, oSelf, nCnt);
    while(GetIsObjectValid(oCreature))
    {
        // Seen, 20M range, enemy
        if(GetObjectSeen(oCreature, oCaster) &&
           GetIsEnemy(oCreature, oCaster) &&
           GetDistanceBetween(oCreature, oCaster) < 20.0)
        {
            // Attack this one.
            oAttack = oCreature;
            break;
        }
        nCnt++;
        oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, oSelf, nCnt);
    }

    // Attack oAttack, if valid
    if(GetIsObjectValid(oAttack))
    {
        ClearAllActions();
        ActionEquipMostDamagingMelee();
        ActionAttack(oAttack);
        return;
    }
    else
    {
        // Return to caster
        ClearAllActions();
        ActionMoveToObject(oCaster, TRUE);
        return;
    }
}
