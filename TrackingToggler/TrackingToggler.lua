SLASH_TRACKINGTOGGLER1 = '/tt';

local trackingModes = {
    minerals = 136025,
    herbs =  133939
}

clickSoundId = 567407;

TrackingToggler = {}

function TrackingToggler:Initialize()
    TrackingToggler.mode1 = "minerals";
    TrackingToggler.mode2 = "herbs";
    TrackingToggler.interval = "5";
    TrackingToggler.running = false;
    print('Tracking Toggler: Use the /tt command to toggle automatic tracking.');
end

TrackingToggler:Initialize();

function TrackingToggler:GetTracking()
    local count = GetNumTrackingTypes();
    for i=1, count do
        local name, texture, active, category, nested = GetTrackingInfo(i);
        if category == "spell" then
            if active == true then
                return texture
            end
        end
    end
end

function TrackingToggler:GetTrackingId(mode)
    local count = GetNumTrackingTypes();
    for i=1, count do
        local name, texture, active, category, nested = GetTrackingInfo(i);
        if mode == texture then
            return i
        end
    end
end

function TrackingToggler:Toggle()
    if TrackingToggler.running == true then
        TrackingToggler:Stop();
    else
        TrackingToggler:Start();
    end
end

function TrackingToggler:RepeatingTimer()
    if TrackingToggler.running == true then
        TrackingToggler.RunInterval();
        C_Timer.After(TrackingToggler.interval, function()
            TrackingToggler.RepeatingTimer();
        end)
    end
end

function TrackingToggler:Start()
    print('Starting Tracking Toggler');
    TrackingToggler.running = true;
    TrackingToggler:RepeatingTimer();
end

function TrackingToggler:Stop()
    print('Stopping Tracking Toggler');
    TrackingToggler.running = false;
end

function TrackingToggler:RunInterval()
    local tracking = TrackingToggler:GetTracking();
    combat = UnitAffectingCombat("player");
    if (combat == false or IsMounted()) then
        if tracking ~= trackingModes[TrackingToggler.mode1] then
            setMode = trackingModes[TrackingToggler.mode1]
        else
            setMode = trackingModes[TrackingToggler.mode2]
        end
        MuteSoundFile(clickSoundId);
        SetTracking(TrackingToggler:GetTrackingId(setMode), true);
        UnmuteSoundFile(clickSoundId);
    end
end

function SlashCmdList.TRACKINGTOGGLER()
    TrackingToggler:Toggle();
end
