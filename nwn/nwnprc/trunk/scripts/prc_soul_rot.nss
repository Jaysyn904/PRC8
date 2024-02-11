
//Soul Rot     DC 23       Incubation 1d8 days     1d6 WIS, 1d6 CHA
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    int nDC = 23;

    effect eDisease = GetFirstEffect(oPC);
    while(GetIsEffectValid(eDisease))
    {
        if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
        break;

        eDisease = GetNextEffect(oPC);
    }// end while - loop through all effects

    // Do the save
    if(PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE))
    {
        // Get the value of the previous save
        if(GetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED"))
        {
            // 2 saves in row, oPC recovers from the disease
            // Remove the disease and relevant locals.
            RemoveEffect(oPC, eDisease);
            DeleteLocalInt(oPC, "SPELL_SOUL_ROT_SAVED");
            DeletePersistantLocalInt(oPC, "PRC_Has_Soul_Rot");
        }
        else
        {
            // Note down the successful save
            SetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED", TRUE);
        }
    }
    else
    {
        // Note down the failed save
        SetLocalInt(oPC, "SPELL_SOUL_ROT_SAVED", FALSE);

        //Set int to signify disease
        SetPersistantLocalInt(oPC, "PRC_Has_Soul_Rot", 1);

        //Cause damage
        int nDam = d6();

        ApplyAbilityDamage(oPC, ABILITY_WISDOM, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_CHARISMA, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
    }
}