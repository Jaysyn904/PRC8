///////////////////////////////////////////////////
// Daylight On Enter
// sp_daylightA.nss
////////////////////////////////////////////////////

void main()
{
        object oTarget = GetEnteringObject();
        int nLight = GetLocalInt(oTarget, "PRCInLight");
        nLight++;
        SetLocalInt(oTarget, "PRCInLight", nLight);
        
        effect eTest = GetFirstEffect(oTarget);
        
        while(GetIsEffectValid(eTest))
        {                        
                if(GetEffectSpellId(eTest) == SPELL_DARKNESS) RemoveEffect(oTarget, eTest);
                eTest =  GetNextEffect(oTarget);
        }
}
                
