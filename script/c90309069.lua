--幸运魔人6
 function c90309069.initial_effect(c)
	--SPECIAL_SUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90309069,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c90309069.sptg)
	e1:SetOperation(c90309069.spop)
	c:RegisterEffect(e1)   
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90309069,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,90309069)
	e2:SetTarget(c90309069.drtg)
	e2:SetOperation(c90309069.drop)
	c:RegisterEffect(e2)
 --return
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(90309069,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(c90309069.retcon)
	e7:SetTarget(c90309069.rettg)
	e7:SetOperation(c90309069.retop)
	c:RegisterEffect(e7)
	if not c90309069.global_check then
		c90309069.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(90309069)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
c90309069.toss_coin=true
function c90309069.thfilter1(c,e,tp)
	return c:IsLevel(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x973) 
end
function c90309069.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c90309069.thfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) 
		 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90309069.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local coin=Duel.TossCoin(tp,1)
 if coin==1 then
	local g=Duel.SelectMatchingCard(tp,c90309069.thfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
end   
function c90309069.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90309069.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c90309069.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(90309069)~=0
end
function c90309069.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c90309069.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
