#include "prc_spell_const"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetExitingObject();
    int nSpellID = GetLocalInt(OBJECT_SELF, "SpellID");

    if(GetHasSpellEffect(nSpellID, oTarget))
    {
        if(nSpellID == SPELL_MINAUR_DETCAST) //Determined Caster
            DeleteLocalInt(oTarget, "Marshal_DetCast");
        if(nSpellID == SPELL_MINAUR_ARTOFWAR) //Determined Caster
            DeleteLocalInt(oTarget, "Marshal_ArtWar");            

        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == nSpellID)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}