//::///////////////////////////////////////////////
//:: Name      Chilling Fog - OnHeartbeat
//:: FileName  inv_dra_chilfogc.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oAoE = OBJECT_SELF;

    //Declare major variables
    int nDamage = d6(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    object oTarget;
    float fDelay;

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if(!GetIsObjectValid(oCaster))
    {
        DestroyObject(oAoE);
        return;
    }

    int nPenetr = SPGetPenetrAOE(oCaster);

    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(oAoE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            
            fDelay = PRCGetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CHILLING_FOG));
            //Spell resistance check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Apply damage and visuals
                //Set the damage effect
                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(oAoE);
    }
}