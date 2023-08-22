#include "prc_alterations"
#include "prgt_inc"

void main()
{
    object oTarget = GetLastDisarmed();
    object oTrap = OBJECT_SELF;
    struct trap tTrap = GetLocalTrap(oTrap, "TrapSettings");
    if(tTrap.nRespawnSeconds)
    {
        struct trap tNewTrap = tTrap;
        if(tTrap.nRespawnRandomCR)
        {
            tNewTrap = CreateRandomTrap(tTrap.nRespawnRandomCR);
            tNewTrap.nRespawnSeconds = tTrap.nRespawnSeconds;
        }
        AssignCommand(GetArea(oTrap),
            DelayCommand(IntToFloat(tTrap.nRespawnSeconds),
                PRGT_VoidCreateTrapAtLocation(GetLocation(oTrap), tNewTrap)));
    }
    
    DoTrapXP(OBJECT_SELF, oTarget, TRAP_EVENT_DISARMED);
}
