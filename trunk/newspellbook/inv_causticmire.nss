//::///////////////////////////////////////////////
//:: Name      Caustic Mire
//:: FileName  inv_causticmire.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
4th Level Spell

You can create an area of acidic sludge on the
ground. Any creature who steps into it is slowed by
about a third, and each 5' they move deals 1d6 acid
damage to them. If a creature stands still in it
they still take 1d6 acid damage each round. The
sludge lasts one round per level, and you can only
create one area at any given time.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    if(GetLocalInt(oCaster, "CausticMireLock"))
    {
        FloatingTextStringOnCreature("You must wait for the previous casting to expire.", oCaster, FALSE);
        return;
    }

    //Declare major variables including Area of Effect Object
    location lTarget = PRCGetSpellTargetLocation();
    float fDuration = RoundsToSeconds(GetInvokerLevel(oCaster, GetInvokingClass()));
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_CAUSTIC_MIRE);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    SetLocalInt(oCaster, "CausticMireLock", TRUE);
    DelayCommand(fDuration, DeleteLocalInt(oCaster, "CausticMireLock"));
}

