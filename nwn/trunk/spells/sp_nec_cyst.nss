/*
    sp_nec_cyst

    Necrotic Cyst
    Necromancy [Evil]
    Level: Clr 2, sor/wiz 2
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    The subject develops an internal spherical sac that
    contains fluid or semisolid necrotic flesh. The
    internal cyst is noticeable as a slight bulge on the
    subject's arm, abdomen, face (wherever you chose to
    touch the target) or it is buried deeply enough in
    the flesh of your target that it is not immediately
    obvious-the subject may not realize what was implanted
    within her.

    From now on, undead foes and necromantic magic are
    particularly debilitating to the subject-the cyst
    enables a sympathetic response between free-roaming
    external undead and itself. Whenever the victim is
    subject to a spell or effect from the school of
    necromancy, she makes saving throws to resist at a -2
    penalty. Whenever the subject is dealt damage by the
    natural weapon of an undead (claw, bite, or other
    attack form), she takes an additional 1d6 points of
    damage.

    Victims who possess necrotic cysts may elect to have
    some well-meaning chirurgeon remove them surgically.
    The procedure is a bloody, painful process that
    incapacitates the subject for 1 hour on a successful
    DC 20 Heal check, and kills the subject with an
    unsuccessful Heal check. The procedure takes 1 hour,
    and the chirurgeon can't take 20 on the check.

    Protection from evil or a similar spell prevents the
    necrotic cyst from forming. Once a necrotic cyst is
    implanted, spells that manipulate the cyst and its
    bearer are no longer thwarted by protection from evil.

    By: Tenjac
    Created: Oct 30, 2005
    Modified: Jul 2, 2006
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
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NECROTIC_CYST, oCaster);

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        if(GetCanCastNecroticSpells(oCaster) && PRCGetIsAliveCreature(oTarget))
        {
            if(!(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL)))
            {
                if(!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_EVIL))
                    {
                        ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, 0, DAMAGE_TYPE_POSITIVE, DAMAGE_TYPE_MAGICAL);
                        GiveNecroticCyst(oTarget);
                    }
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
        //SPEvilShift(oCaster);
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
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