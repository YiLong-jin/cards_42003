--The Savior of The Last
--The Savior of The Last
local m=99970130
local cm=_G["c"..m]
function cm.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1,3)
	c:EnableReviveLimit()
		--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1)
	e0:SetTarget(cm.nmtg)
	e0:SetOperation(cm.nmop)
	c:RegisterEffect(e0)
	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9990281)
	e3:SetCost(c99970130.spcost)
	e3:SetTarget(c99970130.sptg1)
	e3:SetOperation(c99970130.spop1)
	c:RegisterEffect(e3)
	
--	local e1=Effect.CreateEffect(c)
--	e1:SetType(EFFECT_TYPE_SINGLE)
--	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
--	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
--	e1:SetRange(LOCATION_MZONE)
--	e1:SetValue(3)
--	c:RegisterEffect(e1)
--	local e3=e1:Clone()
--	e3:SetCode(EFFECT_XYZ_LEVEL)
--	c:RegisterEffect(e3)
--	local e2=e1:Clone()
--	e2:SetCode(m)
--	e2:SetValue(aux.TRUE)
--	c:RegisterEffect(e2)
	--cannot link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--[[	if not cm.check then
		cm.check=true
		cm[0]=Card.IsCanBeSynchroMaterial
		Card.IsCanBeSynchroMaterial=function(tc,sc,...)
			if tc:IsHasEffect(m) and tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL) then
				if tc:GetSynchroType()&TYPE_MONSTER==0 then return false end
				if sc and tc:IsLocation(LOCATION_MZONE) and tc:GetControler()~=sc:GetControler() and not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then return false end
				if tc:IsStatus(STATUS_FORBIDDEN) then return false end
				if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
				return true 
			else
				return cm[0](tc,sc,...)
			end
		end
		cm[1]=Card.GetSynchroLevel
		Card.GetSynchroLevel=function(tc,sc)
			local es={tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL)}
			local lev=0
			for k,v in pairs(es) do
				lev=v:GetValue(v)
				break 
			end
			if tc:IsHasEffect(m) and lev>0 then
				return lev
			else
				return cm[1](tc,sc)
			end
		end
--[[
		--for utility.lua load first before 2022.2.20
		--now not available here
		cm[2]=aux.AddSynchroProcedure
		aux.AddSynchroProcedure=function(sc,f1,f2,min,max)
			local maxc=max or 99
			aux.AddSynchroMixProcedure(sc,f1,nil,nil,f2,min,maxc)
		end
--]]
		--fix for utility.lua load first 2022.2.20
		--plan1
--[[		cm[3]=Duel.CheckTunerMaterial
		Duel.CheckTunerMaterial=function(sc,smat,f1,f2,minc,maxc,mg1)
			local f1=aux.Tuner(f1)
			local tp=c:GetControler()
			local mg
			local mgchk=false
			if mg1 then
				mg=mg1
				mgchk=true
			else
				mg=Auxiliary.GetSynMaterials(tp,sc)
			end
			if smat~=nil then mg:AddCard(smat) end
			return mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,nil,nil,f2,minc,maxc,sc,mg,smat,nil,mgchk)
		end
		cm[4]=Duel.CheckSynchroMaterial
		Duel.CheckSynchroMaterial=function(sc,f1,f2,minc,maxc,smat,mg1)
			return Duel.CheckTunerMaterial(sc,smat,f1,f2,minc,maxc,mg1)
		end
		cm[5]=Duel.SelectTunerMaterial
		Duel.SelectTunerMaterial=function(tp,sc,smat,f1,f4,minc,maxc,mg1)
				local f1=aux.Tuner(f1)
				local g=Group.CreateGroup()
				local gc=nil
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,sc)
				end
				if smat~=nil then mg:AddCard(smat) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,Auxiliary.SynMixFilter1,1,1,nil,f1,nil,nil,f4,minc,maxc,sc,mg,smat,gc,mgchk):GetFirst()
				g:AddCard(c1)
				local g4=Group.CreateGroup()
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,sc)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,sc,g,smat,gc,mgchk)
					if cg:GetCount()==0 then break end
					local minct=1
					if Auxiliary.SynMixCheckGoal(tp,g4,minc,i,sc,g,smat,gc,mgchk) then
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,1,nil)
					if tg:GetCount()==0 then break end
					g4:Merge(tg)
				end
				g:Merge(g4)
			return g
		end
		cm[6]=Duel.SelectSynchroMaterial
		Duel.SelectSynchroMaterial=function(tp,sc,f1,f2,minc,maxc,smat,mg1)
			return Duel.SelectTunerMaterial(tp,sc,smat,f1,f2,minc,maxc,mg1)
		end
--[[
		--plan2
		local tsg=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_SYNCHRO)
		for tsc in aux.Next(tsg) do 
			local esg={esc:IsHasEffect(EFFECT_SPSUMMON_PROC)}
		end
--]]
end
--]]end
--Effect 1

function cm.thfilter(c)
	return c:IsSetCard(0x1661) and c:IsAbleToHand()
end
function c99970130.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c99970130.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970130.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end










function cm.nf(c)
	if c:GetOriginalType()&TYPE_MONSTER==0 and c:IsSetCard(0x1661,0x669,0x671,0x676,0x666c) then return false end
	return Duel.IsExistingMatchingCard(cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function cm.nf1(c,ec)
	return c:IsFaceup() and not c:IsCode(ec:GetCode())
end
function cm.nmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function cm.nmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local name=tc:GetCode()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local tcc=Duel.SelectMatchingCard(tp,cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc):GetFirst()
		if tcc==nil or tcc:IsFacedown() then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(name)
		tcc:RegisterEffect(e1)
		tcc:SetHint(CHINT_CARD,name)
	end
end