--猎虫棋子 掠食螳蛉
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701047,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.xyzcon)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
	--Gains Effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCountLimit(1,id+o)
	e1:SetCondition(s.efcon)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRace(RACE_INSECT)
end
function s.xyzfilter(c,g)
	return c:IsXyzSummonable(g,#g,#g)
end
function s.xyzcfilter(c,e)
	return c==e:GetHandler()
end
function s.xyzfselect(g,e,tp)
	return g and g:IsExists(s.xyzcfilter,1,nil,e) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.xyzmatfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return g and g:CheckSubGroup(s.xyzfselect,2,#g,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,s.xyzfselect,false,2,#g,e,tp)
	if #sg<1 then return end 
	local scg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if scg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=scg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,rg:GetFirst(),sg)
	end
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsRace(RACE_INSECT)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.ovlcon)
	e1:SetTarget(s.ovltg)
	e1:SetOperation(s.ovlop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function s.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:GetOriginalType()&TYPE_MONSTER~=0 and rc:GetBaseAttack()<e:GetHandler():GetBaseAttack()
end
function s.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and c:GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_INSECT)
		and rc:IsRelateToEffect(re) and rc:IsCanBeXyzMaterial(c) end
end
function s.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local result=0
	if result==0 and c:IsRelateToEffect(e) then
		local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsRace,nil,RACE_INSECT)
		if og:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local g=og:Select(tp,1,1,nil)
		result=Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	end
	if result>0 and c:IsRelateToEffect(e)
		and rc:IsRelateToEffect(re) and rc:IsControler(1-tp) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rc)
	end
end