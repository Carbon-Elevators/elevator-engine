local ElevatorEngine = {}
ElevatorEngine.__index = ElevatorEngine

function ElevatorEngine.Init(Elevator,UserSettings,DevSettings)
    local function HandleError(Type,Message)
        if Type == "Warning" then
            warn(Message)
        elseif Type == "Error" then
            error(Type)
        end
    end
    -- Verify requirements
    local RequiredModels = {
        {InstanceType = "Model", Path = Elevator.Cab, Error = "An elevator cab model doesn't exist"},
        {InstanceType = "BasePart", Path = Elevator.Cab.Platform, Error = "An elevator platform part doesn't exist inside the cab"},
        {InstanceType = "Model", Path = Elevator.Floors, Error = "An elevator floors model doesn't exist"}
    }
    for RequiredModelIndex,RequiredModel in ipairs(RequiredModels) do
        if RequiredModel.Path then
            if RequiredModel.Path:IsA(RequiredModel.InstanceType) == false then
                HandleError("Error",RequiredModel.Error..". This mean your elevator isn't setup correctly. Please check the documention for information on how to setup this engine.")
            end
        else
            HandleError("Error",RequiredModel.Error..". This mean your elevator isn't setup correctly. Please check the documention for information on how to setup this engine.")
        end
    end
    -- Setup elevator
    local WeldFolder = Instance.new("Folder")
    WeldFolder.Parent = Elevator.Cab.Platform
    for DescendentIndex, Descendent in ipairs(Elevator.Cab:GetDescendants()) do
        if Descendent:IsA("BasePart") then
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = Descendent
            WeldConstraint.Part1 = Elevator.Cab.Platform
            WeldConstraint.Parent = WeldFolder
            Descendent.Anchored = false
        end
    end
    local PlatformAttachment = Instance.new("Attachment")
    PlatformAttachment.Parent = Elevator.Cab.Platform
    Elevator.Cab.Platform.Anchored = false
    -- Elevator call logic

    return setmetatable({
        _Elevator = Elevator,
        _Platform = Elevator.Cab.Platform
    }, ElevatorEngine)
end

return ElevatorEngine