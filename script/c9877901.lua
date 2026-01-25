--合作無間的搭檔組合！
function c9877901.initial_effect(c)
	aux.AddCodeList(c,9877895,9877896,9877897)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877901,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,9877901+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c9877901.condition) 
	e3:SetTarget(c9877901.destg)
	e3:SetOperation(c9877901.desop)
	c:RegisterEffect(e3)
end
function c9877901.filter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) ) and c:IsFaceup()
end
function c9877901.atkfilter(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) )
end
function c9877901.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877901.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9877901.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) ) and c:IsType(TYPE_MONSTER)
end 
function c9877901.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877901.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) 
end
function c9877901.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877901.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
		 local g2=Duel.GetMatchingGroup(c9877901.atkfilter,tp,LOCATION_MZONE,0,nil)
		 local bc=g2:GetFirst()
			while bc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(9877901,0))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			bc:RegisterEffect(e3)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(9877901,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			bc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			bc:RegisterEffect(e2)
			bc=g2:GetNext()
		   end
		end
	end 
end

