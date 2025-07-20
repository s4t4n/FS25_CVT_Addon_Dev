--
-- CVT-Addon FS25
-- by SbSh-Modastian
-- GUI insp. Jason06
--

CVTaddonGui = {}
local CVTaddonGui_mt = Class(CVTaddonGui, YesNoDialog)
-- local CVTaddonGui_mt = Class(CVTaddonGui, ScreenElement)

print("CVTaddonGui : initializing")

-- constructor
function CVTaddonGui:new(target, customMt)
	local gui = YesNoDialog:new(nil, CVTaddonGui_mt)
	-- local gui = DialogElement.new(target, custom_mt or CVTaddonGui_mt)
	-- self.vehicle = nil

	-- return self
	return gui
end

-- set current values
function CVTaddonGui.setData(self, vehicleName, spec, hasNothing, debug, showKeys)
	self.spec = spec
	
	-- print("GUIa: " .. tostring(self.spec.HUDpos))
	-- Clicks
	
	self.noButton.onClickCallback  				= CVTaddonGui.onClickBack
	self.yesButton.onClickCallback 				= CVTaddonGui.onClickOk
	self.variantSetting.onFocusCallback 		= CVTaddonGui.logicalCheck
	self.variantSetting.onHighlightCallback 	= CVTaddonGui.logicalCheck
	self.CvtHUDSetting.onFocusCallback 			= CVTaddonGui.logicalCheck
	self.resetButton.onClickCallback  			= CVTaddonGui.onButtonLoad
	-- onButtonAdminLogin()
	-- if g_currentMission.isMasterUser ~= nil then if g_currentMission.isMasterUser then
			
	self.variantSetting.onClickCallback 		= CVTaddonGui.logicalCheck
	
	self.CvtHUDSetting.onClickCallback 			= CVTaddonGui.logicalCheck
	
	self.CvthudPosSetting.onClickCallback 		= CVTaddonGui.logicalCheck
	-- self.CvthudPosSetting.onFocusCallback 		= CVTaddonGui.logicalCheck
	self.drivinglevelSetting.onClickCallback 	= CVTaddonGui.logicalCheck
	self.accRampSetting.onClickCallback 		= CVTaddonGui.logicalCheck
	self.antiSlipSetting.onClickCallback 		= CVTaddonGui.logicalCheck
	self.pitSetting.onClickCallback 			= CVTaddonGui.logicalCheck
	self.ipmSetting.onClickCallback 			= CVTaddonGui.logicalCheck
	self.HSTSetting.onClickCallback 			= CVTaddonGui.logicalCheck
	self.inchingSetting.onClickCallback 		= CVTaddonGui.logicalCheck
	self.inchingSetting.onHighlightCallback 	= CVTaddonGui.logicalCheck
		-- end
	-- end
	
		
	-- Tool Tips
	self.variantTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("variantTT") .. "  State: "..tostring(self.spec.CVTconfig))
	self.CvthudTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CvthudTT"))
	self.ipmTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("ipmTT"))
	self.CvthudPOSTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CvthudPOSTT"))
	self.drivinglevelTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("drivinglevelTT"))
	self.accRampTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("accRampTT"))
	self.antiSlipTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("antiSlipTT"))
	self.pitTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("pitTT"))
	self.HSTTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("hstTT"))
	self.inchingTT:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("inchingTT"))

	
	-- Main Header Titel
	self.guiTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_title") .." für "..vehicleName) -- Top header

	-- Title Texte
	self.variant:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_Variant"))		-- SubHeader
	self.ipmTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_ipmTitle"))		-- SubHeader
	self.Cvthud:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_Hud"))			-- SubHeader
	self.CvthudPos:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_CvthudPos"))	-- XsubHeader
	self.drivinglevelTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_drivinglevelT"))	-- XsubHeader
	self.accRampTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_accRampT"))	-- XsubHeader
	self.antiSlipTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_antiSlipT"))	-- XsubHeader
	self.pitTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_pitT"))	-- XsubHeader
	self.HSTTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_HstTitle"))	-- XsubHeader
	self.inchingTitle:setText(g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAgui_inchingTitle"))	-- Inching

	-- Settings Texte
		-- CVT Variante
	-- local VARv15 = {}		
	local VARv15 = {																	-- Varios
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVTclas_installed_short"),				-- 1 classic		1
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVTmod_installed_short"),				-- 4 modern			2
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_HST_installed_short"),					-- 7 HST and hydrostate 3
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_notInstalledTemp_short"),			-- 8 disabled 4
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_ElektroInstalled_short"),			--10 electric drive		5
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_HarvesterInstalled_short")			--11 harvesterdrive like Hydrostate 6
	}
	local VARv15m = {																	-- Manual Transmission
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_notInstalledTemp_short"),			-- 8 disabled 1
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_CVT_manuInstalled_short")				-- 9 manualshifter 2
	}
	
		-- CVT IPM for classic & modern & manual
	local IPMv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_IPMboost0"),							-- 1 no boost
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_IPMboost15"),							-- 2 15ps boost
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_IPMboost22"),							-- 3 22ps boost
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_IPMboost27"),							-- 4 27ps boost
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("text_IPMboost34")							-- 5 34ps boost
	}
	
		-- HUD Vis
	local HUDSETv15 = {																	-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAguiHUD_on"),								-- visible
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("CVTAguiHUD_off")								-- invisible
	}
	
		-- HUD Position
	local HUDPOSv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_CVTaddonHUDpos_1"),			-- default
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_CVTaddonHUDpos_2")				-- top
	}
		-- drivinglevel count
	local DLCv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_drivinglevel_1"), -- vario
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_drivinglevel_2"),
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_drivinglevel_3"),
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_drivinglevel_4")
	}
		-- accRamp count
	local ARCv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_accRamp_1"), -- no
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_accRamp_2"),
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_accRamp_3"), -- eg JD
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_accRamp_4"), -- eg Fendt
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_accRamp_5")
	}
		-- antiSlip 
	local ASv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_deactive"), -- no
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_active")
	}
		-- VCApullInTurn
	local PITv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_deactive"), -- no
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_active")
	}
	
		-- HST
	local HSTv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_hst_hst"),
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_hst_hydrostat")
	}
	
		-- Inching
	local inchingv15 = {																-- Options
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_inching_dn"),
		g_i18n.modEnvironments[CVTaddon.MOD_NAME]:getText("selection_inching_up")
	}
	
	-- Set Settings Texte
	if self.spec.isVarioTM then
		self.variantSetting:setTexts(VARv15)
	else
		self.variantSetting:setTexts(VARv15m)
	end
	self.ipmSetting:setTexts(IPMv15)
	self.CvtHUDSetting:setTexts(HUDSETv15)
	self.CvthudPosSetting:setTexts(HUDPOSv15)
	self.drivinglevelSetting:setTexts(DLCv15)
	self.accRampSetting:setTexts(ARCv15)
	self.antiSlipSetting:setTexts(ASv15)
	self.pitSetting:setTexts(PITv15)
	self.HSTSetting:setTexts(HSTv15)
	self.inchingSetting:setTexts(inchingv15)
	
	-- States Abfragen
		-- Configs
	-- local variant = self.variantSetting:getState() > 0
	local variantstateSet = 1
	-- if variant and self.spec.isVarioTM then
	if self.spec.isVarioTM == true then
		if self.spec.CVTconfig == 1 or self.spec.CVTconfig == 2 or self.spec.CVTconfig == 3 then
			variantstateSet = 1
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(false)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(false)
			self.accRampTitle:setVisible(true)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		elseif self.spec.CVTconfig == 4 or self.spec.CVTconfig == 5 or self.spec.CVTconfig == 6 then
			variantstateSet = 2
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(false)
			self.accRampTitle:setVisible(true)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(false)
			self.pitTitle:setVisible(true)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		elseif self.spec.CVTconfig == 7 then
			variantstateSet = 3
			self.HSTTitle:setVisible(true)
			self.HSTSetting:setDisabled(false)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 8 then
			variantstateSet = 4
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(true)
			self.antiSlipTitle:setVisible(false)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 10 then
			variantstateSet = 5
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 11 then
			variantstateSet = 6
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(true)
			self.inchingSetting:setDisabled(false)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		end
	-- MANUAL
	elseif self.spec.isVarioTM == false then
		if self.spec.CVTconfig == 8 and self.spec.CVTconfig ~= 9 then
			variantstateSet = 1
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 9 then -- manual set to no vario
			variantstateSet = 2
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		end
	end
	local dlCount = self.spec.cvtDL
	local arCount = self.spec.cvtAR

		-- set other states
	self.variantSetting:setState(variantstateSet)
	self.CvtHUDSetting:setState(self.spec.HUDvis)
	self.CvthudPosSetting:setState(self.spec.HUDpos)
	self.ipmSetting:setState(self.spec.CVTipm)
	self.drivinglevelSetting:setState(dlCount)
	self.antiSlipSetting:setState(self.spec.VCAantiSlip)
	self.pitSetting:setState(self.spec.VCApullInTurn)
	self.accRampSetting:setState(arCount)
	self.HSTSetting:setState(self.spec.HSTstate)
	self.inchingSetting:setState(self.spec.inchingState)

	-- require logged in as admin
	if g_currentMission.isMasterUser ~= nil then if g_currentMission.isMasterUser == false then
			self.variantSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
		else
			self.variantSetting:setDisabled(false)
			self.drivinglevelSetting:setDisabled(false)
		end
	end
	
end

-- CHECK LOGICAL DEPENDENCIES

function CVTaddonGui:logicalCheck()
	-- self.spec = spec
	-- local useConfig = self.variantSetting:getState() > 0
	-- local useNonDefaultHUD = self.CvtHUDSetting:getState() ~= 1
	local useHUDvis = self.CvtHUDSetting:getState() == 1
	local hasIPM = false
	local hasHST = false
	local inching = false
	local couldDL = self.variantSetting:getState() == 1
	local couldAR = false
	local hasAS = false
	local hasPIT = false
	
	print("GUI logical spec HUDpos: " .. tostring(self.spec.HUDpos))
	print("GUI logical state CvthudPosSetting: " .. tostring(self.CvthudPosSetting:getState()))
	
	if self.spec.isVarioTM == true then
		hasIPM = self.variantSetting:getState() == 1 or self.variantSetting:getState() == 2
		hasHST = self.variantSetting:getState() == 3
		couldAR = hasIPM
	else
		hasIPM = self.variantSetting:getState() == 2
		couldDL = false
		couldAR = false
	end
	
	if self.spec.isVarioTM == true then
		hasAS = (self.variantSetting:getState() >= 1 and self.variantSetting:getState() <= 3 ) or self.variantSetting:getState() == 6
	else
		hasAS = self.variantSetting:getState() == 2
	end
	
	if self.spec.isVarioTM == true then
		hasPIT = self.variantSetting:getState() == 2
	else
		hasPIT = false
	end
		
	if self.variantSetting:getState() == 6 then
		inching = true
	else
		inching = false
	end
	
	self.CvthudPos:setDisabled(not useHUDvis)
	self.CvthudPosSetting:setDisabled(not useHUDvis)
	
	self.ipmSetting:setDisabled(not hasIPM)
	self.ipmTitle:setVisible(hasIPM)
	
	self.drivinglevelTitle:setVisible(couldDL)
	self.drivinglevelSetting:setDisabled(not couldDL)
	
	self.accRampTitle:setVisible(couldAR)
	self.accRampSetting:setDisabled(not couldAR)
	
	self.antiSlipSetting:setDisabled(not hasAS)
	self.antiSlipTitle:setVisible(hasAS)
	
	self.pitSetting:setDisabled(not hasPIT)
	self.pitTitle:setVisible(hasPIT)
	
	self.HSTTitle:setVisible(hasHST)
	self.HSTSetting:setDisabled(not hasHST)
	
	self.inchingTitle:setVisible(inching)
	self.inchingSetting:setDisabled(not inching)
	
	-- print("GUI logical E: " .. tostring(self.spec.HUDpos))

end

-- close gui and send new values to callback

function CVTaddonGui:onClickOk()

	-- cfg
	-- local variant = self.variantSetting:getState() > 0
	local variantstate = self.variantSetting:getState()
	if self.spec.isVarioTM then
		if variantstate 			== 1 then -- classic
			self.spec.CVTconfig 	= 1
		elseif variantstate 		== 2 then -- modern
			self.spec.CVTconfig 	= 4
		elseif variantstate 		== 3 then -- HST/Hydrostat
			self.spec.CVTconfig 	= 7
		elseif variantstate 		== 4 then -- Off
			self.spec.CVTconfig 	= 8
		elseif variantstate 		== 5 then -- electric
			self.spec.CVTconfig 	= 10
		elseif variantstate 		== 6 then -- harvester
			self.spec.CVTconfig 	= 11
		end
	elseif not self.spec.isVarioTM then
		if variantstate 			== 1 then -- off
			self.spec.CVTconfig 	= 8
		elseif variantstate 		== 2 then -- manual
			self.spec.CVTconfig 	= 9
		end
	end
	local cvtDLset = self.drivinglevelSetting:getState()
	
	if self.spec.CVTconfig >= 3 then
		cvtDLset = 2
--	else
--		cvtDLset = self.drivinglevelSetting:getState()
	end
	
	-- set states
	self.spec.CVTipm 		= self.ipmSetting:getState()
	self.spec.cvtDL 		= cvtDLset
	self.spec.cvtAR 		= self.accRampSetting:getState()
	self.spec.VCAantiSlip 	= self.antiSlipSetting:getState()
	self.spec.VCApullInTurn = self.pitSetting:getState()
	self.spec.vTwo 			= self.spec.cvtAR -- need to ensure that only until the highest accramp is active and not above out of the range
	
	self.spec.HSTstate 		= self.HSTSetting:getState()
	self.spec.inchingState	= self.inchingSetting:getState()
	
	
	
	-- hud
	local Cvthud = self.CvtHUDSetting:getState() > 0
	local Cvthudstate = self.CvtHUDSetting:getState()
	local CvthudPOSstate = self.CvthudPosSetting:getState()
	if Cvthud then
		self.spec.HUDvis = Cvthudstate
	end
	if Cvthud then
		self.spec.HUDpos = CvthudPOSstate
	end
	self.spec.CVTconfigLast = self.spec.CVTconfig
	
	
	-- local showKeys = self.inputbindingsSetting:getState() == 1
	self:close()
	self.callbackFunc(self.target, self.spec, debug, showKeys)
	
	-- print("GUI OK E: " .. tostring(self.spec.HUDpos))
end

-- just close gui
function CVTaddonGui:onClickBack()
	self:close()
end

function CVTaddonGui:onButtonLoad()
	local variantstateSet = 1
	-- if variant and self.spec.isVarioTM then
	if self.spec.isVarioTM == true then
		if self.spec.CVTconfig == 1 or self.spec.CVTconfig == 2 or self.spec.CVTconfig == 3 then
			variantstateSet = 1
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(false)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(false)
			self.accRampTitle:setVisible(true)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		elseif self.spec.CVTconfig == 4 or self.spec.CVTconfig == 5 or self.spec.CVTconfig == 6 then
			variantstateSet = 2
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(false)
			self.accRampTitle:setVisible(true)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(false)
			self.pitTitle:setVisible(true)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		elseif self.spec.CVTconfig == 7 then
			variantstateSet = 3
			self.HSTTitle:setVisible(true)
			self.HSTSetting:setDisabled(false)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 8 then
			variantstateSet = 4
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(true)
			self.antiSlipTitle:setVisible(false)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 10 then
			variantstateSet = 5
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 11 then
			variantstateSet = 6
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(true)
			self.inchingSetting:setDisabled(false)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		end
	-- MANUAL
	elseif self.spec.isVarioTM == false then
		if self.spec.CVTconfig == 8 and self.spec.CVTconfig ~= 9 then
			variantstateSet = 1
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(true)
			self.ipmTitle:setVisible(false)
		elseif self.spec.CVTconfig == 9 then -- manual set to no vario
			variantstateSet = 2
			self.HSTTitle:setVisible(false)
			self.HSTSetting:setDisabled(true)
			self.inchingTitle:setVisible(false)
			self.inchingSetting:setDisabled(true)
			self.drivinglevelSetting:setDisabled(true)
			self.drivinglevelTitle:setVisible(false)
			self.accRampSetting:setDisabled(true)
			self.accRampTitle:setVisible(false)
			self.antiSlipSetting:setDisabled(false)
			self.antiSlipTitle:setVisible(true)
			self.pitSetting:setDisabled(true)
			self.pitTitle:setVisible(false)
			self.ipmSetting:setDisabled(false)
			self.ipmTitle:setVisible(true)
		end
	end
	local dlCount = self.spec.cvtDL
	local arCount = self.spec.cvtAR

		-- set other states
	self.variantSetting:setState(variantstateSet)
	self.CvtHUDSetting:setState(self.spec.HUDvis)
	self.CvthudPosSetting:setState(self.spec.HUDpos)
	self.ipmSetting:setState(self.spec.CVTipm)
	self.drivinglevelSetting:setState(dlCount)
	self.antiSlipSetting:setState(self.spec.VCAantiSlip)
	self.pitSetting:setState(self.spec.VCApullInTurn)
	self.accRampSetting:setState(arCount)
	self.HSTSetting:setState(self.spec.HSTstate)
	self.inchingSetting:setState(self.spec.inchingState)
end
