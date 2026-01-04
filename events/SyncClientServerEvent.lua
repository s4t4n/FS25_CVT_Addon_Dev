-- Date: 28.01.2023
-- edit: 24.09.2025
SyncClientServerEvent = {}

local SyncClientServerEvent_mt = Class(SyncClientServerEvent, Event)
InitEventClass(SyncClientServerEvent, "SyncClientServerEvent")

---Create instance of Event class
-- @return table self instance of class event
function SyncClientServerEvent.emptyNew()
    local self = Event.new(SyncClientServerEvent_mt)
    return self
end

---Create new instance of event
-- @param table vehicle vehicle
-- @param integer state state
function SyncClientServerEvent.new(vehicle, HSTshuttle, vOne, vTwo, vThree, CVTCanStart, vFive, autoDiffs, isVarioTM, isTMSpedal, CVTconfig, warnHeat, critHeat, warnDamage, critDamage, CVTdamage, HandgasPercent, ClutchInputValue, cvtDL, cvtAR, VCAantiSlip, VCApullInTurn, CVTcfgExists, reverseLightsState, reverseLightsDurationState, brakeForceCorrectionState, brakeForceCorrectionValue, drivingLevelState, drivingLevelValue, HSTstate, preGlow, forDBL_pregluefinished, forDBL_glowingstate, forDBL_preglowing, HUDpos)
    local self = SyncClientServerEvent.emptyNew()
    self.HSTshuttle = HSTshuttle
    self.vOne = vOne
    self.vTwo = vTwo
    self.vThree = vThree
    self.CVTCanStart = CVTCanStart
    self.vFive = vFive
    self.autoDiffs = autoDiffs
    -- self.lastDirection = lastDirection
    self.isVarioTM = isVarioTM
    self.isTMSpedal = isTMSpedal
    -- self.moveRpmL = moveRpmL -- placeholder
    -- self.rpmDmax = rpmDmax
    -- self.rpmrange = rpmrange
    self.CVTconfig = CVTconfig
    self.warnHeat = warnHeat
    self.critHeat = critHeat
    self.warnDamage = warnDamage
    self.critDamage = critDamage
    self.CVTdamage = CVTdamage
    self.HandgasPercent = HandgasPercent --
    self.ClutchInputValue = ClutchInputValue
    self.cvtDL = cvtDL
    self.cvtAR = cvtAR
    self.VCAantiSlip = VCAantiSlip
    self.VCApullInTurn = VCApullInTurn
    self.CVTcfgExists = CVTcfgExists
    self.reverseLightsState = reverseLightsState
    self.reverseLightsDurationState = reverseLightsDurationState
    self.brakeForceCorrectionState = brakeForceCorrectionState
    self.brakeForceCorrectionValue = brakeForceCorrectionValue
    self.drivingLevelState = drivingLevelState
    self.drivingLevelValue = drivingLevelValue
    self.HSTstate = HSTstate
    self.preGlow = preGlow
    self.forDBL_pregluefinished = forDBL_pregluefinished
    self.forDBL_glowingstate = forDBL_glowingstate
    self.forDBL_preglowing = forDBL_preglowing
    self.HUDpos = HUDpos
    self.vehicle = vehicle
    return self
end

---Called on client side on join
-- @param integer streamId streamId
-- @param integer connection connection
function SyncClientServerEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self.HSTshuttle = streamReadInt32(streamId)
    self.vOne = streamReadInt32(streamId)
    self.vTwo = streamReadInt32(streamId)
    self.vThree = streamReadInt32(streamId)
    self.CVTCanStart = streamReadBool(streamId)
    self.vFive = streamReadInt32(streamId)
    self.autoDiffs = streamReadInt32(streamId)
    -- self.lastDirection = streamReadInt32(streamId)
    self.isVarioTM = streamReadBool(streamId)
    self.isTMSpedal = streamReadInt32(streamId)
    -- self.moveRpmL = streamReadFloat32(streamId)
    -- self.rpmDmax = streamReadInt32(streamId)
    -- self.rpmrange = streamReadInt32(streamId)
    self.CVTconfig = streamReadInt32(streamId)
    self.warnHeat = streamReadInt32(streamId)
    self.critHeat = streamReadInt32(streamId)
	self.warnDamage = streamReadInt32(streamId)
    self.critDamage = streamReadInt32(streamId)
    self.CVTdamage = streamReadFloat32(streamId)
    self.HandgasPercent = streamReadFloat32(streamId)
    self.ClutchInputValue = streamReadFloat32(streamId)
    self.cvtDL = streamReadInt32(streamId)
    self.cvtAR = streamReadInt32(streamId)
    self.VCAantiSlip = streamReadInt32(streamId)
    self.VCApullInTurn = streamReadInt32(streamId)
    self.CVTcfgExists = streamReadBool(streamId)
    self.reverseLightsState         = streamReadInt32(streamId)
    self.reverseLightsDurationState = streamReadInt32(streamId)
    self.brakeForceCorrectionState  = streamReadInt32(streamId)
    self.brakeForceCorrectionValue  = streamReadFloat32(streamId)
    self.drivingLevelState          = streamReadInt32(streamId)
    self.drivingLevelValue          = streamReadFloat32(streamId)
    self.HSTstate                   = streamReadInt32(streamId)
    self.preGlow                    = streamReadInt32(streamId)
    self.forDBL_pregluefinished     = streamReadBool(streamId)
    self.forDBL_glowingstate        = streamReadInt32(streamId)
    self.forDBL_preglowing          = streamReadInt32(streamId)
    self.HUDpos                     = streamReadInt32(streamId)
    self:run(connection)
end

---Called on server side on join
-- @param integer streamId streamId
-- @param integer connection connection
function SyncClientServerEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
    if self.ClutchInputValue == nil then
		self.ClutchInputValue = 0.0
	end
    streamWriteInt32(streamId, self.HSTshuttle)
    streamWriteInt32(streamId, self.vOne)
	streamWriteInt32(streamId, self.vTwo)
    streamWriteInt32(streamId, self.vThree)
    streamWriteBool(streamId, self.CVTCanStart)
    streamWriteInt32(streamId, self.vFive)
    streamWriteInt32(streamId, self.autoDiffs)
    -- streamWriteInt32(streamId, self.lastDirection)
	streamWriteBool(streamId, self.isVarioTM)
    streamWriteInt32(streamId, self.isTMSpedal)
    -- streamWriteFloat32(streamId, self.moveRpmL)
    -- streamWriteInt32(streamId, self.rpmDmax)
    -- streamWriteInt32(streamId, self.rpmrange)
    streamWriteInt32(streamId, self.CVTconfig)
    streamWriteInt32(streamId, self.warnHeat)				--
    streamWriteInt32(streamId, self.critHeat)				--
    streamWriteInt32(streamId, self.warnDamage)				--
    streamWriteInt32(streamId, self.critDamage)				--
	streamWriteFloat32(streamId, self.CVTdamage)
    streamWriteFloat32(streamId, self.HandgasPercent)
    streamWriteFloat32(streamId, self.ClutchInputValue)
    streamWriteInt32(streamId, self.cvtDL)
    streamWriteInt32(streamId, self.cvtAR)
    streamWriteInt32(streamId, self.VCAantiSlip)
    streamWriteInt32(streamId, self.VCApullInTurn)
    streamWriteBool(streamId, self.CVTcfgExists)

    streamWriteInt32(streamId, self.reverseLightsState)
    streamWriteInt32(streamId, self.reverseLightsDurationState)

    streamWriteInt32(streamId, self.brakeForceCorrectionState)
    streamWriteFloat32(streamId, self.brakeForceCorrectionValue)

    streamWriteInt32(streamId, self.drivingLevelState)
    streamWriteFloat32(streamId, self.drivingLevelValue)
    streamWriteInt32(streamId, self.HSTstate)
    streamWriteInt32(streamId, self.preGlow)
    streamWriteBool(streamId, self.forDBL_pregluefinished)
    streamWriteInt32(streamId, self.forDBL_glowingstate)
    streamWriteInt32(streamId, self.forDBL_preglowing)
    streamWriteInt32(streamId, self.HUDpos)
end


---Run action on receiving side
-- @param integer connection connection
function SyncClientServerEvent:run(connection)
    if self.vehicle ~= nil and self.vehicle:getIsSynchronized() then
        CVTaddon.SyncClientServer(self.vehicle, self.HSTshuttle, self.vOne, self.vTwo, self.vThree, self.CVTCanStart, self.vFive, self.autoDiffs, self.isVarioTM, self.isTMSpedal, self.CVTconfig, self.warnHeat, self.critHeat, self.warnDamage, self.critDamage, self.CVTdamage, self.HandgasPercent, self.ClutchInputValue, self.cvtDL, self.cvtAR, self.VCAantiSlip, self.VCApullInTurn, self.CVTcfgExists, self.reverseLightsState, self.reverseLightsDurationState, self.brakeForceCorrectionState, self.brakeForceCorrectionValue, self.drivingLevelState, self.drivingLevelValue, self.HSTstate, self.preGlow, self.forDBL_pregluefinished, self.forDBL_glowingstate, self.forDBL_preglowing, self.HUDpos)
		if not connection:getIsServer() then --
			g_server:broadcastEvent(SyncClientServerEvent.new(self.vehicle, self.HSTshuttle, self.vOne, self.vTwo, self.vThree, self.CVTCanStart, self.vFive, self.autoDiffs, self.isVarioTM, self.isTMSpedal, self.CVTconfig, self.warnHeat, self.critHeat, self.warnDamage, self.critDamage, self.CVTdamage, self.HandgasPercent, self.ClutchInputValue, self.cvtDL, self.cvtAR, self.VCAantiSlip, self.VCApullInTurn, self.CVTcfgExists, self.reverseLightsState, self.reverseLightsDurationState, self.brakeForceCorrectionState, self.brakeForceCorrectionValue, self.drivingLevelState, self.drivingLevelValue, self.HSTstate, self.preGlow, self.forDBL_pregluefinished, self.forDBL_glowingstate, self.forDBL_preglowing, self.HUDpos), nil, connection, self.vehicle)
                                                                                            --  spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists, spec.reverseLightsState, spec.reverseLightsDurationState, spec.brakeForceCorrectionState, spec.brakeForceCorrectionValue, spec.drivingLevelState, spec.drivingLevelValue, spec.HSTstate, spec.preGlow, spec.forDBL_pregluefinished, spec.forDBL_glowingstate, spec.forDBL_preglowing, spec.HUDpos))
		end
    end
end

