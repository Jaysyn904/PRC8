#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "inc_newspellbook"

// Helper functions
void DoDamage(object oInitiator, int nDice, int nClass)
{
    location lTarget = GetLocation(oInitiator);
    float fRange = FeetToMeters(10.0);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE, GetPosition(oInitiator));

    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oInitiator)
        {
            int nDamage = d6(nDice);
            int nDC = 14 + GetDCAbilityModForClass(nClass, oInitiator);

            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

            effect eLink = EffectDamage(nDamage/2, DAMAGE_TYPE_FIRE);
                   eLink = EffectLinkEffects(eLink, EffectDamage(nDamage/2, DAMAGE_TYPE_MAGICAL));
                   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_FLAME_M));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE, GetPosition(oInitiator));
    }
}

void DoLoop(object oInitiator, int nDice, int nClass)
{
    if(DEBUG) DoDebug("Dice: " + IntToString(nDice));
    DelayCommand(RoundsToSeconds(9), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(8), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(7), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(6), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(5), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(4), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(3), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(2), DoDamage(oInitiator, nDice, nClass));
    DelayCommand(RoundsToSeconds(1), DoDamage(oInitiator, nDice, nClass));
    DoDamage(oInitiator, nDice, nClass);
}

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        // See if they want augmented stance
        if(GetSpellId() == JPM_SPELL_FIREBIRD_AUGMENTED)
        {
            int nSpellID = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");
            string sArray = GetLocalString(oInitiator, "JPM_SPELL_CURRENT");

            int nUses = sArray == "" ? GetHasSpell(nSpellID, oInitiator) :
                        persistant_array_get_int(oInitiator, sArray, nSpellID);

            if(nUses)
            {
                int nClass = GetPrimaryArcaneClass(oInitiator);
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

                DoLoop(oInitiator, nLevel, nClass);
            }
        }
        // This adds 3 caster levels when using a fire spell
        SetLocalInt(oInitiator, "ToB_JPM_FireB", TRUE);

        if(GetLocalInt(oInitiator, "ReserveFeatsRunning"))
            DelayCommand(0.1f, ExecuteScript("prc_reservefeat", oInitiator));

        effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_FIRE, 10), EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
               eLink = ExtraordinaryEffect(eLink);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}