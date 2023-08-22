//::///////////////////////////////////////////////
//:: Name      Addiction
//:: FileName  sp_addiction.nss
//:://////////////////////////////////////////////
/**@file Addiction
Enchantment
Level: Asn 1, Brd 2, Clr 2, Sor/Wiz 2
Components: V, S, Drug
Casting Time: 1 action
Range: Touch
Area: One living creature
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster gives the target an addiction to a drug.
A caster of level 5 or less can force the subject to
become addicted to any drug with a low addiction
rating. A 6th to 10th level caster can force an
addiction to any drug with a medium addiction
rating, and 11th to 15th level caster can force
addiction to a drug with a high addiction rating.
Casters of 16th level or higher can give the
subject an addiction to a drug with an extreme
addiction rating.

Author:    Tenjac
Created:   5/15/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLvl)
{
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    int nSpellID = PRCGetSpellId();
    int nAddict = -1;
    int nPenetr = nCasterLvl + SPGetPenetr();
    effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ADDICTION));

    //SR and PvP check
    if(!GetIsReactionTypeFriendly(oTarget)
    && !PRCDoResistSpell(oCaster, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
    {
        //Fort save
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            //determine addiction
            switch(nSpellID)
            {
                case SPELL_ADDICTION_TERRAN_BRANDY:
                    nAddict = DISEASE_TERRAN_BRANDY_ADDICTION;
                    break;
                case SPELL_ADDICTION_MUSHROOM_POWDER:
                    nAddict = nCasterLvl > 5 ? DISEASE_MUSHROOM_POWDER_ADDICTION : -1;
                    break;
                case SPELL_ADDICTION_VODARE:
                    nAddict = nCasterLvl > 10 ? DISEASE_VODARE_ADDICTION : -1;
                    break;
                case SPELL_ADDICTION_AGONY:
                    nAddict = nCasterLvl > 15 ? DISEASE_AGONY_ADDICTION : -1;
                    break;
            }

            if(nAddict != -1)
            {
                //Construct effect
                effect eAddict = EffectDisease(nAddict);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
                FloatingTextStringOnCreature("Your caster level is not high enough to use this drug.", oCaster, FALSE);
        }
    }

    return TRUE;
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
            DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
