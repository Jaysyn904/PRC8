//::///////////////////////////////////////////////
//:: Draconic Aura Toggle - Shaman Auras
//:: prc_dracaura_tgl.nss
//::///////////////////////////////////////////////
/*
    Toggles auras gained via the Dragon Shaman class.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Apr 2, 2011
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_dragsham"

void _SetupAura(object oPC, int nSpellID, int nDamageType, string sSlot)
{
    object oAura = GetAuraObject(oPC, "VFX_DRACONIC_AURA_1");
    int nAuraBonus = GetAuraBonus(oPC);
    if(!nDamageType) nDamageType = GetDragonDamageType(GetLocalInt(oPC, "DragonShamanTotem"));

    SetLocalObject(oPC, "DraconicAura"+sSlot, oAura);
    SetLocalInt(oAura, "SpellID", nSpellID);
    SetLocalInt(oAura, "AuraBonus", nAuraBonus);
    SetLocalInt(oAura, "DamageType", nDamageType);
}

void _DisableAura(object oPC, object oAura, int nSpellID, string sSlot)
{
    DestroyObject(oAura);
    DeleteLocalObject(oPC, "DraconicAura"+sSlot);
    string sMes = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellID)));
    sMes = "*"+sMes+" "+GetStringByStrRef(63799)+"*";//Deactivated
    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}

void _EnableAura(object oPC, int nSpellID, string sSlot)
{
    effect eAura = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_DRACONIC_AURA_1));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oPC);
    _SetupAura(oPC, nSpellID, GetLocalInt(oPC, "DraconicAuraElement"), sSlot);
    DeleteLocalInt(oPC, "DraconicAuraElement");
    string sMes = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellID)));
    sMes = "*"+sMes+" "+GetStringByStrRef(63798)+"*";//Activated
    FloatingTextStringOnCreature(sMes, oPC, FALSE);
}

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();

    //if(TakeSwiftAction(oPC))

    //No Double Aura feat
    if(!GetHasFeat(FEAT_DOUBLE_DRACONIC_AURA, oPC))
    {
        //only one aura
        object oFirstAura = GetLocalObject(oPC, "DraconicAura1");
        int nFirstAura = GetLocalInt(oFirstAura, "SpellID");
        
        //aura active
        if(GetIsObjectValid(oFirstAura))
        {
            //same aura - disable
            if(nFirstAura == nSpellID)
            {
                _DisableAura(oPC, oFirstAura, nFirstAura, "1");
                return;
            }
            //different aura - replace
            else
            {
                //delete the old aura
                _DisableAura(oPC, oFirstAura, nFirstAura, "1");

                //apply a new one
                _EnableAura(oPC, nSpellID, "1");
                return;
            }
        }
        else
        {
            _EnableAura(oPC, nSpellID, "1");
            return;
        }
    }
    else
    {
        object oFirstAura = GetLocalObject(oPC, "DraconicAura1");
        object oSecndAura = GetLocalObject(oPC, "DraconicAura2");
        int nFirstAura = GetLocalInt(oFirstAura, "SpellID");
        int nSecndAura = GetLocalInt(oSecndAura, "SpellID");
   
        if(GetIsObjectValid(oFirstAura))
        {
            if(nSpellID == nFirstAura)
            {
                _DisableAura(oPC, oFirstAura, nFirstAura, "1");
                if(GetIsObjectValid(oSecndAura))
                {
                    SetLocalObject(oPC, "DraconicAura1", oSecndAura);
                    DeleteLocalObject(oPC, "DraconicAura2");
                }
                return;
            }
            else if(GetIsObjectValid(oSecndAura))
            {
                if(nSpellID == nSecndAura)
                {
                    _DisableAura(oPC, oSecndAura, nSecndAura, "2");
                    return;
                }
                else
                {
                    //delete the old aura
                    _DisableAura(oPC, oFirstAura, nFirstAura, "1");
                    //swap second aura to first slot
                    SetLocalObject(oPC, "DraconicAura1", oSecndAura);
                    DeleteLocalObject(oPC, "DraconicAura2");
                    //apply a new aura
                    _EnableAura(oPC, nSpellID, "2");
                    return;
                }
            }
            else
            {
                _EnableAura(oPC, nSpellID, "2");
                return;
            }
        }
        else
            _EnableAura(oPC, nSpellID, "1");
    }
}