/*:://////////////////////////////////////////////
//:: Spell Name Phase Door: Heartbeat
//:: Spell FileName PHS_S_PhaseDoorC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses a creature who invisiblieses themselves.

    Each creature (an entrance, point 1, and an exit, point 2) will be created.

    A power will remove the invisibility off it. They should have a visual
    from the spell. The invisiblity will be applied as thier own (undispellable)
    effect.

    Click on one for conversation, it takes you to the other.

    One of the creatures is the "master" of the two, and is set to the caster.
    Thats all, else, if one exsists and one doesn't, they both go.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check Master and charges and other destination in HB
    object oSelf = OBJECT_SELF;
    int nCharges = GetLocalInt(oSelf, "PHS_PHASE_DOOR_CHARGES");
    // Get master/spell on us
    object oMaster = PHS_FirstCasterOfSpellEffect(PHS_SPELL_PHASE_DOOR, oSelf);
    // Get destination
    object oDestination = GetLocalObject(oSelf, "PHS_PHASE_DOOR_TARGET");

    // Check all validity
    if(!GetIsObjectValid(oMaster) || !GetIsObjectValid(oDestination) ||
       nCharges <= 0)
    {
        // We go!
        effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
        PHS_ApplyLocationVFX(GetLocation(oSelf), eUnsummon);

        // Go
        PHS_CompletelyDestroyObject(oSelf);
     }
     else
     {
        // Will maybe make ourselves invisible
        if(!PHS_GetHasEffect(EFFECT_TYPE_INVISIBILITY, oSelf))
        {
            // Reduce the local on us by 1
            if(PHS_IncreaseStoredInteger(oSelf, "PHS_SPELL_PHASE_DOOR_INVIS_ROUNDS", -1) <= 0)
            {
                effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
                eInvis = SupernaturalEffect(eInvis);
                // Apply the invisbility.
                PHS_ApplyPermanent(oSelf, eInvis);
            }
        }
     }
}
