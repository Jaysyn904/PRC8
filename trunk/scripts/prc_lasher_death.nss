//::///////////////////////////////////////////////
//:: Lasher - Death Spiral
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 27, 2005
//:: Modified: Nov 5, 2005
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nDC;
    int nDC2 = 18;
    int nSpellId = GetSpellId();
    float fRange = 4.5;
    location lLoc = GetLocation(oPC);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SILENCE), lLoc);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lLoc, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
        {
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellId));
            nDC = GetAttackBonus(oTarget, OBJECT_SELF, oWeapon) + d20();
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4() + 1));
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC2))
                {
                    int nDur = d4() - 1;
                    nDur = nDur ? nDur : 1;
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oTarget, RoundsToSeconds(nDur));
                }
            }
        }
    oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lLoc, OBJECT_TYPE_CREATURE);
    }
}

