--ウォーター・ドラゴン－オーバーロード
function c10701501.initial_effect(c)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,6022371,LOCATION_MZONE+LOCATION_GRAVE)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10701501.splimit)
	c:RegisterEffect(e1)
	--to grave 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701501,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c10701501.tgtg)
	e2:SetOperation(c10701501.tgop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701501,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCost(c10701501.discost)
	e3:SetOperation(c10701501.disop)
	c:RegisterEffect(e3)
end
function c10701501.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsType(TYPE_SPELL+TYPE_TRAP) and sc:IsSetCard(0x100)
end
function c10701501.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c10701501.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10701501.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetLocation())
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10701501.spfilter(c,e,tp)
	return c:IsLevelBelow(10) and c:IsRace(RACE_SEASERPENT+RACE_DINOSAUR) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE)
end
function c10701501.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(58071123) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_DINOSAUR))) and c:IsAbleToHand()
end
function c10701501.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c10701501.discon)
	e1:SetOperation(c10701501.disop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tg=Duel.GetMatchingGroup(c10701501.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c10701501.thfilter,tp,LOCATION_DECK,0,nil)
	local res1=tg:GetClassCount(Card.GetCode)>=2
	if res1 and bit.band(e:GetLabel(),LOCATION_MZONE)~=0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	   and Duel.GetFlagEffect(tp,10701501)==0
	   and Duel.SelectYesNo(tp,aux.Stringid(10701501,2)) 
	   and Duel.GetMZoneCount(tp,e:GetHandler())>=2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		Duel.RegisterFlagEffect(tp,10701501,RESET_PHASE+PHASE_END,0,1)
	elseif bit.band(e:GetLabel(),LOCATION_HAND)~=0 and g:GetCount()>0 
	   and Duel.GetFlagEffect(tp,10701502)==0
	   and Duel.SelectYesNo(tp,aux.Stringid(10701501,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
		Duel.RegisterFlagEffect(tp,10701502,RESET_PHASE+PHASE_END,0,1)
	end
end
function c10701501.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) and rp==1-tp
end
function c10701501.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end