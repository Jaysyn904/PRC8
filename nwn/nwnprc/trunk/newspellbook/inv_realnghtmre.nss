

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    //Declare major variables including Area of Effect Object
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nAOE;
    
    if(GetLocalInt(OBJECT_SELF, "NightmareLock"))
    {
        FloatingTextStringOnCreature("You must wait for the previous casting to expire.", OBJECT_SELF, FALSE);
        return;
    }
    
    if(nCasterLvl > 36)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_37;
    else if(nCasterLvl > 30)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_31;
    else if(nCasterLvl > 24)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_25;
    else if(nCasterLvl > 20)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_21;
    else if(nCasterLvl > 14)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_15;
    else if(nCasterLvl > 10)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_11;
    else if(nCasterLvl > 6)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_7;
    else if(nCasterLvl > 3)
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_4;
    else 
        nAOE = INVOKE_VFX_NIGHTMARE_TERRAIN_1;
    
    effect eAOE = EffectAreaOfEffect(nAOE,
        "inv_nightmarea", "inv_nightmarec", "inv_nightmareb");
    location lTarget = PRCGetSpellTargetLocation();
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    
    SetLocalInt(OBJECT_SELF, "NightmareLock", TRUE);
    DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(OBJECT_SELF, "NightmareLock"));

}