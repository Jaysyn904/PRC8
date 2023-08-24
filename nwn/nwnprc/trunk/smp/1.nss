void WrapperDelayRemoval(float fDuration);
void CheckAndRemove(int nSpellId, int nTimesCast, object oTarget);

void main() // This would be the spell script.
{
    float fDuration = 4.0; // fDuration = the duration of the tempoary effect
    WrapperDelayRemoval(fDuration);// Put this at the end of all spell scripts with polymorph in
}

void WrapperDelayRemoval(float fDuration)
{
    int nSpell = GetSpellId();
    int nCastTimes = GetLocalInt(OBJECT_SELF, "TIMES_CAST" + IntToString(nSpell));
    nCastTimes++; // Add one to cast times
    SetLocalInt(OBJECT_SELF, "TIMES_CAST" + IntToString(nSpell), nCastTimes);
    DelayCommand(fDuration, CheckAndRemove(nSpell, nCastTimes, OBJECT_SELF));
}

void CheckAndRemove(int nSpellId, int nTimesCast, object oTarget)
{
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "TIMES_CAST" + IntToString(nSpellId)) == nTimesCast)
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectSpellId(eCheck) == nSpellId)
            {
                RemoveEffect(oTarget, eCheck);
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
}
