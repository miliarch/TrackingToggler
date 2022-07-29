SLASH_TRACKINGTOGGLER1 = '/track';

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
    TrackingToggler.busyDelay = 0;
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
        interval = TrackingToggler.interval + TrackingToggler.busyDelay
        TrackingToggler.busyDelay = 0;  -- reset busyDelay if any was set in TrackingToggler:PlayerBusy()
        C_Timer.After(interval, function()
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
    if (TrackingToggler:PlayerBusy() == false) then
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

function TrackingToggler:PlayerBusy()
    status = {
        combat = UnitAffectingCombat("player") == true and IsMounted() == false,
        casting = UnitCastingInfo('player') ~= nil,
        channeling = UnitChannelInfo('player') ~= nil
    }

    for k, v in pairs(status) do
        if (v == true) then
            -- player busy - delay next timer by interval and return true
            TrackingToggler.busyDelay = TrackingToggler.interval;
            return true
        end
    end

    return false
end

function SlashCmdList.TRACKINGTOGGLER()
    TrackingToggler:Toggle();
end
