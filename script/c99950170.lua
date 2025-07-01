--识之律者 符华
local m=99950170
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x366c),2,3)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
--  e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.dacon)
	e3:SetCost(cm.dacost)
	e3:SetTarget(cm.ctg)
	e3:SetOperation(cm.daop)
	c:RegisterEffect(e3)






end
function cm.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsControlerCanBeChanged() then
		if tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_DISABLE)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e8)
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_DISABLE_EFFECT)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e7)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_CODE)
			e5:SetValue(99950040)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_CHANGE_LEVEL)
			e6:SetValue(2)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e6)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_XYZ_LEVEL)
	tc:RegisterEffect(e3)
	local e2=e1:Clone()
	e2:SetCode(99950170)
	e2:SetValue(aux.TRUE)
	tc:RegisterEffect(e2)
	if not c99950170.check then
		c99950170.check=true
		c99950170[0]=Card.IsCanBeSynchroMaterial
		Card.IsCanBeSynchroMaterial=function(tc,sc,...)
			if tc:IsHasEffect(99950170) and tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL) then
				if tc:GetSynchroType()&TYPE_MONSTER==0 then return false end
				if sc and tc:IsLocation(LOCATION_MZONE) and tc:GetControler()~=sc:GetControler() and not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then return false end
				if tc:IsStatus(STATUS_FORBIDDEN) then return false end
				if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
				return true 
			else
				return c99950170[0](tc,sc,...)
			end
		end
		c99950170[1]=Card.GetSynchroLevel
		Card.GetSynchroLevel=function(tc,sc)
			local es={tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL)}
			local lev=0
			for k,v in pairs(es) do
				lev=v:GetValue(v)
				break 
			end
			if tc:IsHasEffect(99950170) and lev>0 then
				return lev
			else
				return c99950170[1](tc,sc)
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
		c99950170[3]=Duel.CheckTunerMaterial
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
		c99950170[4]=Duel.CheckSynchroMaterial
		Duel.CheckSynchroMaterial=function(sc,f1,f2,minc,maxc,smat,mg1)
			return Duel.CheckTunerMaterial(sc,smat,f1,f2,minc,maxc,mg1)
		end
		c99950170[5]=Duel.SelectTunerMaterial
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
		c99950170[6]=Duel.SelectSynchroMaterial
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
		end
		Duel.GetControl(tc,tp,PHASE_END,2)
	end
end









function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.mtfilter(c,e)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
