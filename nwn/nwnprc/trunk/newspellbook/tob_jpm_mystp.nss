#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    //DoDebug(IntToString(move.bCanManeuver));
    if(move.bCanManeuver)
    {
        // This adds 1 caster level to all spells
        SetLocalInt(oInitiator, "ToB_JPM_MystP", 1);

        effect eLink = EffectLinkEffects(EffectACIncrease(2, AC_DODGE_BONUS), EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));

        if(GetSpellId() == MOVE_MYSTIC_PHOENIX_AUG)
        {
            int nSpellID = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");
            string sArray = GetLocalString(oInitiator, "JPM_SPELL_CURRENT");

            int nUses = sArray == "" ? GetHasSpell(nSpellID, oInitiator) :
                        persistant_array_get_int(oInitiator, sArray, nSpellID);

            if(nUses)
            {
                int nLevel = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT_LVL");

                if(sArray == "")
                {
                    DecrementRemainingSpellUses(oInitiator, nSpellID);
                }
                else
                {
                    nUses--;
                    persistant_array_set_int(oInitiator, sArray, nSpellID, nUses);
                }

                if(nLevel > 5) nLevel = 5;
                eLink = EffectLinkEffects(eLink, EffectDamageReduction(nLevel * 2, DAMAGE_POWER_PLUS_TWO));
                //eLink = EffectLinkEffects(VersusAlignmentEffect(eRed, ALIGNMENT_ALL, ALIGNMENT_GOOD), eLink);
                //eLink = EffectLinkEffects(VersusAlignmentEffect(eRed, ALIGNMENT_ALL, ALIGNMENT_NEUTRAL), eLink);
            }
        }
        eLink = ExtraordinaryEffect(eLink);

        if(GetLocalInt(oInitiator, "ReserveFeatsRunning"))
            DelayCommand(0.1f, ExecuteScript("prc_reservefeat", oInitiator));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}