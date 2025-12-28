--亡灵海岸的海盗黑湾
function c21400129.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400129,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21400129)
	e1:SetTarget(c21400129.sptg)
	e1:SetOperation(c21400129.spop)
	c:RegisterEffect(e1)
	--draw 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400129,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11400129)
	e2:SetCondition(c21400129.drcon)
	e2:SetTarget(c21400129.drtg)
	e2:SetOperation(c21400129.drop)
	c:RegisterEffect(e2)
	--tg
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(21400129,3))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,31400129)
	e3:SetCondition(c21400129.tgcon)
	e3:SetTarget(c21400129.tgtg)
	e3:SetOperation(c21400129.tgop)
	c:RegisterEffect(e3)
end
function c21400129.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xb210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400129.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400129.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c21400129.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21400129.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21400129.drckfil(c,tp) 
	return c:IsControler(tp) and c:IsSetCard(0xb210)   
end 
function c21400129.drcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c21400129.drckfil,1,nil,tp)
end
function c21400129.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21400129.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c21400129.tckfil(c,code) 
	return c:IsFaceup() and c:IsCode(code) 
end 
function c21400129.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21400129.tckfil,tp,LOCATION_MZONE,0,1,nil,21400123)
	   and Duel.IsExistingMatchingCard(c21400129.tckfil,tp,LOCATION_MZONE,0,1,nil,21400124)
	   and Duel.IsExistingMatchingCard(c21400129.tckfil,tp,LOCATION_MZONE,0,1,nil,21400125)
end
function c21400129.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function c21400129.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(c21400129.tgfilter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400129.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c21400129.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)  
		end 
	end 
end


