function Exer()
    local thread = 0
    
    while thread < Game.Threads do
        if Game.Exer[thread] then
            if Game.Exer[thread].func then
                Game.Exer[thread].func(Game.Exer[thread])
            end
        end
        thread = thread + 1
    end 
end

function bootExer()
    Game.Triggers.Exer = CreateTrigger()
    TriggerAddAction( Game.Triggers.Exer, Exer )
    TriggerRegisterTimerEvent( Game.Triggers.Exer, 0.04, true )
end

function SDRead(strdata)
    local syncdata = {}
    local counter = 0
    
    return syncdata, counter
end