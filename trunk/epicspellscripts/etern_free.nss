//::///////////////////////////////////////////////
//:: Epic Spell: Eternal Freedom
//:: Author: Boneshank (Don Armstrong)

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "inc_dispel"

void main()
{
        //Declare major variables
        object oTarget = OBJECT_SELF;
        object oSkin;
        itemproperty ip1 = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
        itemproperty ip2 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_ENTANGLE);
        itemproperty ip3 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLOW);
        itemproperty ip4 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_MONSTER);
        itemproperty ip5 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON);
        itemproperty ip6 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP);
        itemproperty ip7 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_ANIMAL);
        itemproperty ip8 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_POWER_WORD_STUN);
        itemproperty ip9 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEB);
        effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

        //Search for and remove the above negative effects
        effect eLook = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eLook))
        {
            if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
                GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
                GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
                GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ||
                GetEffectType(eLook) == EFFECT_TYPE_PETRIFY ||
                GetEffectType(eLook) == EFFECT_TYPE_SLEEP ||
                GetEffectType(eLook) == EFFECT_TYPE_STUNNED)
            {
                RemoveEffect(oTarget, eLook);
            }
            eLook = GetNextEffect(oTarget);
        }
        //Apply properties.
        oSkin = GetPCSkin(oTarget);
        IPSafeAddItemProperty(oSkin, ip1);
        IPSafeAddItemProperty(oSkin, ip2);
        IPSafeAddItemProperty(oSkin, ip3);
        IPSafeAddItemProperty(oSkin, ip4);
        IPSafeAddItemProperty(oSkin, ip5);
        IPSafeAddItemProperty(oSkin, ip6);
        IPSafeAddItemProperty(oSkin, ip7);
        IPSafeAddItemProperty(oSkin, ip8);
        IPSafeAddItemProperty(oSkin, ip9);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDur), oTarget);
}

