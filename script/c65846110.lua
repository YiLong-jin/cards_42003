--彩虹天使 晴
function c65846110.initial_effect(c)
	c:EnableReviveLimit()
	local e0=aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_SYNCHRO),1,1)	
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(65846110)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846110,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c65846110.tktg)
	e1:SetOperation(c65846110.tkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846110.tgtg)
	e2:SetOperation(c65846110.tgop)
	c:RegisterEffect(e2)
	--[[local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TUNER)
	e4:SetValue(function(e,c)
	return e:GetHandler():IsControler(c:GetControler())
	end)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE)  
		c:RegisterEffect(e1)
	end)
	c:RegisterEffect(e4)]]
	--[[if not c65846110.check then
		c65846110.check=true
		c65846110[0]=Card.IsCanBeSynchroMaterial
		Card.IsCanBeSynchroMaterial=function(tc,sc,...)
			if tc:IsHasEffect(65846110) and tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL) then
				if tc:GetSynchroType()&TYPE_MONSTER==0 then return false end
				if sc and tc:IsLocation(LOCATION_MZONE) and tc:GetControler()~=sc:GetControler() and not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then return false end
				if tc:IsStatus(STATUS_FORBIDDEN) then return false end
				if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
				return true 
			else
				return c65846110[0](tc,sc,...)
			end
		end
		c65846110[1]=Card.GetSynchroLevel
		Card.GetSynchroLevel=function(tc,sc)
			local es={tc:IsHasEffect(EFFECT_SYNCHRO_LEVEL)} 
			local lev=0
			for k,v in pairs(es) do
				lev=v:GetValue(v)
				break 
			end
			if tc:IsHasEffect(65846110) and lev>0 then
				return lev
			else
				return c65846110[1](tc,sc) 
			end
		end
		c65846110[3]=Duel.CheckTunerMaterial
		Duel.CheckTunerMaterial=function(sc,smat,f1,f2,minc,maxc,mg1)
			local f1=aux.Tuner(f1)
			local tp=sc:GetControler()
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
		c65846110[4]=Duel.CheckSynchroMaterial
		Duel.CheckSynchroMaterial=function(sc,f1,f2,minc,maxc,smat,mg1)
			return Duel.CheckTunerMaterial(sc,smat,f1,f2,minc,maxc,mg1)
		end
		c65846110[5]=Duel.SelectTunerMaterial
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
		c65846110[6]=Duel.SelectSynchroMaterial
		Duel.SelectSynchroMaterial=function(tp,sc,f1,f2,minc,maxc,smat,mg1)
			return Duel.SelectTunerMaterial(tp,sc,smat,f1,f2,minc,maxc,mg1)
		end
	end]]
end
c65846110.SetCard_ZJ_CH=true
function c65846110.tgfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsAbleToGrave()
end
function c65846110.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c65846110.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846110.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c65846110.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c65846110.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c65846110.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsReleasable()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65846111,0,0x4011,800,800,2,0x4,0x10,0x5) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
end
function c65846110.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65846111,0,0x4011,800,800,2,0x4,0x10,0x5) then return end
	local token=Duel.CreateToken(tp,65846111)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,0x5)~=0 then 
		Duel.Release(e:GetHandler(),REASON_EFFECT)
	end
end
