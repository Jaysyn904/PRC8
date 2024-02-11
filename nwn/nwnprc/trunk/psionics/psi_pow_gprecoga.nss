/*
   ----------------
   Precognition, Greater - Use edge

   psi_pow_gprecoga
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Precognition, Greater - Use edge

    Clairsentience
    Level: Seer 6
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: 11
    Metapsionics: Extend

    Precognition allows your mind to glimpse fragments of potential future
    events - what you see will probably happen if no one takes action to change
    it. However, your vision is incomplete, and it makes no real sense until the
    actual events you glimpsed begin to unfold. That’s when everything begins to
    come together, and you can act, if you act swiftly, on the information you
    previously received when you manifested this power.

    In practice, manifesting this power grants you a “precognitive edge.”
    Normally, you can have only a single precognitive edge at one time. You must
    use your edge within a period of no more than 1 hour per level, at which
    time your preknowledge fades and you lose your edge.

    You can use your precognitive edge in a variety of ways. Essentially, the
    edge translates into a +4 insight bonus that you can apply at any time to
    either an attack roll, a damage roll, a saving throw, or a skill check. To
    apply this bonus for one round, press either the Attack, Save, Skill, or
    Damage option on the radial menu.
*/

#include "psi_inc_psifunc"

void main()
{
    object oUser  = OBJECT_SELF;
    int bIsActive = GetLocalInt(oUser, "PRC_Power_GreaterPrecognition_Active");

    if(bIsActive)
    {
        int nSpellID = PRCGetSpellId();
        effect eVis  = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        effect eEdge;

        switch(nSpellID)
        {
            case POWER_GREATERPRECOGNITION_ATTACK:
                eEdge = EffectAttackIncrease(4);
                break;
            case POWER_GREATERPRECOGNITION_DAMAGE:
                eEdge = EffectDamageIncrease(DAMAGE_BONUS_4);
                break;
            case POWER_GREATERPRECOGNITION_SAVES:
                eEdge = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
                break;
            case POWER_GREATERPRECOGNITION_SKILLS:
                eEdge = EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
                break;

            default:{
                string sErr = "psi_pow_gprecoga: ERROR: Unknown spellID: " + IntToString(nSpellID);
                if(DEBUG) DoDebug(sErr);
                else      WriteTimestampedLogEntry(sErr);
            }
        }

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oUser);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEdge, oUser, 6.0, FALSE);

        // Remove the marker and remove the duration VFX
        DeleteLocalInt(oUser, "PRC_Power_GreaterPrecognition_Active");
        PRCRemoveSpellEffects(POWER_GREATERPRECOGNITION_MAIN, oUser, oUser); // Assumption: The power is personal range, as such the effect applier is always same as the target
    }
    else
    {
        FloatingTextStrRefOnCreature(16824063, oUser, FALSE); // "You do not have a precognitive edge"
    }
}
