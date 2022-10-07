/*
    sp_contagious.nss

Necromancy 
Level: Druid 4, 
Components: V, S, 
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 round/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

Holding out your hand like it's dead, you croak out magic words and imbue your limb with a terrible disease.

Upon casting this spell, you choose one disease from this list: blinding sickness, cackle fever, filth fever, 
mindfire, red ache, the shakes, or slimy doom (DMG 292). Any living creature you hit with a melee touch attack 
during the spell's duration is affected as though by the contagion spell, immediately contracting the disease 
you have selected unless it makes a successful Fortitude save. You cannot infect more than one creature per round.
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int CasterLvl = nCasterLevel;
    int nDC = PRCGetSaveDC(oTarget, oCaster);

    //INSERT SPELL CODE HERE
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        int nRand = Random(7)+1;
        int nDisease;
        //Use a random seed to determine the disease that will be delivered.
        switch (nRand)
        {
            case 1:
                nDisease = DISEASE_CONTAGION_BLINDING_SICKNESS;
            break;
            case 2:
                nDisease = DISEASE_CONTAGION_CACKLE_FEVER;
            break;
            case 3:
                nDisease = DISEASE_CONTAGION_FILTH_FEVER;
            break;
            case 4:
                nDisease = DISEASE_CONTAGION_MINDFIRE;
            break;
            case 5:
                nDisease = DISEASE_CONTAGION_RED_ACHE;
            break;
            case 6:
                nDisease = DISEASE_CONTAGION_SHAKES;
            break;
            case 7:
                nDisease = DISEASE_CONTAGION_SLIMY_DOOM;
            break;
        }
        if(!GetIsReactionTypeFriendly(oTarget) && PRCGetIsAliveCreature(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
            effect eDisease = EffectDisease(nDisease);
            //Make SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl + SPGetPenetr()))
            {
                // Make the real first save against the spell's DC
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                {
                    //The effect is permament because the disease subsystem has its own internal resolution
                    //system in place.
                    // The first disease save is against an impossible fake DC, since at this point the
                    // target has already failed their real first save.
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, TRUE, -1, CasterLvl);
                }
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, nCasterLevel);
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
