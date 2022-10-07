//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock - AoE Heartbeat
//:: sp_dimens_lock_c
//::///////////////////////////////////////////////
/** @ file
    The OnExit script of the area of effect
    created by the spell Dimensional Lock.
    Unsets the teleportation forbiddance marker on
    the exiting creature


    @author Ornedan
    @date   Created  - 2005.10.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_teleport"

void main()
{
    object oAoE = OBJECT_SELF;
    if(!GetLocalInt(oAoE, "INIT_DONE"))
    {
        object oCreator = GetAreaOfEffectCreator();

        SetLocalObject(oAoE, "PRC_Spell_DimLock_Caster", GetLocalObject(oCreator, "PRC_Spell_DimLock_Caster"));
        SetLocalInt(oAoE, "PRC_Spell_DimLock_SpellPenetr", GetLocalInt(oCreator, "PRC_Spell_DimLock_SpellPenetr"));

        DestroyObject(oCreator);

        SetLocalInt(oAoE, "INIT_DONE", TRUE);
    }

    // Attempt to apply the spell's effect to all within that are not already affected
    object oCaster   = GetLocalObject(oAoE, "PRC_Spell_DimLock_Caster");
    int nPenetr      = GetLocalInt(oAoE, "PRC_Spell_DimLock_SpellPenetr");

    object oTarget   = GetFirstInPersistentObject(oAoE);
    while(GetIsObjectValid(oTarget))
    {
        // Do not affect targets twice
        if(!GetLocalInt(oTarget, "PRC_Spell_DimLock_Affected"))
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, SPELL_DIMENSIONAL_LOCK, oCaster);

            // Spell Resistance
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                SendMessageToPCByStrRef(oTarget, 16825687); // "You feel steady"
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), oTarget);
                SetLocalInt(oTarget, "PRC_Spell_DimLock_Affected", TRUE);
                DisallowTeleport(oTarget);
            }
        }

        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }

    int nVFX = VFX_FNF_PW_DN_YG;
    vector vVFX = GetPosition(oAoE);
           vVFX.z -= 1.0f;
    location lVFX = Location(GetArea(oAoE), vVFX, 0.0f);

    // Do VFX. Specs say something green covering the whole area.
    //*
    float fHeight = FeetToMeters(10.0f);
    DrawHemisphere(DURATION_TYPE_INSTANT, nVFX, lVFX, FeetToMeters(20.0f),
                   0.0, 0.0, fHeight, 0.0, 40, 6.0, 6.0f, 0.0, "z"
                   );
    DelayCommand(3.0f, DrawHemisphere(DURATION_TYPE_INSTANT, nVFX, lVFX, FeetToMeters(20.0f),
                   0.0, 0.0, fHeight, 0.0, 40, 6.0, 6.0f, 180.0f, "z"
                   ));
    /*/
    float fX   = 1.0f;
    float fRev = 6.0f;
    DrawRhodonea(DURATION_TYPE_INSTANT, nVFX, lVFX, FeetToMeters(20.0f),
                 fX / fRev, 0.0f, 100, fRev, 6.0f, 0.0f, "z"
                 );
    //*/
}