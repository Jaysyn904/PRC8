//#include "prc_inc_spells"
void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int nSpellID = GetLocalInt(OBJECT_SELF, "X2_AoE_SpellID");
    effect eAOE;

    if(GetHasSpellEffect(nSpellID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectSpellId(eAOE) == nSpellID)
            {
                if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
                    RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}