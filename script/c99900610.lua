--在这个被崩坏的世界上
function c99900610.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,99900610)
	e1:SetCost(c99900610.recost)
	e1:SetTarget(c99900610.retg)
	e1:SetOperation(c99900610.reop)
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99900610,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99900611)
	e2:SetCondition(c99900610.sscon)
	e2:SetTarget(c99900610.sstg)
	e2:SetOperation(c99900610.ssop)
	c:RegisterEffect(e2)


------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99900610.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99900610.refil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x663) 
	and c:GetReasonEffect():GetHandler():GetControler()~=tp and c:IsReason(REASON_EFFECT)
end
function c99900610.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c99900610.refil,1,nil,tp) end
end
function c99900610.reop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我的馒头卡呜呜呜我的馒头卡┭┮﹏┭┮")
	local g=eg:Filter(c99900610.refil,nil,tp) 
	local tc=g:GetFirst()
	local xg=Group.CreateGroup()
	while tc do
	local xc=tc:GetReasonEffect():GetHandler()
	xg:AddCard(xc)
	tc=g:GetNext()
	end
	Duel.Remove(xg,POS_FACEDOWN,REASON_EFFECT)
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900610.sscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil) and (Duel.GetTurnPlayer()==tp or Duel.GetMatchingGroupCount(c99900610.filatk,tp,0,LOCATION_ONFIELD,nil)>0)
end
function c99900610.filatk(c)
	return c:IsType(TYPE_MONSTER)
end
function c99900610.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,99900610,0x676,TYPE_EFFECT+TYPE_MONSTER,1800,1000,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99900610.ssop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("是时候融合馒头卡了（雾）")
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,99900610,0x676,TYPE_EFFECT+TYPE_MONSTER,1800,1000,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_MONSTER)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99900610.filfu),tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local sg1=Duel.GetMatchingGroup(c99900610.filfus,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,c,chkf)
	if Duel.GetChainMaterial(tp) then return end
	if sg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99900610,3)) then
		Duel.BreakEffect()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg1:Select(tp,1,1,nil):GetFirst()
		if tc then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end 
	end
end
function c99900610.filfu(c,tp)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove(tp,POS_FACEUP)
end
function c99900610.filfus(c,e,tp,m,ec,chkf)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,ec,chkf) and c:IsSetCard(0x676)
end
------------------------------------------------------------------------------------------------------------------------------------------------
