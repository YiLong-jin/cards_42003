--思念体×神足由宇
function c69969002.initial_effect(c)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969002,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,69969002)
	e2:SetCondition(c69969002.spcon)
	e2:SetTarget(c69969002.sptg)
	e2:SetOperation(c69969002.spop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c69969002.cost)
	e3:SetTarget(c69969002.tg)
	e3:SetOperation(c69969002.op)
	c:RegisterEffect(e3)
end
--1
function c69969002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c69969002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(69969002,1)) then
	Duel.BreakEffect()
	  local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	   if g:GetCount()>0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local sg=g:Select(tp,1,1,nil)
		   Duel.HintSelection(sg)
		   Duel.Destroy(sg,REASON_EFFECT)
		   Duel.Damage(tp,300,REASON_EFFECT)
	  end
   end 
end
function c69969002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c69969002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,300)
end
function c69969002.op(e,tp,eg,ep,ev,re,r,rp)
	p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end


