//::///////////////////////////////////////////////
//:: Name      Scalding Gust
//:: FileName  inv_dra_scldgust.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You create a strong blast of searing wind in a 60'
line before you. Creatures smaller than medium must
make a Fortitude save or be knocked down, and all
creatures within the area of effect regardless take
1 point of fire damage per caster level.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nPenetr = CasterLvl + SPGetPenetr();
    float fRange = FeetToMeters(60.0);
    float fDelay;
    effect eDmg = EffectDamage(CasterLvl, DAMAGE_TYPE_FIRE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    
    //Get first target in the spell cylinder
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fRange, lTarget,
                                   TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_SCALDING_GUST));
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                if(PRCGetCreatureSize(oTarget) < CREATURE_SIZE_MEDIUM)
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_NONE))
                {
                    effect eWindblown = EffectKnockdown();
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWindblown, oTarget, 6.0));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target in the spell cylinder
        oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fRange, lTarget,
                                      TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}