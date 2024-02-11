//::///////////////////////////////////////////////
//:: Name      Chilling Tentacles
//:: FileName  inv_chillingtent.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
5th Level Spell

This invocation acts as the spell Evard's Black
Tentacles. In addition, every round a creature is
in the area of effect they take 2d6 cold damage.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(INVOKE_VFX_CHILLING_TENTACLES,
        "inv_chilltenta", "inv_chilltentc", "inv_chilltentb");
    location lTarget = PRCGetSpellTargetLocation();
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    //Make sure duration does no equal 0
    if(nDuration < 1)
        nDuration = 1;

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "INVOKE_VFX_CHILLING_TENTACLES");
    SetAllAoEInts(INVOKE_CHILLING_TENTACLES, oAoE, GetInvocationSaveDC(OBJECT_INVALID, OBJECT_SELF, INVOKE_CHILLING_TENTACLES), 0, nDuration);
}