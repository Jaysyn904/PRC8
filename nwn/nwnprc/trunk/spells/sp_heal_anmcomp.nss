//::///////////////////////////////////////////////
//:: Name      Heal Animal Companion
//:: FileName  sp_heal_anmcomp.nss
//:://////////////////////////////////////////////
/**@file HEAL ANIMAL COMPANION
Conjuration (Healing)
Level: Druid 5, ranger 3
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Your animal companion
touched
Duration: Instantaneous
Saving Throw: Will negates
(harmless)
Spell Resistance: Yes (harmless)

This spell functions like heal (PH 239),
except that it affects only your animal
companion.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        
        //Can only have one animal companion, so default is correct
        object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
        int nCasterLevel = PRCGetCasterLevel(oPC);
        int nHealVFX  = VFX_IMP_HEALING_X;
        int nHeal = 10 * nCasterLevel;
        int nCap = 150;
        string nSwitch = PRC_BIOWARE_HEAL;

        if(nHeal > nCap && !GetPRCSwitch(nSwitch)) nHeal = nCap;

        //check if it is your animal companion
        if((oTarget != oComp && oTarget != GetObjectByTag("hen_winterwolf") && oTarget != GetObjectByTag("prc_shamn_cat")) || GetMaster(oComp) != oPC)
        {
                FloatingTextStringOnCreature("** You may only cast this on your animal companion. **", oPC, FALSE);
                return;
        }

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        float fDelay = 0.0;
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal, oTarget), oTarget));
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));

        PRCSetSchool();
}