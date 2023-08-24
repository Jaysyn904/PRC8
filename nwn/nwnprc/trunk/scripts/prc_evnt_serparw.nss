/////////////////////////////////////////////////
// Serpent Arrow Onhit script
// prc_evnt_serparw.nss
////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
        object oItem = PRCGetSpellCastItem(oSpellOrigin);

        //Damage of the bite
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1, DAMAGE_TYPE_PIERCING), oTarget);

        //Save for poison
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 11, SAVING_THROW_TYPE_POISON))
        {
                //DC 11, 1d6 CON, 1d6 CON
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(105), oTarget);
        }

        MultisummonPreSummon();
        //Make snake and make it friendly too
        object oSnake = CreateObject(OBJECT_TYPE_CREATURE, "prc_viper", GetLocation(oTarget), TRUE);
        DestroyObject(oSnake, 600.0f);

        int nMax = GetMaxHenchmen();
        SetMaxHenchmen(99);
        AddHenchman(oSpellOrigin, oSnake);
        SetMaxHenchmen(nMax);
}