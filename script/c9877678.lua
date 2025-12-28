--叛逆者后世纪-卡贝克斯
local id = 9877678
local s = _G["c"..id]
function c9877678.initial_effect(c)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9877678,0))
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1877678)
	e13:SetCost(c9877678.cost1)
	e13:SetTarget(c9877678.destg)
	e13:SetOperation(c9877678.desop)
	c:RegisterEffect(e13)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end



function c9877678.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877678.setfilter(c)  
	return c:IsSetCard(0x17ec) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end  
function c9877678.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9877678.setfilter,tp,LOCATION_GRAVE,0,1,nil) end  
end
function c9877678.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9877678.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then
		Duel.SSet(tp,tc)
	end
end