-- Speical Initializator
function FastBoot()
    bootCore()
    bootExer()
    TimerStart(CreateTimer(), 2.00, false, function()
        local boot = GetExpiredTimer()

        PauseTimer  ( boot )
        DestroyTimer( boot )
        -- boots
    end)
end