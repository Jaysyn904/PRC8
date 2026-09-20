//::///////////////////////////////////////////////  
//:: Name      Anticold Sphere - OnExit  
//:: FileName  sp_anticoldb.nss  
//:://///////////////////////////////////////////// 

void main()  
{  
    object oTarget = GetExitingObject();  
    object oCaster = GetAreaOfEffectCreator();  
    string sTag = "ANTICOLD_SPHERE_" + ObjectToString(oCaster);  
  
    effect eEffect = GetFirstEffect(oTarget);  
    while(GetIsEffectValid(eEffect))  
    {  
        if(GetEffectTag(eEffect) == sTag)  
            RemoveEffect(oTarget, eEffect);  
        eEffect = GetNextEffect(oTarget);  
    }  
}