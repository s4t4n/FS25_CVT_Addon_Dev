-- @titel       LessMotorBrakeforce Script for FarmingSimulator 13
-- @new titel   CVT_Addon Script for FarmingSimulator 2022 now 25
-- @author      SbSh_Modasti4n(s4t4n)
-- @credits		Frvetz, Glowin, UpsideDown - ebenso ein riesen Dank an dieser Stelle!
-- @version     v1.0.0.0 Release Modhub fs22
-- @version		v1.0.0.1 Small Changes(FS22 1.2.0.2)
-- @date        23/07/2022
-- @info        CVTaddon Script for FarmingSimulator 2022
-- 19.11.2024	starting build for fs25

--ToDo's
	-- last changes
		-- DONE - renew hud, new store cfg
		-- DONE -  shop config mp loadable
		-- DONE - inching pedal gui setup
		-- DONE - hud above postion
		-- DONE - requirements admin to do adjusts in gui on server
		-- DONE - preGlow (input is alive, need a timer func)
		-- DONE - outdoorTemp (on it)
		-- DONE - AccRanp settings 0 to 5
		-- DONE - Pull-In-Turn (Voreilung für modern with gui settings)
		-- DONE - Auto Slip Control (vca)
		-- SKIPPED - new GUI elements and scroll fix
		-- TRY - more rpm classic work

		-- SKIPPED - vario drive (next update)
		-- WIP - hydrostat pedal may no rpm in mp
		-- WIP - reverse rolling while drive on
		-- WIP - Harvester inching upward cc active
		-- WIP - cold start with prglow for manual shifted need finetuning
		-- TRY - need to sync preglow ?
		-- WIP - do vca KS steps for AccRamps
		-- SKIPPED - help-line integration

CVTaddon = {};
CVTaddon.modDirectory = g_currentModDirectory;
-- CVTaddon.modDirectory = MOD_NAME;

if CVTaddon.MOD_NAME == nil then CVTaddon.MOD_NAME = g_currentModName end
CVTaddon.MODSETTINGSDIR = g_currentModSettingsDirectory
if CVTaddon.MOD_PATH == nil then CVTaddon.MOD_PATH = g_currentModDirectory end

local modDesc = loadXMLFile("modDesc", g_currentModDirectory .. "modDesc.xml");
CVTaddon.modversion = getXMLString(modDesc, "modDesc.version");
CVTaddon.author = getXMLString(modDesc, "modDesc.author");
CVTaddon.contributor = getXMLString(modDesc, "modDesc.contributor");
source(CVTaddon.modDirectory.."events/SyncClientServerEvent.lua")
source(g_currentModDirectory.."gui/CVTaddonGui.lua")
g_gui:loadGui(g_currentModDirectory.."gui/CVTaddonGui.xml", "CVTaddonGui", CVTaddonGui:new())

local scrversion = "0.9.0.8";
local modversion = CVTaddon.modversion; -- moddesc
local lastupdate = "24.07.2025"
local timestamp = "1753393527672";
local savetime = "23:45:32";

-- _______________________
cvtaDebugCVTon = false	 -- \
debug_for_DBL = false	  -- \
debug_for_VC = false	  --  \
cvtaDebugCVTxOn = false	  --   } Debug change via console commands
cvtaDebugCVTheatOn = false -- /
cvtaDebugCVTuOn = false	  -- /
cvtaDebugCVTu2on = false --/
cvtaDebugCVTtransmission = false --/
-- ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
debugTable = false
sbshDebugWT = false
cvtaDebugCVTcanStartOn = false 
cvtsaved = false 

CVTaddon.debug = false
CVTaddon.showKeys = true

printLMBF = false
VcvtaResetWear = false

local startetATM = false;
local vcaAWDon = false
local vcaInfoUnread = true
peakMotorTorqueOrigin = 0
-- local changeFlag = false;


function addCVTconfig(self, superfunc, xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
    -- print("addCVTconfig : parameters: xmlFile = "..tostring(xmlFile).." / baseXMLName = "..tostring(baseXMLName).." / baseDir = "..tostring(baseDir).." / customEnvironment = "..tostring(customEnvironment).." / isMod = "..tostring(isMod).." / storeItem = "..tostring(storeItem), 2)

    local configurations, defaultConfigurationIds = superfunc(self, xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)

	local category = storeItem.categoryName -- Category types for add_shopConfig
	if 
		(	category == "TRACTORSS" 		 or	category == "TRACTORSM"			 or	category == "TRACTORSL"
		or	category == "HARVESTERS" 		 or	category == "FORAGEHARVESTERS" 	 or	category == "BEETVEHICLES"		or	category == "POTATOVEHICLES"
		or 	category == "VEGETABLEHARVESTERS" or category == "SPINACHHARVESTERS" or category == "OLIVEVEHICLES"
		or	category == "COTTONVEHICLES" 	 or	category == "SPRAYERVEHICLES"	 or  category == "SLURRYVEHICLES"	or	category == "SUGARCANEVEHICLES"
		or	category == "MOWERVEHICLES"		 or	category == "MISCVEHICLES"		 or	category == "GRAPEVEHICLES"		or	category == "MOWERS"
		or 	category == "FRONTLOADERVEHICLES" or category == "TELELOADERVEHICLES" or category == "SKIDSTEERVEHICLES" or category == "WHEELLOADERVEHICLES"
		or 	category == "CARS" 				 or category == "TRUCKS" 			 or category == "MISC"
		or 	category == "FORKLIFTS" 		 or category == "BEETHARVESTERS" 	 or category == "MISCDRIVABLES" 	or 	category == "HANDTOOLSMISC"
		or 	category == "FORESTRYMISC"		or 	category == "WOODCHIPPERS"		or 	category == "FORESTRYEXCAVATORS" or category == ""
		or 	category == "FORESTRYFORWARDERS" or category == "FORESTRYHARVESTERS" or category == "FORAGEMIXERS"		or 	category == "GRAPEHARVESTERS"
		or 	category == "COTTONHARVESTERS"	or 	category == "SUGARCANEHARVESTERS"	or 	category == "RICEHARVESTERS" or category == "RICEPLANTERS"
		or 	category == "PEAHARVESTERS"		or 	category == "GREENBEANHARVESTERS"	or 	category == "POTATOHARVESTING"
		or 	category == "BEETLOADING"
		-- or 	category == ""

		-- Ifkos etc.
		or 	category == "LSFM"
		
		-- Hof Bergmann etc.
		or category == "MINIAGRICULTUREEQUIPMENT"	or category == "FM_VEHICLES"
		
		or category == "FENDTPACKCATEGORY"	or category == "FD_CASEPACKCATEGORY"	or category == "SDFCORE2"	or category == "SDFCORE3"
		or category == "SDFCORE4"	or category == "SDFCORE4H"	or category == "SDFCORE4L"	or category == "SDFCORE4S"	or category == "SDFCORE5"
		or category == "SDFCORE5A"	or category == "SDFCORE5AH"	or category == "SDFCORE5AL"	or category == "SDFCORE5AS"	or category == "SDFCORE5N"
		or category == "SDFCORE5NH"	or category == "SDFCORE5NL"	or category == "SDFCORE5NS"
		)
		
		and	configurations ~= nil
		
		and xmlFile:hasProperty("vehicle.enterable")
		-- and xmlFile:hasProperty("vehicle.motorized")
		-- and xmlFile:hasProperty("vehicle.drivable")

	then
		local cvtAddonConfigFile = XMLFile.load("CVT_Addon_storeConfig", CVTaddon.MOD_PATH.."CVT_Addon_storeConfig.xml", xmlFile.schema) -- ta glowin for cfg schemata
		
		if cvtAddonConfigFile ~= nil then
			local allConfigs = self:getConfigurations()
			local cvtaConfig = allConfigs["CVTaddon"]
			
			if cvtaConfig ~= nil then
				local configItems = {}
				local i = 0
				while true do
					local xmlKey = string.format(cvtaConfig.configurationKey .."(%d)", i)
					if not cvtAddonConfigFile:hasProperty(xmlKey) or i > 1 then
						break
					end
					local configItem = cvtaConfig.itemClass.new(cvtaConfig.name)
					configItem:setIndex(#configItems + 1)
					if configItem:loadFromXML(cvtAddonConfigFile, cvtaConfig.configurationsKey, xmlKey, baseDir, customEnvironment) then
						if i == 0 then
							configItem.name = g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_notInstalled_short")
							configItem.desc = g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_notInstalled_desc")
						else 
							configItem.name = g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_Installed_short")
							configItem.desc = g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_Installed_desc")
						end
						table.insert(configItems, configItem)
					end
					i = i + 1
				end
				if #configItems > 0 then
					defaultConfigurationIds[cvtaConfig.name] = ConfigurationUtil.getDefaultConfigIdFromItems(configItems)
					configurations[cvtaConfig.name] = configItems
				end
			end
			
			cvtAddonConfigFile:delete()
		end
	end
    return configurations, defaultConfigurationIds
end

--new storeCfg fs25


function CVTaddon.prerequisitesPresent(specializations)
    return true
end

function CVTaddon.initSpecialization()
	print("################################# initSpecialization")
	local schemaSavegame = Vehicle.xmlSchemaSavegame
	local key = CVTaddon.MOD_NAME..".CVTaddon"
	
	-- print("here is the key: " .. key)
	schemaSavegame:register(XMLValueType.BOOL, "vehicles.vehicle(?)."..key..".cvtconfigured", "CVTa configured", false)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#vOne", "Driving level", 2) -- DL
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#cvtDL", "Driving level count", 2) -- DLcount
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#cvtAR", "accRamps count", 4) -- AccRampsCount
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#vTwo", "AccRamp", 4) -- AR
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#vThree", "BrakeRamp", 1) -- BR
    -- schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#vFive", "Handthrottle", 0) -- HG
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#autoDiffs", "AutoDiff state", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#CvtConfigId", "Config ID", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#CvtIPM", "IPM state", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#HSTstate", "HST state", 2)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#inchingState", "inchingState", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#reverseLightsState", "reverseLightsState", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#reverseLightsDurationState", "reverseLightsDurationState", 1)
    schemaSavegame:register(XMLValueType.FLOAT, "vehicles.vehicle(?)."..key.."#CVTdamage", "CVT transmission wear", 0)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#HUDpos", "CVT hud position", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#HUDvis", "CVT hud visibility", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#VCAantiSlip", "CVT has automatic anti slip function", 1)
    schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#VCApullInTurn", "CVT has pull in turn like by fendt", 1)
	-- schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#CVTCanStart", "motorAllow to start", 1) -- ms
	-- schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#rpmDmax", "max rpm actually", 1)
	-- schemaSavegame:register(XMLValueType.INT, "vehicles.vehicle(?)."..key.."#CvtConfigActive", "OnOrOff", 1)

	
	-- new config add fs25
	if g_vehicleConfigurationManager.configurations["CVTaddon"] == nil then
		g_vehicleConfigurationManager:addConfigurationType("CVTaddon", g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_cfg"), key, VehicleConfigurationItem)
		-- g_    configurationManager:addConfigurationType("CVTaddon", g_i18n:getText                                 ("text_CVT_title"), key, VehicleConfigurationItem, nil, nil, ConfigurationUtil.SELECTOR_MULTIOPTION)
		-- g_configurationManager:addConfigurationType("CVTaddon", g_i18n:getText                                     ("text_CVT_title"), nil, nil,                      nil, nil, ConfigurationUtil.SELECTOR_MULTIOPTION)
	end
	ConfigurationUtil.getConfigurationsFromXML = Utils.overwrittenFunction(ConfigurationUtil.getConfigurationsFromXML, addCVTconfig)

	
	print("CVT_Addon: initialized config...... ")
	print("CVT_Addon: by " .. CVTaddon.author .. " and awsome contributors " .. CVTaddon.contributor)
	print("CVT_Addon: Script-Version...: " .. scrversion)
	print("CVT_Addon: Mod-Version......: " .. modversion)
	print("CVT-Addon: Date.............: " .. lastupdate)
	print("CVT-Addon: code.............: " .. timestamp)
end -- initSpecialization

function CVTaddon.registerEventListeners(vehicleType)
	print("################################# registerEventListeners")
	local funcNames = {
		"onRegisterActionEvents",
		"onLoad",
		-- "onPreLoad",
		"onPostLoad",
		"saveToXMLFile",
		-- "onRegisterDashboardValueTypes",
		"onUpdateTick",
		"onReadStream",
		"onLeaveVehicle",
		"onWriteStream",
		"onReadUpdateStream",
		"onWriteUpdateStream",
		"onDraw"
	}
	
	for _, funcName in ipairs(funcNames) do
		SpecializationUtil.registerEventListener(vehicleType, funcName, CVTaddon)
		-- addModEventListener(CVTaddon)
	end
end

function CVTaddon.registerOverwrittenFunctions(vehicleType)
	-- print("################################# registerOverwrittenFunctions")
	SpecializationUtil.registerOverwrittenFunction(vehicleType, "getCanMotorRun", CVTaddon.getCanMotorRun)
	-- SpecializationUtil.registerOverwrittenFunction(vehicleType, "GetLastModulatedMotorRpm", CVTaddon.cvtGetLastModulatedMotorRpm)
	SpecializationUtil.registerOverwrittenFunction(vehicleType, "getRequiredMotorRpmRange", CVTaddon.ptoRpmRange)
	-- SpecializationUtil.registerOverwrittenFunction(vehicleType, "onRegisterDashboardValueTypes", CVTaddon.onRegisterDashboardValueTypes)
	-- SpecializationUtil.registerOverwrittenFunction(vehicleType, "getLastRealMotorRpm", CVTaddon.cvtGetLastRealMotorRpm)
end

-- ToDo: buils new fs25 func for this
----------------------------------------------------------------------------------------------------------------------

function CVTaddon:onRegisterActionEvents()
	-- print("################################# onRegisterActionEvents")
	if g_client ~= nil then
		local spec = self.spec_CVTaddon
		spec.BackupMaxFwSpd = tostring(self.spec_motorized.motor.maxForwardSpeedOrigin)
		spec.BackupMaxBwSpd = tostring(self.spec_motorized.motor.maxBackwardSpeedOrigin)
		spec.calcBrakeForce = string.format("%.2f", self.spec_motorized.motor.maxForwardSpeedOrigin/(self.spec_motorized.motor.maxForwardSpeedOrigin*math.pi)+10)
		spec.maxRpmOrigin = tostring(self.spec_motorized.motor.maxRpm)
		
		if self.getIsEntered ~= nil and self:getIsEntered() then
			CVTaddon.actionEventsV1 = {}
			CVTaddon.actionEventsV2 = {}
			CVTaddon.actionEventsV23 = {}
			CVTaddon.actionEventsV24 = {}
			CVTaddon.actionEventsVt = {}
			CVTaddon.actionEventsV3 = {}
			CVTaddon.actionEventsV3toggle = {}
			CVTaddon.actionEventsV3set1 = {}
			CVTaddon.actionEventsV3set2 = {}
			CVTaddon.actionEventsV3set3 = {}
			CVTaddon.actionEventsV3set4 = {}
			CVTaddon.actionEventsV3set5 = {}
			CVTaddon.actionEventsV3d = {}
			CVTaddon.actionEventsV4 = {}
			CVTaddon.actionEventsV5 = {}
			CVTaddon.actionEventsV6 = {}
			CVTaddon.actionEventsV7 = {}
			CVTaddon.actionEventsV12 = {}
			CVTaddon.actionEventsV13 = {}
			CVTaddon.actionEventsVL = {}
			CVTaddon.actionEventsV8 = {}
			CVTaddon.actionEventsV9 = {}
			CVTaddon.actionEventsV10 = {}
			CVTaddon.actionEventsGUI = {}
			CVTaddon.actionEventsGL = {}
			local actionEventIdGui
			local actionEventIdGL
			local storeItem = g_storeManager:getItemByXMLFilename(self.configFileName)
			if cvtaDebugCVTon then
				print("storeItem.categoryName: " .. tostring(storeItem.categoryName)) -- debug
			end
			spec.currSpdCheck = self:getLastSpeed()
			if cvtaDebugCVTon then
				print("CVTaddon: onRegisterActionEvents vOne: ".. tostring(spec.vOne))
				print("CVTaddon: onRegisterActionEvents vTwo: ".. tostring(spec.vTwo))
				print("CVTaddon: onRegisterActionEvents cvtAR: ".. tostring(spec.cvtAR))
				print("CVTaddon: onRegisterActionEvents vThree: ".. tostring(spec.vThree))
				print("CVTaddon: onRegisterActionEvents eventActiveV1: ".. tostring(CVTaddon.eventActiveV1))
				print("CVTaddon: onRegisterActionEvents eventActiveV2: ".. tostring(CVTaddon.eventActiveV2))
				print("CVTaddon: onRegisterActionEvents eventActiveV3: ".. tostring(CVTaddon.eventActiveV3))
				print("CVTaddon: onRegisterActionEvents eventActiveV3toggle: ".. tostring(CVTaddon.eventActiveV3toggle))
				print("CVTaddon: onRegisterActionEvents eventActiveV4: ".. tostring(CVTaddon.eventActiveV4))
			end
			-- Tasten Bindings
			-- D1
			_, CVTaddon.eventIdV1 = self:addActionEvent(CVTaddon.actionEventsV1, 'SETVARIOONE', self, CVTaddon.VarioOne, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV1, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV1, false)
			-- g_inputBinding:setActionEventTextVisibility(spec.eventIdV1, true) -- test if works
			-- D2
			_, CVTaddon.eventIdV2 = self:addActionEvent(CVTaddon.actionEventsV2, 'SETVARIOTWO', self, CVTaddon.VarioTwo, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV2, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV2, false)
			-- D3
			_, CVTaddon.eventIdV23 = self:addActionEvent(CVTaddon.actionEventsV23, 'SETVARIO3', self, CVTaddon.Vario3, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV23, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV23, false)
			-- D4
			_, CVTaddon.eventIdV24 = self:addActionEvent(CVTaddon.actionEventsV24, 'SETVARIO4', self, CVTaddon.Vario4, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV24, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV24, false)
			
			-- D toggle
			_, CVTaddon.eventIdVt = self:addActionEvent(CVTaddon.actionEventsVt, 'SETVARIOTOGGLE', self, CVTaddon.VarioToggle, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdVt, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdVt, false)
			
			-- AR up
			_, CVTaddon.eventIdV3 = self:addActionEvent(CVTaddon.actionEventsV3, 'LMBF_TOGGLE_RAMP', self, CVTaddon.AccRamps, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3, false)
			-- AR down
			_, CVTaddon.eventIdV3d = self:addActionEvent(CVTaddon.actionEventsV3d, 'LMBF_TOGGLE_RAMPD', self, CVTaddon.AccRampsD, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3d, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3d, false)
			-- AR toggle
			_, CVTaddon.eventIdV3toggle = self:addActionEvent(CVTaddon.actionEventsV3toggle, 'LMBF_TOGGLE_RAMPT', self, CVTaddon.AccRampsToggle, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3toggle, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3toggle, false)
			-- AR 1
			_, CVTaddon.eventIdV3set1 = self:addActionEvent(CVTaddon.actionEventsV3set1, 'LMBF_TOGGLE_RAMPS1', self, CVTaddon.AccRampsSet1, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3set1, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3set1, false)
			-- AR 2
			_, CVTaddon.eventIdV3set2 = self:addActionEvent(CVTaddon.actionEventsV3set2, 'LMBF_TOGGLE_RAMPS2', self, CVTaddon.AccRampsSet2, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3set2, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3set2, false)
			-- AR 3
			_, CVTaddon.eventIdV3set3 = self:addActionEvent(CVTaddon.actionEventsV3set3, 'LMBF_TOGGLE_RAMPS3', self, CVTaddon.AccRampsSet3, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3set3, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3set3, false)
			-- AR 4
			_, CVTaddon.eventIdV3set4 = self:addActionEvent(CVTaddon.actionEventsV3set4, 'LMBF_TOGGLE_RAMPS4', self, CVTaddon.AccRampsSet4, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3set4, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3set4, false)
			-- AR 5
			_, CVTaddon.eventIdV3set5 = self:addActionEvent(CVTaddon.actionEventsV3set5, 'LMBF_TOGGLE_RAMPS5', self, CVTaddon.AccRampsSet5, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV3set5, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV3set5, false)
			
			-- BR
			_, CVTaddon.eventIdV4 = self:addActionEvent(CVTaddon.actionEventsV4, 'LMBF_TOGGLE_BRAMP', self, CVTaddon.BrakeRamps, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV4, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV4, false)

			-- rpm axis
			_, CVTaddon.eventIdV12 = self:addActionEvent(CVTaddon.actionEventsV12, 'SETVARIORPM_AXIS', self, CVTaddon.VarioRpmAxis, false, false, true, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV12, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV12, false)
			
			-- clutch axis
			if spec.isVarioTM == true then
				_, CVTaddon.eventIdV13 = self:addActionEvent(CVTaddon.actionEventsV13, 'AXIS_CLUTCH_VEHICLE', self, CVTaddon.VarioClutchAxis, false, false, true, true)
				g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV13, GS_PRIO_NORMAL)
				g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV13, false)
			end

			-- Fernlicht / Lichthupe
			_, CVTaddon.eventIdVL = self:addActionEvent(CVTaddon.actionEventsVL, 'SIGNAL_HOLD_BEAM', self, CVTaddon.onHighBeamPressed, true, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdVL, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdVL, false)
			
	
			-- CC axis
			-- if spec.isVarioTM == true then
				-- _, CVTaddon.eventIdV13 = self:addActionEvent(CVTaddon.actionEventsV13, 'AXIS_CRUISE_CONTROL', self, CVTaddon.VarioClutchAxis, false, false, true, true)
				-- g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV13, GS_PRIO_NORMAL)
				-- g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV13, false)
			-- end
			
			-- Fahrpedalauflösung -- needed?   oder ändern in RPM aka gearbox
			_, CVTaddon.eventIdV8 = self:addActionEvent(CVTaddon.actionEventsV8, 'SETPEDALTMS', self, CVTaddon.VarioPedalRes, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV8, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV8, false)
			
			-- autoDiffs
			_, CVTaddon.eventIdV9 = self:addActionEvent(CVTaddon.actionEventsV9, 'SETVARIOADIFFS', self, CVTaddon.VarioADiffs, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(CVTaddon.eventIdV9, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(CVTaddon.eventIdV9, false)
			
			-- preGlow
			local tempIsCold = g_currentMission.environment.weather:getCurrentTemperature() < 5
			if spec.CVTcfgExists then
				_, actionEventIdGL = self:addActionEvent(CVTaddon.actionEventsGL, 'SETPREGLOW', self, CVTaddon.SETPREGLOW, false, true, true, true, nil)
				g_inputBinding:setActionEventTextPriority(actionEventIdGL, GS_PRIO_NORMAL)
				g_inputBinding:setActionEventTextVisibility(actionEventIdGL, tempIsCold)
			end
		
			-- GUI open
			_, actionEventIdGui = self:addActionEvent(CVTaddon.actionEventsGUI, 'CVT_SHOWGUI', self, CVTaddon.SHOWGUI, false, true, false, true)
			g_inputBinding:setActionEventTextPriority(actionEventIdGui, GS_PRIO_NORMAL)
			g_inputBinding:setActionEventTextVisibility(actionEventIdGui, true)
		end
		if cvtaDebugCVTon then
			print("CVTaddon: onRegisterActionEvents a vOne: ".. tostring(spec.vOne))
			print("CVTaddon: onRegisterActionEvents a vTwo: ".. tostring(spec.vTwo))
			print("CVTaddon: onRegisterActionEvents a vThree: ".. tostring(spec.vThree))
			print("CVTaddon: onRegisterActionEvents a eventActiveV1: ".. tostring(CVTaddon.eventActiveV1))
			print("CVTaddon: onRegisterActionEvents a eventActiveV2: ".. tostring(CVTaddon.eventActiveV2))
			print("CVTaddon: onRegisterActionEvents a eventActiveV3: ".. tostring(CVTaddon.eventActiveV3))
			print("CVTaddon: onRegisterActionEvents a eventActiveV3toggle: ".. tostring(CVTaddon.eventActiveV3toggle))
			print("CVTaddon: onRegisterActionEvents a eventActiveV4: ".. tostring(CVTaddon.eventActiveV4))
		end
		if cvtsaved then
			cvtsaved = false
		end
	end -- g_client
end -- onRegisterActionEvents

function CVTaddon:onLoad(savegame)
	self.spec_CVTaddon = {}
	local spec = self.spec_CVTaddon
	local pcspec = self.spec_powerConsumer
	CVTaddon.isDedi = g_server ~= nil and g_currentMission.connectedToDedicatedServer
	-- spec.dirtyFlag = self:getNextDirtyFlag()		-- register a bit in the sync pattern
	-- print("################################# Anfang onLoad: " .. tostring(spec.CVTconfig))
	if self.spec_RealisticDamageSystemEngineDied == nil then
		self.spec_RealisticDamageSystemEngineDied = {}
		self.spec_RealisticDamageSystemEngineDied.EngineDied = false
	end
	-- HUD Grafiken laden
		spec.CVTIconBg =  Overlay.new(Utils.getFilename("hud/CVTaddon_HUDbg.dds",  CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconFb =  Overlay.new(Utils.getFilename("hud/CVTaddon_HUDfb.dds",  CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconFs1 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDfs1.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconFs2 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDfs2.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconFs3 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDfs3.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconFs4 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDfs4.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
		spec.CVTIconPtms = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDptms.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconHg2 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg2.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg3 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg3.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg4 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg4.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg5 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg5.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconHEAT = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDpto.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconDmg = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDpto.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMScold = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsCOLD.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMSok = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsOK.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMSwarn = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsWARN.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMScrit = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsCRIT.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMSpGlowing = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsPGLOWING.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconMSpGlowed = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDmsPGLOWED.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconHg6 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg6.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg7 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg7.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg8 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg8.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg9 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg9.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconHg10 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhg10.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconPG = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDpreglowing.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconAr12 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar12.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr22 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar22.dds", CVTaddon.modDirectory), 0, 0, 1, 1);

	spec.CVTIconAr13 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar13.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr23 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar23.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr33 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar33.dds", CVTaddon.modDirectory), 0, 0, 1, 1);

	spec.CVTIconAr1 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar1.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr2 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar2.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr3 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar3.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr4 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar4.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconAr15 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar15.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr25 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar25.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr35 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar35.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr45 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar45.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconAr55 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDar55.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconBr1 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDbr1.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconBr2 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDbr2.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconBr3 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDbr3.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconBr4 = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDbr4.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconHydro = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDhydro.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	
	spec.CVTIconR = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDr.dds", CVTaddon.modDirectory), 0, 0, 1, 1);
	spec.CVTIconV = Overlay.new(Utils.getFilename("hud/CVTaddon_HUDv.dds", CVTaddon.modDirectory), 0, 0, 1, 1);

	spec.BG1width, spec.BG1height = 0.005, 0.09;
	spec.currBGcolor = { 0.02, 0.02, 0.02, 0.7 }

	-- defaults if allother nil
	spec.smoother = 0
	-- if spec.HUDpos == nil then spec.HUDpos = 1 end
	spec.HUDpos = 1
	spec.HUDvis = 1
	spec.DTadd = 0
	spec.vOne = 2				-- DrivingLevel
	spec.cvtDL = 2				-- DrivingLevel count
	spec.cvtAR = 4				-- AccRamp count
	spec.VCAantiSlip = 1		-- anti Schlupf
	spec.VCApullInTurn = 1		-- pull in turn
	spec.vTwo = 4				-- AccRamp
	spec.vThree = 2				-- BrakeRamp
	spec.CVTCanStart = false	-- Allowed to start, clutch etc.
	spec.vFive = 0				-- Handthrottle
	spec.HandgasPercent = 0
	spec.ClutchInputValue = 0.0
	spec.autoDiffs = 0			-- AutoDiff Pre- and choosen state
	-- spec.lastDirection = 1
	spec.isTMSpedal = 0
	-- spec.moveRpmL = 0
	spec.impIsLowered = false
	spec.rpmrange = 1
	-- spec.rpmDmin
	spec.rpmDmax = self.spec_motorized.motor.maxRpm
	spec.BlinkTimer = 0
	spec.NumberBlinkTimer = 0
	spec.Counter = 0
	spec.AN = false
	spec.CVTipm = 1
	spec.HSTstate = 2
	spec.inchingState = 1
	spec.reverseLightsState = 1
	spec.reverseLightsDurationState = 5
	spec.preGlow = 0
	if spec.CVTconfig == nil then
		spec.CVTconfig = 8			-- CVT transmission type config id
		spec.CVTconfigLast = 8		-- CVT transmission type config id
	end
	-- if spec.CVTcfgActive == nil then
		-- spec.CVTcfgActive = 1	-- shop configuration en- or disabled 1off 2on
	-- end
	spec.CVTcfgExists = false
	spec.CVTdamage = 0.000			-- cvt transmission wear percent
	
 -- to make it easier read with dashbord-live
	spec.forDBL_pedalpercent = tostring(self.spec_motorized.motor.lastAcceleratorPedal*100)
	spec.forDBL_rpmrange = tostring(spec.rpmDmax .. " - " .. self.spec_motorized.motor.minRpm)
	spec.forDBL_rpmdmin = tostring(0)
	spec.forDBL_autodiffs = tostring(0)
	spec.forDBL_preautodiffs = tostring(0)
	spec.forDBL_ipmactive = tostring(0)
	spec.forDBL_brakeramp = tostring(0)
	
	spec.forDBL_warnheat = 0
	spec.forDBL_warndamage = 0
	spec.forDBL_critheat = 0
	spec.forDBL_critdamage = 0
	spec.forDBL_cvtwear = 0.000
	spec.forDBL_highpressure = 0
	
	spec.forDBL_cvtclutch = 0.0
	spec.forDBL_handthrottle = 0.0
	spec.forDBL_vmaxforward = 0.0
	spec.forDBL_vmaxbackward = 0.0
	spec.forDBL_preglowing = 0
	spec.forDBL_glowingstate = 0
	spec.forDBL_cvtaccrange = 4
	spec.forDBL_cvtdlrange = 2
	spec.forDBL_autoantislip = 0
	spec.forDBL_pullinturnactive = 0
	spec.forDBL_autoreverselight = 0
	
	-- #GLOWIN-TEMP-SYNC
	-- spec.SyncMotorTemperature = 20 -- temp
	spec.motorTemperature = 20
	spec.fanEnabled = false
	spec.fanEnabledLast = false
	spec.SyncFanEnabled = false
		
	if spec.isTMSpedal ~= nil then
		if spec.isTMSpedal == 0 then
			spec.forDBL_tmspedal = 0
		elseif spec.isTMSpedal == 1 then
			spec.forDBL_tmspedal = 1
		end
	end

	if spec.vOne ~= nil then
		-- if spec.vOne == 1 then
			-- spec.forDBL_drivinglevel = tostring(1)
		-- elseif spec.vOne == 2 then
			-- spec.forDBL_drivinglevel = tostring(2)
			
		-- end
		spec.forDBL_drivinglevel = tostring(spec.vOne)
	end
	if spec.cvtDL ~= nil then
		spec.forDBL_drivinglevelcount = tostring(spec.cvtDL)
	end
	if spec.cvtAR ~= nil then
		spec.forDBL_accrampcount = tostring(spec.cvtAR)
	end
	
	
	spec.forDBL_digitalhandgasstep = tostring(spec.vFive)
	if spec.vTwo ~= nil then
		if spec.vTwo == 4 then
			spec.forDBL_accramp = tostring(4)
		elseif spec.vTwo == 1 then
			spec.forDBL_accramp = tostring(1)
		elseif spec.vTwo == 2 then
			spec.forDBL_accramp = tostring(2)
		elseif spec.vTwo == 3 then
			spec.forDBL_accramp = tostring(3)
		end
	end
	spec.forDBL_rpmdmax = tostring(spec.rpmDmax)
	if spec.vThree ~= nil then
		if (spec.vThree == 1) then -- BRamp 1
			spec.forDBL_brakeramp = tostring(17) -- off
		end
		if (spec.vThree == 2) then -- BRamp 2
			spec.forDBL_brakeramp = tostring(0) -- km/h
		end
		if (spec.vThree == 3) then -- BRamp 3
			spec.forDBL_brakeramp = tostring(4) -- km/h
		end
		if (spec.vThree == 4) then -- BRamp 4
			spec.forDBL_brakeramp = tostring(8) -- km/h
		end
		if (spec.vThree == 5) then -- BRamp 5
			spec.forDBL_brakeramp = tostring(15) -- km/h
		end
	end
	spec.forDBL_motorcanstart = 0

	-- inputBinding events
	CVTaddon.eventActiveV1 = true
	CVTaddon.eventActiveV2 = true
	CVTaddon.eventActiveVt = true
	CVTaddon.eventActiveV3toggle = true
	CVTaddon.eventActiveV3set1 = true
	CVTaddon.eventActiveV3set2 = true
	CVTaddon.eventActiveV3set3 = true
	CVTaddon.eventActiveV3set4 = true
	CVTaddon.eventActiveV3 = true
	CVTaddon.eventActiveV3d = true
	CVTaddon.eventActiveV4 = true
	CVTaddon.eventActiveV5 = true
	CVTaddon.eventActiveV6 = true
	CVTaddon.eventActiveV7 = true
	CVTaddon.eventActiveV12 = true
	CVTaddon.eventActiveV13 = true
	CVTaddon.eventActiveV8 = true
	CVTaddon.eventActiveV9 = true
	CVTaddon.eventActiveV10 = true
	CVTaddon.eventIdV1 = nil
	CVTaddon.eventIdV2 = nil
	CVTaddon.eventIdV23 = nil
	CVTaddon.eventIdV24 = nil
	CVTaddon.eventIdVt = nil
	CVTaddon.eventIdV3 = nil
	CVTaddon.eventIdV3toggle = nil
	CVTaddon.eventIdV3set1 = nil
	CVTaddon.eventIdV3set2 = nil
	CVTaddon.eventIdV3set3 = nil
	CVTaddon.eventIdV3set4 = nil
	CVTaddon.eventIdV3set5 = nil
	CVTaddon.eventIdV3d = nil
	CVTaddon.eventIdV4 = nil
	CVTaddon.eventIdV5 = nil
	CVTaddon.eventIdV6 = nil
	CVTaddon.eventIdV7 = nil
	CVTaddon.eventIdV12 = nil
	CVTaddon.eventIdV13 = nil
	CVTaddon.eventIdVL = nil
	CVTaddon.eventIdV8 = nil
	CVTaddon.eventIdV9 = nil
	CVTaddon.eventIdV10 = nil
	spec.BackupMaxFwSpd = ""
	if spec.calcBrakeForce == nil then
		spec.calcBrakeForce = "0.5"
	end
	spec.highBeamActive = false
	spec.highBeamPressed = false
	spec.reverseWorkLightActive = false
	spec.reverseLightTimeout = 0
	spec.reverseLightDelayTimer = 0
	spec.reverseLightDelayDuration = 0


	-- Timer für Warnblinker-Blinken
    spec.warningBlinkerTimer = 0
    -- spec.warningBlinkerDuration = 2000 -- 2 Sekunden (Zeit für zwei kurze Blinkungen)
    spec.warningBlinkerActive = false
    spec.warningBlinkerState = false -- an oder aus
    -- spec.warningBlinkerBlinkInterval = 500 -- Intervall zwischen an/aus (500ms = 0.5s)
    spec.warningBlinkerBlinkTimer = 0
    spec.warningBlinkerBlinkCount = 0
	spec.warningBlinkerBlinkInterval = 0.5 -- halbe Sekunde an/aus
	spec.warningBlinkerDuration = 2       -- 2 Sekunden Gesamtblinkzeit

	spec.check = false
	spec.dirtyFlag = self:getNextDirtyFlag()		-- register a bit in the sync pattern
end  -- onLoad

-----------------------------------------------------------------------------------------------

-- function CVTaddon:onPostLoad(savegame, mission, node, state)
function CVTaddon:onPostLoad(savegame)

-- load vehicle setting
	local spec = self.spec_CVTaddon
	if spec == nil then return end
	
	print("################################# onPostLoad: ".. tostring(spec.CVTcfgExists))
	-- local CvtConfigActive = Utils.getNoNil(self.configurations["CVTaddon"], 1)
	-- if g_client ~= nil then
		-- if self.spec_motorized ~= nil then
			-- if spec == nil then return end
			-- spec.CVTcfgExists = self.configurations["CVTaddon"] ~= nil and self.configurations["CVTaddon"] ~= 1
			
	spec.CVTcfgExists = self.configurations["CVTaddon"] ~= nil and self.configurations["CVTaddon"] == 2 -- CFGTEST
	-- print("LOAD CFG: " .. tostring(self.configurations["CVTaddon"]))
	-- print("GUI Load A: " .. tostring(spec.HUDpos))
	if savegame ~= nil then
		local xmlFile = savegame.xmlFile
		local key = savegame.key .. ".FS25_CVT_Addon.CVTaddon"
		spec.CVTcfgExists = xmlFile:getValue(key..".cvtconfigured", spec.CVTcfgExists)
		
		-- if spec.CVTcfgExists then
			spec.vOne = xmlFile:getValue(key.."#vOne", spec.vOne)
			spec.cvtDL = xmlFile:getValue(key.."#cvtDL", spec.cvtDL)
			spec.cvtAR = xmlFile:getValue(key.."#cvtAR", spec.cvtAR)
			spec.vTwo = xmlFile:getValue(key.."#vTwo", spec.vTwo)
			spec.vThree = xmlFile:getValue(key.."#vThree", spec.vThree)
			-- spec.vFive = xmlFile:getValue(key.."#vFive", spec.vFive)
			spec.autoDiffs = xmlFile:getValue(key.."#autoDiffs", spec.autoDiffs)
			spec.CVTconfig = xmlFile:getValue(key.."#CvtConfigId", spec.CVTconfig)
			spec.CVTipm = xmlFile:getValue(key.."#CvtIPM", spec.CVTipm)
			spec.HSTstate = xmlFile:getValue(key.."#HSTstate", spec.HSTstate)
			spec.inchingState = xmlFile:getValue(key.."#inchingState", spec.inchingState)
			spec.reverseLightsState = xmlFile:getValue(key.."#reverseLightsState", spec.reverseLightsState)
			spec.reverseLightsDurationState = xmlFile:getValue(key.."#reverseLightsDurationState", spec.reverseLightsDurationState)
			spec.CVTdamage = xmlFile:getValue(key.."#CVTdamage", spec.CVTdamage)
			spec.HUDpos = xmlFile:getValue(key.."#HUDpos", spec.HUDpos)
			spec.HUDvis = xmlFile:getValue(key.."#HUDvis", spec.HUDvis)
			spec.VCAantiSlip = xmlFile:getValue(key.."#VCAantiSlip", spec.VCAantiSlip)
			spec.VCApullInTurn = xmlFile:getValue(key.."#VCApullInTurn", spec.VCAantiSlip)
			-- spec.CVTCanStart = xmlFile:getValue(key.."#CVTCanStart", spec.CVTCanStart)

		if spec.CVTcfgExists then
			print("CVT_Addon: personal adjustments loaded for "..self:getName())
			print("CVT_Addon: Load Driving Level id: "..tostring(spec.vOne))
			print("CVT_Addon: Load Acceleration Ramp id: "..tostring(spec.vTwo))
			print("CVT_Addon: Load Brake Ramp id: "..tostring(spec.vThree))
		end
	end
	spec.highBeamActive = false
	spec.highBeamPressed = false
	spec.reverseWorkLightActive = false
	spec.reverseLightTimeout = 0
	spec.reverseLightDelayTimer = 0
	spec.reverseLightDelayDuration = 0

	-- Timer für Warnblinker-Blinken
    spec.warningBlinkerTimer = 0
    -- spec.warningBlinkerDuration = 2000 -- 2 Sekunden (Zeit für zwei kurze Blinkungen)
    spec.warningBlinkerActive = false
    spec.warningBlinkerState = false -- an oder aus
    -- spec.warningBlinkerBlinkInterval = 500 -- Intervall zwischen an/aus (500ms = 0.5s)
    spec.warningBlinkerBlinkTimer = 0
    spec.warningBlinkerBlinkCount = 0
	spec.warningBlinkerBlinkInterval = 0.5 -- halbe Sekunde an/aus
	spec.warningBlinkerDuration = 2       -- 2 Sekunden Gesamtblinkzeit

	-- print("GUI Load M: " .. tostring(spec.HUDpos))
	-- savegame set config
	-- self.configurations["CVTaddon"] = spec.CVTcfgExists and 2 or 1 -- CFGTEST
	if spec.CVTcfgExists then
		self.configurations["CVTaddon"] = 2
	elseif not spec.CVTcfgExists then
		self.configurations["CVTaddon"] = 1
	end
	-- CFGTEST
	-- self.configurations["CVTaddon"] = spec.CVTcfgExists -- CFGTEST
		-- end
	-- end -- g_client

	-- if spec.CVTcfgExists then
		-- spec.CVTcfgActive = 2
	-- end
	
	-- gU_targetSelf = self

	print("CVTa: CvtConfigId spec.CVTconfig " .. tostring(spec.CVTconfig))
	-- print("CVTa: CvtConfigActive " .. tostring(spec.CVTcfgActive))

 -- to make it easier read with dashbord-live
	spec.forDBL_pedalpercent = tostring(self.spec_motorized.motor.lastAcceleratorPedal*100)
	spec.forDBL_rpmrange = 1
	spec.forDBL_rpmdmin = tostring(0)
	spec.forDBL_autodiffs = tostring(0)
	spec.forDBL_preautodiffs = tostring(0)
	spec.forDBL_ipmactive = tostring(0)
	spec.forDBL_ipmstate = tostring(0)
	spec.forDBL_brakeramp = tostring(0)
	spec.forDBL_warnheat = 0
	spec.forDBL_warndamage = 0
	spec.forDBL_critheat = 0
	spec.forDBL_critdamage = 0
	spec.forDBL_highpressure = 0
	if spec.CVTdamage ~= nil then
		spec.forDBL_cvtwear = spec.CVTdamage
	else
		spec.forDBL_cvtwear = 0.00
		spec.CVTdamage = 0.000
	end
	
	-- if spec.CVTCanStart ~= nil then
	if spec.isTMSpedal ~= nil then
		if spec.isTMSpedal == 0 then
			spec.forDBL_tmspedal = 0
		elseif spec.isTMSpedal == 1 then
			spec.forDBL_tmspedal = 1
		end
	end

	if spec.vOne ~= nil then
		-- if spec.vOne == 1 then
			-- spec.forDBL_drivinglevel = tostring(2)
		-- elseif spec.vOne == 2 then
			-- spec.forDBL_drivinglevel = tostring(1)
		-- end
		spec.forDBL_drivinglevel = tostring(spec.vOne)
	end
	if spec.cvtDL ~= nil then
		spec.forDBL_drivinglevelcount = tostring(spec.cvtDL)
	end
	if spec.cvtAR ~= nil then
		spec.forDBL_accrampcount = tostring(spec.cvtAR)
	end
	
	spec.forDBL_digitalhandgasstep = tostring(spec.vFive)
	if spec.vTwo ~= nil then
		if spec.vTwo == 4 then
			spec.forDBL_accramp = tostring(4)
		elseif spec.vTwo == 1 then
			spec.forDBL_accramp = tostring(1)
		elseif spec.vTwo == 2 then
			spec.forDBL_accramp = tostring(2)
		elseif spec.vTwo == 3 then
			spec.forDBL_accramp = tostring(3)
		end
	end
	-- spec.forDBL_rpmdmax = tostring(spec.rpmDmax)
	if spec.vThree ~= nil then
		if (spec.vThree == 1) then -- BRamp 1
			spec.forDBL_brakeramp = tostring(17) -- off
		end
		if (spec.vThree == 2) then -- BRamp 2
			spec.forDBL_brakeramp = tostring(0) -- km/h
		end
		if (spec.vThree == 3) then -- BRamp 3
			spec.forDBL_brakeramp = tostring(4) -- km/h
		end
		if (spec.vThree == 4) then -- BRamp 4
			spec.forDBL_brakeramp = tostring(8) -- km/h
		end
		if (spec.vThree == 5) then -- BRamp 5
			spec.forDBL_brakeramp = tostring(15) -- km/h
		end
	end
	-- spec.forDBL_
	-- print("GUI Load E: " .. tostring(spec.HUDpos))
	
	-- if self.spec_motorized.motor:getRotInertia() < 0.003 then
		-- local setRIorigin = self.spec_motorized.motor.peakMotorTorque / 600
		-- self.spec_motorized.motor:setRotInertia(setRIorigin)
		-- -- print("setRIorigin: ".. tostring(setRIorigin))
	-- end
end -- onPostLoad
if CVTaddon.ModName == nil then
	CVTaddon.ModName = g_currentModName
end
CVTaddon.PoH = 1; -- Position of HUD
-- CVTaddon.HUDpos = 1;
CVTaddon.XMLloaded = 0;
-- CVTaddon.HUDposChanged = {}
-- CVTaddon.HUDposChanged[1] = g_i18n.modEnvironments[CVTaddon.ModName]:getText("selection_CVTaddonHUDpos_1")
-- CVTaddon.HUDposChanged[2] = g_i18n.modEnvironments[CVTaddon.ModName]:getText("selection_CVTaddonHUDpos_2")
-- CVTaddon.HUDposChanged[3] = g_i18n.modEnvironments[CVTaddon.ModName]:getText("selection_CVTaddonHUDpos_3")


-- make localizations available
local i18nTable = getfenv(0).g_i18n
for l18nId,l18nText in pairs(g_i18n.texts) do
  i18nTable:setText(l18nId, l18nText)
end

function CVTaddon:saveToXMLFile(xmlFile, key, usedModNames)
	
	
	-- if g_currentMission.missionInfo.isValid then
        -- local xmlFile4HUD = XMLFile.create("CVTaddon", g_currentMission.missionInfo.savegameDirectory .. "/CVTaddonHUD.xml", "CVTaddon")
        -- if xmlFile4HUD ~= nil then
            -- xmlFile4HUD:setInt("CVTaddon.nvHUDpos", CVTaddon.HUDpos)
            -- xmlFile4HUD:save()
            -- xmlFile4HUD:delete()
			-- print("CVTa: CVTaddonHUD.xml data saved")
        -- end
    -- end
	
	-- if self.spec_motorized ~= nil then
	local spec = self.spec_CVTaddon
	-- spec.CVTcfgExists = self.configurations["CVTaddon"] or 1 -- CFGTEST
	
	if self.configurations["CVTaddon"] == 2 then
		spec.CVTcfgExists = true
	elseif self.configurations["CVTaddon"] == 1 then
		spec.CVTcfgExists = false
	end
	
	-- spec.CVTcfgExists = self.configurations["CVTaddon"] or false -- CFGTEST
	-- spec.CVTcfgExists = self.configurations["CVTaddon"] == 2 -- CFGTEST
	-- print("################################# saveToXMLFile cfg: " .. tostring(spec.CVTcfgExists))

	-- spec.CvtConfigActive = self.configurations["CVTaddon"] or 1
	
	xmlFile:setValue(key..".cvtconfigured", spec.CVTcfgExists)
	xmlFile:setValue(key.."#vOne", spec.vOne)
	xmlFile:setValue(key.."#cvtDL", spec.cvtDL)
	xmlFile:setValue(key.."#cvtAR", spec.cvtAR)
	xmlFile:setValue(key.."#vTwo", spec.vTwo)
	xmlFile:setValue(key.."#vThree", spec.vThree)
	xmlFile:setValue(key.."#autoDiffs", spec.autoDiffs)
	xmlFile:setValue(key.."#CvtConfigId", spec.CVTconfig)
	xmlFile:setValue(key.."#CvtIPM", spec.CVTipm)
	xmlFile:setValue(key.."#HSTstate", spec.HSTstate)
	xmlFile:setValue(key.."#inchingState", spec.inchingState)
	xmlFile:setValue(key.."#reverseLightsState", spec.reverseLightsState)
	xmlFile:setValue(key.."#reverseLightsDurationState", spec.reverseLightsDurationState)
	xmlFile:setValue(key.."#CVTdamage", spec.CVTdamage)
	xmlFile:setValue(key.."#HUDpos", spec.HUDpos)
	xmlFile:setValue(key.."#HUDvis", spec.HUDvis)
	xmlFile:setValue(key.."#VCAantiSlip", spec.VCAantiSlip)
	xmlFile:setValue(key.."#VCApullInTurn", spec.VCApullInTurn)
	-- spec.CVTCanStart = xmlFile:setValue(key.."#CVTCanStart", spec.CVTCanStart)
	-- spec.vFive = 0
	-- spec.vFive = xmlFile:setValue(key.."#vFive", spec.vFive)
	-- xmlFile:setValue(key.."#CvtConfigActive", spec.CvtConfigActive)
	-- spec.CVTcfgActive = xmlFile:setValue(key.."#CvtConfigActive", spec.CVTcfgActive)
	if not cvtsaved then
		print("CVT_Addon: 16 values saved.")
		cvtsaved = true
	end
end

-----------------------------------------------------------------------------------------------

-- CVT GUI
function CVTaddon:SHOWGUI(actionName, keyStatus, arg3, arg4, arg5)
	local spec = self.spec_CVTaddon
	local CVTAGui = g_gui:showDialog("CVTaddonGui")
	local hasNothing = false
	-- print("cvtDL: " .. tostring(spec.cvtDL))
	-- print("showGUI A: " .. tostring(spec.HUDpos))
	CVTAGui.target:setCallback(CVTaddon.guiCallback, self)
	CVTaddonGui.setData(CVTAGui.target, self:getFullName(), spec, hasNothing, CVTaddon.debug, CVTaddon.showKeys)
	-- CVTaddonGui.logicalCheck(self)
end

function CVTaddon:guiCallback(changes, debug, showKeys)
	self.spec_CVTaddon = changes
	CVTaddon.debug = debug
	CVTaddon.showKeys = showKeys
	local spec = self.spec_CVTaddon
	print("guiCallBack : "..tostring(spec.CVTconfig).." / "..tostring(spec.CVTconfigLast))
	if spec.CVTconfig ~= 0 and spec.CVTconfig ~= spec.CVTconfigLast then 
		print("guiCallback : CVT config changed")
	else 
		print("guiCallback : no transmission changes")
	end
	-- spec.CVTconfigLast = spec.CVTconfig
	-- print("callbackGUI E: " .. tostring(spec.HUDpos))
	self:raiseDirtyFlags(spec.dirtyFlag)
end


function CVTaddon:BrakeRamps() -- BREMSRAMPEN - Ab kmh X wird die Betriebsbremse automatisch aktiv
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		-- local spec = self.spec_CVTaddon
		if cvtaDebugCVTon then
			print("BrRamp Taste gedrückt vThree: "..tostring(spec.vThree))
			print("BrRamp Taste gedrückt lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
		end
		if self.CVTaddon == nil then
			return
		end
		if not CVTaddon.eventActiveV4 then
			return
		end
		if (spec.vThree == 1) then -- BRamp 1
			spec.forDBL_brakeramp = tostring(0) -- off / 1-2 km/h vanilla lowBrakeForceSpeedLimit: 0.00027777777777778
			if cvtaDebugCVTon then
				print("BrRamp 1 vThree: "..tostring(spec.vThree))
				print("BrRamp 1 lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
			end
		end
		if (spec.vThree == 2) then -- BRamp 2
			spec.forDBL_brakeramp = tostring(4) -- km/h
			if cvtaDebugCVTon then
				print("BrRamp 2 vThree: "..tostring(spec.vThree))
				print("BrRamp 2 lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
			end
		end
		if (spec.vThree == 3) then -- BRamp 3
			spec.forDBL_brakeramp = tostring(8) -- km/h
			if cvtaDebugCVTon then
				print("BrRamp 3 vThree: "..tostring(spec.vThree))
				print("BrRamp 3 lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
			end
		end
		if (spec.vThree == 4) then -- BRamp 4
			spec.forDBL_brakeramp = tostring(15) -- km/h
			if cvtaDebugCVTon then
				print("BrRamp 4 vThree: "..tostring(spec.vThree))
				print("BrRamp 4 lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
			end
		end
		if (spec.vThree == 5) then -- BRamp 5
			spec.forDBL_brakeramp = tostring(17) -- km/h
			if cvtaDebugCVTon then
				print("BrRamp 5 vThree: "..tostring(spec.vThree))
				print("BrRamp 5 lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
			end
		end
		if spec.vThree == 5 or spec.vThree == nil then
			spec.vThree = 1
		else
			spec.vThree = spec.vThree + 1
		end
		-- to make it easier read with dashbord-live
		if cvtaDebugCVTon then
			print("BrRamp Taste losgelassen vThree: "..tostring(spec.vThree))
			print("BrRamp Taste losgelassen lBFSL: "..self.spec_motorized.motor.lowBrakeForceSpeedLimit)
		end
		self:raiseDirtyFlags(spec.dirtyFlag)
		if g_server ~= nil then
			g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
		end
		if debug_for_DBL then
			print("CVTa BR event: " .. spec.vThree)		
			print("CVTa BR 4_dbl: " .. spec.forDBL_brakeramp)		
		end
		spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
		spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
	end --g_client
end -- BrakeRamps

function CVTaddon:AccRampsToggle() -- BESCHLEUNIGUNGSRAMPEN
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		if cvtaDebugCVTon then
			print("AccRamp Taste gedrückt vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		if self.CVTaddon == nil then
			return
		end
		if not CVTaddon.eventActiveV3toggle then
			return
		end
		if spec.vTwo == spec.cvtAR or spec.vTwo == nil then
			spec.vTwo = 1
		else
			spec.vTwo = spec.vTwo + 1
		end
		-- DBL convert
			spec.forDBL_accramp = tostring(spec.vTwo)
				
		if (spec.vTwo == 1) then -- Ramp 1 +1
			if cvtaDebugCVTon then
				print("AccRamp 1 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 1 acc0.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 2) then -- Ramp 2 +1
			if cvtaDebugCVTon then
				print("AccRamp 2 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 2 acc1.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 3) then -- Ramp 3 +1
			if cvtaDebugCVTon then
				print("AccRamp 3 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 3 acc1.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo >= 4) then -- Ramp 4 +1
			-- self.spec_motorized.motor.peakMotorTorque = self.spec_motorized.motor.peakMotorTorque * 0.5
			if cvtaDebugCVTon then
				print("AccRamp 4> vTwo: "..tostring(spec.vTwo))
				print("AccRamp 4> acc2.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		
		if cvtaDebugCVTon then
			print("AccRamp Taste losgelassen vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste losgelassen cvtAR: "..tostring(spec.cvtAR))
			print("AccRamp Taste losgelassen acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		
		
		self:raiseDirtyFlags(spec.dirtyFlag)
		if g_server ~= nil then
			g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
		end
		spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
		spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
	end -- g_client
end -- AccRamps Toggle

function CVTaddon:AccRampsSet1() -- BESCHLEUNIGUNGSRAMPEN I
	local spec = self.spec_CVTaddon
	if spec.cvtAR >= 1 then
		if g_client ~= nil then
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV3set1 then
				return
			end
			spec.vTwo = 1
			-- DBL convert
			spec.forDBL_accramp = tostring(1)

			if cvtaDebugCVTon then
				print("AccRamp1 Taste gedrückt vTwo: "..tostring(spec.vTwo))
				print("AccRamp1 Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
			spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
			spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
		end -- g_client
	end
end -- AccRamps set1

function CVTaddon:AccRampsSet2() -- BESCHLEUNIGUNGSRAMPEN II
	local spec = self.spec_CVTaddon
	if spec.cvtAR >= 2 then
		if g_client ~= nil then
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV3set2 then
				return
			end
			spec.vTwo = 2
			-- DBL convert
			spec.forDBL_accramp = tostring(2)

			if cvtaDebugCVTon then
				print("AccRamp2 Taste gedrückt vTwo: "..tostring(spec.vTwo))
				print("AccRamp2 Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
			spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
			spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
		end -- g_client
	end
end -- AccRamps set2

function CVTaddon:AccRampsSet3() -- BESCHLEUNIGUNGSRAMPEN III
	local spec = self.spec_CVTaddon
	if spec.cvtAR >= 3 then
		if g_client ~= nil then
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV3set3 then
				return
			end
			spec.vTwo = 3
			-- DBL convert
			spec.forDBL_accramp = tostring(3)

			if cvtaDebugCVTon then
				print("AccRamp3 Taste gedrückt vTwo: "..tostring(spec.vTwo))
				print("AccRamp3 Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
			spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
			spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
		end -- g_client
	end
end -- AccRamps set3

function CVTaddon:AccRampsSet4() -- BESCHLEUNIGUNGSRAMPEN IV
	local spec = self.spec_CVTaddon
	if spec.cvtAR >= 4 then
		if g_client ~= nil then
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV3set4 then
				return
			end
			spec.vTwo = 4
			-- DBL convert
			spec.forDBL_accramp = tostring(4)

			if cvtaDebugCVTon then
				print("AccRamp4 Taste gedrückt vTwo: "..tostring(spec.vTwo))
				print("AccRamp4 Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
			spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
			spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
		end -- g_client
	end
end -- AccRamps set4

function CVTaddon:AccRampsSet5() -- BESCHLEUNIGUNGSRAMPEN V
	local spec = self.spec_CVTaddon
	if spec.cvtAR == 5 then
		if g_client ~= nil then
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV3set4 then
				return
			end
			spec.vTwo = 5
			-- DBL convert
			spec.forDBL_accramp = tostring(4)

			if cvtaDebugCVTon then
				print("AccRamp4 Taste gedrückt vTwo: "..tostring(spec.vTwo))
				print("AccRamp4 Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
			spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
			spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
		end -- g_client
	end
end -- AccRamps set5

function CVTaddon:AccRamps() -- BESCHLEUNIGUNGSRAMPEN - Motorbremswirkung wird kontinuirlich berechnet @update
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		if cvtaDebugCVTon then
			print("AccRamp Taste gedrückt vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		if self.CVTaddon == nil then
			return
		end
		if not CVTaddon.eventActiveV3 then
			return
		end
		
		if spec.vTwo < spec.cvtAR then
			spec.vTwo = spec.vTwo + 1
			-- CVTaddon.eventActiveV3 = true
		else
			spec.vTwo = spec.cvtAR
			-- CVTaddon.eventActiveV3 = false
		end
		if cvtaDebugCVTon then
			print("AccRamp Taste losgelassen vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste losgelassen acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		-- DBL convert
		if spec.vTwo == 4 then
			spec.forDBL_accramp = tostring(4)
		elseif spec.vTwo == 1 then
			spec.forDBL_accramp = tostring(1)
		elseif spec.vTwo == 2 then
			spec.forDBL_accramp = tostring(2)
		elseif spec.vTwo == 3 then
			spec.forDBL_accramp = tostring(3)
		end
		
		if (spec.vTwo == 1) then -- Ramp 1 +1
			if cvtaDebugCVTon then
				print("AccRamp 1 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 1 acc0.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 2) then -- Ramp 2 +1
					
			if cvtaDebugCVTon then
				print("AccRamp 2 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 2 acc1.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 3) then -- Ramp 3 +1

			if cvtaDebugCVTon then
				print("AccRamp 3 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 3 acc1.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 4) then -- Ramp 4 +1
			-- self.spec_motorized.motor.peakMotorTorque = self.spec_motorized.motor.peakMotorTorque * 0.5
			if cvtaDebugCVTon then
				print("AccRamp 4 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 4 acc2.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		
		
		self:raiseDirtyFlags(spec.dirtyFlag)
		if g_server ~= nil then
			g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
		end
		spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
		spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
	end -- g_client
end -- AccRamps
function CVTaddon:AccRampsD()
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		if cvtaDebugCVTon then
			print("AccRamp Taste gedrückt vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste gedrückt acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		if self.CVTaddon == nil then
			return
		end
		if not CVTaddon.eventActiveV3d then
			return
		end
		
		if spec.vTwo > 1 then
			spec.vTwo = spec.vTwo - 1
			-- CVTaddon.eventActiveV3d = true
		else
			spec.vTwo = 1
			-- CVTaddon.eventActiveV3d = false
		end
		if cvtaDebugCVTon then
			print("AccRamp Taste losgelassen vTwo: "..tostring(spec.vTwo))
			print("AccRamp Taste losgelassen acc: "..self.spec_motorized.motor.accelerationLimit)
		end
		-- DBL convert
		if spec.vTwo == 4 then
			spec.forDBL_accramp = tostring(4)
		elseif spec.vTwo == 1 then
			spec.forDBL_accramp = tostring(1)
		elseif spec.vTwo == 2 then
			spec.forDBL_accramp = tostring(2)
		elseif spec.vTwo == 3 then
			spec.forDBL_accramp = tostring(3)
		end
		
		if (spec.vTwo == 1) then -- Ramp 1 +1
			if cvtaDebugCVTon then
				print("AccRamp 1 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 1 acc0.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 2) then -- Ramp 2 +1
			
			if cvtaDebugCVTon then
				print("AccRamp 2 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 2 acc1.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 3) then -- Ramp 3 +1
			if cvtaDebugCVTon then
				print("AccRamp 3 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 3 acc1.5: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
		if (spec.vTwo == 4) then -- Ramp 4 +1
			-- self.spec_motorized.motor.peakMotorTorque = self.spec_motorized.motor.peakMotorTorque * 0.5
			if cvtaDebugCVTon then
				print("AccRamp 4 vTwo: "..tostring(spec.vTwo))
				print("AccRamp 4 acc2.0: "..self.spec_motorized.motor.accelerationLimit)
			end
		end
				
		self:raiseDirtyFlags(spec.dirtyFlag)
		if g_server ~= nil then
			g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
		end
		spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
		spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
	end -- g_client
end -- AccRamps Down



function CVTaddon:VarioRpmAxis(actionName, inputValue)	
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		if inputValue ~= nil then
			spec.HandgasPercent = (math.floor(tonumber(inputValue) * 100)/100)
		end
		spec.forDBL_digitalhandgasstep = spec.vFive
		-- print("CVTa HandgasPercent: " .. tostring(spec.HandgasPercent))
		self:raiseDirtyFlags(spec.dirtyFlag)
		-- if g_server ~= nil then
			-- g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue), nil, nil, self)
		-- else
			-- g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue))
		-- end
	end
end

function CVTaddon:onHighBeamPressed(actionName, inputValue, callbackState, isAnalog)
	local spec = self.spec_CVTaddon
	
	if spec.highBeamActive == nil then
		spec.highBeamActive = false
		-- print("spec.highBeamActive ist nil und wurde auf false gesetzt")
	end

	local bit3 = 2 ^ 3
	local mask = self.spec_lights.lightsTypesMask or 0

	if inputValue == 1 then
		spec.highBeamActive = true
		-- print("Fernlicht AN")
		if bitAND(mask, bit3) == 0 then
			self:setLightsTypesMask(bitOR(mask, bit3))
		end
	elseif inputValue == 0 then
		spec.highBeamActive = false
		-- print("Fernlicht AUS")
		if bitAND(mask, bit3) ~= 0 then
			self:setLightsTypesMask(bitAND(mask, bitNOT(bit3)))
		end
	end
end


function CVTaddon:VarioClutchAxis(actionName, inputValue)	
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		spec.ClutchInputValue = tonumber(inputValue)
		spec.ClutchInputValue = (math.floor(spec.ClutchInputValue * 10)/10)
		-- print("(f)ClutchInputValue: " .. tostring(spec.ClutchInputValue))
		self:raiseDirtyFlags(spec.dirtyFlag)
		if g_server ~= nil then
			g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
		end
	end
end

function CVTaddon:VarioOne() -- FAHRSTUFE 1 field
	local spec = self.spec_CVTaddon
	spec.BlinkTimer = -1
	spec.Counter = 0
	if spec.CVTconfig ~= 4 or spec.CVTconfig ~= 5 or spec.CVTconfig ~= 6 or spec.CVTconfig ~= 8 or spec.CVTconfig ~= 9 or spec.CVTconfig ~= 7 then
		if g_client ~= nil then
			if cvtaDebugCVTon then
				print("VarioOne Taste gedrückt vOne: ".. tostring(spec.vOne))
			end
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV1 or not CVTaddon.eventActiveV2 then
				return
			end

			if self:getIsEntered() and self:getIsMotorStarted() then
				if spec.cvtDL > 1 then
					spec.vOne = 1
				end
				
				if spec.vOne < spec.cvtDL then
					if self:getLastSpeed() <=10 then
						if self:getLastSpeed() > 1 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 then
							spec.CVTdamage = math.min(spec.CVTdamage + math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- if self.spec_RealisticDamageSystem == nil then
								-- self:addDamageAmount(math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- end
							spec.forDBL_critdamage = 1
							spec.forDBL_warndamage = 0
							if cvtaDebugCVTxOn then
								print("Damage: ".. (math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))  ) -- debug
							end
						end
						CVTaddon.eventActiveV1 = true
						CVTaddon.eventActiveV2 = true
						if cvtaDebugCVTon then
							print("VarioTwo vOne<: "..tostring(spec.vOne))
							print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
							print("VarioTwo : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						end
					end
					self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94)
					self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL* spec.vOne, 3.21), 6.36)
				elseif spec.vOne == spec.cvtDL then
					self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin
					self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin
					spec.autoDiffs = 0
					if self.spec_vca ~= nil then
						self:vcaSetState("diffLockFront", false)
						self:vcaSetState("diffLockBack", false)
					end
					CVTaddon.eventActiveV1 = true
					CVTaddon.eventActiveV2 = true
					if cvtaDebugCVTon then
						print("VarioTwo vOne>: "..tostring(spec.vOne))
						print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
						-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
						print("VarioTwo MAX : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
					end
				end
			end
			
			if cvtaDebugCVTon then
				print("VarioOne Taste losgelassen vOne: ".. tostring(spec.vOne))
			end
			
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end -- g_client
	end
	-- DBL convert
	spec.forDBL_drivinglevel = tostring(1)
	spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
	spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
end -- VarioOne

function CVTaddon:VarioTwo() -- FAHRSTUFE 2
	local spec = self.spec_CVTaddon
	spec.BlinkTimer = -1
	spec.Counter = 0
	if spec.CVTconfig ~= 4 or spec.CVTconfig ~= 5 or spec.CVTconfig ~= 6 or spec.CVTconfig ~= 8 or spec.CVTconfig ~= 9 or spec.CVTconfig ~= 7 then
		if g_client ~= nil then
			if cvtaDebugCVTon then
				print("VarioOne Taste gedrückt vOne: ".. tostring(spec.vOne))
			end
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV1 or not CVTaddon.eventActiveV2 then
				return
			end

			if self:getIsEntered() and self:getIsMotorStarted() then
				if spec.cvtDL >= 2 then
					spec.vOne = 2
				end
				
				if spec.vOne < spec.cvtDL then
					if self:getLastSpeed() <=10 then
						if self:getLastSpeed() > 1 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 then
							spec.CVTdamage = math.min(spec.CVTdamage + math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- if self.spec_RealisticDamageSystem == nil then
								-- self:addDamageAmount(math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- end
							spec.forDBL_critdamage = 1
							spec.forDBL_warndamage = 0
							if cvtaDebugCVTxOn then
								print("Damage: ".. (math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))  ) -- debug
							end
						end
						CVTaddon.eventActiveV1 = true
						CVTaddon.eventActiveV2 = true
						if cvtaDebugCVTon then
							print("VarioTwo vOne<: "..tostring(spec.vOne))
							print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
							print("VarioTwo : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						end
					end
					self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94)
					self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL* spec.vOne, 3.21), 6.36)
				elseif spec.vOne == spec.cvtDL then
					self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin
					self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin
					spec.autoDiffs = 0
					if self.spec_vca ~= nil then
						self:vcaSetState("diffLockFront", false)
						self:vcaSetState("diffLockBack", false)
					end
					CVTaddon.eventActiveV1 = true
					CVTaddon.eventActiveV2 = true
					if cvtaDebugCVTon then
						print("VarioTwo vOne>: "..tostring(spec.vOne))
						print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
						-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
						print("VarioTwo MAX : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
					end
				end
			end
			
			if cvtaDebugCVTon then
				print("VarioOne Taste losgelassen vOne: ".. tostring(spec.vOne))
			end
			
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end -- g_client
	end
	-- DBL convert
	spec.forDBL_drivinglevel = tostring(2)
	spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
	spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
end -- VarioTwo

function CVTaddon:Vario3() -- FAHRSTUFE 3
	local spec = self.spec_CVTaddon
	spec.BlinkTimer = -1
	spec.Counter = 0
	if spec.CVTconfig ~= 4 or spec.CVTconfig ~= 5 or spec.CVTconfig ~= 6 or spec.CVTconfig ~= 8 or spec.CVTconfig ~= 9 or spec.CVTconfig ~= 10 or spec.CVTconfig ~= 11 or spec.CVTconfig ~= 7 then
		if g_client ~= nil then
			if cvtaDebugCVTon then
				print("VarioOne Taste gedrückt vOne: ".. tostring(spec.vOne))
			end
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV1 or not CVTaddon.eventActiveV2 then
				return
			end

			if self:getIsEntered() and self:getIsMotorStarted() then
				if spec.cvtDL >= 3 then
					spec.vOne = 3
				end
				
				if spec.vOne < spec.cvtDL then
					if self:getLastSpeed() <=10 then
						if self:getLastSpeed() > 1 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 then
							spec.CVTdamage = math.min(spec.CVTdamage + math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- if self.spec_RealisticDamageSystem == nil then
								-- self:addDamageAmount(math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- end
							spec.forDBL_critdamage = 1
							spec.forDBL_warndamage = 0
							if cvtaDebugCVTxOn then
								print("Damage: ".. (math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))  ) -- debug
							end
						end
						CVTaddon.eventActiveV1 = true
						CVTaddon.eventActiveV2 = true
						if cvtaDebugCVTon then
							print("VarioTwo vOne<: "..tostring(spec.vOne))
							print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
							print("VarioTwo : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						end
					end
					self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94)
					self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL* spec.vOne, 3.21), 6.36)
				elseif spec.vOne == spec.cvtDL then
					self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin
					self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin
					spec.autoDiffs = 0
					if self.spec_vca ~= nil then
						self:vcaSetState("diffLockFront", false)
						self:vcaSetState("diffLockBack", false)
					end
					CVTaddon.eventActiveV1 = true
					CVTaddon.eventActiveV2 = true
					if cvtaDebugCVTon then
						print("VarioTwo vOne>: "..tostring(spec.vOne))
						print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
						-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
						print("VarioTwo MAX : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
					end
				end
			end
			
			if cvtaDebugCVTon then
				print("VarioOne Taste losgelassen vOne: ".. tostring(spec.vOne))
			end
			
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end -- g_client
	end
	-- DBL convert
	spec.forDBL_drivinglevel = tostring(3)
	spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
	spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
end -- Vario3

function CVTaddon:Vario4() -- FAHRSTUFE 4
	local spec = self.spec_CVTaddon
	spec.BlinkTimer = -1
	spec.Counter = 0
	if spec.CVTconfig ~= 4 or spec.CVTconfig ~= 5 or spec.CVTconfig ~= 6 or spec.CVTconfig ~= 8 or spec.CVTconfig ~= 9 or spec.CVTconfig ~= 10 or spec.CVTconfig ~= 11 or spec.CVTconfig ~= 7 then
		if g_client ~= nil then
			if cvtaDebugCVTon then
				print("VarioOne Taste gedrückt vOne: ".. tostring(spec.vOne))
			end
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV1 or not CVTaddon.eventActiveV2 then
				return
			end

			if self:getIsEntered() and self:getIsMotorStarted() then
				if spec.cvtDL == 4 then
					spec.vOne = 4
				end
				
				if spec.vOne < spec.cvtDL then
					if self:getLastSpeed() <=10 then
						if self:getLastSpeed() > 1 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 then
							spec.CVTdamage = math.min(spec.CVTdamage + math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- if self.spec_RealisticDamageSystem == nil then
								-- self:addDamageAmount(math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- end
							spec.forDBL_critdamage = 1
							spec.forDBL_warndamage = 0
							if cvtaDebugCVTxOn then
								print("Damage: ".. (math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))  ) -- debug
							end
						end
						CVTaddon.eventActiveV1 = true
						CVTaddon.eventActiveV2 = true
						if cvtaDebugCVTon then
							print("VarioTwo vOne<: "..tostring(spec.vOne))
							print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
							print("VarioTwo : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						end
					end
					self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94)
					self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL* spec.vOne, 3.21), 6.36)
				elseif spec.vOne == spec.cvtDL then
					self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin
					self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin
					spec.autoDiffs = 0
					if self.spec_vca ~= nil then
						self:vcaSetState("diffLockFront", false)
						self:vcaSetState("diffLockBack", false)
					end
					CVTaddon.eventActiveV1 = true
					CVTaddon.eventActiveV2 = true
					if cvtaDebugCVTon then
						print("VarioTwo vOne>: "..tostring(spec.vOne))
						print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
						-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
						print("VarioTwo MAX : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
					end
				end
			end
			
			if cvtaDebugCVTon then
				print("VarioOne Taste losgelassen vOne: ".. tostring(spec.vOne))
			end
			
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end -- g_client
	end
	-- DBL convert
	spec.forDBL_drivinglevel = tostring(4)
	spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
	spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
end -- Vario4

function CVTaddon:VarioToggle() -- FAHRSTUFEN WECHSELN
	-- changeFlag = true -- tryout
	local spec = self.spec_CVTaddon
	spec.BlinkTimer = -1
	spec.Counter = 0
	if spec.CVTconfig ~= 4 or spec.CVTconfig ~= 5 or spec.CVTconfig ~= 6 or spec.CVTconfig ~= 8 or spec.CVTconfig ~= 9 or spec.CVTconfig ~= 7 then
		if g_client ~= nil then
			if cvtaDebugCVTon then
				print("VarioOne Taste gedrückt vOne: ".. tostring(spec.vOne))
				-- print("Entered: " .. tostring(self:getIsEntered()))
				-- print("Started: " .. tostring(self:getIsMotorStarted()))
				-- print("VarioOne : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
			end
			if self.CVTaddon == nil then
				return
			end
			if not CVTaddon.eventActiveV1 or not CVTaddon.eventActiveV2 then
				return
			end

			if self:getIsEntered() and self:getIsMotorStarted() then
			
				if spec.vOne < spec.cvtDL then
					spec.vOne = spec.vOne + 1
					-- CVTaddon.eventActiveV3d = true
				else
					spec.vOne = 1
					-- CVTaddon.eventActiveV3d = false
				end
				
				if spec.vOne < spec.cvtDL then
					if self:getLastSpeed() <=10 then
						if self:getLastSpeed() > 1 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 then
							spec.CVTdamage = math.min(spec.CVTdamage + math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- if self.spec_RealisticDamageSystem == nil then
								-- self:addDamageAmount(math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))
							-- end
							spec.forDBL_critdamage = 1
							spec.forDBL_warndamage = 0
							if cvtaDebugCVTxOn then
								print("Damage: ".. (math.min(0.00008*(self:getOperatingTime()/1000000)+(self.spec_motorized.motor.lastMotorRpm/10000)+(self:getLastSpeed()/100), 1))  ) -- debug
							end
						end
						-- spec.vOne = 2
						-- local SpeedScale = spec.moveRpmL
						CVTaddon.eventActiveV1 = true
						CVTaddon.eventActiveV2 = true
						if cvtaDebugCVTon then
							print("VarioTwo vOne<: "..tostring(spec.vOne))
							print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
							-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
							print("VarioTwo : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
							-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
						end
					end
					self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94)
					self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL* spec.vOne, 3.21), 6.36)
				elseif spec.vOne == spec.cvtDL then
					
					-- spec.vOne = 1
					-- local SpeedScale = spec.moveRpmL
					self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin
					self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin
					
					spec.autoDiffs = 0
					if self.spec_vca ~= nil then
						self:vcaSetState("diffLockFront", false)
						self:vcaSetState("diffLockBack", false)
					end

					CVTaddon.eventActiveV1 = true
					CVTaddon.eventActiveV2 = true
					if cvtaDebugCVTon then
						print("VarioTwo vOne>: "..tostring(spec.vOne))
						print("VarioTwo cvtDL: "..tostring(spec.cvtDL))
						-- print("VarioTwo : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
						print("VarioTwo MAX : FwS / BwS:"..self.spec_motorized.motor.maxForwardSpeed.." / "..self.spec_motorized.motor.maxBackwardSpeed)
						-- print("VarioTwo : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
					end
				end
			end
			
			if cvtaDebugCVTon then
				print("VarioOne Taste losgelassen vOne: ".. tostring(spec.vOne))
				-- print("VarioOne : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
			end
			
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end -- g_client
	end
	-- DBL convert
	-- if spec.vOne == 1 then
		-- spec.forDBL_drivinglevel = tostring(2)
	-- elseif spec.vOne == 2 then
		-- spec.forDBL_drivinglevel = tostring(1)
	-- end
	spec.forDBL_drivinglevel = tostring(spec.vOne)
	spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
	spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
end -- VarioToggle

function CVTaddon:VarioADiffs() -- autoDiffs
	local spec = self.spec_CVTaddon
	if g_client ~= nil then
		
		-- local isEntered = self.getIsEntered ~= nil and self:getIsEntered()
		
		if cvtaDebugCVTon then
			-- print("VarioN Taste gedrückt CVTCanStart: "..spec.CVTCanStart)
			-- print("VarioN : FwS/BwS/lBFS/cBF:"..self.spec_motorized.motor.maxForwardSpeed.."/"..self.spec_motorized.motor.maxBackwardSpeed.."/"..self.spec_motorized.motor.lowBrakeForceScale.."/"..spec.calcBrakeForce)
			-- print("VarioN : BMFwSpd/BMBwSpd:"..tostring(spec.BackupMaxFwSpd).."/"..tostring(spec.BackupMaxBwSpd))
		end
		if self:getIsEntered() and self:getIsMotorStarted() then
			if (spec.autoDiffs == 0) then
				CVTaddon.eventActiveV9 = true
				if cvtaDebugCVTxOn then
					print("Auto Diffs aktiv") -- debug
				end
			end
			if (spec.autoDiffs == 1) then
				CVTaddon.eventActiveV9 = true
				if cvtaDebugCVTxOn then
					print("Auto Diffs inaktiv") -- debug
				end
			end
			if spec.autoDiffs == 1 and spec.CVTconfig ~= 8 then
				spec.autoDiffs = 0
				if self.spec_vca ~= nil then
					self:vcaSetState("diffLockFront", false)
					self:vcaSetState("diffLockBack", false)
				elseif FS25_EnhancedVehicle ~= nil and FS25_EnhancedVehicle.FS25_EnhancedVehicle ~= nil and FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall ~= nil then
					if self.vData.is[1] and self.vData.is[2] then
						FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
						FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
					end
				end
			else
				spec.autoDiffs = 1
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end
	end
end -- Automatic Diffs

function CVTaddon:VarioPedalRes() -- Pedal Resolution TMS like
	local spec = self.spec_CVTaddon
	if g_client ~= nil and spec.CVTconfig ~= 8 then
		-- local spec = self.spec_CVTaddon
		-- local isEntered = self.getIsEntered ~= nil and self:getIsEntered()
		
		if cvtaDebugCVTon then
			print("VarioN Taste gedrückt isTMSpedal: "..spec.isTMSpedal)
		end
		if self:getIsEntered() and self:getIsMotorStarted() then
			if (spec.isTMSpedal == 0) then
				if cvtaDebugCVTxOn then
					print("Erster cD")
				end
				
				CVTaddon.eventActiveV8 = true
				if cvtaDebugCVTxOn then
					print("TMS Pedal AN") -- debug
				end
			end
			if (spec.isTMSpedal == 1) then
				CVTaddon.eventActiveV8 = true
				if cvtaDebugCVTxOn then
					print("TMS Pedal AUS") -- debug
				end
			end
			if spec.isTMSpedal == 1 then
				spec.isTMSpedal = 0
			else
				spec.isTMSpedal = 1
			end
			self:raiseDirtyFlags(spec.dirtyFlag)
			if g_server ~= nil then
				g_server:broadcastEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists), nil, nil, self)
			else
				g_client:getServerConnection():sendEvent(SyncClientServerEvent.new(self, spec.vOne, spec.vTwo, spec.vThree, spec.CVTCanStart, spec.vFive, spec.autoDiffs, spec.isVarioTM, spec.isTMSpedal, spec.CVTconfig, spec.forDBL_warnheat, spec.forDBL_critheat, spec.forDBL_warndamage, spec.forDBL_critdamage, spec.CVTdamage, spec.HandgasPercent, spec.ClutchInputValue, spec.cvtDL, spec.cvtAR, spec.VCAantiSlip, spec.VCApullInTurn, spec.CVTcfgExists))
			end
		end
	end
	-- DBL convert
	if spec.isTMSpedal == 0 then
		spec.forDBL_tmspedal = 0
	elseif spec.isTMSpedal == 1 then
		spec.forDBL_tmspedal = 1
	end
end

-- function CVTaddon:wait(seconds)
  -- local start2wait = os.time()
  -- -- repeat until os.time() > start2wait + seconds
  -- if os.time() > start2wait + seconds then return true else return false end
-- end

function CVTaddon:onLeaveVehicle()
	local spec = self.spec_CVTaddon
	-- print("DEBUG: onLeaveVehicle aufgerufen")
	if spec.CVTconfig ~= 8 then
		if self.spec_vca ~= nil then
			if spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 or spec.CVTconfig == 7 then
				if FS25_AutoDrive ~= nil and FS25_AutoDrive.AutoDrive ~= nil then
					if (self.ad.stateModule:isActive() ~= nil ) then
						if (self.ad.stateModule:isActive() == true ) then
							self.spec_vca.handbrake = false
						else
							self.spec_vca.handbrake = true
						end
					end
				else
					self.spec_vca.handbrake = true
				end
				
				if self.spec_cpAIWorker ~= nil then
					if (self.rootVehicle:getIsCpActive() ~= nil ) then
						if (self.rootVehicle:getIsCpActive() == true ) then
							self.spec_vca.handbrake = false
						else
							self.spec_vca.handbrake = true
						end
					end
				else
					self.spec_vca.handbrake = true
				end
			end
		end
    -- Warnblinker starten
    -- spec.warningBlinkerActive = true
    -- spec.warningBlinkerTimer = 0
    -- spec.warningBlinkerBlinkTimer = 0
    -- spec.warningBlinkerBlinkCount = 0
    -- spec.warningBlinkerState = false

    -- Sicherstellen, dass Warnblinker aus sind
    -- CVTaddon.setWarningLightsActive(self, false)
	end
	-- spec.vFive = 0
end

function CVTaddon:getCanMotorRun(superFunc)
	if self.spec_CVTaddon ~= nil then
		local spec = self.spec_CVTaddon
		if spec.CVTcfgExists then
			if spec.isVarioTM == true and spec.CVTconfig ~= 8 then
				if spec.CVTCanStart == true then
				  return superFunc(self)
				else
					return false
				end
				
			elseif spec.isVarioTM == false and spec.CVTconfig == 9 then
				local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
				
				if 	   airTemp <= 6  and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow >= 100 then
					return superFunc(self)
				elseif airTemp <= 2  and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow >= 250 then
					return superFunc(self)
				elseif airTemp <= -1 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow >= 350 then
					return superFunc(self)
				elseif airTemp <= -4 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow >= 480 then
					return superFunc(self)
				elseif airTemp > 6 or self.spec_motorized.motorTemperature.value >= 40 then
					return superFunc(self)
				else
					return false
				end
			end
			if spec.CVTconfig == 8 then
				return superFunc(self)
				-- spec.CVTCanStart == true
			-- else
				-- if spec.CVTCanStart == true then
					-- return superFunc(self)
				-- end
			end
		elseif not spec.CVTcfgExists then
			return superFunc(self)
		end
	end
end

function CVTaddon.ptoRpmRange(self, superFunc)
	local spec = self.spec_CVTaddon
	-- need to build 1000er & 540er & 540e pto
	
	 -- local motorPtoRpm = math.min(PowerConsumer.getMaxPtoRpm(self.vehicle)*self.ptoMotorRpmRatio, self.maxRpm)
	-- if motorPtoRpm ~= 0 then
        -- return motorPtoRpm, self.maxRpm
    -- end
	if spec.isVarioTM then
		return self.minRpm, self.maxRpm
	else
		return superFunc(self)
	end;

end

-- function CVTaddon:cvtGetLastModulatedMotorRpm(self, superFunc) -- clutch is completly disabled for cvt's :(
    -- local modulationIntensity = math.clamp((self.smoothedLoadPercentage) / (MODULATION_RPM_MAX_REF_LOAD - MODULATION_RPM_MIN_REF_LOAD), MODULATION_RPM_MIN_INTENSITY, 1)
    -- local modulationOffset = self.lastModulationPercentage * (MODULATION_RPM_MAX_OFFSET * modulationIntensity) * self.constantRpmCharge

    -- apply only if clutch is released since with slipping clutch the rpm is already decreased
    -- local loadChangeChargeDrop = 0
    -- if self:getClutchPedal() < 0.1 and self.minGearRatio > 0 then
        -- local rpmRange = self.maxRpm - self.minRpm
        -- local dropScale = (self.lastMotorRpm - self.minRpm) / rpmRange * 0.5
        -- loadChangeChargeDrop = self.loadPercentageChangeCharge * rpmRange * dropScale
    -- else
        -- self.loadPercentageChangeCharge = 0
    -- end

    -- return self.lastMotorRpm + modulationOffset - loadChangeChargeDrop
	-- return self.lastMotorRpm
-- end

function cvtGetLastRealMotorRpm(self, superFunc)
	-- return self.lastRealMotorRpm
	return self.lastMotorRpm
end

function CVTaddon:SETPREGLOW()
	local spec = self.spec_CVTaddon
	if (g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 2) or (not g_ignitionLockManager:getIsAvailable() and self:getMotorState() < 3) then
		spec.preGlow = math.min(spec.preGlow + 1, 500)
		spec.forDBL_preglowing = 1
		
		local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
				
		if airTemp <= 6 and self.spec_motorized.motorTemperature.value <= 40 and spec.preGlow > 100 then
			spec.forDBL_glowingstate = 1
		elseif airTemp <= 2 and self.spec_motorized.motorTemperature.value <= 40 and spec.preGlow > 250 then
			spec.forDBL_glowingstate = 1
		elseif airTemp <= -1 and self.spec_motorized.motorTemperature.value <= 40 and spec.preGlow > 350 then
			spec.forDBL_glowingstate = 1
		elseif airTemp <= -4 and self.spec_motorized.motorTemperature.value <= 40 and spec.preGlow > 480 then
			spec.forDBL_glowingstate = 1
		else
			spec.forDBL_glowingstate = 0
		end
		-- print("spec.preGlow: " .. tostring(spec.preGlow))
	elseif self:getMotorState() == 1 then
		spec.forDBL_glowingstate = 0
	end
	return true
end

-- function CVTaddon:setWarningLightsActive(active)
--     local specLights = self.spec_lights
--     local bitWarningLight = 2 ^ 1 -- Beispiel-Bit für Warnblinker

--     if specLights == nil then
--         print("WARNUNG: spec_lights ist nil!")
--         return
--     end

--     local mask = specLights.lightsTypesMask or 0

--     if active then
--         if (bitAND(mask, bitWarningLight) == 0) then
--             self:setLightsTypesMask(bitOR(mask, bitWarningLight))
--             print("Warnblinklicht AN")
--         end
--     else
--         if (bitAND(mask, bitWarningLight) ~= 0) then
--             self:setLightsTypesMask(bitAND(mask, bitNOT(bitWarningLight)))
--             print("Warnblinklicht AUS")
--         end
--     end
-- end

function CVTaddon.setReverseWorkLight(self, active)
    local bitReverseWorkLight = 2 ^ 1 -- Beispielbit für Rückwärts-Arbeitslicht
    local mask = self.spec_lights.lightsTypesMask or 0

    if active then
        -- print("Rückwärts-Arbeitslicht AN")
		spec.forDBL_autoreverselight = 1
        if (bitAND(mask, bitReverseWorkLight) == 0) then
            self:setLightsTypesMask(bitOR(mask, bitReverseWorkLight))
		end
    else
        -- print("Rückwärts-Arbeitslicht AUS")
		spec.forDBL_autoreverselight = 0
        if (bitAND(mask, bitReverseWorkLight) ~= 0) then
            self:setLightsTypesMask(bitAND(mask, bitNOT(bitReverseWorkLight)))
        end
    end
end

function CVTaddon:onUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected, vehicle)
	-- print("################################# onUpdateTick")
	local spec = self.spec_CVTaddon
	local specMF = self.spec_motorized
	local storeItem = g_storeManager:getItemByXMLFilename(self.configFileName)
	local StI = storeItem.categoryName
	local isTractorS = StI == "TRACTORSS"
	local isTractorM = StI == "TRACTORSM"
	local isTractorL = StI == StI == "TRACTORSL"
	local isTractor = StI == "TRACTORSS" or StI == "TRACTORSM" or StI == "TRACTORSL"
	local isErnter = storeItem.categoryName == "HARVESTERS" or StI == "FORAGEHARVESTERS" or StI == "POTATOVEHICLES" or StI == "BEETVEHICLES" or StI == "SUGARCANEVEHICLES" or StI == "COTTONVEHICLES" or StI == "MISCVEHICLES"
	local isLoader = storeItem.categoryName == "FRONTLOADERVEHICLES" or StI == "TELELOADERVEHICLES" or StI == "SKIDSTEERVEHICLES" or StI == "WHEELLOADERVEHICLES"
	local isPKWLKW = StI == "CARS" or StI == "TRUCKS"
	local isPKW = StI == "CARS"
	local isLKW = StI == "TRUCKS"
	local isWoodWorker = storeItem.categoryName == "WOODHARVESTING"
	local isFFF = storeItem.categoryName == "FORKLIFTS"
	local samples = specMF.samples
	spec.isVarioTM = self.spec_motorized.motor.lastManualShifterActive == false and self.spec_motorized.motor.groupType == 1 and self.spec_motorized.motor.gearType == 1 and self.spec_motorized.motor.forwardGears == nil
	if self.spec_motorized.motorTemperature.valueMin == 20 then
		self.spec_motorized.motorTemperature.valueMin = -10
	end
	-- CODE Rückwärtslich ab hier
	if spec.reverseLightsState == 2 then
	    local mask = self.spec_lights.lightsTypesMask or 0
	    local bitArbeitslichtHinten = 2 -- 2^1
	    -- Prüfen, ob Rückwärtsfahrt aktiv ist
	    local isReverse = self.spec_motorized.motor.currentDirection < 0 and self:getLastSpeed() > 0.5
	    if isReverse then
	        -- Arbeitslicht hinten an und Timer zurücksetzen
	        if not spec.reverseWorkLightActive then
	            spec.reverseWorkLightActive = true
	            spec.reverseWorkLightDelayTimer = 0
	            -- print("Rückwärtsarbeitslicht AN")
	        end

	        -- Arbeitslicht in Maske setzen, falls noch nicht gesetzt
	        if bitAND(mask, bitArbeitslichtHinten) == 0 then
	            self:setLightsTypesMask(bitOR(mask, bitArbeitslichtHinten))
	        end
			spec.forDBL_autoreverselight = 1
	    else
	        -- Wenn Arbeitslicht gerade an war, starten wir Nachleuchten
	        if spec.reverseWorkLightActive then
	            if spec.reverseWorkLightDelayTimer == nil then
	                spec.reverseWorkLightDelayTimer = 0
	            end
	            spec.reverseWorkLightDelayTimer = spec.reverseWorkLightDelayTimer + dt
	            local nachleuchtDauer = (spec.reverseLightsDurationState * 1000) -- ms
	            if spec.reverseWorkLightDelayTimer >= nachleuchtDauer then
	                -- Nachleuchten vorbei, Licht ausschalten
	                spec.reverseWorkLightActive = false
	                spec.reverseWorkLightDelayTimer = 0

	                if bitAND(mask, bitArbeitslichtHinten) ~= 0 then
	                    self:setLightsTypesMask(bitAND(mask, bitNOT(bitArbeitslichtHinten)))
	                end
					spec.forDBL_autoreverselight = 0
	                -- print("Rückwärtsarbeitslicht AUS nach Nachleuchten")
	            else
	                -- Nachleuchten: Licht bleibt an, nix tun
	            end
	        end
		end
    end

	-- blinker closed
	-- if spec.warningBlinkerActive then
    --     spec.warningBlinkerTimer = spec.warningBlinkerTimer + dt
    --     spec.warningBlinkerBlinkTimer = spec.warningBlinkerBlinkTimer + dt

    --     if spec.warningBlinkerBlinkTimer >= spec.warningBlinkerBlinkInterval then
    --         -- Toggle Licht AN/AUS
    --         spec.warningBlinkerState = not spec.warningBlinkerState
    --         self:setWarningLightsActive(spec.warningBlinkerState)
            
    --         spec.warningBlinkerBlinkTimer = 0

    --         if spec.warningBlinkerState then
    --             spec.warningBlinkerBlinkCount = spec.warningBlinkerBlinkCount + 1
    --         end
    --     end

    --     -- Nach 2 Sekunden (oder gewünschter Dauer) Warnblinker ausmachen
    --     if spec.warningBlinkerTimer >= spec.warningBlinkerDuration then
    --         spec.warningBlinkerActive = false
    --         self:setWarningLightsActive(false)
    --     end
    -- end

	spec.forDBL_preglowing = 0
	-- end
	
	if cvtaDebugCVTtransmission then -- Getriebe Debug lesen
		-- print("cvt: lastManualShifterActive : " .. tostring(self.spec_motorized.motor.lastManualShifterActive))
		-- print("cvt: groupType : " .. tostring(self.spec_motorized.motor.groupType))
		-- print("cvt: gearType : " .. tostring(self.spec_motorized.motor.gearType))
		-- print("cvt: forwardGears : " .. tostring(self.spec_motorized.motor.forwardGears))
		-- print("cvt: isVarioTM : " .. tostring(spec.isVarioTM))
		print("cvt: motorStartDuration : " .. tostring(self.spec_motorized.motorStartDuration))
	end
	
	if debug_for_VC then
		print("cvt CAT: " .. tostring(StI))
		print("dt: " .. tostring(dt))
	end
	
	
	
	if cvtaDebugCVTuOn == true then
		print("CVTa Config spec: " .. tostring(spec.CVTconfig))
		print("CVTa ############ isVarioTM: " .. tostring(spec.isVarioTM))
	end
	-- print("CVTa DayTemp: " .. tostring(currentDayTemp))
	
	local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
	-- if spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 and spec.CVTcfgActive ~= 1 then
	if spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 and spec.CVTcfgExists then
		-- if not self.spec_RealisticDamageSystem.EngineDied then

		
		-- -- Secure starting engine
		if self.getIsEntered ~= nil and self:getIsEntered() and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 then
			if cvtaDebugCVTcanStartOn then print("CVTa CanStart: " .. tostring(spec.CVTCanStart)) end
			if self.spec_cpAIWorker ~= nil then -- CP
				if self.rootVehicle:getIsCpActive() == false then
					if not self:getIsMotorStarted() then
						if spec.isVarioTM == true then
							if spec.CVTconfig ~= 7 and spec.CVTcfgExists then
								if spec.CVTconfig ~= 9 and spec.CVTconfig ~= 10 and spec.CVTconfig ~= 11 and spec.CVTconfig ~= 7 then
									if spec.ClutchInputValue < 0.6 or spec.HandgasPercent > 0.05 then
										if spec.ClutchInputValue < 0.6 then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needClutch2start"), 75)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa Clutch/Config [A]: " .. tostring(spec.ClutchInputValue .."/" .. spec.CVTconfig)) end
										end
										
										if spec.HandgasPercent > 0.05 then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
										end
										
									elseif spec.ClutchInputValue >= 0.6 or spec.HandgasPercent <= 0.05 then
										if spec.ClutchInputValue >= 0.6 then
											spec.CVTCanStart = true
											if cvtaDebugCVTcanStartOn then print("CVTa Clutch [B]: " .. tostring(spec.ClutchInputValue)) end
										end
										if spec.HandgasPercent <= 0.05 then
											spec.CVTCanStart = true
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
										else
											spec.CVTCanStart = false
										end
									end
								end

							elseif spec.CVTconfig == 7 then
								-- if self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal == 1 or self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal <= 0.1 then
								if self.spec_vca ~= nil and self.spec_vca.handbrake ~= nil then
									if self.spec_vca.handbrake == false or spec.HandgasPercent > 0.05 then
										if self.spec_vca.handbrake == false then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needBrake2start"), 3072)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa HB [C]: " .. tostring(self.spec_vca.handbrake)) end
										end
										if spec.HandgasPercent > 0.05 then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
										end
										
									elseif self.spec_vca.handbrake == true or spec.HandgasPercent <= 0.05 then
										if self.spec_vca.handbrake == true then
											spec.CVTCanStart = true
										end
										if cvtaDebugCVTcanStartOn then print("CVTa HB [D]: " .. tostring(self.spec_vca.handbrake)) end
										
										if spec.HandgasPercent <= 0.05 then
											spec.CVTCanStart = true
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
										else
											spec.CVTCanStart = false
										end
									end
								else
									spec.CVTCanStart = true
								end
							end
						end
						
						if ( spec.CVTconfig ~= 4 and spec.CVTconfig ~= 5 and spec.CVTconfig ~= 6 ) then
							-- cold need to preGlow     250 (1-(°C:40))
							-- local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
							
							if spec.CVTCanStart == true and airTemp <= 6 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 100 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= 2 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 250 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= -1 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 350 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= -4 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 480 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and (airTemp > 6 or self.spec_motorized.motorTemperature.value >= 40 ) then
								spec.CVTCanStart = true
							end
							
							
							-- if spec.CVTCanStart == true and spec.preGlow < 250 then
								-- spec.CVTCanStart = false
							-- elseif spec.CVTCanStart == true and spec.preGlow >= 250 then
								-- spec.CVTCanStart = true
							-- end
						end
					end
					if ((g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 1) or (not g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 4)) and spec.preGlow ~= 0 then
						spec.preGlow = 0
						spec.forDBL_glowingstate = 0
					end
				elseif self.rootVehicle:getIsCpActive() == true then
					-- print("CVTa: CP aktiv")
					spec.CVTCanStart = true
				end
			elseif not self.spec_cpAIWorker and not FS25_AutoDrive then
				if not self:getIsMotorStarted() then
					if spec.isVarioTM == true then
						if spec.CVTconfig ~= 7 and spec.CVTconfig ~= 8 then
							if spec.ClutchInputValue < 0.6 or spec.HandgasPercent > 0.05 then
							
								if spec.ClutchInputValue < 0.6 then
									spec.CVTCanStart = false
									if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needClutch2start"), 75)
										end
									end
									if cvtaDebugCVTcanStartOn then print("CVTa Clutch/Config [A]: " .. tostring(spec.ClutchInputValue .."/" .. spec.CVTconfig)) end
								end
								
								if spec.HandgasPercent > 0.05 then
									spec.CVTCanStart = false
									-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
									if g_client ~= nil and isActiveForInputIgnoreSelection == false then
										if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
										end
									end
									if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
								end
								
							elseif spec.ClutchInputValue >= 0.6 or spec.HandgasPercent <= 0.05 then
								if spec.ClutchInputValue >= 0.6 then
									spec.CVTCanStart = true
									if cvtaDebugCVTcanStartOn then print("CVTa Clutch [B]: " .. tostring(spec.ClutchInputValue)) end
								end
								if spec.HandgasPercent <= 0.05 then
									spec.CVTCanStart = true
									if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
								else
									spec.CVTCanStart = false
								end
							end
						elseif spec.CVTconfig == 7 then
							-- if self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal == 1 or self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal <= 0.1 then
							if self.spec_vca ~= nil and self.spec_vca.handbrake ~= nil then
								if self.spec_vca.handbrake == false or spec.HandgasPercent > 0.05 then
									if self.spec_vca.handbrake == false then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needBrake2start"), 3072)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa HB [C]: " .. tostring(self.spec_vca.handbrake)) end
									end
									if spec.HandgasPercent > 0.05 then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
									end
									
								elseif self.spec_vca.handbrake == true or spec.HandgasPercent <= 0.05 then
									if self.spec_vca.handbrake == true then
										spec.CVTCanStart = true
									end
									if cvtaDebugCVTcanStartOn then print("CVTa HB [D]: " .. tostring(self.spec_vca.handbrake)) end
									
									if spec.HandgasPercent <= 0.05 then
										spec.CVTCanStart = true
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
									else
										spec.CVTCanStart = false
									end
								end
							else
								spec.CVTCanStart = true
							end
						end
					end
					if ( spec.CVTconfig ~= 4 and spec.CVTconfig ~= 5 and spec.CVTconfig ~= 6 ) then
						-- cold need to preGlow     250 (1-(°C:40))
						-- local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
				
						if spec.CVTCanStart == true and airTemp <= 6 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 100 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= 2 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 250 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= -1 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 350 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= -4 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 480 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and (airTemp > 6 or self.spec_motorized.motorTemperature.value >= 40 ) then
							spec.CVTCanStart = true
						end
					end
				end
				if ((g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 1) or (not g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 4)) and spec.preGlow ~= 0 then
					spec.preGlow = 0
					spec.forDBL_glowingstate = 0
				end
			end -- cp
				
			if FS25_AutoDrive ~= nil and FS25_AutoDrive.AutoDrive ~= nil then -- AD
				if self.ad.stateModule:isActive() == false and not self.spec_cpAIWorker then
					if not self:getIsMotorStarted() then
						if spec.isVarioTM == true then
							if spec.CVTconfig ~= 7 and spec.CVTconfig ~= 8 then
								if spec.ClutchInputValue < 0.6 or spec.HandgasPercent > 0.05 then
								
									if spec.ClutchInputValue < 0.6 then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needClutch2start"), 75)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa Clutch/Config [A]: " .. tostring(spec.ClutchInputValue .."/" .. spec.CVTconfig)) end
									end
									
									if spec.HandgasPercent > 0.05 then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
									end
									
								elseif spec.ClutchInputValue >= 0.6 or spec.HandgasPercent <= 0.05 then
									if spec.ClutchInputValue >= 0.6 then
										spec.CVTCanStart = true
										if cvtaDebugCVTcanStartOn then print("CVTa Clutch [B]: " .. tostring(spec.ClutchInputValue)) end
									end
									if spec.HandgasPercent <= 0.05 then
										spec.CVTCanStart = true
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
									else
										spec.CVTCanStart = false
									end
								end
							elseif spec.CVTconfig == 7 then -- hydrostate / hst
								-- if self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal == 1 or self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal <= 0.1 then
								if self.spec_vca ~= nil and self.spec_vca.handbrake ~= nil then
									if self.spec_vca.handbrake == false or spec.HandgasPercent > 0.05 then
										if self.spec_vca.handbrake == false then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needBrake2start"), 3072)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa HB [C]: " .. tostring(self.spec_vca.handbrake)) end
										end
										if spec.HandgasPercent > 0.05 then
											spec.CVTCanStart = false
											-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
											if g_client ~= nil and isActiveForInputIgnoreSelection == false then
												if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
													g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
												end
											end
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
										end
										
									elseif self.spec_vca.handbrake == true or spec.HandgasPercent <= 0.05 then
										if self.spec_vca.handbrake == true then
											spec.CVTCanStart = true
										end
										if cvtaDebugCVTcanStartOn then print("CVTa HB [D]: " .. tostring(self.spec_vca.handbrake)) end
										
										if spec.HandgasPercent <= 0.05 then
											spec.CVTCanStart = true
											if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
										else
											spec.CVTCanStart = false
										end
									end
								else
									spec.CVTCanStart = true
								end
							end
						end
						if ( spec.CVTconfig ~= 4 and spec.CVTconfig ~= 5 and spec.CVTconfig ~= 6 ) then
							-- cold need to preGlow     250 (1-(°C:40))
							-- local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
				
							if spec.CVTCanStart == true and airTemp <= 6 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 100 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= 2 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 250 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= -1 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 350 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and airTemp <= -4 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 480 then
								if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
								spec.CVTCanStart = false
							elseif spec.CVTCanStart == true and (airTemp > 6 or self.spec_motorized.motorTemperature.value >= 40 ) then
								spec.CVTCanStart = true
							end
						end
					end
					if ((g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 1) or (not g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 4)) and spec.preGlow ~= 0 then
						spec.preGlow = 0
						spec.forDBL_glowingstate = 0
					end
				elseif self.ad.stateModule:isActive() == true then
					-- print("CVTa: AD active")
					spec.CVTCanStart = true
				end
			elseif not self.spec_cpAIWorker then -- ad
				if not self:getIsMotorStarted() then
					if spec.isVarioTM == true then
						if spec.CVTconfig ~= 7 and spec.CVTconfig ~= 8 then
							if spec.ClutchInputValue < 0.6 or spec.HandgasPercent > 0.05 then
								if spec.ClutchInputValue < 0.6 then
									spec.CVTCanStart = false
									-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
									if g_client ~= nil and isActiveForInputIgnoreSelection == false then
										if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needClutch2start"), 75)
										end
									end
									if cvtaDebugCVTcanStartOn then print("CVTa Clutch/Config [A]: " .. tostring(spec.ClutchInputValue .."/" .. spec.CVTconfig)) end
								end
								
								if spec.HandgasPercent > 0.05 then
									spec.CVTCanStart = false
									-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
									if g_client ~= nil and isActiveForInputIgnoreSelection == false then
										if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
										end
									end
									if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
								end
								
							elseif spec.ClutchInputValue >= 0.6 or spec.HandgasPercent <= 0.05 then
								if spec.ClutchInputValue >= 0.6 then
									spec.CVTCanStart = true
									if cvtaDebugCVTcanStartOn then print("CVTa Clutch [B]: " .. tostring(spec.ClutchInputValue)) end
								end
								if spec.HandgasPercent <= 0.05 then
									spec.CVTCanStart = true
									if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
								else
									spec.CVTCanStart = false
								end
							end
						elseif spec.CVTconfig == 7 then
							-- if self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal == 1 or self.spec_motorized.motor.vehicle.wheelsUtilSmoothedBrakePedal <= 0.1 then
							if self.spec_vca ~= nil and self.spec_vca.handbrake ~= nil then
								if self.spec_vca.handbrake == false or spec.HandgasPercent > 0.05 then
									if self.spec_vca.handbrake == false then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needBrake2start"), 3072)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa HB [C]: " .. tostring(self.spec_vca.handbrake)) end
									end
									if spec.HandgasPercent > 0.05 then
										spec.CVTCanStart = false
										-- if g_client ~= nil and isActiveForInputIgnoreSelection and self:getCanMotorRun() == false then
										if g_client ~= nil and isActiveForInputIgnoreSelection == false then
											if not self.spec_RealisticDamageSystemEngineDied.EngineDied then
												g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needNoHG2start"), 4096)
											end
										end
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [E]: " .. tostring(spec.HandgasPercent)) end
									end
									
								elseif self.spec_vca.handbrake == true or spec.HandgasPercent <= 0.05 then
									if self.spec_vca.handbrake == true then
										spec.CVTCanStart = true
									end
									if cvtaDebugCVTcanStartOn then print("CVTa HB [D]: " .. tostring(self.spec_vca.handbrake)) end
									
									if spec.HandgasPercent <= 0.05 then
										spec.CVTCanStart = true
										if cvtaDebugCVTcanStartOn then print("CVTa Hgas [F]: " .. tostring(spec.HandgasPercent)) end
									else
										spec.CVTCanStart = false
									end
								end
							else
								spec.CVTCanStart = true
							end
						end
					end
					if ( spec.CVTconfig ~= 4 and spec.CVTconfig ~= 5 and spec.CVTconfig ~= 6 ) then
						-- cold need to preGlow     250 (1-(°C:40))
						-- local airTemp = g_currentMission.environment.weather:getCurrentTemperature()
				
						if spec.CVTCanStart == true and airTemp <= 6 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 100 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= 2 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 250 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= -1 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 350 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and airTemp <= -4 and self.spec_motorized.motorTemperature.value < 40 and spec.preGlow < 480 then
							if spec.preGlow == 0 then 
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_needpreGlow"), 75)
								else
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_preGlow"), 75)
								end
							spec.CVTCanStart = false
						elseif spec.CVTCanStart == true and (airTemp > 6 or self.spec_motorized.motorTemperature.value >= 40 ) then
							spec.CVTCanStart = true
						end
					end
				end
				if ((g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 1) or (not g_ignitionLockManager:getIsAvailable() and self:getMotorState() == 4)) and spec.preGlow ~= 0 then
					spec.preGlow = 0
					spec.forDBL_glowingstate = 0
				end
			end -- secure AD
		end
		-- rebuild hst, hvst can starting
		-- if spec.CVTconfig == 8 or spec.CVTconfig == 0 or spec.CVTconfig == 10 or spec.CVTconfig == 11 or spec.CVTconfig == 9 or spec.CVTcfgExists ~= true then
		if spec.CVTconfig == 8 or spec.CVTconfig == 0 or spec.CVTconfig == 10 or spec.CVTconfig == 11 or spec.CVTcfgExists ~= true then
			spec.CVTCanStart = true
		end
		if spec.CVTcfgExists == false then
			spec.CVTCanStart = true
		end
		-- print(spec.CVTCanStart)
		local changeFlag = false
		local motor = nil

		-- Anbaugeräte ermitteln und prüfen ob abgesenkt Front/Back
		local moveDownFront = false
		local moveDownBack = false
		local object;
		
		if self.spec_attacherJoints ~= nil and self.spec_attacherJoints.attachedImplements[attachedImplement] ~= nil
		 and self.spec_attacherJoints.attachedImplements[attachedImplement].object ~= nil then
		
			if #self.spec_attacherJoints.attachedImplements ~= nil and g_client ~= nil and g_currentMission.controlledVehicle == self then
				for attachedImplement = 1, #self.spec_attacherJoints.attachedImplements do
					if self.spec_attacherJoints.attachedImplements[attachedImplement].object ~= nil then
						object = self.spec_attacherJoints.attachedImplements[attachedImplement].object;
					end
					local object_specAttachable = object.spec_attachable
					if object_specAttachable.attacherVehicle ~= nil then
						local attacherJointVehicleSpec = object_specAttachable.attacherVehicle.spec_attacherJoints;
						local implementIndex = object_specAttachable.attacherVehicle:getImplementIndexByObject(object);
						local implement = attacherJointVehicleSpec.attachedImplements[implementIndex];
						local jointDescIndex = implement.jointDescIndex;
						local jointDesc = attacherJointVehicleSpec.attacherJoints[jointDescIndex];
						
						if jointDesc.bottomArm ~= nil then
							-- if math.abs(jointDesc.bottomArm.zScale) == 1 then
								-- spec.impIsLowered = object:getIsImplementChainLowered();
							-- end
							if jointDesc.bottomArm.zScale == 1 then
								moveDownFront = object:getIsImplementChainLowered();
							elseif jointDesc.bottomArm.zScale == -1 then
								moveDownBack = object:getIsImplementChainLowered();
							end
						end
						if moveDownBack == true or moveDownFront == true then
							spec.impIsLowered = true
						else
							spec.impIsLowered = false
						end
					else
						spec.impIsLowered = false
					end
				end
			else
				spec.impIsLowered = false
			end
			if self:getTotalMass() - self:getTotalMass(true) == 0 then
				spec.impIsLowered = false
			end
		end
		
		-- FRONTLADER HYDRAULIK RPM - make wheelloader hydraulic assign to rpm
		-- if spec.CVTconfig == 7 or isLoader or isWoodWorker or isTractor then
			local i = 0
			local RPMforHydraulics = 1
			if spec.CVTconfig == 10 then
				RPMforHydraulics = math.min( math.max(spec.HandgasPercent, 0.05), 0.8)
			else
				RPMforHydraulics = math.min( math.max((self.spec_motorized.motor:getLastModulatedMotorRpm()/self.spec_motorized.motor:getMaxRpm())*0.7, 0.05), 0.8)
			end
			-- local KGforHydraulics = math.min( math.max((self.spec_motorized.motor:getLastModulatedMotorRpm()/self.spec_motorized.motor:getMaxRpm())*0.7, 0.05), 0.8)
			if self:getTotalMass() - self:getTotalMass(true) > 1.2 then
				RPMforHydraulics = RPMforHydraulics * 0.5
				-- RPMforHydraulics = RPMforHydraulics * (  1-(self:getTotalMass() - self:getTotalMass(true))/self:getTotalMass(true)  )
			end

			if spec.CVTconfig ~= 10 and spec.CVTconfig ~= 8 and spec.CVTcfgExists then
			
				for i=1, #self.spec_cylindered.movingTools do
					local tool = self.spec_cylindered.movingTools[i]
					local isSelectedGroup = tool.controlGroupIndex == 0 or tool.controlGroupIndex == self.spec_cylindered.currentControlGroupIndex
					local easyArmControlActive = false
					if self.spec_cylindered.easyArmControl ~= nil then
						easyArmControlActive = self.spec_cylindered.easyArmControl.state
					end
					local canBeControlled = (easyArmControlActive and tool.easyArmControlActive) or (not easyArmControlActive and not tool.isEasyControlTarget)
					local tool = self.spec_cylindered.movingTools[i]
					local rotSpeed = 0
					local transSpeed = 0
					local animSpeed = 0
					local move = self:getMovingToolMoveValue(tool)

					if math.abs(move) > 0 then
						if move < 0 then
							move = move * 0.8
						end
						
						if move < -0.5 then
							self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm - (math.abs(move)*10)
							self.spec_motorized.motor.smoothedLoadPercentage = math.min(self.spec_motorized.motor.smoothedLoadPercentage + (math.abs(move)), .9)
							if self.spec_motorized.motor.lastMotorRpm < self.spec_motorized.motor.minRpm * 0.89 and self.spec_motorized.motor.smoothedLoadPercentage > 0.8 and self.spec_motorized.motorTemperature.value < 50 then
								move = 0
								RPMforHydraulics = 0
								-- Motor abwürgen
								self:stopMotor();
								-- break;
								move = 0
								self:startMotor(true)
								if self.spec_vca ~= nil and self.spec_vca.handbrake ~= nil then
									self.spec_vca.handbrake = true
									-- self.spec_vca.handbrake = false
								end
								-- self:stopMotor()
								-- tool.rotSpeed = movingBU
							end
						elseif move < 0  and move >= -0.5 then
							self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm - (math.abs(move)*10)
							self.spec_motorized.motor.smoothedLoadPercentage = math.min(self.spec_motorized.motor.smoothedLoadPercentage + (math.abs(move)), .9)
						elseif move > 0 then
							self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm - (math.abs(move)*5)
							self.spec_motorized.motor.smoothedLoadPercentage = math.min(self.spec_motorized.motor.smoothedLoadPercentage + (math.abs(move)), .4)
						end
						
						
						-- print("move: " .. move) -- 0 - 1
						tool.externalMove = 0
						-- spec.moveRpmL = 1

						if tool.rotSpeed ~= nil then
							-- rotSpeed = move*tool.rotSpeed * (MathUtil.clamp(RPMforHydraulics, 0.01, 0.7))
							rotSpeed = move*tool.rotSpeed * RPMforHydraulics
							-- rotSpeed = move*tool.rotSpeed * (math.max(spec.HandgasPercent, 0.1))
							if tool.rotAcceleration ~= nil and math.abs(rotSpeed - tool.lastRotSpeed) >= tool.rotAcceleration*dt then
								if rotSpeed > tool.lastRotSpeed then
									rotSpeed = (tool.lastRotSpeed*0.8 ) + tool.rotAcceleration*dt
								else
									rotSpeed = (tool.lastRotSpeed ) - tool.rotAcceleration*dt
								end
							end
						end
						if tool.transSpeed ~= nil then
							-- transSpeed = move*tool.transSpeed * (MathUtil.clamp(RPMforHydraulics, 0.01, 0.7))
							transSpeed = move*tool.transSpeed * RPMforHydraulics
							if tool.transAcceleration ~= nil and math.abs(transSpeed - tool.lastTransSpeed) >= tool.transAcceleration*dt then
								if transSpeed > tool.lastTransSpeed then
									transSpeed = (tool.lastTransSpeed*0.8 ) + tool.transAcceleration*dt
								else
									transSpeed = (tool.lastTransSpeed ) - tool.transAcceleration*dt
								end
							end
						end
						if tool.animSpeed ~= nil then
							-- animSpeed = move*tool.animSpeed * (MathUtil.clamp(RPMforHydraulics, 0.01, 0.7))
							animSpeed = move*tool.animSpeed * RPMforHydraulics
							if tool.animAcceleration ~= nil and math.abs(animSpeed - tool.lastAnimSpeed) >= tool.animAcceleration*dt then
								if animSpeed > tool.lastAnimSpeed then
									animSpeed = (tool.lastAnimSpeed*0.8 ) + tool.animAcceleration*dt
								else
									animSpeed = (tool.lastAnimSpeed) - tool.animAcceleration*dt
								end
							end
						end
						-- set rpm here
						
						-- spec.moveRpmL = 1
					else
						if tool.rotAcceleration ~= nil then
							if tool.lastRotSpeed < 0 then
								rotSpeed = math.min(tool.lastRotSpeed + tool.rotAcceleration*dt, 0)
							else
								rotSpeed = math.max(tool.lastRotSpeed - tool.rotAcceleration*dt, 0)
							end
						end
						if tool.transAcceleration ~= nil then
							if tool.lastTransSpeed < 0 then
								transSpeed = math.min(tool.lastTransSpeed + tool.transAcceleration*dt, 0)
							else
								transSpeed = math.max(tool.lastTransSpeed - tool.transAcceleration*dt, 0)
							end
						end
						if tool.animAcceleration ~= nil then
							if tool.lastAnimSpeed < 0 then
								animSpeed = math.min(tool.lastAnimSpeed + tool.animAcceleration*dt, 0)
							else
								animSpeed = math.max(tool.lastAnimSpeed - tool.animAcceleration*dt, 0)
							end
						end
					end
					
					
					
					local changed = false
					if rotSpeed ~= nil and rotSpeed ~= 0 then
						changed = changed or Cylindered.setToolRotation(self, tool, rotSpeed, dt)
					else
						tool.lastRotSpeed = 0
					end
					if transSpeed ~= nil and transSpeed ~= 0 then
						changed = changed or Cylindered.setToolTranslation(self, tool, transSpeed, dt)
					else
						tool.lastTransSpeed = 0
					end
					if animSpeed ~= nil and animSpeed ~= 0 then
						changed = changed or Cylindered.setToolAnimation(self, tool, animSpeed, dt)
					else
						tool.lastAnimSpeed = 0
					end
					for _, dependentTool in pairs(tool.dependentMovingTools) do
						if dependentTool.speedScale ~= nil then
							local isAllowed = true
							if dependentTool.requiresMovement then
								if not changed then
									isAllowed = false
								end
							end

							if isAllowed then
								dependentTool.movingTool.externalMove = dependentTool.speedScale * tool.move
							end
						end
						Cylindered.updateRotationBasedLimits(self, tool, dependentTool)
						self:updateDependentToolLimits(tool, dependentTool)
					end
				end
			end
		-- end -- FRONTLADER HYDRAULIK RPM END
		
		
		
		-- BEGIN OF THE MAIN SCRIPT	

			-- ODB motorTemp an Umgebungstemp. anpassen
			if spec.CVTconfig ~= 9 and spec.CVTconfig ~= nil then
				if self.spec_motorized.motorTemperature.value < (math.floor(tonumber(g_currentMission.environment.weather:getCurrentTemperature()) * 100)/100)-2 then
					self.spec_motorized.motorTemperature.value = (math.floor(tonumber(g_currentMission.environment.weather:getCurrentTemperature()) * 100)/100)
				end
			end

			if spec.isVarioTM then
				if self.CVTaddon == nil then
					self.CVTaddon = true
					if self.spec_motorized ~= nil then
						if self.spec_motorized.motor ~= nil then
							-- print("CVT_Addon: Motorized eingestiegen")
						end;
					end;
				end;
				
				if self.spec_vca ~= nil and self.spec_motorized.motor.lowBrakeForceScale ~= nil then
					-- if self.spec_vca.brakeForce ~= 1 or self.spec_vca.idleThrottle == true then
						-- Check for wrong vca settings to use CVT addon
						-- self.spec_vca.brakeForce = 1
						-- self.spec_vca.idleThrottle = false
						-- g_currentMission:showBlinkingWarning(g_i18n:getText("txt_vcaInfo"), 1024)
						-- if vcaInfoUnread and g_currentMission.isMissionStarted and self:getIsEntered() then
						-- 	g_gui:showInfoDialog({
						-- 	titel = "titel",
						-- 	text = g_i18n:getText("txt_vcaInfo", "vcaInfo"),
						-- 	})
						-- 	vcaInfoUnread = false
						-- end
					-- end

				-- AUTO-DIFFS: enable & disable VCA AWD and difflocks automaticly by speed and steering angle
					-- Vehicle Control Addon
					if spec.autoDiffs == 1 and self.spec_vca ~= nil then
						self:vcaSetState("diffManual", true)
					end
					if spec.cvtDL == nil then
						spec.cvtDL = 2;
					end
					if spec.vOne < spec.cvtDL and spec.autoDiffs == 1 then
						-- classic
						if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 7 or spec.CVTconfig == 11 then
							if self.spec_vca ~= nil then
								-- awd
								if self:getLastSpeed() > 19 then
									self:vcaSetState("diffLockAWD", false)
								elseif self:getLastSpeed() < 16 then
									self:vcaSetState("diffLockAWD", true)
								end
								-- diff front
								if self:vcaGetState("diffLockFront") == true and math.abs(self.rotatedTime) > 0.29 then
									self:vcaSetState("diffLockFront", false)
									if spec.VCAantiSlip == 2 then
										self:vcaSetState("antiSlip", false)
									end
								elseif math.abs(self.rotatedTime) < 0.15 then
									self:vcaSetState("diffLockFront", true)
									if spec.VCAantiSlip == 2 then
										self:vcaSetState("antiSlip", true)
										spec.forDBL_autoantislip = 1
									end
								end
								-- diff rear
								if self:vcaGetState("diffLockBack") == true and math.abs(self.rotatedTime) > 0.18 then
									self:vcaSetState("diffLockBack", false)
								elseif math.abs(self.rotatedTime) < 0.11 then
									self:vcaSetState("diffLockBack", true)
								end
							end
						end
					end
					if spec.vOne ~= nil then
						-- modern
						if spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
							if self.spec_vca ~= nil then
								-- awd
								if self:getLastSpeed() >= 16 then
									self:vcaSetState("diffLockAWD", false)
									if spec.VCAantiSlip == 2 then
										self:vcaSetState("antiSlip", false)
										spec.forDBL_autoantislip = 0
									end
								elseif self:getLastSpeed() <= 14 then
									self:vcaSetState("diffLockAWD", true)
									if spec.VCAantiSlip == 2 then
										self:vcaSetState("antiSlip", true)
										spec.forDBL_autoantislip = 1
									end
								end
								if self:getLastSpeed() < 12 and spec.autoDiffs == 1 then
									-- diff front
									if self:vcaGetState("diffLockFront") == true and math.abs(self.rotatedTime) > 0.29 then
										self:vcaSetState("diffLockFront", false)
									elseif math.abs(self.rotatedTime) < 0.15 then
										self:vcaSetState("diffLockFront", true)
										if spec.VCApullInTurn == 2 then
											self:vcaSetState("diffFrontAdv", false)
											spec.forDBL_pullinturnactive = 0
										end
									end
									-- diff rear
									if self:vcaGetState("diffLockBack") == true and math.abs(self.rotatedTime) > 0.18 then
										self:vcaSetState("diffLockBack", false)
										if spec.VCApullInTurn == 2 then
											self:vcaSetState("diffFrontAdv", true)
											spec.forDBL_pullinturnactive = 1
										end
									elseif math.abs(self.rotatedTime) < 0.11 then
										self:vcaSetState("diffLockBack", true)
									end
								elseif self:getLastSpeed() > 12 then
									self:vcaSetState("diffLockFront", false)
									self:vcaSetState("diffLockBack", false)
								end
							end
						end
					end
					if spec.vOne ~= nil then
						if spec.CVTconfig == 7 then -- always for hst's
							if self.spec_vca ~= nil then
								if spec.autoDiffs == 1 then
									-- awd
									if self:getLastSpeed() > 16 then
										self:vcaSetState("diffLockAWD", false)
									elseif self:getLastSpeed() < 13 then
										self:vcaSetState("diffLockAWD", true)
									end
									-- diff front
									if self:vcaGetState("diffLockFront") == true and math.abs(self.rotatedTime) > 0.39 then
										self:vcaSetState("diffLockFront", false)
									elseif math.abs(self.rotatedTime) < 0.25 then
										self:vcaSetState("diffLockFront", true)
									end
									-- diff rear
									if self:vcaGetState("diffLockBack") == true and math.abs(self.rotatedTime) > 0.28 then
										self:vcaSetState("diffLockBack", false)
									elseif math.abs(self.rotatedTime) < 0.21 then
										self:vcaSetState("diffLockBack", true)
									end
								else
									self:vcaSetState("diffLockFront", false)
									self:vcaSetState("diffLockBack", false)
								end
							end
						end
					end
				end
				
				-- Enhanced Vehicle
				if FS25_EnhancedVehicle ~= nil and FS25_EnhancedVehicle.FS25_EnhancedVehicle ~= nil and FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall ~= nil then
					-- print("CVTa: EV found")
					if spec.vOne == 1 and spec.autoDiffs == 1 then
						-- classic
						if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
							if FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall ~= nil then
								-- awd
								if self:getLastSpeed() > 19 and self.vData.is[3] == 1 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_DM", 1, nil, nil, nil)
								elseif self:getLastSpeed() < 16 and self.vData.is[3] == 0 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_DM", 1, nil, nil, nil)
								end
								-- diff front
								if self.vData.is[1] and math.abs(self.rotatedTime) > 0.29 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
								elseif not self.vData.is[1] and math.abs(self.rotatedTime) < 0.15 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
								end
								-- diff rear
								if self.vData.is[2] and math.abs(self.rotatedTime) > 0.18 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
								elseif not self.vData.is[2] and math.abs(self.rotatedTime) < 0.11 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
									-- self.vData.is[2] = true
								end
							end
						end
					end
					if spec.vOne >= 2 then
						-- modern
						if spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
							if FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall ~= nil then
								-- awd
								if self:getLastSpeed() >= 16 and self.vData.is[3] == 1 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_DM", 1, nil, nil, nil)
								elseif self:getLastSpeed() <= 14 and self.vData.is[3] == 0 then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_DM", 1, nil, nil, nil)
								end
								if self:getLastSpeed() < 12 and spec.autoDiffs == 1 then
									-- diff front
									if self.vData.is[1] and math.abs(self.rotatedTime) > 0.29 then
										FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
									elseif not self.vData.is[1] and math.abs(self.rotatedTime) < 0.15 then
										FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
									end
									-- diff rear
									if self.vData.is[2] and math.abs(self.rotatedTime) > 0.18 then
										FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
									elseif not self.vData.is[2] and math.abs(self.rotatedTime) < 0.11 then
										FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
									end
								elseif self:getLastSpeed() >= 12 and self.vData.is[1] and self.vData.is[2] then
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_FD", 1, nil, nil, nil)
									FS25_EnhancedVehicle.FS25_EnhancedVehicle.onActionCall(self, "FS25_EnhancedVehicle_RD", 1, nil, nil, nil)
								end
							end
						end
					end
				end
				if FS25_EngineBrakeforceCompensation ~= nil then
					if printLMBF == false then
						print("CVT-Addon: FS25_EngineBrakeforceCompensation found, this will change something calculation with the motorbrake force !")
						printLMBF = true
					end
				end

				-- get maxForce sum of all tools attached
				local maxForce = 0

				-- Boost function e.g. IPM		The exact multiplier number Giants uses is 0.00414, (rounded) =1hp. So target hp x 0.00414 = torque scale value #.
				if (self.spec_motorized.motor.motorExternalTorque * self.spec_motorized.motor.lastMotorRpm * math.pi / 30) == 0 or self:getLastSpeed() < 14 then
					peakMotorTorqueOrigin = self.spec_motorized.motor.peakMotorTorque
				end
				if (spec.CVTconfig ~= 8) and spec.CVTipm ~= 1 and spec.CVTipm ~= 0 then
																		-- 1800 * 0.43 * pi / 30   = 81.053
																		-- 81.053 / pi * 30 * 1800 = 0.42999
					if (self.spec_motorized.motor.motorExternalTorque * self.spec_motorized.motor.lastMotorRpm * math.pi / 30) ~= 0 or self:getLastSpeed() >= 14 then
						if spec.CVTipm == 2 then
							if cvtaDebugCVTxOn then print("CVTa: IPM c15") end
							self.spec_motorized.motor.motorRotationAccelerationLimit = math.max(self.spec_motorized.motor.motorRotationAccelerationLimit *1.25 , 2)
							self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.85
							self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.85
							spec.forDBL_ipmactive = 1
						elseif spec.CVTipm == 3 then
							if cvtaDebugCVTxOn then print("CVTa: IPM c22") end
							self.spec_motorized.motor.motorRotationAccelerationLimit = math.max(self.spec_motorized.motor.motorRotationAccelerationLimit *1.25 , 2)
							self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.75
							self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.75
							spec.forDBL_ipmactive = 1
						elseif spec.CVTipm == 4 then
							if cvtaDebugCVTxOn then print("CVTa: IPM m27") end
							self.spec_motorized.motor.motorRotationAccelerationLimit = math.max(self.spec_motorized.motor.motorRotationAccelerationLimit *1.25 , 2)
							self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.83
							self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.83
							spec.forDBL_ipmactive = 1
						elseif spec.CVTipm == 5 then
							if cvtaDebugCVTxOn then print("CVTa: IPM m34") end
							self.spec_motorized.motor.motorRotationAccelerationLimit = math.max(self.spec_motorized.motor.motorRotationAccelerationLimit *1.25 , 2)
							self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.73
							self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.83
							spec.forDBL_ipmactive = 1
							
							-- print("###############      cvt Print: torqueScale: ".. tostring(self.spec_motorized.motor.torqueScale))
							-- self.spec_motorized.motor.externalTorqueVirtualMultiplicator = self.spec_motorized.motor.externalTorqueVirtualMultiplicator * 4
							-- self.spec_motorized.motor.motorExternalTorque = self.spec_motorized.motor.motorExternalTorque * 0.27
							-- self.spec_motorized.motor.lastMotorAppliedTorque = self.spec_motorized.motor.lastMotorAppliedTorque * 1.27
							-- self.spec_motorized.motor.differentialRotSpeed = self.spec_motorized.motor.differentialRotSpeed * 1.27
							-- self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.27
							-- self.spec_motorized.motor.lastMotorAvailableTorque = self.spec_motorized.motor.lastMotorAvailableTorque * 0.27
							-- self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.73
							-- self.spec_motorized.motor.motorAvailableTorque = self.spec_motorized.motor.motorAvailableTorque * 1.27
							-- self.spec_motorized.motor.differentialRotAcceleration = self.spec_motorized.motor.differentialRotAcceleration * 1.73
							-- self.spec_motorized.motor.peakMotorTorque = peakMotorTorqueOrigin + 0.4
							-- self.rotatedTime = 0.7
							-- self:updateMotorProperties()
						end
					print("IPM boost " .. tostring(spec.CVTipm))
					else
						-- self.spec_motorized.motor.ptoMotorRpmRatio = 4
						-- self.spec_motorized.motor.peakMotorTorque = peakMotorTorqueOrigin
						spec.forDBL_ipmactive = 0
						-- spec.forDBL_ipmstate = 0
					end
				end

				-- ODB V
				if cvtaDebugCVTon then
					print("weather curTemp: " .. tostring( (math.floor(tonumber(g_currentMission.environment.weather:getCurrentTemperature()) * 100)/100) ))
					
					-- print("getCanMotorRun(): " .. tostring(self:getCanMotorRun()))
				end
				
				if self:getMotorState() > 2 and self.spec_motorized.motor.lastMotorRpm >= self.spec_motorized.motor.minRpm - 1 then
					spec.forDBL_glowingstate = 0
				end
				
				if not self:getIsMotorStarted() then
					if self.getIsEntered ~= nil and self:getIsEntered() then
					-- Verschleiß Info
						if spec.CVTdamage > 50 and self:getDamageAmount() >= 0.4 then
							if g_client ~= nil and isActiveForInputIgnoreSelection then -- Bitte reparieren, der Verschleiß des Triebsatzes liegt bei über
								g_currentMission:showBlinkingWarning(g_i18n:getText("damageWT").. math.floor(math.min(spec.CVTdamage,95)) .." %", 2048)
							end
						elseif spec.CVTdamage > 0 and self:getDamageAmount() == 0 then
							if self.spec_RealisticDamageSystem == nil then
								spec.CVTdamage = 0
							end
						end
						spec.CVTdamage = math.min(spec.CVTdamage,100)
						if sbshDebugWT then
							print("CVTa Verschleiß : ".. spec.CVTdamage)
							print("Fahrzeug Schaden: ".. self:getDamageAmount() )
						end
						-- self.spec_frontloaderAttacher.attacherJoint.allowsLowering = true
						if self:getDamageAmount() <= 0.6 and self:getLastSpeed() < 3 and self.spec_motorized.motor.lastMotorRpm < (self.spec_motorized.motor.minRpm + 20) then
							-- Kritische CVT Schaden-Kontrolllampe geht erst aus, wenn repariert und sich das Fahrzeug im Standgas und Stillstand befindet.
							if self.spec_motorized.motorTemperature.value < 88 then
								spec.forDBL_critdamage = 0
								spec.forDBL_warndamage = 0
								spec.forDBL_highpressure = 0
							end
							spec.forDBL_highpressure = 0
						end
					end
					-- warmup while outside
					if self.spec_motorized.motorTemperature ~= nil then
						if not self.getIsEntered ~= nil and not self:getIsEntered() then
							if self.spec_motorized.motorTemperature.value < 50 then
								self.spec_motorized.motorTemperature.heatingPerMS = 3.0 / 1000
								self.spec_motorized.motorFan.enabled = false
							elseif self.spec_motorized.motorTemperature.value >= 50 and self.spec_motorized.motorTemperature.value < 100 then
								self.spec_motorized.motorTemperature.heatingPerMS = 1.5 / 1000
								if self.spec_motorized.motorTemperature.value > 93 then
									self.spec_motorized.motorFan.enabled = true
								end
								if self.spec_motorized.motorTemperature.value < 87 then
									self.spec_motorized.motorFan.enabled = false
								end
							elseif self.spec_motorized.motorTemperature.value >= 100 then
								self.spec_motorized.motorTemperature.heatingPerMS = 0.018
								-- self.spec_motorized.motorTemperature.coolingPerMS = 3.0 / 1000
								self.spec_motorized.motorTemperature.coolingByWindPerMS = 1.00 / 1000
								self.spec_motorized.motorFan.enabled = true
							end
						end
					end
				end
				
				-- ACCELERATION RAMPS - BESCHLEUNIGUNGSRAMPEN
				if self:getIsMotorStarted() then
					spec.CVTdamage = math.min(spec.CVTdamage,100)
					if spec.CVTconfig ~= 7 and spec.CVTconfig ~= 11 and spec.CVTconfig ~= 10 then
						
						if spec.cvtAR == 5 then
							-- 1/5
							if spec.vTwo == 1 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.2) then
									self.spec_motorized.motor.accelerationLimit = 0.40 * math.max((1-spec.ClutchInputValue), 0.01) -- I
								else
									self.spec_motorized.motor.accelerationLimit = 0.6 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 20 97 																																														-- BR 1 /5
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /97 ))*(0.8-(self:getLastSpeed()/100)), 0.05*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 2) ),0.08), (0.03 ) )), 0.01 ) )*(1-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.9
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.9
							end
							-- 2/5
							if spec.vTwo == 2 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(3.2) then
									self.spec_motorized.motor.accelerationLimit = 0.55 * math.max((1-spec.ClutchInputValue), 0.01) -- II
								else
									self.spec_motorized.motor.accelerationLimit = 0.8 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 25 98 																																														-- BR 2/5
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /98 ))*(0.8-(self:getLastSpeed()/100)), 0.1*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 1.5) ,0.16),0.04) ), 0.02 ) )*(1.001-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.95
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.95
							end
							-- 3/5
							if spec.vTwo == 3 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(2.6) then
									self.spec_motorized.motor.accelerationLimit = 0.60 * math.max((1-spec.ClutchInputValue), 0.01) -- III
								else
									self.spec_motorized.motor.accelerationLimit = 1.0 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 30 99 																																															-- BR 3/5
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /99 ))*(0.8-(self:getLastSpeed()/100)), 0.20*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 1.25) ,0.12),0.06) ), 0.02 ) )*(1.001-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1
							end
							-- 4/5
							if spec.vTwo == 4 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(2.4) then -- Beschleunigung wird ab kmh X full
									self.spec_motorized.motor.accelerationLimit = 1.12 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard IV
								else
									self.spec_motorized.motor.accelerationLimit = 1.2 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 								-- BR 4/5
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.18 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 1.00) ,0.16),0.08) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
							-- 5/5
							if spec.vTwo == 5 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(2.2) then -- Beschleunigung wird ab kmh X full
									self.spec_motorized.motor.accelerationLimit = 1.31 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard IV
								else
									self.spec_motorized.motor.accelerationLimit = 1.5 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 								-- BR 5/5
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.25 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) ,0.24),0.1) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
							
						elseif spec.cvtAR == 4 then
							-- 1/4
							if spec.vTwo == 1 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.2) then
									self.spec_motorized.motor.accelerationLimit = 0.40 * math.max((1-spec.ClutchInputValue), 0.01) -- I
								else
									self.spec_motorized.motor.accelerationLimit = 0.6 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 20 97 																																																	-- BR 1/4
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /97 ))*(0.8-(self:getLastSpeed()/100)), 0.05*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 2) ),0.11), (0.03 ) )), 0.05 ) )*(1-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.9
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.9
							end
							-- 2/4
							if spec.vTwo == 2 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(3.2) then
									self.spec_motorized.motor.accelerationLimit = 0.55 * math.max((1-spec.ClutchInputValue), 0.01) -- II
								else
									self.spec_motorized.motor.accelerationLimit = 0.95 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 25 98 																																																		-- BR 2/4
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /98 ))*(0.8-(self:getLastSpeed()/100)), 0.1*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 1.5) ),0.615), (0.04 ) )) )*(1-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.95
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.95
							end
							-- 3/4
							if spec.vTwo == 3 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(2.6) then
									self.spec_motorized.motor.accelerationLimit = 0.60 * math.max((1-spec.ClutchInputValue), 0.01) -- III
								else
									self.spec_motorized.motor.accelerationLimit = 1.1 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 30 99 																																																			-- BR 3/4 20.9
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /99 ))*(0.8-(self:getLastSpeed()/100)), 0.20*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 1.00) , 0.15), 0.06) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1
							end
							-- 4/4
							if spec.vTwo == 4 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(2.4) then -- Beschleunigung wird ab kmh X full
									self.spec_motorized.motor.accelerationLimit = 1.32 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard IV
								else
									self.spec_motorized.motor.accelerationLimit = 1.4 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 												-- BR 4/4
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.22 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) , 0.22), 0.08) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
						elseif spec.cvtAR == 3 then
							-- 1/3
							if spec.vTwo == 1 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.2) then
									self.spec_motorized.motor.accelerationLimit = 0.40 * math.max((1-spec.ClutchInputValue), 0.01) -- I
								else
									self.spec_motorized.motor.accelerationLimit = 0.7 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 20 97 																							-- BR 1/3 
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /97 ))*(0.8-(self:getLastSpeed()/100)), 0.05*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 2) ),0.11), (0.04 ) )), 0.02 ) )*(1-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.9
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.9
							end
							-- 2/3
							if spec.vTwo == 2 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(3.2) then
									self.spec_motorized.motor.accelerationLimit = 0.55 * math.max((1-spec.ClutchInputValue), 0.01) -- II
								else
									self.spec_motorized.motor.accelerationLimit = 1.0 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 25 98 																								-- BR 2/3
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max(math.min((0.5-((self:getTotalMass() - self:getTotalMass(true)) /98 ))*(0.8-(self:getLastSpeed()/100)), 0.1*( 1-(self:getTotalMass() - self:getTotalMass(true))/100 ) ), 0.01) )*(1-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) ,0.15),0.6) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.95
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.95
							end
							-- 3/3
							if spec.vTwo == 3 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.8) then -- Beschleunigung wird ab kmh X full
									self.spec_motorized.motor.accelerationLimit = 1.32 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard III
								else
									self.spec_motorized.motor.accelerationLimit = 1.4 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 								-- BR 3/3
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.22 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) ,0.22),0.1) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
						elseif spec.cvtAR == 2 then
							-- 1/2
							if spec.vTwo == 1 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.2) then
									self.spec_motorized.motor.accelerationLimit = 0.40 * math.max((1-spec.ClutchInputValue), 0.01) -- I
								else
									self.spec_motorized.motor.accelerationLimit = 0.8 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 20 97 																							-- BR 1 
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.12 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 2) ),0.12), (0.05 ) )), 0.05 ) )*(1.001-spec.ClutchInputValue)
								end
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 0.9
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 0.9
							end
							
							--2/2
							if spec.vTwo == 2 and spec.isVarioTM then
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(3.4) then -- Beschleunigung wird ab kmh X full
									self.spec_motorized.motor.accelerationLimit = 1.22 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard II
								else
									self.spec_motorized.motor.accelerationLimit = 1.4 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 								-- BR 2
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.22 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) ,0.19),0.08) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
						elseif spec.cvtAR == 1 then
							--1/0 ~ 1
							if spec.isVarioTM then
								spec.vTwo = 1
								if self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)/(4.4) then -- Beschleunigung wird ab kmh X full 53 = 16.87*3.14159 / 2.6
									self.spec_motorized.motor.accelerationLimit = 1.02 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard IV
								else
									self.spec_motorized.motor.accelerationLimit = 1.4 * math.max((1-spec.ClutchInputValue), 0.01) -- Standard
								end
								if (self:getTotalMass() - self:getTotalMass(true)) ~= 0 then -- 35 100
								-- 			Total				Nur Schlepper
									-- anstatt das Gewicht hinten dran zusätzlich bremst wie vanilla, schiebt das zusätzliche Gewicht nun, vorallem bergab.
									--													z.B. big plough		(                   3.7t              / 100 = 0.037  )*(	45 kmh	 = 0.35				)  =  {(3.7/100)*(0.8-0.45=0.35 ~ 0.013)} 								-- BR 4
									self.spec_motorized.motor.lowBrakeForceScale = ( math.abs( math.max(math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6) * 0.75) ),0.18 *  (1-(self:getTotalMass() - self:getTotalMass(true)) / self:getTotalMass())   ), (0.02 ) )) )*(1.001-spec.ClutchInputValue)
								else
									-- bei Schlepper Leermasse
									self.spec_motorized.motor.lowBrakeForceScale = ( math.max( math.abs( math.max( math.min( (1-(self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))*(1-(self:getLastSpeed()/(self.spec_motorized.motor.maxForwardSpeed*3.6)) * 0.75) ,0.17),0.08) ), 0.05 ) )*(1.001-spec.ClutchInputValue)
									-- start at ca. 0.16
								end
								-- Sprit-Verbrauch anpassen
								self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage * 1.2
								self.spec_motorized.lastDefUsage = self.spec_motorized.lastDefUsage * 1.2
							end
						end
						if printLMBF == true then
							self.spec_motorized.motor.lowBrakeForceScale = math.man(self.spec_motorized.motor.lowBrakeForceScale * 0.8, 0.01) 
						end
					end
					-- g_currentMission:addExtraPrintText(tostring(self.spec_motorized.motor.maxForwardSpeed))
					-- string = "TEST"
					-- BRAKE RAMPS - BREMSRAMPEN
					if spec.vThree == 1 and spec.isVarioTM then
						-- g_currentMission:addExtraPrintText(g_i18n:getText("txt_bRamp5")) -- #hud 4
						self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00500 * math.max((1-spec.ClutchInputValue), 0.00001) -- 17 kmh
					end
					if spec.vThree == 2 and spec.isVarioTM then
						-- self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00027777777777778 -- 1-2 kmh
						self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00002777777777778 -- 1-2 kmh
						-- self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.0000000001 -- 1-2 kmh -- Fließkomme Fehler nach einer Weile
					end
					if spec.vThree == 3 and spec.isVarioTM then
						self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00150 * math.max((1-spec.ClutchInputValue), 0.00001) -- ca 4 kmh
					end
					if spec.vThree == 4 and spec.isVarioTM then
						self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00250 * math.max((1-spec.ClutchInputValue), 0.00001) -- ca 8 kmh
					end
					if spec.vThree == 5 and spec.isVarioTM then
						self.spec_motorized.motor.lowBrakeForceSpeedLimit = 0.00427 * math.max((1-spec.ClutchInputValue), 0.00001) -- 15 km/h
					end
					
					-- local spiceLoad = (tonumber(string.format("%.2f", math.min(math.abs(self.spec_motorized.motor.smoothedLoadPercentage)/5, 0.17))))
					-- local spiceRPM = self.spec_motorized.motor.lastMotorRpm
					-- local spiceMaxSpd = self.spec_motorized.motor.maxForwardSpeed
					local Nonce = 0
					
					if math.abs(self.spec_motorized.motor.lastAcceleratorPedal) <= 0.01 then
						self.spec_motorized.motor.motorAppliedTorque = 0
					end
					
					-- automatic drivinglevel for modern cvt, CVTconfig: 4,5,6
					--
					-- Adjust the params when CP or/and AD is active
					if self.spec_cpAIWorker ~= nil then 
						if (self.rootVehicle:getIsCpActive() ~= nil ) then
							if (self.rootVehicle:getIsCpActive() == true ) then
								if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
									if 	   spec.cvtDL == 4 then spec.vOne = 2
									elseif spec.cvtDL == 3 then spec.vOne = 1
									elseif spec.cvtDL == 2 then spec.vOne = 1 
									else
										spec.vOne = 1
									end
								end
							end
						end
					end
					if FS25_AutoDrive ~= nil and FS25_AutoDrive.AutoDrive ~= nil then
						if (self.ad.stateModule:isActive() ~= nil ) then
							if (self.ad.stateModule:isActive() == true ) then
								if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
									spec.vOne = math.max(spec.cvtDL, 2)
								end
							end
						end
					end
					
					-- print("CVTa vOne: " .. spec.vOne)
					
					-- different classic and modern @server or @local
					local mcRPMvar = 1
					-- if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then -- classic
					
					if g_server and g_client and not g_currentMission.connectedToDedicatedServer then 	-- das ist Local und server host local
						-- spec.mcRPMvar = 1.0009*0.97 	-- 22er c.local
						mcRPMvar = 1.025*0.98 	-- 25er c.local
					else																				-- das ist (dedi)server
						-- spec.mcRPMvar = 1.0009	-- 22er c.server
						mcRPMvar = 0.992	-- 25er c.server
					end
					if cvtaDebugCVTuOn == true then
						print("CVTa mcRPMvar: " .. tostring(mcRPMvar))
					end
					
					-- -- FAHRSTUFE I. classic
					if spec.vOne == 1 and spec.isVarioTM and spec.CVTconfig ~= 7
					and ( spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 ) and spec.cvtDL ~= 1 then
						local motor = self.spec_motorized.motor
					    local axis = self.spec_drivable.axisForward or 0
				        local dir = motor.currentDirection or 1

						-- Planetengetriebe / Hydromotor Übersetzung
						spec.isHydroState = false
						if spec.CVTdamage > 60 and spec.forDBL_critdamage == 1 then 																										-- Notlauf
							self.spec_motorized.motor.maxForwardSpeed = (math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne / 2, 4.49), 6.94*(1-spec.ClutchInputValue)))/2.5
							self.spec_motorized.motor.maxBackwardSpeed = (math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne / 2, 3.21), 6.36*(1-spec.ClutchInputValue)))/2.5
							-- self.spec_motorized.motor.accelerationLimit = 0.3
							-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1-spec.ClutchInputValue),0.04)
							-- self.spec_motorized.motor.accelerationLimit = math.min(self.spec_motorized.motor.accelerationLimit * (1-spec.ClutchInputValue),0.3)
						elseif spec.forDBL_critdamage == 0 and spec.isTMSpedal == 0 then 																									-- Normalbetrieb
							-- Setze die maxSpeed proportional zum Pedal
					        local maxSpeed = motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
					        if dir == -1 then
					            maxSpeed = motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
					        end
					        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
							-- self.spec_motorized.motor.maxForwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94*(1))
							-- self.spec_motorized.motor.maxBackwardSpeed = math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 3.21), 6.36*(1))
							-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1-spec.ClutchInputValue),0.04)
							-- self.spec_motorized.motor.accelerationLimit = self.spec_motorized.motor.accelerationLimit * (1-spec.ClutchInputValue)
						elseif spec.isTMSpedal == 1 and self:getCruiseControlState() == 0 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) >= 0.03 then 						-- PedalTMS
							-- TMS like
							-- wenn Tempomat aus, wird die Tempomatgescwindigkeit als Steps der maxSpeed benutzt
							-- Setze die maxSpeed proportional zum Pedal
					        local maxSpeed = math.min(self:getCruiseControlSpeed(), (motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * (1-spec.ClutchInputValue)))
					        if dir == -1 then
					            maxSpeed = math.min(self:getCruiseControlSpeed(), (motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * (1-spec.ClutchInputValue)))
					        end

					        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
							-- self.spec_motorized.motor.maxBackwardSpeed = (math.min(self:getCruiseControlSpeed(), math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 3.21), 6.36*(1-spec.ClutchInputValue) ) )) * math.abs(self.spec_motorized.motor.lastAcceleratorPedal)
							-- self.spec_motorized.motor.maxForwardSpeed = (math.min(self:getCruiseControlSpeed(), math.min(math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne, 4.49), 6.94*(1-spec.ClutchInputValue) ) )) * math.abs(self.spec_motorized.motor.lastAcceleratorPedal)
							self.spec_motorized.motor.motorAppliedTorque = math.max(self.spec_motorized.motor.motorAppliedTorque, 0.5)
						end
						-- g_currentMission:addExtraPrintText(g_i18n:getText("txt_VarioOne")) -- #l10n
						self.spec_motorized.motor.gearRatio = math.max(self.spec_motorized.motor.gearRatio, 100) * 1.81 + (self.spec_motorized.motor.rawLoadPercentage*9)
						self.spec_motorized.motor.minForwardGearRatio = self.spec_motorized.motor.minForwardGearRatioOrigin * 1.6
						-- self.spec_motorized.motor.maxBackwardGearRatio = self.spec_motorized.motor.maxForwardGearRatioOrigin + 1
						-- self.spec_motorized.motor.minBackwardGearRatio = self.spec_motorized.motor.minForwardGearRatioOrigin * 2
						self.spec_motorized.motor.rawLoadPercentage = (self.spec_motorized.motor.rawLoadPercentage * 0.94)
						-- self.spec_motorized.motor.differentialRotSpeed = self.spec_motorized.motor.differentialRotSpeed * 0.8

						if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 60 then
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.2 then
								-- Gaspedal and Variator
								-- smooth = 1 + dt / 1400 for 60 fps range
								spec.smoother = 1 + dt / 1400
								-- if spec.smoother ~= nil and spec.smoother > 10 then
									-- spec.smoother = 0;
									-- if cvtaDebugCVTuOn then
										-- print("DT smooth: " .. spec.smoother)
									-- end
									
									--
									if self:getLastSpeed() > 1 then
										self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(math.min((self:getLastSpeed() * math.abs(math.max(self.spec_motorized.motor.rawLoadPercentage, 0.52)))*44, self.spec_motorized.motor.maxRpm*0.98), self.spec_motorized.motor.minRpm+203), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm*spec.HandgasPercent)
										if self:getLastSpeed() > (self.spec_motorized.motor.maxForwardSpeed*3.6)-1 then
											self.spec_motorized.motor.rawLoadPercentage = self.spec_motorized.motor.rawLoadPercentage *0.97
											self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm + self:getLastSpeed()
										end
										if math.max(0, self.spec_drivable.axisForward) < 0.2 then
										-- if self.isClient and not self.isServer
											self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 16), self.spec_motorized.motor.maxRpm)
											if self.spec_motorized.motor.rawLoadPercentage < 0 then
												-- self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * ( math.max(math.abs(self.spec_motorized.motor.rawLoadPercentage)*1.7, 1) )
												self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm + (math.abs(self:getLastSpeed()) * 14), self.spec_motorized.motor.maxRpm)
											end
										end
										--
										if math.max(0, self.spec_drivable.axisForward) > 0.5 and math.max(0, self.spec_drivable.axisForward) <= 0.9 and self.spec_motorized.motor.rawLoadPercentage < 0.5 then
											self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * 0.8 * mcRPMvar
										end
									elseif self:getLastSpeed() > 15 then
										if math.max(0, self.spec_drivable.axisForward) > 0.5 and self.spec_motorized.motor.lastMotorRpm < (self.spec_motorized.motor.maxRpm - 400) then
											self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * 1.2 * mcRPMvar, self.spec_motorized.motor.maxRpm)
										end
									end
									-- print("smooth: " .. spec.smoother)
								-- end -- smooth
							end
							
							-- Factor für Drehmoment/rpm ref. motorLoad
							-- local refKn = (self.spec_motorized.motor.smoothedLoadPercentage )
							
							-- print("actualLoadPercentage: " .. tostring( self.spec_motorized.motor.actualLoadPercentage))
							
														
							-- Nm kurven für unterschiedliche Lasten, Berücksichtigung pto
							if self.spec_motorized.motor.smoothedLoadPercentage >= 0.1 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.4 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.984 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0)+(math.abs(self.spec_motorized.motor.lastAcceleratorPedal)*25), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.4 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.6 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.9825 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0)+(math.abs(self.spec_motorized.motor.lastAcceleratorPedal)*25), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.6 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.625 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.985 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0)+(math.abs(self.spec_motorized.motor.lastAcceleratorPedal)*45), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.625 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.65 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.9875 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0)+(math.abs(self.spec_motorized.motor.lastAcceleratorPedal)*45), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.65 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.675 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.99 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.675 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.9925 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.7 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.725 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.995 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.725 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.75 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 0.9975 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.75 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.775 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.00 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.775 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.8 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.0025 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.8 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.825 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.005 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.825 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.85 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.01 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.85 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.875 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.015 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.875 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.9 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.02 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
							end
							
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.9 then
								self.spec_motorized.motor.lastMotorRpm = math.min(math.max((self.spec_motorized.motor.lastMotorRpm * 1.025 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0), self.spec_motorized.motor.maxRpm)
								self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 3 + (self.spec_motorized.motor.rawLoadPercentage*19)
								self.spec_motorized.motor.minForwardGearRatio = self.spec_motorized.motor.minForwardGearRatio + self.spec_motorized.motor.smoothedLoadPercentage*15
							end
							
							-- Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt
							if math.max(0, self.spec_drivable.axisForward) >= 0.01 and self:getLastSpeed() <= 4 then
								self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0)
								if cvtaDebugCVTon == true then
									print("## Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt: " .. math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.015, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0))
									print("## self:getDamageAmount(): " .. self:getDamageAmount())
								end
							end

							-- Wenn ein Anbaugerät zu schwere Last erzeugt, schafft es die 4. Beschleunigungsrampe nicht oder nimmt Schaden
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.95 and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)/2.26) and spec.vTwo == 4 and spec.impIsLowered == true then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.94 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.0)
								self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 3.1 + (self.spec_motorized.motor.rawLoadPercentage*9)
								self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm - 10
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.022 * self.spec_motorized.motor.rawLoadPercentage, 0.0015)
								end
								if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
									spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4), 100)
									if self.spec_RealisticDamageSystem == nil then
										-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4)
									end
								end
								if self.spec_motorized.motorTemperature.value > 94 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										spec.forDBL_warndamage = 1
									end
									if spec.CVTdamage > 60 then
										spec.forDBL_critdamage = 1
										spec.forDBL_warndamage = 0
									end
								end
								if cvtaDebugCVTheatOn then
									print("warnHeat: " .. spec.forDBL_warnheat)
									print("critHeat: " .. spec.forDBL_critheat)
									print("warnDamage: " .. spec.forDBL_warndamage)
									print("critDamage: " .. spec.forDBL_critdamage)
									print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
								end
								local FFeffekt = math.max(self.spec_motorized.motor.rawLoadPercentage * 0.75, 0.2)
								if cvtaDebugCVTxOn == true then
									print("CVTa: > 95 % - Lowered, AR4, vTwo=" .. spec.vTwo)
									print("CVTa: > 95 % - Lowered, AR4, Damage=" .. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
									print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
								end
								-- Getriebeschaden erzeugen bzw. Verschleiß
								if self.spec_motorized.motor.rawLoadPercentage > 0.98 then
									if g_client ~= nil and isActiveForInputIgnoreSelection then
										g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 2048)
										spec.forDBL_highpressure = 1
									end
									if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
										spec.CVTdamage = math.min(spec.CVTdamage + (self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ) ),100)
										if self.spec_RealisticDamageSystem == nil then
											-- self:addDamageAmount(self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ) )
										end
									end
									self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm -100
									if self.spec_motorized.motorTemperature ~= nil then
										self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0035 * self.spec_motorized.motor.rawLoadPercentage,0.0015)
									end
									if self.spec_motorized.motorTemperature.value > 94 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
										spec.forDBL_warnheat = 1
									elseif self.spec_motorized.motorTemperature.value > 105 then
										spec.forDBL_critheat = 1
										spec.forDBL_warnheat = 0
										if spec.forDBL_critdamage ~= 1 then
											spec.forDBL_warndamage = 1
										end
										if spec.CVTdamage > 60 then
											spec.forDBL_critdamage = 1
											spec.forDBL_warndamage = 0
										end
									end
									if cvtaDebugCVTheatOn then
										print("warnHeat: " .. spec.forDBL_warnheat)
										print("critHeat: " .. spec.forDBL_critheat)
										print("warnDamage: " .. spec.forDBL_warndamage)
										print("critDamage: " .. spec.forDBL_critdamage)
										print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									end
									if cvtaDebugCVTxOn == true then
										print("CVTa: > 98 % - Lowered, AR4, vTwo=" .. spec.vTwo)
										print("CVTa: > 98 % - Lowered, AR4, Damage=" .. self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ))
										print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
									end
									if self.spec_motorized.motor.rawLoadPercentage > 0.99 then
										self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * 0.5 * mcRPMvar
										if self.spec_motorized.motorTemperature ~= nil then
											self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.040 * self.spec_motorized.motor.rawLoadPercentage,0.0015)
										end
										if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
											spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5),100)
											if self.spec_RealisticDamageSystem == nil then
												-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5)
											end
										end
										if self.spec_motorized.motorTemperature.value > 94 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
											spec.forDBL_warnheat = 1
										elseif self.spec_motorized.motorTemperature.value > 105 then
											spec.forDBL_critheat = 1
											spec.forDBL_warnheat = 0
											if spec.forDBL_critdamage ~= 1 then
												spec.forDBL_warndamage = 1
											end
										end
										if cvtaDebugCVTheatOn then
											print("warnHeat: " .. spec.forDBL_warnheat)
											print("critHeat: " .. spec.forDBL_critheat)
											print("warnDamage: " .. spec.forDBL_warndamage)
											print("critDamage: " .. spec.forDBL_critdamage)
											print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
										end
										local FFeffekt = math.max(self.spec_motorized.motor.rawLoadPercentage, 0.5)
										if cvtaDebugCVTxOn == true then
											print("CVTa: > 99 % - Lowered, AR4, vTwo=" .. spec.vTwo)
											print("CVTa: > 99 % - Lowered, AR4, Damage=" .. (self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.7)
											print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
										end
									end
								end
							end
							-- Wenn ein Anbaugerät zu schwere Last erzeugt, schafft es die 4. Beschleunigungsrampe nicht oder nimmt Schaden
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.96 and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)/1.69) and spec.vTwo == 4 and spec.impIsLowered == true then
								if g_client ~= nil and isActiveForInputIgnoreSelection then
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 2048)
									spec.forDBL_highpressure = 1
								end
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.96 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0)
								self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 3.1 + (self.spec_motorized.motor.rawLoadPercentage*9)
								-- self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								-- self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm - 50
								local FFeffekt = math.max(self.spec_motorized.motor.rawLoadPercentage * 0.75, 0.2)
								if cvtaDebugCVTxOn == true then
									print("CVTa: > 97 % - Lowered, AR3, vTwo=" .. spec.vTwo)
									print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
								end
								-- Getriebeschaden erzeugen
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.98 then
									if g_client ~= nil and isActiveForInputIgnoreSelection then
										g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 2048)
										spec.forDBL_highpressure = 1
									end
									if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
										spec.CVTdamage = math.min(spec.CVTdamage + (self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ) ),100)
										if self.spec_RealisticDamageSystem == nil then
											-- self:addDamageAmount(self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ) )
										end
									end
									local FFeffekt = math.max(self.spec_motorized.motor.rawLoadPercentage * 0.95, 0.5)
									self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm -100
									if self.spec_motorized.motorTemperature ~= nil then
										self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0030 * self.spec_motorized.motor.rawLoadPercentage, 0.0015)
									end
									if self.spec_motorized.motorTemperature.value > 94 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
										spec.forDBL_warnheat = 1
									elseif self.spec_motorized.motorTemperature.value > 105 then
										spec.forDBL_critheat = 1
										spec.forDBL_warnheat = 0
										if spec.forDBL_critdamage ~= 1 then
											spec.forDBL_warndamage = 1
										end
										if spec.CVTdamage > 60 then
											spec.forDBL_critdamage = 1
											spec.forDBL_warndamage = 0
										end
									end
									if cvtaDebugCVTheatOn then
										print("warnHeat: " .. spec.forDBL_warnheat)
										print("critHeat: " .. spec.forDBL_critheat)
										print("warnDamage: " .. spec.forDBL_warndamage)
										print("critDamage: " .. spec.forDBL_critdamage)
										print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									end
									if cvtaDebugCVTxOn == true then
										print("CVTa: > 98 % - Lowered, AR3, vTwo=" .. spec.vTwo)
										print("CVTa: > 98 % - Lowered, AR3, Damage=" .. self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ))
										print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
									end
									if self.spec_motorized.motor.smoothedLoadPercentage > 0.99 then
										-- g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 2048)
										self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * 0.6 * mcRPMvar
										if self.spec_motorized.motorTemperature ~= nil then
											self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0035 * self.spec_motorized.motor.rawLoadPercentage,0.0015)
										end
										if self.spec_motorized.motorTemperature.value > 94 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
											spec.forDBL_warnheat = 1
										elseif self.spec_motorized.motorTemperature.value > 105 then
											spec.forDBL_critheat = 1
											spec.forDBL_warnheat = 0
											if spec.forDBL_critdamage ~= 1 then
												-- spec.forDBL_warndamage = 1
											end
											if spec.CVTdamage > 60 then
												-- spec.forDBL_critdamage = 1
												-- spec.forDBL_warndamage = 0
											end
										end
										if cvtaDebugCVTheatOn then
											print("warnHeat: " .. spec.forDBL_warnheat)
											print("critHeat: " .. spec.forDBL_critheat)
											print("warnDamage: " .. spec.forDBL_warndamage)
											print("critDamage: " .. spec.forDBL_critdamage)
											print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
										end
										if cvtaDebugCVTxOn == true then
											print("CVTa: > 99 % - Lowered, AR3, vTwo=" .. spec.vTwo)
											print("CVTa Mass:" .. (self:getTotalMass() - self:getTotalMass(true)) ..">=".. (self:getTotalMass(true)/2.26))
										end
									end
								end
							end
						end
					end --FS I

					-- HYDROSTAT HST DRIVES
					if spec.HSTstate ~= nil and spec.CVTconfig == 7 then
						local motor = self.spec_motorized.motor
					    local forwardInput = math.abs(motor.lastAcceleratorPedal) or 0
						local maxSpeedFw = self.spec_motorized.motor.maxForwardSpeedOrigin
						local maxSpeedBw = self.spec_motorized.motor.maxBackwardSpeedOrigin
					    local reverseInput = spec.ClutchInputValue or 0  -- zweckentfremdet

					    local direction = 0
					    local activePedal = 0

					    -- Nur eine Richtung aktiv (anti-Stotter)
					    if reverseInput > 0.01 and forwardInput < 0.01 then
					        direction = -1
					        activePedal = reverseInput
					    elseif forwardInput > 0.01 and reverseInput < 0.01 then
					        direction = 1
					        activePedal = forwardInput
					    else
					        direction = 0
					        activePedal = 0
					    end

					    -- Richtung setzen (nur wenn aktiv)
					    if direction ~= 0 then
					        motor.currentDirection = direction
					        motor.lastAcceleratorPedal = activePedal
					        motor.acceleratorPedal = activePedal
					        motor.axisForward = activePedal
					        self.spec_drivable.axisForward = activePedal
					    else
					        motor.lastAcceleratorPedal = 0
					    end
						local targetSpeedFw = math.max(0.1, maxSpeedFw * activePedal)
						local targetSpeedBw = math.max(0.1, maxSpeedBw * activePedal)
					    -- local targetSpeed = math.max(minSpeed, self._originalMaxSpeed * activePedal)
						-- kann die pedale für Vor- und Rückwärts nicht trennen, es muß immer das Gaspedal dazu genommen werden
					    
-- print(string.format("activePedal=%.2f Dir=%d Speed=%.2f km/h RPM=%.0f MaxSpeed=%.2f axisForward=%.2f" ,    activePedal, motor.currentDirection, self:getLastSpeed(), motor.lastMotorRpm, motor.maxForwardSpeed*3.6, motor.axisForward))


						if spec.cvtAR ~= 4 then
							spec.cvtAR = 4
						end
						if spec.cvtDL ~= 2 then
						-- if spec.vOne ~= 2 or spec.cvtDL ~= 2 then
							spec.cvtDL = 2
							-- spec.vOne = 2
						end
						-- local mtspec = self.spec_motorized.motor
						spec.isHydroState = true
						-- spec.HydrostatPedal = math.abs(self.spec_motorized.motor.lastAcceleratorPedal) -- nach oben verschoben z.719
						
						-- Hydrostatisches Fahrpedal
						self.spec_motorized.motor.maxBackwardGearRatio = self.spec_motorized.motor.maxForwardGearRatio
						self.spec_motorized.motor.minBackwardGearRatio = self.spec_motorized.motor.minForwardGearRatio
						if spec.HSTstate == 1 then -- vorher FS I. HST (älter)
							if math.abs(self.spec_motorized.motor.lastAcceleratorPedal) >= 0.01 then  -- todo:  need to check if its in MP works also
								if direction == -1 then
									self.spec_motorized.motor.maxBackwardSpeed = math.max((targetSpeedBw / spec.cvtAR * spec.vTwo) * (self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm), 0.001)
								else
									self.spec_motorized.motor.maxForwardSpeed  = math.max((targetSpeedFw / spec.cvtAR * spec.vTwo) * (self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm), 0.001)
								end
									-- self.spec_motorized.motor.maxForwardSpeed  = (self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtAR * spec.vTwo) * math.abs(self.spec_motorized.motor.lastAcceleratorPedal * (self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))
								-- self.spec_motorized.motor.maxBackwardSpeed = (self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtAR * spec.vTwo) * math.abs(self.spec_motorized.motor.lastAcceleratorPedal * (self.spec_motorized.motor.lastMotorRpm/self.spec_motorized.motor.maxRpm))
									
								if self.spec_vca ~= nil then
									if self.spec_vca.handThrottle > 0 then
										self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.minRpm*0.99, self.spec_motorized.motor.maxRpm* (math.min(self.spec_vca.handThrottle,0.999)) )
									else
										if spec.HandgasPercent > 0 then
											self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.minRpm*0.95, self.spec_motorized.motor.maxRpm * spec.HandgasPercent)
											self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.9
											-- print("## hier NOT 0")
										else
											self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.minRpm * 0.95
											-- print("## hier 0")
										end
									end
								else
									if spec.HandgasPercent > 0 then
										self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.minRpm*0.95, self.spec_motorized.motor.maxRpm*spec.HandgasPercent)
										self.spec_motorized.motor.smoothedLoadPercentage = self.spec_motorized.motor.smoothedLoadPercentage * 0.9
									else
										self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.minRpm * 0.95
										-- print("## hier")
									end
								end
								if self.spec_vca ~= nil then
									self.spec_motorized.motor.accelerationLimit = 1 + ( 3 * (math.min(self.spec_vca.handThrottle,0.999)))
								else
									self.spec_motorized.motor.accelerationLimit = 1 + ( 3 * spec.HandgasPercent)
								end
							end
						elseif spec.HSTstate == 2 then -- vorher FS II. Hydrostat (moderner)
							if math.abs(self.spec_motorized.motor.lastAcceleratorPedal) >= 0.01 then
								-- if direction == -1 then
								-- 	self.spec_motorized.motor.maxBackwardSpeed = math.max((targetSpeedBw / spec.cvtAR * spec.vTwo), 0.001)
								-- else
								-- 	self.spec_motorized.motor.maxForwardSpeed  = math.max((targetSpeedFw / spec.cvtAR * spec.vTwo), 0.001)
								-- end
									self.spec_motorized.motor.maxForwardSpeed  = (self.spec_motorized.motor.maxForwardSpeedOrigin / 4 * spec.vTwo) * math.max( math.abs(self.spec_motorized.motor.lastAcceleratorPedal), 0.05)
								self.spec_motorized.motor.maxBackwardSpeed = (self.spec_motorized.motor.maxForwardSpeedOrigin / 4 * spec.vTwo) * math.max( math.abs(self.spec_motorized.motor.lastAcceleratorPedal), 0.05)
								-- self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(self.spec_motorized.motor.lastMotorRpm, self.spec_motorized.motor.minRpm + (self.spec_motorized.motor.minRpm/1.4 * self.spec_motorized.motor.smoothedLoadPercentage), (self.spec_motorized.motor.maxRpm*0.6) * self.spec_motorized.motor.smoothedLoadPercentage*0.5 ), self.spec_motorized.motor.minRpm), self.spec_motorized.motor.maxRpm * math.max(self.spec_motorized.motor.smoothedLoadPercentage, .5))
								self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(self.spec_motorized.motor.lastMotorRpm, self.spec_motorized.motor.minRpm + (self.spec_motorized.motor.minRpm/1.4), (self.spec_motorized.motor.maxRpm*0.6) * 0.5 ), self.spec_motorized.motor.minRpm), self.spec_motorized.motor.maxRpm * math.max(self.spec_motorized.motor.smoothedLoadPercentage, 0.5))
								self.spec_motorized.motor.accelerationLimit = 2
							else
								self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm, math.min(self.spec_motorized.motor.maxRpm * self.spec_motorized.motor.smoothedLoadPercentage*0.8, self.spec_motorized.motor.maxRpm * 0.7 )  )
								-- self.spec_motorized.motor.lastMotorRpm = math.max(math.min(self.spec_motorized.motor.minRpm * self.spec_motorized.motor.smoothedLoadPercentage, self.spec_motorized.motor.maxRpm*0.4 * self.spec_motorized.motor.smoothedLoadPercentage*0.5 ), self.spec_motorized.motor.minRpm)
							end
							self.spec_motorized.motor.lowBrakeForceScale = 0.05
							-- limit and smooth
						end
						if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 2 then
							if self.spec_motorized.motor.smoothedLoadPercentage >= 0.99 then
								self.spec_motorized.motor.lastMotorRpm = (self.spec_motorized.motor.lastMotorRpm * .8 * mcRPMvar)
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = 0.0016
								end
								if self.spec_motorized.motorTemperature.value > 104 then
									spec.CVTdamage = math.min(spec.CVTdamage + (self.spec_motorized.motorTemperature.value/1250),100)
									if self.spec_RealisticDamageSystem == nil then
										-- self:addDamageAmount(self.spec_motorized.motorTemperature.value/1250)
									end
								end
								if self.spec_motorized.motorTemperature.value > 94 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
									spec.forDBL_warndamage = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										spec.forDBL_warndamage = 1
									end
									if spec.CVTdamage > 60 then
										spec.forDBL_critdamage = 1
										spec.forDBL_warndamage = 0
									end
								end
							end
						end
					end -- HST
					
					-- DANGERZONE
					if debugTable == true then
						if firstTimeRun == nil then
							-- DebugUtil.printTableRecursively(self.spec_frontloaderAttacher, "flA- " , 0, 5)
							-- DebugUtil.printTableRecursively(self.spec_cylindered, "cyl- " , 0, 5)
							-- DebugUtil.printTableRecursively(self.spec_cylindered.movingTools, "mT- " , 0, 3)
							-- DebugUtil.printTableRecursively(self.spec_motorized.actionEvents[InputAction.TOGGLE_MOTOR_STATE], "mStart- " , 0, 5)
							-- DebugUtil.printTableRecursively(self.spec_motorized.actionEvents[InputAction.TOGGLE_MOTOR_STATE].1, "mStart- " , 0, 5)
							-- DebugUtil.printTableRecursively(self.spec_motorized.motor, "motor- " , 0, 4)
							-- DebugUtil.printTableRecursively(self.spec_powerConsumer, "pC- " , 0, 3) -- wth
							firstTimeRun = true
						end;
					end
					
					
					-- ODB V
													-- self.spec_RealisticDamageSystem.CVTRepairActive
					if spec.CVTconfig ~= 10 then -- nicht für Elektrofahrzeuge (cfg)
						if self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) <= 0.9 then
							if self.spec_motorized.motorTemperature ~= nil then
								self.spec_motorized.motorTemperature.heatingPerMS = 0.0015
							end
							if self.spec_motorized.motorTemperature.value > 92 then
								self.spec_motorized.motorFan.enabled = true
							elseif self.spec_motorized.motorTemperature.value < 85 then
								self.spec_motorized.motorFan.enabled = false
							end
							if self.spec_motorized.motorTemperature.value < 95 then
								-- Reset der Warn-Kontrolllampen erst, wenn alles abgekühlt ist
								spec.forDBL_warnheat = 0
								if spec.forDBL_critdamage ~= 1 then
									spec.forDBL_warndamage = 0
									spec.forDBL_highpressure = 0
								end
									-- Kritische CVT Schaden-Kontrolllampe geht erst aus, wenn repariert und sich das Fahrzeug Stillstand und Motor AUS->EIN befindet.
							elseif self.spec_motorized.motorTemperature.value < 104 and self.spec_motorized.motorTemperature.value > 94 then
								spec.forDBL_critheat = 0
								spec.forDBL_warnheat = 1
							end
						end
						if self.spec_motorized.motor.smoothedLoadPercentage <= 0.4 and self:getLastSpeed() < 3 then
							local sspMOT = self.spec_motorized.motor
							if self.spec_motorized.motorTemperature ~= nil then
								self.spec_motorized.motorTemperature.heatingPerMS = 0.0015
							end
							if self.spec_motorized.motorTemperature.value > 92 then
								self.spec_motorized.motorFan.enabled = true
							elseif self.spec_motorized.motorTemperature.value < 85 then
								self.spec_motorized.motorFan.enabled = false
							end
							if self.spec_motorized.motorTemperature.value < 95 then
								-- Reset der Warn-Kontrolllampen erst, wenn alles abgekühlt ist
								spec.forDBL_warnheat = 0
								if spec.forDBL_critdamage == 1 then
									-- spec.forDBL_warndamage = 1
								elseif spec.forDBL_critdamage ~= 1 then
									spec.forDBL_warndamage = 0
									spec.forDBL_highpressure = 0
								end
													-- Kritische CVT Schaden-Kontrolllampe geht erst aus, wenn repariert und sich das Fahrzeug Stillstand und Motor AUS->EIN befindet.
							elseif self.spec_motorized.motorTemperature.value < 104 and self.spec_motorized.motorTemperature.value > 94 then
								spec.forDBL_critheat = 0
								spec.forDBL_warnheat = 1
							end
							if cvtaDebugCVTheatOn then
								-- print("Cooling Phase")
								-- print("warnHeat: " .. spec.forDBL_warnheat)
								-- print("critHeat: " .. spec.forDBL_critheat)
								-- print("warnDamage: " .. spec.forDBL_warndamage)
								-- print("critDamage: " .. spec.forDBL_critdamage)
								-- print("Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
							end
							-- Bei etwas mehr Drehzahl, fördert die WaPu mehr Wasser und die Kühlleistung nimmt zu. Zuviel Drehzahl hat keinen Mehrwert.
							if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 100 and self.spec_motorized.motor.lastMotorRpm < self.spec_motorized.motor.minRpm + 400  then
								self.spec_motorized.motorTemperature.coolingPerMS = math.max( math.min( ((sspMOT.maxRpm/100000)*(sspMOT.lastMotorRpm/10000)), 0.0034 ), 0.003)
								-- self.spec_motorized.motorTemperature.coolingPerMS = 2.0 / 1000
							else
								self.spec_motorized.motorTemperature.coolingPerMS = 3.0 / 1000
							end
						end
						if self.spec_motorized.motor.smoothedLoadPercentage <= 0.6 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) <= 0.5 then
							if self.spec_motorized.motorTemperature ~= nil then
								if self.spec_motorized.motorTemperature.value > 90 and self.spec_motorized.motorTemperature.value < 105 then
									if spec.forDBL_critheat == 1 then
										spec.forDBL_warnheat = 1
										spec.forDBL_critheat = 0
									end
								end
								if self.spec_motorized.motorTemperature.value < 90 then
									if spec.forDBL_critheat ~= 1 then
										spec.forDBL_warnheat = 0
									end
								end
								if self.spec_motorized.motorTemperature.value < 83 then
									-- self.spec_motorized.motorTemperature.coolingPerMS = 2.0 / 1000
									self.spec_motorized.motorTemperature.heatingPerMS = 1.5 / 1000
								end
							end
						end
						-- Ist der Motor kalt, dreh ihn nur halb.
						if self.spec_motorized.motorTemperature.value < 55 and self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.maxRpm /1.6 then
							spec.forDBL_warndamage = 1
						elseif self.spec_motorized.motorTemperature.value < 55 and self.spec_motorized.motor.lastMotorRpm <= self.spec_motorized.motor.maxRpm /1.6 then
							spec.forDBL_warndamage = 0
							spec.forDBL_highpressure = 0
						end
						if self.spec_motorized.motorTemperature.value < 55 and self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.maxRpm /1.3  then
							if spec.forDBL_critdamage == 0 then
								if self.getIsEntered ~= nil and self:getIsEntered() then
									spec.CVTdamage = math.min(spec.CVTdamage + (self.spec_motorized.motorTemperature.value/1250),100)
									if self.spec_RealisticDamageSystem == nil then
										-- self:addDamageAmount(self.spec_motorized.motorTemperature.value/1250)
									end
								end
							end
							spec.forDBL_critdamage = 1
						elseif self.spec_motorized.motorTemperature.value < 55 and self.spec_motorized.motor.lastMotorRpm <= self.spec_motorized.motor.maxRpm /1.6 then
							spec.forDBL_critdamage = 0
						end
						if self.spec_motorized.motorTemperature.value < 55 then
							spec.forDBL_motorcoldlamp = 1
							-- self:raiseActive()
						else
							spec.forDBL_motorcoldlamp = 0
						end
					end
					-- ODB END
				
					-- -- FAHRSTUFE II. classic (Street/light weight transport or work) inputbinding =====================================
					if spec.vOne >= 2 and spec.isVarioTM and spec.CVTconfig ~= 7
					and ( spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 ) and spec.cvtDL ~= 1 then
						-- if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
						-- Planetengetriebe / Hydromotor Übersetzung
						spec.isHydroState = false
						-- self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.95 + (self.spec_motorized.motor.rawLoadPercentage*9)
						self.spec_motorized.motor.minForwardGearRatio =  self.spec_motorized.motor.minForwardGearRatioOrigin
						self.spec_motorized.motor.maxForwardGearRatio =  self.spec_motorized.motor.maxForwardGearRatioOrigin
						self.spec_motorized.motor.minBackwardGearRatio = self.spec_motorized.motor.minBackwardGearRatioOrigin
						self.spec_motorized.motor.maxBackwardGearRatio = self.spec_motorized.motor.maxBackwardGearRatioOrigin
						local motor = self.spec_motorized.motor
					    local axis = self.spec_drivable.axisForward or 0
				        local dir = motor.currentDirection or 1
						-- TMS like
						-- wenn Tempomat aus, wird die Tempomatgeschwindigkeit als Steps der maxSpeed benutzt
						if spec.isTMSpedal == 1 and self:getCruiseControlState() == 0 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) > 0.02 then -- PedalTMS
					        -- Setze die maxSpeed proportional zum Pedal
					        local maxSpeed = math.min(self:getCruiseControlSpeed(), (motor.maxForwardSpeedOrigin))
					        if dir == -1 then
					            maxSpeed = math.min(self:getCruiseControlSpeed(), (motor.maxBackwardSpeedOrigin))
					        end

					        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
							
							-- self.spec_motorized.motor.maxBackwardSpeed = (math.min(self:getCruiseControlSpeed(), (self.spec_motorized.motor.maxBackwardSpeedOrigin * math.abs(self.spec_motorized.motor.lastAcceleratorPedal))))
							-- self.spec_motorized.motor.maxForwardSpeed = (math.min(self:getCruiseControlSpeed(), (self.spec_motorized.motor.maxForwardSpeedOrigin * math.abs(self.spec_motorized.motor.lastAcceleratorPedal))))
							
							
							self.spec_motorized.motor.motorAppliedTorque = math.max(self.spec_motorized.motor.motorAppliedTorque, 0.5)
						-- Utils.getNoNil(self:getDamageAmount(), 0)
						elseif spec.isTMSpedal == 0 then
							if self.spec_motorized.motor ~= nil then
								-- if self:getDamageAmount() > 0.7 and spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then
								if spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then -- Notlauf
									self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne / 2.5 * math.max((1-spec.ClutchInputValue), 0.01)
									self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne / 2.5 * math.max((1-spec.ClutchInputValue), 0.01)
									-- self.spec_motorized.motor.accelerationLimit = 0.25
									-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale
									-- self.spec_motorized.motor.accelerationLimit = math.min(self.spec_motorized.motor.accelerationLimit
								elseif spec.forDBL_critdamage == 0 then 																	-- Normalbetrieb
									-- Setze die maxSpeed proportional zum Pedal
							        local maxSpeed = motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        if dir == -1 then
							            maxSpeed = motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        end
							        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
									-- self.spec_motorized.motor.maxForwardSpeed  =  self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne
									-- self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne
								else 																										-- nur heat
									local maxSpeed = motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        if dir == -1 then
							            maxSpeed = motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        end
							        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
									-- self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne
									-- self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne
								end
							end
						end
						-- smoothing nicht im Leerlauf
						if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 20 then
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.2 then
							-- if self:getLastSpeed() >= 1 then
								-- Gaspedal and Variator
								-- spec.smoother = spec.smoother + dt;
								-- if spec.smoother ~= nil and spec.smoother > 10 then -- Drehzahl zucken eliminieren
									-- spec.smoother = 0;
									if self:getLastSpeed() > 0.5 then
										self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(math.min((self:getLastSpeed() * math.abs(math.max(self.spec_motorized.motor.rawLoadPercentage, 0.55)))*42, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+203), self.spec_motorized.motor.lastPtoRpm*0.7), self.spec_motorized.motor.maxRpm*spec.HandgasPercent)
										if cvtaDebugCVTxOn == true then
											-- print("0: " .. tostring(self:getLastSpeed()))
										end
										-- Drehzahl Erhöhung angleichen zur Motorbremswirkung, wenn Pedal losgelassen wird FS2
										if math.max(0, self.spec_drivable.axisForward) < 0.1 and spec.ClutchInputValue ~= 1 then
											-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm)
											self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm + (math.abs(self:getLastSpeed()) * 19), self.spec_motorized.motor.maxRpm)
											-- self.spec_motorized.motor.rawLoadPercentage = self.spec_motorized.motor.rawLoadPercentage - (self:getLastSpeed() / 50)
											if cvtaDebugCVTon == true then
												print("## Angleichen zur Motorbremswirkung,  Pedal losgelassen: " .. math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm))
											end
										end
										
										-- Drehzahl Erhöhung sobald Pedal wieder aktiviert wird zur Fahrt in Fahrt FS2
										-- (self:getLastSpeed()/math.pi) / (self.spec_motorized.motor.maxForwardSpeed)
										if math.max(0, self.spec_drivable.axisForward) >= 0.05 and self:getLastSpeed() >= 15 and self:getLastSpeed() <= (self.spec_motorized.motor.maxForwardSpeed*3.6)-6 then
											self.spec_motorized.motor.lastMotorRpm = math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.03, self.spec_motorized.motor.maxRpm), self.spec_motorized.motor.lastPtoRpm*1.01)
											if cvtaDebugCVTon == true then
												print("## Drehzahl Erhöhung sobald Pedal wieder aktiviert wird zur Fahrt in Fahrt: " .. math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.7))
												print("## self:getDamageAmount(): " .. self:getDamageAmount())
											end
										end
									end
								-- end -- smooth
							end
														
							-- Nm kurven für unterschiedliche Lasten, Berücksichtigung pto FS2
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.4 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.984 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = 0.0015
								end
							end
							if self:getLastSpeed() < ((self.spec_motorized.motor.maxForwardSpeed*3.6) - 2) then
								if self.spec_motorized.motor.smoothedLoadPercentage >= 0.4 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.5 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.985 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.5 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.65 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.9875 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.65 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.989 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.7 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.75 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.992 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.75 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.8 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.994 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.8 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.85 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.996 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
								end
								if self.spec_motorized.motor.smoothedLoadPercentage > 0.85 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.9 then
									self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.998 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
								end
							end
							-- Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt FS2
							if math.max(0, self.spec_drivable.axisForward) >= 0.02 and self:getLastSpeed() <= 8 then
								self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.7)
								if cvtaDebugCVTon == true then
									print("## Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt: " .. math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.7))
									print("## self:getDamageAmount(): " .. self:getDamageAmount())
								end
							end
							
							if (
							 self.spec_motorized.motor.smoothedLoadPercentage > (1.15 - (spec.vTwo/12))
							 )
							 and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)/(spec.vTwo/10.3))
							  then
								self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm * 0.993 * mcRPMvar, self.spec_motorized.motor.lastPtoRpm*0.6)
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0023 * self.spec_motorized.motor.rawLoadPercentage, 0.0015)
								end
								if self.spec_motorized.motorTemperature.value > 94 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										-- spec.forDBL_warndamage = 1
									end
									if self:getDamageAmount() ~= nil then
										if self:getDamageAmount() > 0.6 then
											-- spec.forDBL_critdamage = 1
											-- spec.forDBL_warndamage = 0
										end
									end
								elseif self.spec_motorized.motorTemperature.value <= 95 then
									spec.forDBL_warnheat = 0
									spec.forDBL_critheat = 0
								end
								if cvtaDebugCVTheatOn then
									print("##1 load > 0.9")
									print("##1 warnHeat: " .. spec.forDBL_warnheat)
									print("##1 critHeat: " .. spec.forDBL_critheat)
									print("##1 warnDamage: " .. spec.forDBL_warndamage)
									print("##1 critDamage: " .. spec.forDBL_critdamage)
									print("##1 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									print("##1 heatingPerMS: " .. 0.0018 * self.spec_motorized.motor.rawLoadPercentage)
								end
								if cvtaDebugCVTxOn == true then
									print("##1 CVTa: II. > ".. (1.15 - (spec.vTwo/12) )*100 .." %r - Weighted, vTwo=" .. spec.vTwo)
									print("##1 addDamage: ".. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
								end
							end

							-- Wenn ein abgesenktes Anbaugerät zu schwere Last erzeugt und abgesenkt ist, schafft es die 2. Fahrstufe nicht II.
							if self.spec_motorized.motor.smoothedLoadPercentage > (1.05 - (spec.vTwo/21) ) and spec.impIsLowered == true then
								if g_client ~= nil and isActiveForInputIgnoreSelection then
									g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 1024)
									spec.forDBL_highpressure = 1
								end
								self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 1
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0035 * self.spec_motorized.motor.rawLoadPercentage / (1.5-spec.vTwo/10), 0.0015)
									-- self.spec_motorized.motorTemperature.coolingPerMS = 0.70 / 1000
								end
								if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
									spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4),100)
									if self.spec_RealisticDamageSystem == nil then
										if spec.CVTdamage >= 80 then
											-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4)
										end
									end
								end
								if self.spec_motorized.motorTemperature.value > 95 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										spec.forDBL_warndamage = 1
									end
									if spec.CVTdamage > 70 then
										if spec.forDBL_critdamage == 1 then
											-- Motor abwürgen
											-- self:stopMotor()
											print("##2 Motor abgewürgt")
											-- self:stopMotor(false)
										end
										spec.forDBL_critdamage = 1
										spec.forDBL_warndamage = 0
									end
								end
								if cvtaDebugCVTheatOn then
									print("##2 load > ".. (1.05 - (spec.vTwo/13) ) .."r   lowered")
									print("##2 warnHeat: " .. spec.forDBL_warnheat)
									print("##2 critHeat: " .. spec.forDBL_critheat)
									print("##2 warnDamage: " .. spec.forDBL_warndamage)
									print("##2 critDamage: " .. spec.forDBL_critdamage)
									print("##2 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									print("##2 heatingPerMS: " .. 0.0090 * self.spec_motorized.motor.rawLoadPercentage)
								end
								if cvtaDebugCVTxOn == true then
									print("##2 CVTa: II. > ".. (1.05 - (spec.vTwo/10) )*100 .." %r - Lowered, vTwo=" .. spec.vTwo)
									print("##2 addDamage: ".. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
									-- print("mass() - mass(true)>=mass(true)" .. (self:getTotalMass() - self:getTotalMass(true)) .. " >= " .. (self:getTotalMass(true)))
								end
							end
							-- Wenn ein Anbaugerät zu schwere Last erzeugt, schafft es die 2. Fahrstufe nicht oder nimmt Schaden II.
							if self.spec_motorized.motor.smoothedLoadPercentage > (1.222 - (spec.vTwo/9) ) and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)) and spec.vTwo > 3 then
								-- g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 2048)
								-- self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.95 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.8)
								self.spec_motorized.motor.lastPtoRpm = math.max(self.spec_motorized.motor.lastPtoRpm * 0.6, 0)
								self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 100
								-- self.spec_motorized.motor.maxForwardSpeed = ( (self:getLastSpeed()-1.5) / math.pi )  -- fs25 overrides the vmaxlimit and do not despeeds
								-- self.spec_motorized.motor.maxBackwardSpeed = ( (self:getLastSpeed()-0.5) / math.pi )
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max((0.0024 + (spec.vTwo^2/10000)), 0.0015)
									-- self.spec_motorized.motorTemperature.coolingPerMS = 1.2 / 1000
								end
								if spec.forDBL_critheat == 1 and spec.forDBL_warndamage == 1 or spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
									spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4), 100)
									if self.spec_RealisticDamageSystem == nil then
										if spec.CVTdamage >= 50 then
											-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4)
										end
									end
									if cvtaDebugCVTheatOn then
										print("##3 addDamage: " .. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *2.4) )
									end
								end
								if self.spec_motorized.motorTemperature.value > 95 and self.spec_motorized.motorTemperature.value <= 105 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										spec.forDBL_warndamage = 1
									end
									-- if self:getDamageAmount() ~= nil then
									if spec.CVTdamage > 80 then
										spec.forDBL_critdamage = 1
										spec.forDBL_warndamage = 0
									end
									-- end
								end
								if cvtaDebugCVTheatOn then
									print("##3 load > " .. (1.222 - (spec.vTwo/9) .. " mass AR4"))
									print("##3 warnHeat: " .. spec.forDBL_warnheat)
									print("##3 critHeat: " .. spec.forDBL_critheat)
									print("##3 warnDamage: " .. spec.forDBL_warndamage)
									print("##3 critDamage: " .. spec.forDBL_critdamage)
									print("##3 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									print("##3 heatingPerMS = " .. self.spec_motorized.motorTemperature.heatingPerMS)
									print("##3 coolingPerMS = " .. self.spec_motorized.motorTemperature.coolingPerMS)
									print("##3 coolingByWindPerMS = " .. self.spec_motorized.motorTemperature.coolingByWindPerMS)
								end
								self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm +10
								local massDiff = (self:getTotalMass() - self:getTotalMass(true)) / 100
								if cvtaDebugCVTxOn == true then
									print("##3 CVTa: II. > " .. (1.222 - (spec.vTwo/9))*100 .. " %r - Mass, AR4, vTwo=" .. spec.vTwo)
									print("##3 CVTa: II. > " .. (1.222 - (spec.vTwo/9))*100 .. " %r - Mass, AR4, forDBL_warnheat=" .. spec.forDBL_warnheat)
									print("##3 mass("..self:getTotalMass()..") - mass(true)>=mass(true)" .. (self:getTotalMass() - self:getTotalMass(true)) .. " >= " .. (self:getTotalMass(true)))
								end
								
								-- Getriebeschaden erzeugen nur klassisch  II.
								if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
									if self.spec_motorized.motor.smoothedLoadPercentage > 0.98  then
										if g_client ~= nil and isActiveForInputIgnoreSelection then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 1024)
											spec.forDBL_highpressure = 1
										end
										if self.spec_motorized.motorTemperature ~= nil then
											self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0022 * self.spec_motorized.motor.rawLoadPercentage, 0.0015)
										end
										-- self.spec_motorized.motorTemperature.coolingPerMS = 0.65 / 1000
										if self.spec_motorized.motorTemperature.value > 95 and spec.forDBL_critheat ~= 1 then
											spec.forDBL_warnheat = 1
										elseif self.spec_motorized.motorTemperature.value > 105 then
											spec.forDBL_critheat = 1
											spec.forDBL_warnheat = 0
											if spec.forDBL_critdamage ~= 1 then
												-- spec.forDBL_warndamage = 1
											end
											if self:getDamageAmount() ~= nil then
												if self:getDamageAmount() > 0.6 then
													-- spec.forDBL_critdamage = 1
													-- spec.forDBL_warndamage = 0
												end
											end
										end
										if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 150 then
											if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
												spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4),100)
												if self.spec_RealisticDamageSystem == nil then
													if spec.CVTdamage >= 80 then
														-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4)
													end
												end
												if cvtaDebugCVTheatOn then
													print("##4 addDamage: " .. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4) )
												end
											end
											if self.spec_motorized.motorTemperature.value > 95 and spec.forDBL_critheat ~= 1 then
												spec.forDBL_warnheat = 1
											elseif self.spec_motorized.motorTemperature.value > 105 then
												spec.forDBL_critheat = 1
												spec.forDBL_warnheat = 0
												if spec.forDBL_critdamage ~= 1 then
													spec.forDBL_warndamage = 1
												end
												if spec.CVTdamage > 80 then
													spec.forDBL_critdamage = 1
													spec.forDBL_warndamage = 0
												end
											end
											if cvtaDebugCVTheatOn then
												print("##4 rpm > min+150 classic")
												print("##4 warnHeat: " .. spec.forDBL_warnheat)
												print("##4 critHeat: " .. spec.forDBL_critheat)
												print("##4 warnDamage: " .. spec.forDBL_warndamage)
												print("##4 critDamage: " .. spec.forDBL_critdamage)
												print("##4 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
												print("##4 heatingPerMS: " .. 0.0110 * self.spec_motorized.motor.rawLoadPercentage)
												print("##4 CVTa: II. > 98 % - Mass, AR3, Damage=" .. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
											end
											-- self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
											-- self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
											self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * 1.14 * mcRPMvar
											-- self.spec_motorized.motor.accelerationLimit = 0.01
											
											-- ToDo: 
											-- - find a way to reduciion speed or forwarding like gear ratio
											
											if cvtaDebugCVTxOn == true then
												print("##4 CVTa: II. > 98 % - Mass, AR3, vTwo=" .. spec.vTwo .. " damage: " .. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4) )
												print("##4 CVTa: II. > 98 % - Mass, AR3, forDBL_critHeat=" .. spec.forDBL_critheat)
												print("##4 CVTa: II. > 98 % - Mass, AR3, forDBL_warnDamage=" .. spec.forDBL_warndamage)
											end
										end
									end
									if spec.impIsLowered == true and self.spec_motorized.motor.rawLoadPercentage > 0.97 then
										if g_client ~= nil and isActiveForInputIgnoreSelection then
											g_currentMission:showBlinkingWarning(g_i18n:getText("txt_attCVTpressure"), 1024)
											spec.forDBL_highpressure = 1
										end
										if self.spec_motorized.motorTemperature ~= nil then
											self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0045 * self.spec_motorized.motor.rawLoadPercentage, 0.0015)
											-- self.spec_motorized.motorTemperature.heatingPerMS = 0.0045 * self.spec_motorized.motor.rawLoadPercentage -- 30% Last < default
										end
										if spec.forDBL_critheat == 1 and spec.forDBL_critdamage == 1 then
											spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5),100)
											if self.spec_RealisticDamageSystem == nil then
												if spec.CVTdamage >= 80 then
													-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5)
												end
											end
										end
										if self.spec_motorized.motorTemperature.value > 95 and spec.forDBL_critheat ~= 1 then
											spec.forDBL_warnheat = 1
										elseif self.spec_motorized.motorTemperature.value > 105 then
											spec.forDBL_critheat = 1
											spec.forDBL_warnheat = 0
											if spec.forDBL_critdamage ~= 1 then
												spec.forDBL_warndamage = 1
											end
											if spec.CVTdamage > 80 then
												if spec.forDBL_critdamage == 1 then
													-- Motor abwürgen
													-- self:stopMotor()
													-- self:stopMotor(false)
													print("##5 Motor abgewürgt")
												end
												spec.forDBL_critdamage = 1
												spec.forDBL_warndamage = 0
											end
										end
										if cvtaDebugCVTheatOn then
											print("##5 load > 0.97 lowered classic")
											print("##5 warnHeat: " .. spec.forDBL_warnheat)
											print("##5 critHeat: " .. spec.forDBL_critheat)
											print("##5 warnDamage: " .. spec.forDBL_warndamage)
											print("##5 critDamage: " .. spec.forDBL_critdamage)
											print("##5 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
											print("##5 heatingPerMS: " .. 0.080 * self.spec_motorized.motor.rawLoadPercentage)
											print("##5 addDamage lowered: "  .. (self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 ))*0.7)
										end
										self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.maxBackwardSpeed = ( self:getLastSpeed() / math.pi ) - 2
										self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm * 1.5 * mcRPMvar
										if cvtaDebugCVTxOn == true then
											print("##5 CVTa: II. > 97 % - Mass, AR3, vTwo=" .. spec.vTwo)
										end
									end
								end
							end
							-- HydroPumpe abschwenken auf nur mechanischen Antrieb bei vMax FS2
							-- ToDo: assign with vca.keepspeed
							-- 			kmh 		> 				max kmh								-						max kmh                     :14
							--          47							16.87 * 3.141592654 (53) 		    -                 "   (53)/14= 3.786    53-3.786= 49.214 kmh
							
							-- if self:getLastSpeed() > 15 then
								-- if ( math.max(0, self.spec_drivable.axisForward) > 0.5 and math.max(0, self.spec_drivable.axisForward) < 0.99 ) and self.spec_motorized.motor.lastMotorRpm < (self.spec_motorized.motor.maxRpm - 400) then
									-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * 1.8 * mcRPMvar, self.spec_motorized.motor.maxRpm -50)
								-- end
							-- end
							-- print("DT: "..dt)
							if self:getLastSpeed() > ((self.spec_motorized.motor.maxForwardSpeed*3.6) - 3) and self.spec_drivable.axisForward >= 0.1 then
							-- Ändert die Drehzahl wenn man sich der vMax nähert  ##here  II. FS2
								-- self.spec_motorized.motor.lastMotorRpm = math.min((self.spec_motorized.motor.lastMotorRpm*1.05) + (self:getLastSpeed()/(8*mcRPMvar) ), self.spec_motorized.motor.maxRpm-18)
								self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.maxRpm-18, self.spec_motorized.motor.maxRpm*0.77*( (self:getLastSpeed() / math.pi) / (self.spec_motorized.motor.maxForwardSpeed)) )
								-- self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.lastMotorRpm *
								-- if self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 then
									-- self.spec_motorized.motor.smoothedLoadPercentage = math.max(self.spec_motorized.motor.smoothedLoadPercentage , ( (self:getLastSpeed()/math.pi) / (self.spec_motorized.motor.maxForwardSpeed)) )
								-- end
								if cvtaDebugCVTon == true then
									print("## Ändert die Drehzahl wenn man sich der vMax nähert: ")
								end
							end
						end
						local currentRpm = motor.lastMotorRpm or motor.minRpm
					    local targetRpm = motor.motorRpm or currentRpm  -- Ist-Wert vom Motor
					    local blendSpeed = 5  -- je höher, desto schneller reagiert es

					    local lerpFactor = math.min(1, dt * 0.001 * blendSpeed)
					    motor.lastMotorRpm = currentRpm + (targetRpm - currentRpm) * lerpFactor
					end -- FSII.
					
	-- MODERN CURVES =====================================
					if spec.isVarioTM and spec.CVTconfig ~= 7 and ( spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 ) then
						local motor = self.spec_motorized.motor
					    local axis = self.spec_drivable.axisForward or 0
				        local dir = motor.currentDirection or 1
						if self.spec_vca ~= nil then
							if math.abs(self.spec_drivable.axisForward) > 0.75 and self.spec_vca.handbrake == true and self:getLastSpeed() < 1 then
								self.spec_vca.handbrake = false
							else
								--
							end
						end

						if spec.cvtDL ~= 2 then
							spec.cvtDL = 2
						end
						-- if self:getLastSpeed() < 10 then
						if self:getLastSpeed() < 14 or self.spec_motorized.motor.smoothedLoadPercentage >= 0.7 then
							spec.vOne = 1
							spec.forDBL_drivinglevel = 1
						-- elseif self:getLastSpeed() >= 10 then
						elseif self:getLastSpeed() >= 14 or self.spec_motorized.motor.smoothedLoadPercentage < 0.7 then
							spec.vOne = 2
							spec.forDBL_drivinglevel = 2
						end

						-- Planetengetriebe / Hydromotor Übersetzung
						spec.isHydroState = false
						self.spec_motorized.motor.minForwardGearRatio = self.spec_motorized.motor.minForwardGearRatioOrigin
						self.spec_motorized.motor.maxForwardGearRatio = self.spec_motorized.motor.maxForwardGearRatioOrigin
						self.spec_motorized.motor.minBackwardGearRatio = self.spec_motorized.motor.minBackwardGearRatioOrigin
						self.spec_motorized.motor.maxBackwardGearRatio = self.spec_motorized.motor.maxBackwardGearRatioOrigin
						
						-- TMS like
						-- wenn Tempomat aus, wird die Tempomatgescwindigkeit als Steps der maxSpeed benutzt
						if spec.isTMSpedal == 1 and self:getCruiseControlState() == 0 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) > 0.02 then
							self.spec_motorized.motor.maxBackwardSpeed = (math.min(self:getCruiseControlSpeed(), (self.spec_motorized.motor.maxBackwardSpeedOrigin * math.abs(self.spec_motorized.motor.lastAcceleratorPedal))))
							self.spec_motorized.motor.maxForwardSpeed = (math.min(self:getCruiseControlSpeed(), (self.spec_motorized.motor.maxForwardSpeedOrigin * math.abs(self.spec_motorized.motor.lastAcceleratorPedal))))
							self.spec_motorized.motor.motorAppliedTorque = math.max(self.spec_motorized.motor.motorAppliedTorque, 0.5)
						-- Utils.getNoNil(self:getDamageAmount(), 0)
						elseif spec.isTMSpedal == 0 then
							if self.spec_motorized.motor ~= nil then
								-- if self:getDamageAmount() > 0.7 and spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then
								if spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then 																					-- Notlauf
									self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.02) / 2.8 * math.max((1-spec.ClutchInputValue), 0.01)
									self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.02) / 2.8 * math.max((1-spec.ClutchInputValue), 0.01)
									-- self.spec_motorized.motor.accelerationLimit = 0.25
									-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1-spec.ClutchInputValue),0.04)
									-- self.spec_motorized.motor.accelerationLimit = math.min(self.spec_motorized.motor.accelerationLimit * (1-spec.ClutchInputValue),0.25)
								elseif spec.forDBL_critdamage == 0 then 																							-- Normalbetrieb
									-- Setze die maxSpeed proportional zum Pedal
							        local maxSpeed = motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        if dir == -1 then
							            maxSpeed = motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        end
							        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
									-- self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.01)
									-- self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.01)
									-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1-spec.ClutchInputValue),0.04)
									-- self.spec_motorized.motor.accelerationLimit = self.spec_motorized.motor.accelerationLimit * (1-spec.ClutchInputValue)
								else
									local maxSpeed = motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        if dir == -1 then
							            maxSpeed = motor.maxBackwardSpeedOrigin / spec.cvtDL * spec.vOne * math.max((1-spec.ClutchInputValue), 0.01)
							        end
							        motor.motorLimitSpeed = math.abs(axis) * maxSpeed
									-- self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.01)
									-- self.spec_motorized.motor.maxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeedOrigin * math.max((1-spec.ClutchInputValue), 0.01)
								end
							end
						end
						
						
						-- smoothing nicht im Leerlauf
						if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 20 then
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.2 then
							-- if self:getLastSpeed() >= 1 then
								-- Gaspedal and Variator
								-- spec.smoother = spec.smoother + dt;
								-- if spec.smoother ~= nil and spec.smoother > 10 then -- Drehzahl zucken eliminieren
									-- spec.smoother = 0;
									if self:getLastSpeed() > 0.5 then
										self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(math.min((self:getLastSpeed() * math.abs(math.max(self.spec_motorized.motor.rawLoadPercentage, 0.55)))*42, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+203), self.spec_motorized.motor.lastPtoRpm*0.7), self.spec_motorized.motor.maxRpm*spec.HandgasPercent)
										if cvtaDebugCVTxOn == true then
											-- print("0: " .. tostring(self:getLastSpeed()))
										end
										-- Drehzahl Erhöhung angleichen zur Motorbremswirkung, wenn Pedal losgelassen wird MODERN
										if math.max(0, self.spec_drivable.axisForward) < 0.1 then
											-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm)
											self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm + (math.abs(self:getLastSpeed()) * 14), self.spec_motorized.motor.maxRpm)
											-- self.spec_motorized.motor.rawLoadPercentage = self.spec_motorized.motor.rawLoadPercentage - (self:getLastSpeed() / 50)
											if cvtaDebugCVTon == true then
												print("## Angleichen zur Motorbremswirkung, Pedal losgelassen: " .. math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm))
											end
										end
									end
								-- end -- smooth
							end
							
																					
							-- Nm kurven für unterschiedliche Lasten, Berücksichtigung pto MODERN
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.4 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.983 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = 0.0015
									-- self.spec_motorized.motorTemperature.coolingPerMS = 0.002
								end
							end
							if self.spec_motorized.motor.smoothedLoadPercentage >= 0.4 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.5 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.992 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.5 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.65 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.984 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.88)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.65 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.9865 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.7 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.75 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.9885 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.75 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.8 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.99 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.8 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.85 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.9925 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.85 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.9 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.995 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.9 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.99 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.9975 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							
							-- Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt MODERN
							if math.max(0, self.spec_drivable.axisForward) >= 0.02 and self:getLastSpeed() <= 7 then
								self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.7)
								if cvtaDebugCVTon == true then
									print("### Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt: " .. math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.7))
									print("### self:getDamageAmount(): " .. self:getDamageAmount())
								end
							end
							
							-- Fahrzeug nicht leer
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.95 and spec.vTwo > 3 and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)) then
								self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm * 0.993 * mcRPMvar, self.spec_motorized.motor.lastPtoRpm*0.6)
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max( (0.0011 + (spec.vTwo^2/10000)) , 0.0015)
								end
								self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - (spec.vTwo/2)
								spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5),100)
								if self.spec_RealisticDamageSystem == nil then
									if spec.CVTdamage >= 80 then
										-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5)
									end
								end
								
								-- print("###0 TEST: " ..((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4) )
																
								if self.spec_motorized.motorTemperature.value > 96 and spec.forDBL_critheat ~= 1 then
									spec.forDBL_warnheat = 1
								elseif self.spec_motorized.motorTemperature.value > 105 then
									spec.forDBL_critheat = 1
									spec.forDBL_warnheat = 0
									if spec.forDBL_critdamage ~= 1 then
										spec.forDBL_warndamage = 1
									end
									if self:getDamageAmount() ~= nil then
										if self:getDamageAmount() > 0.6 then
											-- spec.forDBL_critdamage = 1
											-- spec.forDBL_warndamage = 0
										end
									end
								elseif self.spec_motorized.motorTemperature.value <= 96 then
									spec.forDBL_warnheat = 0
									spec.forDBL_critheat = 0
								end
								
								if cvtaDebugCVTheatOn then
									print("###1 load > 0.9")
									print("###1 warnHeat: " .. spec.forDBL_warnheat)
									print("###1 critHeat: " .. spec.forDBL_critheat)
									print("###1 warnDamage: " .. spec.forDBL_warndamage)
									print("###1 critDamage: " .. spec.forDBL_critdamage)
									print("###1 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
									print("###1 heatingPerMS: " .. self.spec_motorized.motorTemperature.heatingPerMS)
								end
								if cvtaDebugCVTxOn == true then
									print("###1 CVTa: M. > ".. (1.05 - (spec.vTwo/10) )*100 .." %r, vTwo=" .. spec.vTwo)
									print("###1 addDamage: ".. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
									print("###1 heatingPerMS.: " .. self.spec_motorized.motorTemperature.heatingPerMS)
								end
							end

							
							-- Wenn ein Anbaugerät zu schwere Last erzeugt, steigt der Druck je nach Beschleunigungsrampe.
							if self.spec_motorized.motor.smoothedLoadPercentage > (1.20 - (spec.vTwo/10) ) and (self:getTotalMass() - self:getTotalMass(true)) >= (self:getTotalMass(true)) and spec.vTwo >= 3 and spec.impIsLowered == true then
								if self.spec_motorized.motorTemperature ~= nil then
									self.spec_motorized.motorTemperature.heatingPerMS = math.max(0.0031 * self.spec_motorized.motor.rawLoadPercentage   / (1.8-spec.vTwo/10), 0.0015)
									-- self.spec_motorized.motor.maxForwardSpeed = ( self:getLastSpeed() / math.pi ) - spec.vTwo
									spec.CVTdamage = math.min(spec.CVTdamage + ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5),100)
									if self.spec_RealisticDamageSystem == nil then
										if spec.CVTdamage >= 80 then
											-- self:addDamageAmount((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.5)
										end
									end
									
									if self.spec_motorized.motorTemperature.value > 96 and spec.forDBL_critheat ~= 1 then
										spec.forDBL_warnheat = 1
									elseif self.spec_motorized.motorTemperature.value > 105 then
										spec.forDBL_critheat = 1
										spec.forDBL_warnheat = 0
										if spec.forDBL_critdamage ~= 1 then
											spec.forDBL_warndamage = 1
										end
										if self:getDamageAmount() ~= nil then
											if self:getDamageAmount() > 0.6 then
												spec.forDBL_critdamage = 1
												spec.forDBL_warndamage = 0
											end
										end
									elseif self.spec_motorized.motorTemperature.value <= 96 then
										spec.forDBL_warnheat = 0
										spec.forDBL_critheat = 0
									end
									
									if cvtaDebugCVTheatOn then
										print("###2 load > ".. (1.222 - (spec.vTwo/9) ))
										print("###2 warnHeat: " .. spec.forDBL_warnheat)
										print("###2 critHeat: " .. spec.forDBL_critheat)
										print("###2 warnDamage: " .. spec.forDBL_warndamage)
										print("###2 critDamage: " .. spec.forDBL_critdamage)
										print("###2 Temp: " .. self.spec_motorized.motorTemperature.value .. "°C")
										print("###2 heatingPerMS: " .. self.spec_motorized.motorTemperature.heatingPerMS)
									end
									if cvtaDebugCVTxOn == true then
									print("###2 CVTa: M. > ".. (1.05 - (spec.vTwo/10) )*100 .." %r, vTwo=" .. spec.vTwo)
									print("###2 addDamage: ".. ((self.spec_motorized.motor.smoothedLoadPercentage * ((self:getTotalMass() - self:getTotalMass(true)) / 1000 )) *0.4))
									print("###2 heatingPerMS.: " .. self.spec_motorized.motorTemperature.heatingPerMS)
								end
								end
							end
							
							-- if self:getLastSpeed() > 15 then
								-- if ( math.max(0, self.spec_drivable.axisForward) > 0.5 and math.max(0, self.spec_drivable.axisForward) < 0.99 ) and self.spec_motorized.motor.lastMotorRpm < (self.spec_motorized.motor.maxRpm - 400) then
									-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * 1.6 * mcRPMvar, self.spec_motorized.motor.maxRpm -50)
								-- end
							-- end
							
							-- Ändert die Drehzahl wenn man sich der vMax nähert  ##here  II. MODERN
							-- HydroPumpe abschwenken auf nur mechanischen Antrieb bei vMax
							-- ToDo: assign with vca.keepspeed
							-- 			kmh 		> 				max kmh								-						max kmh                     :14
							--          47							16.87 * 3.141592654 (53) 		    -                 "   (53)/14= 3.786    53-3.786= 49.214 kmh
							if self:getLastSpeed() > ((self.spec_motorized.motor.maxForwardSpeed*3.6) - 1) then
								-- if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 then
									-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm + (self:getLastSpeed()/(11*mcRPMvar) ), self.spec_motorized.motor.maxRpm-18)
									-- self.spec_motorized.motor.smoothedLoadPercentage = math.max(self.spec_motorized.motor.smoothedLoadPercentage, 0.61)
								-- elseif spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
								self.spec_motorized.motor.lastMotorRpm = math.min((self.spec_motorized.motor.lastMotorRpm*0.99) + (self:getLastSpeed()/14 ), self.spec_motorized.motor.maxRpm-21)
								-- end
								if cvtaDebugCVTon == true then
									print("### Ändert die Drehzahl wenn man sich der vMax nähert: ")
								end
							end
						end
					end -- Modern Curves.

	-- MOTORDREHZAHL (Handgas-digital)
					local maxRpm = self.spec_motorized.motor.maxRpm
					local minRpm = self.spec_motorized.motor.minRpm

					if spec.vFive == nil then
						spec.vFive = 0
					end
					if spec.HandgasPercent ~= nil then					-- HG per axis
						spec.vFive = math.max(math.floor(10*spec.HandgasPercent), 0)
						-- print(tostring(spec.moveRpmL))
						if spec.HandgasPercent > 0 then
							if self.spec_motorized.motor.smoothedLoadPercentage <= 0.8 then
								self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm, math.max(self.spec_motorized.motor.minRpm+(self.spec_motorized.motor.maxRpm-self.spec_motorized.motor.minRpm) * spec.HandgasPercent, self.spec_motorized.motor.minRpm) )
							elseif self.spec_motorized.motor.smoothedLoadPercentage > 0.8 then
								self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm, math.max((self.spec_motorized.motor.minRpm+(self.spec_motorized.motor.maxRpm-self.spec_motorized.motor.minRpm) * spec.HandgasPercent) * math.min(math.max(spec.HandgasPercent*1.5, 0.8),1), self.spec_motorized.motor.minRpm) )
								-- self.spec_motorized.motor.lastMotorRpm = math.max(self.spec_motorized.motor.lastMotorRpm, math.max(self.spec_motorized.motor.minRpm+(self.spec_motorized.motor.maxRpm-self.spec_motorized.motor.minRpm) * (math.max(math.min(spec.HandgasPercent*(1.8*self.spec_motorized.motor.smoothedLoadPercentage), 1), 0.6)), self.spec_motorized.motor.minRpm) )  -- push it higher
							end
						end
					else
						spec.HandgasPercent = 0
						spec.vFive = 0
					end -- Handgas
					
					
					
				-- Elektro Stapler
					if spec.CVTconfig == 10 then
						-- print("vTwo: " .. tostring(spec.vTwo))
						-- print("cvtAR: " .. tostring(spec.cvtAR))
						if spec.cvtDL ~= 2 then
							-- print("DL korregiert")
							spec.cvtDL = 2
						end

						local axis = self.spec_drivable.axisForward or 0
					    local motor = self.spec_motorized.motor
					    if motor == nil then return end

					    local maxSpeed = motor.maxForwardSpeedOrigin * 3.6  -- km/h
					    local pedalInput = math.abs(axis)

					    -- Zielgeschwindigkeit bei Pedaleingabe
					    local desiredSpeed = maxSpeed * pedalInput / spec.cvtDL * spec.vOne

					    -- Rekuperation / sanftes Abbremsen wenn kein Pedal gedrückt
					    if pedalInput < 0.01 then
					        self.rekuSpeed = self.rekuSpeed or self:getLastSpeed()

					        -- Abbremsrate (km/h pro Sekunde)
					        local brakeRate = 5  -- Beispiel: 5 km/h/s
					        self.rekuSpeed = math.max(0, self.rekuSpeed - brakeRate * (dt / 1000))
					        desiredSpeed = self.rekuSpeed
					    else
					        self.rekuSpeed = nil
					    end

					    -- Glättung
					    self.smoothedTargetSpeed = self.smoothedTargetSpeed or 0
					    local smoothing = 0.5
					    if desiredSpeed > self.smoothedTargetSpeed then
					        self.smoothedTargetSpeed = desiredSpeed
					    else
					        self.smoothedTargetSpeed = self.smoothedTargetSpeed * (1 - smoothing) + desiredSpeed * smoothing
					    end

					    -- Anwenden (m/s)
					    motor.motorLimitSpeed = self.smoothedTargetSpeed / 3.6


						-- self.spec_motorized.motor.maxForwardSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin / spec.cvtDL * spec.vOne * math.abs(self.spec_motorized.motor.lastAcceleratorPedal),0.01)
						-- self.spec_motorized.motor.maxBackwardSpeed =math.max(self.spec_motorized.motor.maxBackwardSpeedOrigin/ spec.cvtDL * spec.vOne * math.abs(self.spec_motorized.motor.lastAcceleratorPedal),0.01)
						-- self.spec_motorized.motor.accelerationLimit = self.spec_motorized.motor.accelerationLimit / spec.cvtAR * spec.vTwo -- erzeugt fließkomme Fehler 9.950011824203226e-64 1.3266682432270968e-63 8.599638309184327e-77
						self.spec_motorized.motor.accelerationLimit = 2.24 / spec.cvtAR * spec.vTwo
						self.spec_motorized.lastFuelUsage = self.spec_motorized.lastFuelUsage / 2.1 * spec.vTwo

						-- local motor = self.spec_motorized.motor
					    -- if motor == nil then return end

					    local speed = self:getLastSpeed() or 0                      -- aktuelle Geschwindigkeit in km/h
					    -- local maxSpeed = maxSpeed               -- m/s → km/h
					    local minRpm = motor.minRpm or 800
					    local maxRpm = motor.maxRpm or 5000

					    -- Ziel-Drehzahl linear aus Geschwindigkeit
					    local speedFactor = math.max(math.min(speed, 0.01) / maxSpeed, 1)
					    local rpmTarget = minRpm + speedFactor * (maxRpm - minRpm)

					    -- Sanfte Interpolation (Trägheit simulieren)
					    self.prevRpm = self.prevRpm or rpmTarget                    -- Initialisierung
					    local smoothing = 0.2                                       -- 10 % Ziel, 90 % alt — glättet deutlich
					    local rpmSmoothed = self.prevRpm * (1 - smoothing) + rpmTarget * smoothing

					    motor.lastMotorRpm = rpmSmoothed
					    self.prevRpm = rpmSmoothed
						-- self.spec_motorized.motor.lastMotorRpm = self.spec_motorized.motor.maxRpm -- berechnung hier

						-- print("maxForwardSpeed: " .. tostring(self.spec_motorized.motor.maxForwardSpeed))
						-- print("maxBackwardSpeed: " .. tostring(self.spec_motorized.motor.maxBackwardSpeed))
						-- print("accelerationLimit: " .. tostring(self.spec_motorized.motor.accelerationLimit))
					end
					
				-- HARVESTER config Erntemaschine
					if spec.isVarioTM and spec.CVTconfig == 11 then
						
						local combineLeaver = math.abs(self.spec_motorized.motor.lastAcceleratorPedal)
						if spec.cvtDL ~= 2 then
							spec.cvtDL = 2
						end
						-- Planetengetriebe / Hydromotor Übersetzung
						spec.isHydroState = false
						-- self.spec_motorized.motor.gearRatio = self.spec_motorized.motor.gearRatio * 0.95 + (self.spec_motorized.motor.rawLoadPercentage*9)
						-- self.spec_motorized.motor.minForwardGearRatio = self.spec_motorized.motor.minForwardGearRatioOrigin
						-- self.spec_motorized.motor.maxForwardGearRatio = self.spec_motorized.motor.maxForwardGearRatioOrigin
						-- self.spec_motorized.motor.minBackwardGearRatio=self.spec_motorized.motor.minBackwardGearRatioOrigin
						-- self.spec_motorized.motor.maxBackwardGearRatio=self.spec_motorized.motor.maxBackwardGearRatioOrigin
						
						-- TMS like
						-- wenn Tempomat aus, wird die Tempomatgescwindigkeit als Steps der maxSpeed benutzt
						if spec.isTMSpedal == 0 or 1 then
							if self.spec_motorized.motor ~= nil then
								-- if self:getDamageAmount() > 0.7 and spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then
								if spec.forDBL_critdamage == 1 and spec.forDBL_critheat == 1 then -- Notlauf
									self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin / 3
									self.spec_motorized.motor.maxBackwardSpeed=self.spec_motorized.motor.maxBackwardSpeedOrigin / 1.2
									-- self.spec_motorized.motor.accelerationLimit = 0.25
									self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1 - spec.ClutchInputValue),0.02)
									-- self.spec_motorized.motor.accelerationLimit = math.min(self.spec_motorized.motor.accelerationLimit * (1 - spec.ClutchInputValue),0.25)
								elseif spec.forDBL_critdamage == 0 then -- Normalbetrieb
									if spec.vOne == 1 then 																-- FIELDMODE
										-- if self.spec_motorized.motor.lastAcceleratorPedal >= 0.9 then
										self.spec_motorized.motor.lowBrakeForceScale = 0.4
										
										-- Clutchpedal as Inching -pedal
										-- if ccSpeed == nil then local ccSpeed = 1 end
										if self:getCruiseControlState() == 0 then -- inching wenn CC aus
											if spec.inchingState == 1 then
													-- slower
												self.spec_motorized.motor.maxForwardSpeed = math.max( (self.spec_motorized.motor.maxForwardSpeedOrigin * combineLeaver  / spec.cvtAR * spec.vTwo) / 1.5 * math.max( (1 - spec.ClutchInputValue), 0.4), 0.01)
												self.spec_motorized.motor.maxBackwardSpeed= math.max( (self.spec_motorized.motor.maxBackwardSpeedOrigin* combineLeaver  / spec.cvtAR * spec.vTwo) / 1.5 * math.max( (1 - spec.ClutchInputValue), 0.6), 0.01)
											elseif spec.inchingState == 2 then
													-- faster
												self.spec_motorized.motor.maxForwardSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin  / spec.cvtAR * spec.vTwo * (0.6 + spec.ClutchInputValue), 0.01)
												-- self.spec_motorized.motor.motorLimitSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin  / spec.cvtAR * spec.vTwo * (1 + spec.ClutchInputValue), 0.001)
												self.spec_motorized.motor.maxBackwardSpeed= math.max(self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtAR * spec.vTwo * (0.4 + spec.ClutchInputValue), 0.01)
											end
										elseif self:getCruiseControlState() > 0 then -- inching wenn CC an
											if spec.inchingState == 1 then -- slower
												-- self:setCruiseControlMaxSpeed( self:getCruiseControlSpeed() * (2.0 - spec.ClutchInputValue), self:getCruiseControlSpeed() * (2.0 - spec.ClutchInputValue) )
												self.spec_motorized.motor.maxForwardSpeed = ( self:getCruiseControlSpeed() * (1.5 - spec.ClutchInputValue) ) / 3.6
												self.spec_motorized.motor.maxBackwardSpeed= ( self:getCruiseControlSpeed() * (1.5 - spec.ClutchInputValue) ) / 3.6
											elseif spec.inchingState == 2 then  -- faster
												-- self.spec_drivable.lastInputValues.cruiseControlValue = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin  / spec.cvtAR * spec.vTwo * (1 + spec.ClutchInputValue), 1)
												self.spec_motorized.motor.maxForwardSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin  / spec.cvtAR * spec.vTwo * (1 + spec.ClutchInputValue), 0.01)
												-- self.spec_motorized.motor.motorLimitSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin  / spec.cvtAR * spec.vTwo * (1 + spec.ClutchInputValue), 0.01)
												self.spec_motorized.motor.maxBackwardSpeed= math.max(self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtAR * spec.vTwo * (1 + spec.ClutchInputValue), 0.01)
												-- self:getLastSpeed() = self:getLastSpeed() * (1 + spec.ClutchInputValue)
												-- self:setCruiseControlMaxSpeed( ccSpeed, self:getCruiseControlSpeed() * (1.0 + spec.ClutchInputValue) )

												-- self:setCruiseControlMaxSpeed( (self:getCruiseControlSpeed()/3.6)*(2-spec.ClutchInputValue), self:getCruiseControlSpeed() * (1.0 + spec.ClutchInputValue) )
												-- self.spec_motorized.motor.maxForwardSpeed = ( self:getCruiseControlSpeed() * (1.1 + spec.ClutchInputValue) ) / 3.6
												-- self.spec_motorized.motor.maxBackwardSpeed= ( self:getCruiseControlSpeed() * (1.0 + spec.ClutchInputValue) ) / 3.6
												-- self.spec_drivable.lastInputValues.cruiseControlValue = 10 * spec.ClutchInputValue
											end
										end

									elseif spec.vOne == 2 then 												-- STREETMODE
										self.spec_motorized.motor.motorLimitSpeed = math.max(self.spec_motorized.motor.maxForwardSpeedOrigin * combineLeaver / spec.cvtAR * spec.vTwo, 0.001)
										local function lerp(a, b, t)
										    return (1 - t) * a + t * b
										end
										local brakeScale
										local speedRatio = (self:getLastSpeed() / 3.6) / self.spec_motorized.motor.maxForwardSpeedOrigin

										if speedRatio < 0.5 then
										    brakeScale = 0.4
										else
										    local t = (speedRatio - 0.5) / 0.5
										    brakeScale = lerp(0.4, 0.04, t)
										end

										-- print( ("speed=%.2f halfSpeed=%.2f brakeScale=%.3f"):format(speed, halfSpeed, brakeScale) )

										self.spec_motorized.motor.lowBrakeForceScale = brakeScale



										-- self.spec_motorized.motor.motorLimitSpeed = math.max(self.spec_motorized.motor.maxBackwardSpeedOrigin / spec.cvtAR * spec.vTwo, 0.001)
										-- self.spec_motorized.motor.maxBackwardSpeed= ( self:getCruiseControlSpeed() ) / 3.6
									end
									-- self.spec_motorized.motor.lowBrakeForceScale = math.max(self.spec_motorized.motor.lowBrakeForceScale * (1.001 - spec.ClutchInputValue),0.04)
									-- self.spec_motorized.motor.accelerationLimit = 			self.spec_motorized.motor.accelerationLimit  * (1 - spec.ClutchInputValue)
									
									
								else
									self.spec_motorized.motor.maxForwardSpeed = self.spec_motorized.motor.maxForwardSpeedOrigin * (1.1 - spec.ClutchInputValue)
									self.spec_motorized.motor.maxBackwardSpeed=self.spec_motorized.motor.maxBackwardSpeedOrigin * (1.1 - spec.ClutchInputValue)
									-- print("else 2")
								end
							end
						end
						
						
						-- smoothing nicht im Leerlauf
						if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.minRpm + 20 then
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.2 then
							-- if self:getLastSpeed() >= 1 then
								-- Gaspedal and Variator
								-- spec.smoother = spec.smoother + dt;
								-- if spec.smoother ~= nil and spec.smoother > 10 then -- Drehzahl zucken eliminieren
									-- spec.smoother = 0;
								if self:getLastSpeed() > 0.5 then
									self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.max(math.min((self:getLastSpeed() * math.abs(math.max(self.spec_motorized.motor.rawLoadPercentage, 0.55)))*42, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+203), self.spec_motorized.motor.lastPtoRpm*0.7), self.spec_motorized.motor.maxRpm*spec.HandgasPercent)
									if cvtaDebugCVTxOn == true then
										-- print("0: " .. tostring(self:getLastSpeed()))
									end
									-- Drehzahl Erhöhung angleichen zur Motorbremswirkung, wenn Pedal losgelassen wird MODERN
									if math.max(0, self.spec_drivable.axisForward) < 0.1 then
										-- self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm)
										self.spec_motorized.motor.lastMotorRpm = math.min(self.spec_motorized.motor.lastMotorRpm + (math.abs(self:getLastSpeed()) * 14), self.spec_motorized.motor.maxRpm)
										-- self.spec_motorized.motor.rawLoadPercentage = self.spec_motorized.motor.rawLoadPercentage - (self:getLastSpeed() / 50)
										if cvtaDebugCVTon == true then
											print("#### Angleichen zur Motorbremswirkung, Pedal losgelassen: " .. math.min(self.spec_motorized.motor.lastMotorRpm * mcRPMvar + (self:getLastSpeed() * 14), self.spec_motorized.motor.maxRpm))
										end
									end
								end
								-- end -- smooth
							end
														
							-- Nm kurven für unterschiedliche Lasten, Berücksichtigung pto MODERN
							if self.spec_motorized.motor.smoothedLoadPercentage < 0.4 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 1 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*1)
								if self.spec_motorized.motorTemperature ~= nil then
									--
								else
									self.spec_motorized.motorTemperature.heatingPerMS = 0.0016
									-- self.spec_motorized.motorTemperature.coolingPerMS = 0.002
									
								end
							end
							if self.spec_motorized.motor.smoothedLoadPercentage >= 0.4 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.5 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.99 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*1)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.5 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.65 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.982 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*1)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.65 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.7 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.985 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.7 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.75 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.989 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.75 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.8 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.993 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.8 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.85 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.995 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
								-- self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * ((self.spec_motorized.motor.smoothedLoadPercentage/9.95)+0.908) * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.85 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.9 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 0.998 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
								-- self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * ((self.spec_motorized.motor.smoothedLoadPercentage/9.95)+0.905) * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							if self.spec_motorized.motor.smoothedLoadPercentage > 0.9 and self.spec_motorized.motor.smoothedLoadPercentage <= 0.99 then
								self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * 1 * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.99)
								-- self.spec_motorized.motor.lastMotorRpm = math.max((self.spec_motorized.motor.lastMotorRpm * ((self.spec_motorized.motor.smoothedLoadPercentage/9.95)+0.90) * mcRPMvar), self.spec_motorized.motor.lastPtoRpm*0.87)
							end
							
							-- Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt H
							if math.max(0, self.spec_drivable.axisForward) >= 0.02 and self:getLastSpeed() <= 7 then
								self.spec_motorized.motor.lastMotorRpm = math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.99)
								if cvtaDebugCVTon == true then
									print("#### Drehzahl Erhöhung sobald Pedal aktiviert wird zur Fahrt: " .. math.max(math.max(math.min(self.spec_motorized.motor.lastMotorRpm * 1.01, self.spec_motorized.motor.maxRpm*0.99), self.spec_motorized.motor.minRpm+323), self.spec_motorized.motor.lastPtoRpm*0.99))
									print("#### self:getDamageAmount(): " .. self:getDamageAmount())
								end
							end
						end
					end -- Havester Curves.
					
					
					if cvtaDebugCVTu2on then
						print("CVTa: spec.CVTdamage: " .. tostring(spec.CVTdamage))
					end
				end -- isMotorStarted

				if cvtaDebugCVTuOn == true then
					print("motorFan.enabled: " .. tostring(self.spec_motorized.motorFan.enabled))
					print("smoothedLoadPercentage: " .. tostring(self.spec_motorized.motor.smoothedLoadPercentage))
					print("rawLoadPercentage     : " .. tostring(self.spec_motorized.motor.rawLoadPercentage))
				end
				-- self.spec_motorized.motor.equalizedMotorRpm = self.spec_motorized.motor.lastMotorRpm
				-- self.spec_motorized.motor.lastRealMotorRpm = self.spec_motorized.motor.lastMotorRpm
				
				-- DBL convert Pedalposition and/or PedalVmax
				spec.forDBL_pedalpercent = string.format("%.1f", ( self.spec_drivable.axisForward*100 ))
				spec.forDBL_tmspedalvmax = math.min(string.format("%.1f", (( self:getCruiseControlSpeed()*math.pi) )), self.spec_motorized.motor.maxForwardSpeed*3.6)
				spec.forDBL_tmspedalvmaxactual = math.min(string.format("%.1f", (( self:getCruiseControlSpeed()*math.pi) )*self.spec_drivable.axisForward), self.spec_motorized.motor.maxForwardSpeed*3.6)
				if spec.autoDiffs ~= 1 then
					spec.forDBL_autodiffs = 0 -- inaktiv
				end
				if spec.CVTdamage ~= nil then
					spec.forDBL_cvtwear = spec.CVTdamage
				else
					spec.forDBL_cvtwear = 0.00
					spec.CVTdamage = 0.000
				end
				spec.forDBL_cvtclutch = spec.ClutchInputValue
																							-- self HG
				if spec.HandgasPercent > 0 then
					spec.forDBL_handthrottle = spec.HandgasPercent
					-- print(tostring(spec.forDBL_handthrottle))
				else
																							-- VCA
					if spec.HandgasPercent == 0 then
						if self.spec_vca ~= nil then
							if self.spec_vca.handThrottle > 0 then
								spec.forDBL_handthrottle = self.spec_vca.handThrottle
								-- print(tostring(spec.forDBL_handthrottle))
							else
								spec.forDBL_handthrottle = 0.0
							end
						end
																							-- realismAddon_Gearbox
						if self.spec_realismAddon_gearbox_inputs ~= nil then
							if self.spec_realismAddon_gearbox_inputs.handThrottlePercent > 0 then
								spec.forDBL_handthrottle = self.spec_realismAddon_gearbox_inputs.handThrottlePercent
								-- print(tostring(spec.forDBL_handthrottle))
							else
								spec.forDBL_handthrottle = 0.0
							end
						end
					end
				end
				spec.forDBL_vmaxforward = tostring(self.spec_motorized.motor.maxForwardSpeed * 3.6)
				spec.forDBL_vmaxbackward = tostring(self.spec_motorized.motor.maxBackwardSpeed * 3.6)
				
				-- spec.groupsSecondSet.currentGroup
				
				-- print("raG-HG: ", tostring(self.spec_realismAddon_gearbox_inputs.handThrottlePercent))
				if spec.autoDiffs == 1 then
					if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 11 then
						if spec.vOne == spec.cvtDL then
							spec.forDBL_autodiffs = 0 -- Vorwahl und inaktiv
							spec.forDBL_preautodiffs = 1 -- Vorwahl und inaktiv
						elseif spec.vOne < spec.cvtDL then
							spec.forDBL_autodiffs = 1 -- aktiv
							spec.forDBL_preautodiffs = 0 -- aktiv
						end
					elseif spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
						if spec.vOne >= 1 then
							if self:getLastSpeed() <= 16 then
								spec.forDBL_autodiffs = 1 -- aktiv
								spec.forDBL_preautodiffs = 0 -- aktiv
							else
								spec.forDBL_autodiffs = 0 -- Vorwahl
								spec.forDBL_preautodiffs = 1 -- Vorwahl
							
							end
						end
					elseif spec.CVTconfig == 7 then -- HST I&II
						if spec.vOne ~= nil then
							spec.forDBL_autodiffs = 1 -- aktiv
							spec.forDBL_preautodiffs = 0 -- n.V.
						end
					end
				elseif spec.autoDiffs ~= 1 then
					spec.forDBL_autodiffs = 0 -- inaktiv
					spec.forDBL_preautodiffs = 0 -- inaktiv
				end
				-- spec.forDBL_cvtwear = math.max(math.min(spec.CVTdamage, 100), 0) -- integer

				-- Brainstorm for later:
					-- DebugUtil.printTableRecursively()
					-- self.spec_motorized.consumersByFillType[FillType.DEF]
					-- rpm at vmax new gen    40 = 950; 50 = 1250; 60 = 1450;
				
			end

			if spec.autoDiffs == 1 and self:getMotorState() > 3 then
				if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 11 then
					if spec.vOne == spec.cvtDL then
						spec.forDBL_autodiffs = 0 -- Vorwahl und inaktiv
						spec.forDBL_preautodiffs = 1 -- Vorwahl und inaktiv
					elseif spec.vOne < spec.cvtDL then
						spec.forDBL_autodiffs = 1 -- aktiv
						spec.forDBL_preautodiffs = 0 -- aktiv
					end
				elseif spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
					if spec.vOne ~= nil then
						if self:getLastSpeed() <= 16 then
							spec.forDBL_autodiffs = 1 -- aktiv
							spec.forDBL_preautodiffs = 0 -- aktiv
						else
							spec.forDBL_autodiffs = 0 -- Vorwahl
							spec.forDBL_preautodiffs = 1 -- Vorwahl
						end
					end
				elseif spec.CVTconfig == 7 then
					if spec.vOne ~= nil then
						spec.forDBL_autodiffs = 1 -- aktiv
						spec.forDBL_preautodiffs = 0 -- n.V.
					end
				end
			elseif spec.autoDiffs ~= 1 then
				spec.forDBL_autodiffs = 0 -- inaktiv
				spec.forDBL_preautodiffs = 0 -- inaktiv
			end
			
			-- if spec.CVTconfig ~= 8 then
			-- 	-- Anti-Rollback: richtungsabhängig bremsen..... 
			-- 	local wheels = self.spec_wheels.wheels
			-- 	local motor = self.spec_motorized.motor
			-- 	local direction = motor.currentDirection or 1
			-- 	local axis = self.spec_drivable.axisForward or 0
			-- 	local absAxis = math.abs(axis)
			-- 	local isRollingWrong = false
			-- 	local speed = self:getLastSpeed() * direction  -- Richtung berücksichtigen
			-- 	local minTriggerSpeed = 0.15  -- m/s

			-- 	-- Prüfen: Fährt entgegen der gewählten Richtung?
			-- 	if speed < -minTriggerSpeed then
			-- 	    isRollingWrong = true
			-- 	end

			-- 	-- Wenn falsche Richtung + zu wenig Gas, dann bremsen
			-- 	if isRollingWrong and absAxis < 0.1 then
			-- 	    -- Setze natives Bremsen
			-- 	    motor.brakePedal = 1.0
			-- 		print("brake")
			-- 	    -- Deaktiviere Motorantrieb vollständig
			-- 	    motor.equalizedMotorDelta = 0

			-- 	    -- (Optional) Hard-stop: Wheel Brake zusätzlich
			-- 	    for _, wheel in ipairs(wheels) do
			-- 	        wheel.wantedBrakeForce = 1.0
			-- 	    end
			-- 	end
			-- end

			
			-- DevTools
			if VcvtaResetWear == true then
				spec.forDBL_cvtwear = 0.00
				spec.CVTdamage = 0.000
				spec.forDBL_critheat = 0
				spec.forDBL_warnheat = 0
				spec.forDBL_critdamage = 0
				spec.forDBL_warndamage = 0
				print("CVTa: Verschleiß und Warnings wurden für dieses Fahrzeug zurückgesetzt")
				VcvtaResetWear = false
			end
			
					
			-- if g_server ~= nil then	end
			if debug_for_DBL then
				print("AOD####################################################################")
				print("spec.forDBL_drivinglevel: " .. spec.forDBL_drivinglevel)
				print("spec.vOne: " .. spec.vOne)
				print("spec.forDBL_accramp: " .. spec.forDBL_accramp)
				print("spec.vTwo: " .. spec.vTwo)
				print("-------------------------------------------------------------")
				print("spec.forDBL_brakeramp: " .. spec.forDBL_brakeramp)
				print("spec.vThree: " .. spec.vThree)
				print("-------------------------------------------------------------")
				print("spec.forDBL_warnheat: " .. spec.forDBL_warnheat)
				print("spec.forDBL_warndamage: " .. spec.forDBL_warndamage)
				print("spec.forDBL_critheat: " .. spec.forDBL_critheat)
				print("spec.forDBL_critdamage: " .. spec.forDBL_critdamage)
				print("spec.CVTdamage: " .. spec.CVTdamage)
				print("spec.forDBL_cvtwear: " .. spec.forDBL_cvtwear)
				-- print("-------------------------------------------------------------")
				-- print("spec.forDBL_neutral: " .. spec.forDBL_neutral)
				print("spec.CVTCanStart: " .. tostring(spec.CVTCanStart))
				print("spec.forDBL_motorcanstart: " .. tostring(spec.forDBL_motorcanstart))
				print("-------------------------------------------------------------")
				print("spec.forDBL_autodiffs: " .. tostring(spec.forDBL_autodiffs))
				print("spec.autoDiffs: " .. tostring(spec.autoDiffs))
				print("-------------------------------------------------------------")
				print("spec.forDBL_tmspedal: " .. tostring(spec.forDBL_tmspedal))
				print("spec.isTMSpedal: " .. tostring(spec.isTMSpedal))
				print("spec.forDBL_tmspedalvmax: " .. spec.forDBL_tmspedalvmax)
				print("spec.forDBL_pedalpercent: " .. spec.forDBL_pedalpercent)
				print("spec.forDBL_tmspedalvmaxactual: " .. spec.forDBL_tmspedalvmaxactual)
				print("spec.forDBL_vmaxforward: " .. spec.forDBL_vmaxforward)
				print("spec.forDBL_vmaxbackward: " .. spec.forDBL_vmaxbackward)
				print("-------------------------------------------------------------")
				print("spec.forDBL_digitalhandgasstep: " .. spec.forDBL_digitalhandgasstep)
				print("spec.vFive: " .. spec.vFive)
				-- print("spec.RpmInputValue: " .. spec.RpmInputValue)
				print("spec.HandgasPercent: " .. spec.HandgasPercent)
				print("spec.forDBL_handthrottle: " .. spec.forDBL_handthrottle)
				print("-------------------------------------------------------------")
				print("spec.forDBL_rpmrange: " .. spec.forDBL_rpmrange)
				print("-------------------------------------------------------------")
				print("spec.forDBL_rpmdmin: " .. spec.forDBL_rpmdmin)
				print("-------------------------------------------------------------")
				print("spec.forDBL_rpmdmax: " .. spec.forDBL_rpmdmax)
				print("-------------------------------------------------------------")
				print("spec.forDBL_ipmactive: " .. spec.forDBL_ipmactive)
				print("-------------------------------------------------------------")
				print("spec.forDBL_rpmrange: " .. spec.forDBL_rpmrange)
				print("EOD_________________________________________________________________________")
			end -- isVarioTM
			
			if spec.CVTCanStart == true then
				spec.forDBL_motorcanstart = 1
			else
				spec.forDBL_motorcanstart = 0
			end
			
			-- motor need warmup and show it for manual transmissions.
			
			-- if spec.isVarioTM == false and not isPKWLKW and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 then
			if spec.isVarioTM == false and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 then
				if self.spec_motorized.motorTemperature.value < 56 then
					spec.forDBL_motorcoldlamp = 1
					-- self:raiseActive()
					if self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.maxRpm / 1.4 then
						self:addDamageAmount(self.spec_motorized.motor.lastMotorRpm * 0.0000007 * self.spec_motorized.motor.smoothedLoadPercentage, true)
					end
				else
					spec.forDBL_motorcoldlamp = 0
				end
			end
			
			-- print("motorAppliedTorque: " .. self.spec_motorized.motor.motorAppliedTorque)
			-- print("maxAcceleration: " .. self.spec_motorized.motor.maxAcceleration)
			-- print("self:getClutchPedal(): " ..  tostring(self:getClutchPedal() ))
	else
		-- set Acceleration of CVT-Addon deactivated vehicle, so that they don't cheating faster than others
		self.spec_motorized.motor.accelerationLimit = 1.6
	end -- if spec.CVTconfig deactivated
	
	-- manual shifter set to manual config, if not disabled
	-- if not spec.isVarioTM and not isPKWLKW and spec.CVTconfig ~= 8 then
	if not spec.isVarioTM and spec.CVTconfig ~= 8 and spec.CVTcfgExists then
		-- spec.CVTconfig = 9
		-- print("cvt: config manual " .. spec.CVTconfig)
	end
	
	-- Telemetrie
	if self.FStelemetryAddonData == nil then
		self.FStelemetryAddonData = {} -- set the table if not exist
	end
	if dt <= 200 then -- don't spam the telemetry server, just reduce it a bit.
		self.FStelemetryAddonData.CVT_accRamp 		= spec.forDBL_accramp;			-- Beschleunigungsrampe
		self.FStelemetryAddonData.CVT_drivinglevel 	= spec.forDBL_drivinglevel;		-- Fahrbereich
		self.FStelemetryAddonData.CVT_handthrottle 	= spec.forDBL_handthrottle;		-- Handgasposition
		self.FStelemetryAddonData.CVT_motorcanstart = spec.forDBL_motorcanstart;	-- Motor Starterlaubnis(Kupplung, Handbremse, Handgas, AirTemp[preGlow])
		self.FStelemetryAddonData.CVT_motorIsCold 	= spec.forDBL_motorcoldlamp;	-- Motor ist noch kalt
		self.FStelemetryAddonData.CVT_warnHeat 		= spec.forDBL_warnheat;			-- Überhitzungs-Warnung
		self.FStelemetryAddonData.CVT_warnDamage 	= spec.forDBL_warndamage;		-- Schadenswarnung
		self.FStelemetryAddonData.CVT_critHeat 		= spec.forDBL_critheat;			-- Überhitzt
		self.FStelemetryAddonData.CVT_critDamage 	= spec.forDBL_critdamage;		-- Schaden entstanden oder Getriebe-Notlauf
		self.FStelemetryAddonData.CVT_wear 			= spec.forDBL_cvtwear;			-- Getriebe Verschleiß in %
		self.FStelemetryAddonData.CVT_autoDiffs 	= spec.forDBL_autodiffs;		-- Automatische Diff-Sperre aktiv
		self.FStelemetryAddonData.CVT_preAutoDiffs 	= spec.forDBL_preautodiffs;		-- Automatische Diff-Sperre vorgewählt
		self.FStelemetryAddonData.CVT_Clutch 		= spec.forDBL_cvtclutch;		-- Position des Kupplungspedals
		self.FStelemetryAddonData.CVT_brakeRamp 	= spec.forDBL_brakeramp;		-- Bremsrampe
		self.FStelemetryAddonData.CVT_vmaxFw 		= spec.fandDBL_vmaxfandward;		-- Aktuelle maximale Geschwindigkeit Vorwärts
		self.FStelemetryAddonData.CVT_vmaxBw 		= spec.forDBL_vmaxbackward;		-- Aktuelle maximale Geschwindigkeit Rückwärts
		self.FStelemetryAddonData.CVT_IMPisActive 	= spec.forDBL_ipmactive;		-- Intelligent Power Management greift ein
		self.FStelemetryAddonData.CVT_TMSpadelMode 	= spec.forDBL_tmspedal;			-- TMS Pedal Modus aktiv
		self.FStelemetryAddonData.CVT_GlowingState 	= spec.forDBL_glowingstate;		-- Vorglüh-Status
		self.FStelemetryAddonData.CVT_PreGlowing 	= spec.forDBL_preglowing;		-- Vorglüh-Taster glüht gerade
		self.FStelemetryAddonData.CVT_HighPressure 	= spec.forDBL_highpressure;		-- Hoher Druck im Getriebe Warnung
		-- self.FStelemetryAddonData.CVT_ 		= spec.forDBL; 			--
	end

	-- print("Telemetry Table aR: ".. tostring(self.FStelemetryAddonData.accRamp))
	-- print("Telemetry Table DL: ".. tostring(self.FStelemetryAddonData.drivinglevel))
	
	
	-- print("TMS-HUD: " .. tostring(self.gearTexts[3]))
	-- print("TMS-HUD: " .. tostring(self.gearTexts[3]))
	-- print("TMS-HUD cfg: " .. tostring(spec.CVTconfig))
	
	-- renderText(0.5, 0.5, 0.05, "TEs7") -- BACK
	-- print("isAdmin: " .. tostring( g_currentMission.isMasterUser ))
end -- onUpdate

addConsoleCommand("cvtaResetWear", "resetts the cvt wear", "FcvtaResetWear", CVTaddon)
function CVTaddon:FcvtaResetWear()
	VcvtaResetWear = true
end

addConsoleCommand("cvtaPrintTable", "prints Table Recursively", "DprintTableRecursively", self)
function CVTaddon:DprintTableRecursively(paramTable)
	if paramTable ~= nil then
		DebugUtil.printTableRecursively(paramTable, "- " , 0, 50)
	else
		print("table angeben!")
		print("cvtaPrintTable [table]")
		print("z.B.: cvtaPrintTable self.spec_frontloaderAttacher")
	end
end

addConsoleCommand("cvtaVER", "Versions CVT-Addon", "cCVTaVer", CVTaddon)
function CVTaddon:cCVTaVer()
	print("CVT-Addon Mod Version: " .. modversion)
	print("CVT-Addon Script Version: " .. scrversion)
	print("CVT-Addon Date: " .. lastupdate)
	print("CVT-Addon code: " .. timestamp)
end

addConsoleCommand("CvTaHB", "Versions CVT-Addon", "cCVTaHappyBirthday", CVTaddon)
function CVTaddon:cCVTaHappyBirthday(bdayuser)
	print(" ")
	print(" ")
	print(" ")
	print("° ")
	print("*___________________________________________________/\\")
	print(" |¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯SbSh-PooL¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|\\")
	print(" |   Das Team vom CVT-Addon und das Script selbst,   |¯")
	print(" |   wünschen allen Geburtstagskindern frohe Ostern. |")
	print(" |   365 Tage Freude wie heute,                      |")
	print(" |   525.600 Minuten Zufriedenheit,                  |")
	print(" |   genieße die Jahre und die Zeit!                 |")
	print(" |   Ostern? 365 Tage/Jahr gibt's B-Day's der Leute, |")
	print(" |   alle anderen Feierlichkeiten, ebenso wunderbar- |")
	print(" |   gibt's nur einmal im Jahr'.                     |")
	print(" |___________________________________________________|")
	print(" ´¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯`")
	print(" ")
	if bdayuser == nil then
		bdayuser = ""
	end
	g_currentMission:showBlinkingWarning("H a p p y   B i r t h d a y ".. tostring(bdayuser) .. " !", 20480)
end

addConsoleCommand("cvtaDebugVC", "Debug CVT-Addon Vehicle Categories", "cCVTaVC", CVTaddon)
function CVTaddon:cCVTaVC()
	-- local spec = self.spec_CVTaddon
	if debug_for_VC == true then
		print("CVTa: VC Debug disabled")
		debug_for_VC = false
	elseif debug_for_VC == false then
	print("CVTa: VC Debug enabled")
		debug_for_VC = true
	end
end

addConsoleCommand("cvtaDebugDBL", "Debug CVT-Addon DBL Values", "cCVTaDBL", CVTaddon)
function CVTaddon:cCVTaDBL()
	-- local spec = self.spec_CVTaddon
	if debug_for_DBL == true then
		print("CVTa: DBL Debug disabled")
		debug_for_DBL = false
	elseif debug_for_DBL == false then
	print("CVTa: DBL Debug enabled")
		debug_for_DBL = true
	end
end

addConsoleCommand("cvtaDebugWT", "Debug CVT-Addon", "cCVTaCVTwt", CVTaddon)
function CVTaddon:cCVTaCVTwt()
	-- local spec = self.spec_CVTaddon
	if sbshDebugWT == true then
		print("CVTa: Verschleiß Debug disabled")
		sbshDebugWT = false
	elseif sbshDebugWT == false then
		print("CVTa: Verschsleiß Debug enabled")
		sbshDebugWT = true
	end
end

addConsoleCommand("cvtaDebugCVT", "Debug CVT-Addon", "cCVTaCVTdg", CVTaddon)
function CVTaddon:cCVTaCVTdg()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTon == true then
		print("CVTa: Debug disabled")
		cvtaDebugCVTon = false
	elseif cvtaDebugCVTon == false then
		print("CVTa: Debug enabled")
		cvtaDebugCVTon = true
	end
end

addConsoleCommand("cvtaDebugCVTx", "Debug CVT-Addon xtra", "cCVTaCVTdgx", CVTaddon)
function CVTaddon:cCVTaCVTdgx()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTxOn == true then
		print("CVTa: Fly Debug disabled")
		cvtaDebugCVTxOn = false
	elseif cvtaDebugCVTxOn == false then
		print("CVTa: Fly Debug enabled")
		cvtaDebugCVTxOn = true
	end
end

-- DANGERZONE
-- addConsoleCommand("cvtaDebugTableACHTUNG", "Debug Table print", "cCVTaCVTdTbl", CVTaddon)
-- function CVTaddon:cCVTaCVTdTbl()
	-- -- local spec = self.spec_CVTaddon
	-- if debugTable == true then
		-- print("CVTa: debugTable Debug disabled")
		-- debugTable = false
		-- firstTimeRun = nil
	-- elseif debugTable == false then
		-- print("CVTa: debugTable Debug enabled")
		-- debugTable = true
	-- end
-- end

addConsoleCommand("cvtaDebugCVTheat", "Debug CVT-Addon xtra", "cCVTaCVTheat", CVTaddon)
function CVTaddon:cCVTaCVTheat()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTheatOn == true then
		print("CVTa: Heat Debug disabled")
		cvtaDebugCVTheatOn = false
	elseif cvtaDebugCVTheatOn == false then
		print("CVTa: Heat Debug enabled")
		cvtaDebugCVTheatOn = true
	end
end

addConsoleCommand("cvtaDebugCVTcanStart", "Debug CVT-Addon start", "cCVTaCVTstart", CVTaddon)
function CVTaddon:cCVTaCVTstart()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTcanStartOn == true then
		print("CVTa: Start Debug disabled")
		cvtaDebugCVTcanStartOn = false
	elseif cvtaDebugCVTcanStartOn == false then
		print("CVTa: Start Debug enabled")
		cvtaDebugCVTcanStartOn = true
	end
end

addConsoleCommand("cvtaDebugCVTu", "Debug CVT-Addon xtra", "cCVTaCVTupd", CVTaddon)
function CVTaddon:cCVTaCVTupd()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTuOn == true then
		print("CVTa: Upd Debug disabled")
		cvtaDebugCVTuOn = false
	elseif cvtaDebugCVTuOn == false then
		print("CVTa: Upd Debug enabled")
		cvtaDebugCVTuOn = true
	else
		print("CVTa: Upd Debug enabled *forced")
		cvtaDebugCVTuOn = true
	end
end

addConsoleCommand("cvtaDebugCVT_trans", "Debug CVT-Addon transmission", "cCVTaCVTtrans", CVTaddon)
function CVTaddon:cCVTaCVTtrans()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTtransmission == true then
		print("CVTa: Transmission Debug disabled")
		cvtaDebugCVTtransmission = false
	elseif cvtaDebugCVTtransmission == false then
		print("CVTa: Transmission Debug enabled")
		cvtaDebugCVTtransmission = true
	else
		print("CVTa: Transmission Debug enabled *forced")
		cvtaDebugCVTtransmission = true
	end
end

addConsoleCommand("cvtaDebugCVTu2", "Debug CVT-Addon xtra", "cCVTaCVTupd2", CVTaddon)
function CVTaddon:cCVTaCVTupd2()
	-- local spec = self.spec_CVTaddon
	if cvtaDebugCVTu2on == true then
		print("CVTa: Upd2 Debug disabled")
		cvtaDebugCVTu2on = false
	elseif cvtaDebugCVTu2on == false then
		print("CVTa: Upd2 Debug enabled")
		cvtaDebugCVTu2on = true
	else
		print("CVTa: Upd2 Debug enabled *forced")
		cvtaDebugCVTu2on = true
	end
end

addConsoleCommand("cvtaSETcfg", "Versions CVT-Addon", "cCVTaSetCfg", self)
function CVTaddon:cCVTaSetCfg(c)
	local spec = self.spec_CVTaddon
	print("CVT-Addon Sets " .. tostring(c))
	print("CVT-Addon Sets Config from: " .. tostring(spec.CVTconfig))
	spec.CVTconfig = tonumber(c)
	print("to " .. spec.CVTconfig)
end

----------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------			
------------- Should be external in CVT_Addon_HUD.lua, but I can't sync spec between 2 lua's -------------------------			
function CVTaddon:onDraw(dt, mission, SpeedMeterDisplay, HUDDisplay)
	local spec = self.spec_CVTaddon
	-- fix for the issue with the göweil dlc "and g_currentMission.controlledVehicle ~= nil/self" thanks glowin
	
	
	if g_client ~= nil and g_currentMission.hud.controlledVehicle == self then
		local posX, posY = g_currentMission.hud.speedMeter:getPosition()

		local TposX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*4.5) - (0.035*g_gameSettings.uiScale) -0.003
		local TposY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) -0.015
			
		-- if g_currentMission.hud.isVisible and spec.isVarioTM == false and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 and spec.CVTcfgExists and self.getIsEntered ~= nil and self:getIsEntered() then
		-- if g_currentMission.hud.hudVisibility and spec.isVarioTM == false and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 and spec.CVTcfgExists and self.getIsEntered ~= nil and self:getIsEntered() then
		if g_currentMission.hud.isVisible and spec.isVarioTM == false and spec.CVTconfig ~= 8 and spec.CVTconfig ~= 0 and spec.CVTcfgExists and self.getIsEntered ~= nil and self:getIsEntered() then
		
			-- new referecies fs25 
			local TposX = g_currentMission.hud.speedMeter.speedGaugeCenterOffsetX - g_currentMission.hud.speedMeter.speedGaugeRadiusY - 0.02
			local TposY = g_currentMission.hud.speedMeter.speedGaugeCenterOffsetY + g_currentMission.hud.speedMeter.speedGaugeRadiusY
			
			-- Position of HUD MANUAL
			-- if spec.HUDpos == 1 then --                 speedGaugeCenterOffsetY
				-- TposX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*4.5) - (0.035*g_gameSettings.uiScale) -0.003
				-- TposY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) -0.015
			-- elseif spec.HUDpos == 2 then
					-- TposX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*1.0) - (0.035*g_gameSettings.uiScale) +0.045
					-- TposY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) + 0.1 -- höhe
			-- end
			-- local TposX, TposY = scalePixelValuesToScreenVector(0.2, 0.7)
			if spec.HUDpos == 1 then --                 speedGaugeCenterOffsetY
				TposX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*4.5) - (0.035*g_gameSettings.uiScale) -0.003
				TposY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) -0.015
			elseif spec.HUDpos == 2 then
					TposX = 0.98 - (0.035*g_gameSettings.uiScale)
					TposY = 0.2 + (0.035*g_gameSettings.uiScale)
			end

			
			-- speedGaugeCenterOffsetX
			
			-- COLD
			if g_currentMission.environment.weather:getCurrentTemperature() <= 5 and self.spec_motorized.motorTemperature.value <= 20 then
				spec.CVTIconMScold:setColor(0, 1, 0.5, 1)
			else
				spec.CVTIconMScold:setColor(1, 1, 1, 1)
			end
			if forDBL_preglowing == 1 then
				spec.CVTIconMScold:setColor(1, 0.4, 0, 1)
			else
				spec.CVTIconMScold:setColor(1, 1, 1, 1)
			end

			spec.CVTIconMSpGlowed:setColor(1, 1, 1, 1)
			spec.CVTIconMSpGlowing:setColor(1, 1, 1, 1)
			spec.CVTIconMSpGlowed:setPosition(TposX, TposY+0.022)
			spec.CVTIconMSpGlowing:setPosition(TposX, TposY+0.022)
			spec.CVTIconMScold:setPosition(TposX, TposY+0.01)
			spec.CVTIconMScold:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
			spec.CVTIconMScold:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			spec.CVTIconMSpGlowed:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			spec.CVTIconMSpGlowing:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			
			if self.spec_motorized.motorTemperature.value <= 55 then
				spec.CVTIconMScold:render()
			end

			-- Vorglühen
			if spec.forDBL_preglowing == 1 and spec.forDBL_glowingstate ~= 1 then
				spec.CVTIconMSpGlowing:render()
			elseif spec.forDBL_glowingstate == 1 then
				spec.CVTIconMSpGlowed:render()
			end

			-- OK
			spec.CVTIconMSok:setColor(1, 1, 1, 1)
			spec.CVTIconMSok:setPosition(TposX, TposY+0.01)
			spec.CVTIconMSok:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
			spec.CVTIconMSok:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			if self.spec_motorized.motorTemperature.value > 55 and self.spec_motorized.motorTemperature.value < 94 then
				spec.CVTIconMSok:render()
			end
			
			-- WARN
			spec.CVTIconMSwarn:setColor(1, 1, 1, 1)
			spec.CVTIconMSwarn:setPosition(TposX, TposY+0.01)
			spec.CVTIconMSwarn:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
			spec.CVTIconMSwarn:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			if (self.spec_motorized.motorTemperature.value >= 94 and self.spec_motorized.motorTemperature.value < 98) 
			or (self.spec_motorized.motorTemperature.value <= 55 and self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.maxRpm / 1.5) then
				spec.CVTIconMSwarn:render()
			end
			
			-- CRIT
			spec.CVTIconMScrit:setColor(1, 1, 1, 1)
			spec.CVTIconMScrit:setPosition(TposX, TposY+0.01)
			spec.CVTIconMScrit:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
			spec.CVTIconMScrit:setScale(0.025*g_gameSettings.uiScale, 0.05*g_gameSettings.uiScale)
			if self.spec_motorized.motorTemperature.value <= 55 and self.spec_motorized.motor.lastMotorRpm > self.spec_motorized.motor.maxRpm / 1.35 then
				spec.CVTIconMScrit:render()
			end
		end
		
		if spec.CVTconfig ~= 8 and spec.HUDvis ~= 2 and spec.CVTcfgExists then
			-- local spec = self.spec_CVTaddon
			local storeItem = g_storeManager:getItemByXMLFilename(self.configFileName)
			local StI = storeItem.categoryName
			local isTractor = StI == "TRACTORSS" or StI == "TRACTORSM" or StI == "TRACTORSL"
			local isErnter = StI == "HARVESTERS" or StI == "FORAGEHARVESTERS" or StI == "POTATOVEHICLES" or StI == "BEETVEHICLES" or StI == "SUGARCANEVEHICLES" or StI == "COTTONVEHICLES" or StI == "MISCVEHICLES"
			local isLoader = StI == "FRONTLOADERVEHICLES" or StI == "TELELOADERVEHICLES" or StI == "SKIDSTEERVEHICLES" or StI == "WHEELLOADERVEHICLES"
			local isPKWLKW = StI == "CARS" or StI == "TRUCKS"
			local isWoodWorker = storeItem.categoryName == "WOODHARVESTING"
			local isFFF = storeItem.categoryName == "FORKLIFTS"
			
			
			if g_currentMission.hud.isVisible and spec.isVarioTM == true then
				-- calculate position and size
				local uiScale = g_gameSettings.uiScale;
				
				-- v |   + hoch
				-- if g_currentMission.hud.fillLevelsDisplay:getVisible() then
				-- if g_currentMission.hud.speedMeter:getVisible() then

				-- Position of HUD
				if spec.HUDpos == 1 then --                 speedGaugeCenterOffsetY
					posX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*4.5) - (0.035*g_gameSettings.uiScale) -0.003
					posY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) -0.015
				elseif spec.HUDpos == 2 then
					-- if g_currentMission.hud.fillLevelsDisplay:getVisible() then
						-- posX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*1.0) - (0.035*g_gameSettings.uiScale) +0.003
						-- posY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) +0.4
					-- else
						posX = posX - (g_currentMission.hud.speedMeter.speedGaugeRadiusX*1.0) - (0.035*g_gameSettings.uiScale) +0.025
						posY = posY + (g_currentMission.hud.speedMeter.speedGaugeRadiusY*2) +0.2 -- höhe
					-- end
				end
				-- print("getVisible: " .. tostring(g_currentMission.hud.fillLevelsDisplay:getVisible()))
				local BGcvt = 1
				local overlayP = 1
				local Transparancy = 0.6
				local size = 0.013 * g_gameSettings.uiScale
				
				
				-- local ptmsX = g_currentMission.hud.speedMeter.speedGaugeCenterOffsetX
				-- local ptmsY = g_currentMission.hud.speedMeter.speedGaugeCenterOffsetY
		-- +oben +rechts relativ
				local ptmsX = posX + 0.0
				local ptmsY = posY -0.02

				-- vca diff locks
				-- local VCAposX   = g_currentMission.hud.speedMeter.gearOffsetX
				local VCAposX   = posX + 0.012
				-- local VCAposY   = g_currentMission.hud.speedMeter.gearOffsetY
				local VCAposY   = posY + 0.08

				local VCAl = g_currentMission.hud.speedMeter.gearTextSize
				-- local VCAl = self:scalePixelToScreenHeight(12)
				
				-- render
				if spec.transparendSpd == nil then
					spec.transparendSpd = 0.6
					spec.transparendSpdT = 1
				end
				if self:getLastSpeed() > 20 then
					spec.transparendSpd = (1- (self:getLastSpeed()/20-1))
					spec.transparendSpdT = (1- (self:getLastSpeed()/20-1))
				elseif self:getLastSpeed() <= 20 or self:getLastSpeed() == nil then
					spec.transparendSpdT = 1
				end
				setTextColor(0, 0.95, 0, 0.8)
				setTextAlignment(RenderText.ALIGN_LEFT)
				setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
				setTextBold(false)
				 
				-- add background overlay box -
				-- if not isPKWLKW then  -- nil in mp at lkw 1661 dH
					
				local warnTempC = { 0.4, 1, 0, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				local critTempC = { 1, 0, 0.4, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				local coldTempC = { 0, 0, 1, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				if g_currentMission.environment.weather:getCurrentTemperature() <= 5 and self.spec_motorized.motorTemperature.value <= 20 then
					coldTempC = { 0, 0.5, 1, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				end
				if forDBL_preglowing == 1 then
					coldTempC = { 1, 0.5, 0, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				-- else
					-- coldTempC = { 0, 0, 1, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				end
				local warnDmgC = { 0, 0.5, 1, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				local critDmgC = { 1, 0.3, 0, math.max(math.min(spec.transparendSpdT, 0.7), 0.1) }
				
				local HgColour = { 0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1) }
				
				if spec.vFive == nil then -- fix for mp nil at first HG use/unuse
					spec.vFive = 0
				end
				if spec.vFive ~= nil and spec.vFive == 9 then
					HgColour = { 0.627, 0.461, 0.055, 1 }
				-- elseif spec.vFive ~= nil and spec.vFive >= 10 then
					
				end
				local HgRColour = { 1, 0.2, 0.2, 1 }
				spec.CVTIconBg:setColor(0.01, 0.01, 0.01, math.max(math.min(spec.transparendSpd, 0.6), 0.2))
				spec.CVTIconFb:setColor(0, 0, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
				spec.CVTIconFs1:setColor(0, 0.9, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
				spec.CVTIconFs2:setColor(0, 0.9, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
				spec.CVTIconFs3:setColor(0, 0.9, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
				spec.CVTIconFs4:setColor(0, 0.9, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
				spec.CVTIconPtms:setColor(0, 0.9, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))

				spec.CVTIconHg2:setColor(unpack(HgColour))
				spec.CVTIconHg3:setColor(unpack(HgColour))
				spec.CVTIconHg4:setColor(unpack(HgColour))
				spec.CVTIconHg5:setColor(unpack(HgColour))
				spec.CVTIconHg6:setColor(unpack(HgColour))
				spec.CVTIconHg7:setColor(unpack(HgColour))
				spec.CVTIconHg8:setColor(unpack(HgColour))
				spec.CVTIconHg9:setColor(unpack(HgColour))
				if spec.vFive ~= nil and spec.vFive == 9 then
					spec.CVTIconHg10:setColor(unpack(HgColour))
				elseif spec.vFive ~= nil and spec.vFive >= 10 then
					spec.CVTIconHg10:setColor(unpack(HgRColour))
				end
				if spec.forDBL_critheat == 1 then
					spec.CVTIconHEAT:setColor(unpack(critTempC))
				end
				if spec.forDBL_warnheat == 1 and spec.forDBL_critheat ~= 1 then
					spec.CVTIconHEAT:setColor(unpack(warnTempC))
				end
				
				if spec.forDBL_warnheat == 1 and spec.forDBL_critheat == 1 then
					spec.CVTIconHEAT:setColor(unpack(critTempC))
				end
				if self.spec_motorized.motorTemperature.value < 56 then
					spec.CVTIconHEAT:setColor(unpack(coldTempC))
				end
				if spec.forDBL_warndamage == 1 then
					spec.CVTIconDmg:setColor(unpack(warnDmgC))
				end
				if spec.forDBL_critdamage == 1 then
					spec.CVTIconDmg:setColor(unpack(critDmgC))
				end
				if spec.forDBL_warndamage == 1 and spec.forDBL_critdamage == 1 then
					spec.CVTIconDmg:setColor(unpack(critDmgC))
				end
				
				if spec.forDBL_preglowing == 1 and spec.forDBL_glowingstate ~= 1 then
					spec.CVTIconPG:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				elseif spec.forDBL_glowingstate == 1 then
					spec.CVTIconPG:setColor(0.927, 0.261, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				else
					spec.CVTIconPG:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				end
				
				spec.CVTIconAr12:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr22:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))

				spec.CVTIconAr13:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr23:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr33:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				
				spec.CVTIconAr1:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr2:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr3:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr4:setColor(1, 0.5, 0.5, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				
				spec.CVTIconAr15:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr25:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr35:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr45:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconAr55:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				
				spec.CVTIconBr1:setColor(0.6, 0.1, 0.1, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconBr2:setColor(0.6, 0.1, 0.1, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconBr3:setColor(0.6, 0.1, 0.1, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconBr4:setColor(0.6, 0.1, 0.1, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				
				spec.CVTIconHydro:setColor(0.8, 0.1, 0, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				-- spec.CVTIconN:setColor(0, 0.8, 0, math.max(math.min(spec.transparendSpdT-0.3, 0.5), 0.1))
				-- spec.CVTIconN2:setColor(0, 0.8, 0, math.max(math.min(spec.transparendSpdT-0.3, 0.5), 0.1))
				
				spec.CVTIconV:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				spec.CVTIconR:setColor(0.627, 0.761, 0.075, math.max(math.min(spec.transparendSpdT-0.3, 0.9), 0.1))
				--
				spec.CVTIconBg:setPosition(posX-0.01, posY) -- 
				-- spec.CVTIconBg:setPosition(0.5, 0.5)
				spec.CVTIconFb:setPosition(posX-0.01, posY)
				spec.CVTIconFs1:setPosition(posX-0.01, posY)
				spec.CVTIconFs2:setPosition(posX-0.01, posY)
				spec.CVTIconFs3:setPosition(posX-0.01, posY)
				spec.CVTIconFs4:setPosition(posX-0.01, posY)
				spec.CVTIconPtms:setPosition(posX-0.01, posY)
				
				spec.CVTIconHg2:setPosition(posX-0.01, posY)
				spec.CVTIconHg3:setPosition(posX-0.01, posY)
				spec.CVTIconHg4:setPosition(posX-0.01, posY)
				spec.CVTIconHg5:setPosition(posX-0.01, posY)
				
				spec.CVTIconDmg:setPosition(posX-0.01, posY+0.012)
				spec.CVTIconHEAT:setPosition(posX-0.01, posY)
				
				spec.CVTIconHg6:setPosition(posX-0.01, posY)
				spec.CVTIconHg7:setPosition(posX-0.01, posY)
				spec.CVTIconHg8:setPosition(posX-0.01, posY)
				spec.CVTIconHg9:setPosition(posX-0.01, posY)
				spec.CVTIconHg10:setPosition(posX-0.01, posY)
				

				spec.CVTIconPG:setPosition(posX-0.01, posY)
				
				spec.CVTIconAr12:setPosition(posX-0.01, posY)
				spec.CVTIconAr22:setPosition(posX-0.01, posY)

				spec.CVTIconAr13:setPosition(posX-0.01, posY)
				spec.CVTIconAr23:setPosition(posX-0.01, posY)
				spec.CVTIconAr33:setPosition(posX-0.01, posY)

				spec.CVTIconAr1:setPosition(posX-0.01, posY)
				spec.CVTIconAr2:setPosition(posX-0.01, posY)
				spec.CVTIconAr3:setPosition(posX-0.01, posY)
				spec.CVTIconAr4:setPosition(posX-0.01, posY)
				
				spec.CVTIconAr15:setPosition(posX-0.01, posY)
				spec.CVTIconAr25:setPosition(posX-0.01, posY)
				spec.CVTIconAr35:setPosition(posX-0.01, posY)
				spec.CVTIconAr45:setPosition(posX-0.01, posY)
				spec.CVTIconAr55:setPosition(posX-0.01, posY)
				
				spec.CVTIconBr1:setPosition(posX-0.01, posY)
				spec.CVTIconBr2:setPosition(posX-0.01, posY)
				spec.CVTIconBr3:setPosition(posX-0.01, posY)
				spec.CVTIconBr4:setPosition(posX-0.01, posY)
				
				spec.CVTIconHydro:setPosition(posX-0.01, posY)
				-- spec.CVTIconN:setPosition(posX-0.01, posY)
				-- spec.CVTIconN2:setPosition(posX-0.01, posY)
				
				spec.CVTIconV:setPosition(posX-0.01, posY)
				spec.CVTIconR:setPosition(posX-0.01, posY)
				--
				spec.CVTIconBg:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconFb:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconFs1:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconFs2:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconFs3:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconFs4:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconPtms:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconHg2:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg3:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg4:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg5:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHEAT:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconDmg:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg6:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg7:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg8:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg9:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconHg10:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconPG:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconAr12:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr22:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconAr13:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr23:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr33:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconAr1:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr2:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr3:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr4:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconAr15:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr15:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr25:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr35:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr45:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconAr55:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconBr1:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconBr2:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconBr3:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconBr4:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconHydro:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				-- spec.CVTIconN:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				-- spec.CVTIconN2:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				
				spec.CVTIconV:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)
				spec.CVTIconR:setAlignment(Overlay.ALIGN_VERTICAL_MIDDLE, Overlay.ALIGN_HORIZONTAL_LEFT)

				-- :setAlignment(self.alignmentVertical, self.alignmentHorizontal)
				
				spec.CVTIconBg:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconBg:setVisible(true)
				spec.CVTIconFb:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconFs1:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconFs2:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconFs3:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconFs4:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconPtms:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)

				spec.CVTIconHg2:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg3:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg4:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg5:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHEAT:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconDmg:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg6:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg7:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg8:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg9:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconHg10:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconPG:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconAr12:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr22:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconAr13:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr23:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr33:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconAr1:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr1:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr2:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr3:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr4:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconAr15:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr25:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr35:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr45:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconAr55:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconBr1:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconBr2:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconBr3:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconBr4:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconHydro:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				-- spec.CVTIconN:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				-- spec.CVTIconN2:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				
				spec.CVTIconV:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)
				spec.CVTIconR:setScale(0.04*g_gameSettings.uiScale, 0.094*g_gameSettings.uiScale)

				local hgUVs = {0,0, 0.5,1}

				spec.CVTIconBg:render()
				if self:getMotorState() > 1 then
					spec.CVTIconFb:render()
				end
				if spec.AN then
					spec.CVTIconFs2:render()
				end
				if spec.forDBL_critdamage ~= 0 then
					spec.CVTIconDmg:render()
				end
				-- motor starting
				-- 					1=off 2=ignition 3=starting 4=running
				local daytime = 0
				local ignitionTimer
				local iTimer = 0
				if self:getMotorState() ~= 2 then
					ignitionTimer = true
					iTimer = 0
				end

				if spec.forDBL_preglowing == 1 then
					spec.CVTIconPG:render()
				elseif spec.forDBL_glowingstate == 1 then
					spec.CVTIconPG:render()
				end
				-- if self:getMotorState() == 2 and iTimer <= 100 then
					-- spec.CVTIconFs1:render()
					-- spec.CVTIconFs2:render()
					-- spec.CVTIconFs3:render()
					-- spec.CVTIconFs4:render()
					-- spec.CVTIconPtms:render()
					-- spec.CVTIconHg10:render()
					-- spec.CVTIconDmg:render()
					-- spec.CVTIconHEAT:render()
					-- spec.CVTIconBr1:render()
					-- spec.CVTIconBr2:render()
					-- spec.CVTIconBr3:render()
					-- spec.CVTIconBr4:render()
					-- spec.CVTIconPG:render()
					-- if spec.cvtAR == 2 then
						-- spec.CVTIconAr12:render()
						-- spec.CVTIconAr22:render()
					-- elseif spec.cvtAR == 3 then
						-- spec.CVTIconAr13:render()
						-- spec.CVTIconAr23:render()
						-- spec.CVTIconAr23:render()
					-- elseif spec.cvtAR == 4 then
						-- spec.CVTIconAr1:render()
						-- spec.CVTIconAr2:render()
						-- spec.CVTIconAr3:render()
						-- spec.CVTIconAr4:render()
					-- elseif spec.cvtAR == 5 then
						-- spec.CVTIconAr15:render()
						-- spec.CVTIconAr25:render()
						-- spec.CVTIconAr35:render()
						-- spec.CVTIconAr45:render()
						-- spec.CVTIconAr55:render()
					-- end
					-- spec.CVTIconV:render()
					-- spec.CVTIconR:render()
					-- if iTimer <= 101 then
						-- iTimer = iTimer + 1
					-- end
				-- end

				if self:getMotorState() > 2 then
					if spec.cvtDL == 4 then
						if spec.vOne == 1 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs1:render() -- 1
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 2 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs2:render() -- 2
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 3 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs3:render() -- 3
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 4 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs4:render() -- 4
								spec.CVTIconPtms:render()
							end
						end
					elseif spec.cvtDL == 3 then
						if spec.vOne == 1 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs1:render() -- 1
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 2 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs2:render() -- 2
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 3 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs4:render() -- 4
								spec.CVTIconPtms:render()
							end
						end
					elseif spec.cvtDL == 2 then
						if spec.vOne == 1 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs1:render() -- 1
								spec.CVTIconPtms:render()
							end
						elseif spec.vOne == 2 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig ==  7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs3:render() -- 3
								spec.CVTIconFs4:render() -- 4
								spec.CVTIconPtms:render()
							end
						end
					elseif spec.cvtDL == 1 then
						if spec.vOne == 1 and self:getMotorState() > 3 then
							if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 7 or spec.CVTconfig == 10 or spec.CVTconfig == 11 then
								spec.CVTIconFs1:setColor(1, 0.17, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
								spec.CVTIconFs2:setColor(1, 0.17, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
								spec.CVTIconFs3:setColor(1, 0.17, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
								spec.CVTIconFs4:setColor(1, 0.17, 0, math.max(math.min(spec.transparendSpdT, 1), 0.7))
								spec.CVTIconFs1:render() -- 1
								spec.CVTIconFs2:render()
								spec.CVTIconFs3:render()
								spec.CVTIconFs4:render()
							end
						end
					end
					
					-- modern
					if spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 and self:getMotorState() > 3 then
						spec.CVTIconFs1:render() -- 1
						spec.CVTIconFs3:render() -- 3
						spec.CVTIconFs4:render() -- 4
					end
					-- end
					if spec.isTMSpedal == 1 and self:getMotorState() > 2 then
					local tmsSpeed = string.format("%.1f", math.min((self:getCruiseControlSpeed() ) * math.pi, self.spec_motorized.motor.maxForwardSpeed * 3.6))
						spec.CVTIconPtms:render() -- 3
						if self:getCruiseControlState() == 0 then
							renderText(ptmsX, ptmsY, size, tmsSpeed)
							-- setTextColor(0.5, 1, 0.5, 0.5)
							-- setTextAlignment(RenderText.ALIGN_LEFT)
							-- setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
							-- setTextBold(true)
							-- renderText(0.5, 0.5, 0.05, "TEs7") -- BACK
							
						end
					end
					
					-- VCA DiffLocks AutoDiffsAWD
					if spec.autoDiffs == 1 and self:getMotorState() > 3 then
						if spec.CVTconfig == 1 or spec.CVTconfig == 2 or spec.CVTconfig == 3 or spec.CVTconfig == 11 then
							if spec.vOne == spec.cvtDL then
								setTextColor(0.8, 0.8, 0, 0.8)
								setTextAlignment(RenderText.ALIGN_LEFT)
								setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
								setTextBold(false)
								-- spec.forDBL_autodiffs = 0 -- Vorwahl und inaktiv
								-- spec.forDBL_preautodiffs = 1 -- Vorwahl und inaktiv
							elseif spec.vOne < spec.cvtDL then
								setTextColor(0, 0.95, 0, 0.8)
								setTextAlignment(RenderText.ALIGN_LEFT)
								setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
								setTextBold(false)
								-- spec.forDBL_autodiffs = 1 -- aktiv
								-- spec.forDBL_preautodiffs = 0 -- aktiv
							end
							-- renderText( 0.485 * ( VCAposX + VCAwidth + 1 ), VCAposY + 0.2 * VCAheight, VCAl + 0.005, "A" )
							renderText( VCAposX, VCAposY, VCAl + 0.005, "A" )
						elseif spec.CVTconfig == 4 or spec.CVTconfig == 5 or spec.CVTconfig == 6 then
							if spec.vOne ~= nil then
								setTextColor(0, 0.95, 0, 0.8)
								setTextAlignment(RenderText.ALIGN_LEFT)
								setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
								setTextBold(false)
							end
							-- renderText( 0.485 * ( VCAposX + VCAwidth + 1 ), VCAposY + 0.2 * VCAheight, VCAl + 0.005, "A" )
							renderText( VCAposX, VCAposY, VCAl + 0.005, "A" )
						elseif spec.CVTconfig == 7 then
							if spec.vOne ~= nil then
								setTextColor(0, 0.95, 0, 0.8)
								setTextAlignment(RenderText.ALIGN_LEFT)
								setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
								setTextBold(false)
								-- spec.forDBL_autodiffs = 1 -- aktiv
								-- spec.forDBL_preautodiffs = 0 -- n.V.
							end
							-- renderText( 0.485 * ( VCAposX + VCAwidth + 1 ), VCAposY + 0.2 * VCAheight, VCAl + 0.005, "A" )
							renderText( VCAposX, VCAposY, VCAl + 0.005, "A" )
						end
					elseif spec.autoDiffs ~= 1 then
						-- spec.forDBL_autodiffs = 0 -- inaktiv
						-- spec.forDBL_preautodiffs = 0 -- inaktiv
					end
					
					-- PTO hud icon changed to warning indicator
					if spec.forDBL_warnheat ~= 0 or spec.forDBL_critheat ~= 0 then
						spec.CVTIconHEAT:render()
					end
					if self.spec_motorized.motorTemperature.value < 56 and spec.CVTconfig ~= 10 then
						spec.CVTIconHEAT:render() -- for cold
					end
					if spec.forDBL_warndamage ~= 0 then
						spec.CVTIconDmg:render()
					end
					if spec.vFive ~= 0 and spec.vFive ~= nil then
						if spec.vFive == 1 then
							spec.CVTIconHg2:render()
						elseif spec.vFive == 2 then
							spec.CVTIconHg3:render()
						elseif spec.vFive == 3 then
							spec.CVTIconHg4:render()
						elseif spec.vFive == 4 then
							spec.CVTIconHg5:render()
						elseif spec.vFive == 5 then
							spec.CVTIconHg6:render()
						elseif spec.vFive == 6 then
							spec.CVTIconHg7:render()
						elseif spec.vFive == 7 then
							spec.CVTIconHg8:render()
						elseif spec.vFive == 8 then
							spec.CVTIconHg9:render()
						elseif spec.vFive >= 9 then
							spec.CVTIconHg10:render()
						end
					end
						
					if spec.cvtAR > 1 then
						if spec.cvtAR == 2 then
							if spec.vTwo == 1 then
								spec.CVTIconAr12:render()
							elseif spec.vTwo == 2 then
								spec.CVTIconAr22:render()
							end
						elseif spec.cvtAR == 3 then
							if spec.vTwo == 1 then
								spec.CVTIconAr13:render()
							elseif spec.vTwo == 2 then
								spec.CVTIconAr23:render()
							elseif spec.vTwo == 3 then
								spec.CVTIconAr33:render()
							end
						elseif spec.cvtAR == 4 then
							if spec.vTwo == 1 then
								spec.CVTIconAr1:render()
							elseif spec.vTwo == 2 then
								spec.CVTIconAr2:render()
							elseif spec.vTwo == 3 then
								spec.CVTIconAr3:render()
							elseif spec.vTwo == 4 then
								spec.CVTIconAr4:render()
							end
						elseif spec.cvtAR == 5 then
							if spec.vTwo == 1 then
								spec.CVTIconAr15:render()
							elseif spec.vTwo == 2 then
								spec.CVTIconAr25:render()
							elseif spec.vTwo == 3 then
								spec.CVTIconAr35:render()
							elseif spec.vTwo == 4 then
								spec.CVTIconAr45:render()
							elseif spec.vTwo == 5 then
								spec.CVTIconAr55:render()
							end
						end
					elseif spec.cvtAR == 1 then
						--
					end

					if spec.vThree ~= 2 then
						if spec.vThree == 3 then
							spec.CVTIconBr1:render()
							local showBrake = 0
							if self:getLastSpeed() >= 2 and self:getLastSpeed() <= 4 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) < 0.01 then
								for showBrake=1, 2 do
									spec.CVTIconBr1:render()
									spec.CVTIconBr2:render()
									spec.CVTIconBr3:render()
									spec.CVTIconBr4:render()
									showBrake = showBrake +1;
								end
							end
						elseif spec.vThree == 4 then
							spec.CVTIconBr2:render()
							local showBrake = 0
							if self:getLastSpeed() >= 2 and self:getLastSpeed() <= 8 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) < 0.01 then
								for showBrake=1, 2 do
									spec.CVTIconBr1:render()
									spec.CVTIconBr2:render()
									spec.CVTIconBr3:render()
									spec.CVTIconBr4:render()
									showBrake = showBrake +1;
								end
							end
						elseif spec.vThree == 5 then
							spec.CVTIconBr3:render()
							local showBrake = 0
							if self:getLastSpeed() >= 2 and self:getLastSpeed() <= 15 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) < 0.01 then
								for showBrake=1, 2 do
									spec.CVTIconBr1:render()
									spec.CVTIconBr2:render()
									spec.CVTIconBr3:render()
									spec.CVTIconBr4:render()
									showBrake = showBrake +1;
								end
							end
						elseif spec.vThree == 1 then
							spec.CVTIconBr4:render()
							if self:getLastSpeed() >= 2 and self:getLastSpeed() <= 17 and math.abs(self.spec_motorized.motor.lastAcceleratorPedal) < 0.01 then
								local showBrake = 0
								for showBrake=1, 2 do
									spec.CVTIconBr1:render()
									spec.CVTIconBr2:render()
									spec.CVTIconBr3:render()
									spec.CVTIconBr4:render()
									showBrake = showBrake +1;
								end
							end
						end -- rle
					end
					
					-- if spec.CVTCanStart == 0 then
						-- spec.CVTIconN2:render()
					-- end
					if self:getMotorState() > 2 then
						if self.spec_motorized.motor.currentDirection == 1 then
							spec.CVTIconV:render()
						elseif self.spec_motorized.motor.currentDirection == -1 then
							spec.CVTIconR:render()
						end
					end
					
					if spec.isHydroState then
						spec.CVTIconHydro:render()
					end
				end
				-- HUD.drawControlledEntityHUD()
				-- end

				-- 1337 Back to roots, wer hat das erfunden ?
				setTextColor(1,1,1,1)
				setTextAlignment(RenderText.ALIGN_LEFT)
				setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
				setTextBold(false)
				setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE)
				setTextLineBounds(0, 0)
				setTextWrapWidth(0)
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------
-- HUD draw	end		
----------------------------------------------------------------------------------------------------------------------


-- insert help menu
-- function CVTaddon:loadMapDataHelpLineManager(superFunc, ...)
    -- if superFunc(self, ...) then
		-- self:loadFromXML(Utils.getFilename("helpMenu/helpMenuCVTa.xml", CVTaddon.modDirectory))
        -- return true
    -- end
    -- return false
-- end
-- HelpLineManager.loadMapData = Utils.overwrittenFunction(HelpLineManager.loadMapData, CVTaddon.loadMapDataHelpLineManager)

----------------------------------------------------------------------------------------------------------------------			
-- ----------------   Server Sync   --------------------------------

-- function CVTaddon.SyncClientServer(vehicle, vOne, vTwo, vThree, CVTCanStart, vFive, autoDiffs, isVarioTM, isTMSpedal, CVTconfig, warnHeat, critHeat, warnDamage, critDamage, CVTdamage, HandgasPercent, ClutchInputValue, cvtDL, cvtAR, CVTcfgExists)
function CVTaddon.SyncClientServer(vehicle, vOne, vTwo, vThree, CVTCanStart, vFive, autoDiffs, isVarioTM, isTMSpedal, CVTconfig, warnHeat, critHeat, warnDamage, critDamage, CVTdamage, HandgasPercent, ClutchInputValue, cvtDL, cvtAR, VCAantiSlip, VCApullInTurn, CVTcfgExists)
	local spec = vehicle.spec_CVTaddon
	spec.vOne = vOne
	spec.vTwo = vTwo
	spec.vThree = vThree
	spec.CVTCanStart = CVTCanStart
	spec.vFive = vFive
	spec.autoDiffs = autoDiffs
	-- spec.lastDirection = lastDirection
	spec.isVarioTM = isVarioTM
	spec.isTMSpedal = isTMSpedal
	-- spec.moveRpmL = moveRpmL
	-- spec.rpmDmax = rpmDmax
	-- spec.rpmrange = rpmrange
	spec.CVTconfig = CVTconfig
	spec.forDBL_warnheat = warnHeat
	spec.forDBL_critheat = critHeat
	spec.forDBL_warndamage = warnDamage
	spec.forDBL_critdamage = critDamage
	spec.CVTdamage = CVTdamage
	spec.HandgasPercent = HandgasPercent --
	spec.ClutchInputValue = ClutchInputValue
	spec.cvtDL = cvtDL
	spec.cvtAR = cvtAR
	spec.VCAantiSlip = VCAantiSlip
	spec.VCApullInTurn = VCApullInTurn
	spec.CVTcfgExists = CVTcfgExists
	-- spec.mcRPMvar = mcRPMvar
end								
function CVTaddon:onReadStream(streamId, connection)
	local spec = self.spec_CVTaddon
	spec.vOne = streamReadInt32(streamId)  -- state driving level
	spec.vTwo = streamReadInt32(streamId) -- state accelerationRamp
	spec.vThree = streamReadInt32(streamId) -- state brakeRamp
	spec.CVTCanStart = streamReadBool(streamId) -- state neutral
	spec.vFive = streamReadInt32(streamId) -- state Handgas
	spec.autoDiffs = streamReadInt32(streamId) -- state autoDiffs n awd
	-- spec.lastDirection = streamReadInt32(streamId) -- backup for neutral
	spec.isVarioTM = streamReadBool(streamId) -- checks if cvt
	spec.isTMSpedal = streamReadInt32(streamId) -- checks if pedalresolution is in use
	-- spec.moveRpmL = streamReadFloat32(streamId) -- tms pedalmodus in %
	-- spec.rpmDmax = streamReadInt32(streamId) -- rpm range for max rpm
	-- spec.rpmrange = streamReadInt32(streamId) -- rpm state for max rpm
	spec.CVTconfig = streamReadInt32(streamId) -- cfg id
	spec.forDBL_warnheat = streamReadInt32(streamId) -- warnHeat
	spec.forDBL_critheat = streamReadInt32(streamId) -- critHeat
	spec.forDBL_warndamage = streamReadInt32(streamId) -- warnDamage
	spec.forDBL_critdamage = streamReadInt32(streamId) -- critDamage
	spec.CVTdamage = streamReadFloat32(streamId) -- Verschleiß
	spec.HandgasPercent = streamReadFloat32(streamId) -- Verschleiß
	spec.ClutchInputValue = streamReadFloat32(streamId) -- CVT Kupplung (new inputAction like origin)
	spec.cvtDL = streamReadInt32(streamId) -- DL count
	spec.cvtAR = streamReadInt32(streamId) -- AR count
	spec.VCAantiSlip = streamReadInt32(streamId) -- AR count
	spec.VCApullInTurn = streamReadInt32(streamId) -- AR count
	spec.CVTcfgExists = streamReadBool(streamId) -- CVT Kupplung (new inputAction like origin)
	
	-- Set DBL Values after read stream
	if spec.forDBL_ipmactive == nil then spec.forDBL_ipmactive = 0 end
	
	spec.forDBL_pedalpercent = "0"
	spec.forDBL_tmspedalvmax = "0"
	spec.forDBL_tmspedalvmaxactual = "0"
	
	if spec.autoDiffs == 1 then
		spec.forDBL_autodiffs = 1 -- aktiv
	else
		spec.forDBL_autodiffs = 0 -- inaktiv
	end
	if spec.isTMSpedal ~= nil then
		if spec.isTMSpedal == 0 then
			spec.forDBL_tmspedal = 0
		elseif spec.isTMSpedal == 1 then
			spec.forDBL_tmspedal = 1
		end
	end

	if spec.vOne ~= nil then
		spec.forDBL_drivinglevel = tostring(spec.vOne)
	end
	spec.forDBL_digitalhandgasstep = tostring(spec.vFive)
	if spec.vTwo ~= nil then
		spec.forDBL_accramp = tostring(spec.vTwo)
	end
	spec.forDBL_rpmdmax = tostring(spec.rpmDmax)
	if spec.vThree ~= nil then
		if (spec.vThree == 1) then -- BRamp 1
			spec.forDBL_brakeramp = tostring(17) -- off
		end
		if (spec.vThree == 2) then -- BRamp 2
			spec.forDBL_brakeramp = tostring(0) -- km/h
		end
		if (spec.vThree == 3) then -- BRamp 3
			spec.forDBL_brakeramp = tostring(4) -- km/h
		end
		if (spec.vThree == 4) then -- BRamp 4
			spec.forDBL_brakeramp = tostring(8) -- km/h
		end
		if (spec.vThree == 5) then -- BRamp 5
			spec.forDBL_brakeramp = tostring(15) -- km/h
		end
	end
	spec.forDBL_warnheat = 0
	spec.forDBL_warndamage = 0
	spec.forDBL_critheat = 0
	spec.forDBL_critdamage = 0
	spec.HandgasPercent = 0.0
	if spec.ClutchInputValue == nil then
		spec.ClutchInputValue = 0.0
	end
	if spec.CVTdamage ~= nil then
		spec.forDBL_cvtwear = spec.CVTdamage
	else
		spec.forDBL_cvtwear = 0.0
		spec.CVTdamage = 0.0
	end
end

function CVTaddon:onWriteStream(streamId, connection)
	local spec = self.spec_CVTaddon
	streamWriteInt32(streamId, spec.vOne)
	streamWriteInt32(streamId, spec.vTwo)
	streamWriteInt32(streamId, spec.vThree)
	streamWriteBool(streamId, spec.CVTCanStart)
	streamWriteInt32(streamId, spec.vFive)	
	streamWriteInt32(streamId, spec.autoDiffs)	
	-- streamWriteInt32(streamId, spec.lastDirection)	
	streamWriteBool(streamId, spec.isVarioTM)
	streamWriteInt32(streamId, spec.isTMSpedal)
	-- streamWriteFloat32(streamId, spec.moveRpmL)
	-- streamWriteInt32(streamId, spec.rpmDmax)
	-- streamWriteInt32(streamId, spec.rpmrange)
	streamWriteInt32(streamId, spec.CVTconfig)
	streamWriteInt32(streamId, spec.forDBL_warnheat)
	streamWriteInt32(streamId, spec.forDBL_critheat)
	streamWriteInt32(streamId, spec.forDBL_warndamage)
	streamWriteInt32(streamId, spec.forDBL_critdamage)
	streamWriteFloat32(streamId, spec.CVTdamage)
	streamWriteFloat32(streamId, spec.HandgasPercent)
	streamWriteFloat32(streamId, spec.ClutchInputValue) -- nil
	streamWriteInt32(streamId, spec.cvtDL)
	streamWriteInt32(streamId, spec.cvtAR)
	streamWriteInt32(streamId, spec.VCAantiSlip) -- error?
	streamWriteInt32(streamId, spec.VCApullInTurn)
	streamWriteBool(streamId, spec.CVTcfgExists)
	-- streamWriteFloat32(streamId, spec.mcRPMvar)
end

function CVTaddon:onReadUpdateStream(streamId, timestamp, connection)
	if not connection:getIsServer() then
		local spec = self.spec_CVTaddon
		if streamReadBool(streamId) then			
			spec.vOne = streamReadInt32(streamId)
			spec.vTwo = streamReadInt32(streamId)
			spec.vThree = streamReadInt32(streamId)
			spec.CVTCanStart = streamReadBool(streamId)
			spec.vFive = streamReadInt32(streamId)
			spec.autoDiffs = streamReadInt32(streamId)
			-- spec.lastDirection = streamReadInt32(streamId)
			spec.isVarioTM = streamReadBool(streamId)
			spec.isTMSpedal = streamReadInt32(streamId)
			-- spec.moveRpmL = streamReadFloat32(streamId)
			-- spec.rpmDmax = streamReadInt32(streamId)
			-- spec.rpmrange = streamReadInt32(streamId)
			spec.CVTconfig = streamReadInt32(streamId)
			spec.forDBL_warnheat = streamReadInt32(streamId) -- warnHeat
			spec.forDBL_critheat = streamReadInt32(streamId) -- critHeat
			spec.forDBL_warndamage = streamReadInt32(streamId) -- warnDamage
			spec.forDBL_critdamage = streamReadInt32(streamId) -- critDamage
			spec.CVTdamage = streamReadFloat32(streamId)
			spec.HandgasPercent = streamReadFloat32(streamId) --?
			spec.ClutchInputValue = streamReadFloat32(streamId)
			spec.cvtDL = streamReadInt32(streamId)
			spec.cvtAR = streamReadInt32(streamId)
			spec.VCAantiSlip = streamReadInt32(streamId)
			spec.VCApullInTurn = streamReadInt32(streamId)
			spec.CVTcfgExists = streamReadBool(streamId)
			-- end
		end
	end
end

function CVTaddon:onWriteUpdateStream(streamId, connection, dirtyMask)
-- local spec = self.spec_CVTaddon
	if connection:getIsServer() then
		local spec = self.spec_CVTaddon
		if streamWriteBool(streamId, bitAND(dirtyMask, spec.dirtyFlag) ~= 0) then
			streamWriteInt32(streamId, spec.vOne)
			streamWriteInt32(streamId, spec.vTwo)
			streamWriteInt32(streamId, spec.vThree) --
			streamWriteBool(streamId, spec.CVTCanStart) --
			streamWriteInt32(streamId, spec.vFive)
			streamWriteInt32(streamId, spec.autoDiffs)  --
			-- streamWriteInt32(streamId, spec.lastDirection) --
			streamWriteBool(streamId, spec.isVarioTM)
			streamWriteInt32(streamId, spec.isTMSpedal) --
			-- streamWriteFloat32(streamId, spec.moveRpmL) --
			-- streamWriteInt32(streamId, spec.rpmDmax)  --
			-- streamWriteInt32(streamId, spec.rpmrange)  --
			streamWriteInt32(streamId, spec.CVTconfig)  --
			streamWriteInt32(streamId, spec.forDBL_warnheat) --
			streamWriteInt32(streamId, spec.forDBL_critheat) --
			streamWriteInt32(streamId, spec.forDBL_warndamage)
			streamWriteInt32(streamId, spec.forDBL_critdamage)
			streamWriteFloat32(streamId, spec.CVTdamage) --
			streamWriteFloat32(streamId, spec.HandgasPercent) --
			streamWriteFloat32(streamId, spec.ClutchInputValue)
			streamWriteInt32(streamId, spec.cvtDL)
			streamWriteInt32(streamId, spec.cvtAR)
			streamWriteInt32(streamId, spec.VCAantiSlip)
			streamWriteInt32(streamId, spec.VCApullInTurn)
			streamWriteBool(streamId, spec.CVTcfgExists)
			-- streamWriteBool(streamId, spec.check
		end
	end
end

-- Drivable = true
-- addModEventListener(CVTaddon)
-- Player.registerActionEvents = Utils.appendedFunction(Player.registerActionEvents, CVTaddon.registerActionEvents)
-- Drivable.onUpdate  = Utils.appendedFunction(Drivable.onUpdate, CVTaddon.onUpdate);