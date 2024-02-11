#include "prc_sp_func"
#include "prc_add_spell_dc"
void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE,OBJECT_SELF,1);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    
    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEARING_LIGHT));
        eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
        //Make an SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            //Limit caster level
            if (nCasterLevel > 10)
            {
                nCasterLevel = 10;
            }
            //Check for racial type undead
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                nDamage = d6(nCasterLevel);
                nDamage = nDamage + (nDamage/2);
            }
            //Check for racial type construct
            else if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
            {
                nCasterLevel /= 2;
                if(nCasterLevel == 0)
                {
                    nCasterLevel = 1;
                }
                nDamage = d6(nCasterLevel);
            }
            else
            {
                nCasterLevel = nCasterLevel/2;
                if(nCasterLevel == 0)
                {
                    nCasterLevel = 1;
                }
                nDamage = d8(nCasterLevel);
            }
            //Set the damage effect
            eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
            //Apply the damage effect and VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
        }
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
}

