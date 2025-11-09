--二叶莎奈-原点进化
local s,id,o=GetID()
function c9877914.initial_effect(c)
	aux.AddCodeList(c,9877913) 

	aux.EnableChangeCode(c,9877913,LOCATION_MZONE+LOCATION_GRAVE)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)  
	e11:SetDescription(aux.Stringid(9877635,1)) 
	e11:SetCategory(CATEGORY_TODECK) 
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAINING)
	e11:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,id+o)
	e11:SetCondition(s.spcon1)   
	e11:SetTarget(s.settg)  
	e11:SetOperation(s.setop)  
	c:RegisterEffect(e11)  
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.setfilter(c)  
	return  c:GetType()==TYPE_TRAP and c:IsSSetable() 
end  
function s.setfilter1(c)  
	return  aux.IsCodeListed(c,9877913) and c:IsAbleToDeck() and c:IsFaceup()
end  
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(s.setfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end 
	local g=Duel.SelectTarget(tp,s.setfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
end  
function s.setop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local tc=g1:GetFirst()  
		if tc then  
			Duel.SSet(tp,tc)
		end  
	end 
	  
end  