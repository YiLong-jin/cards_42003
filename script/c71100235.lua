--白狼战鬼
local m=71100235
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Attribute light
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--race
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e3)
end
function cm.spf(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ZOMBIE) and Duel.GetMZoneCount(tp)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if eg:IsContains(e:GetHandler()) or #eg~=1 then return false end
		local ec=eg:GetFirst()
		return ec:IsRace(RACE_ZOMBIE) or (ec:IsControler(1-tp) and ec:IsLocation(LOCATION_MZONE)) or (ec:IsControler(tp) and Duel.IsPlayerCanDraw(tp,1)) or Duel.IsExistingMatchingCard(cm.spf,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	local ec=eg:GetFirst()
	e:SetCategory(0) 
	if ec:IsRace(RACE_ZOMBIE) then e:SetCategory(CATEGORY_ATKCHANGE+e:GetCategory()) end
	if Duel.GetMZoneCount(tp)>0 and not ec:IsRace(RACE_ZOMBIE) then 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+e:GetCategory()) 
	end
	if ec:IsControler(1-tp) and ec:IsLocation(LOCATION_MZONE) then 
		e:SetCategory(CATEGORY_DESTROY+e:GetCategory()) 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,1-tp,LOCATION_MZONE)
	end
	if ec:IsControler(tp) and Duel.IsPlayerCanDraw(tp,1) then 
		e:SetCategory(CATEGORY_DRAW+e:GetCategory()) 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	Duel.SetTargetCard(ec)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetFirstTarget()
	if ec:IsRelateToEffect(e) and ec:IsLocation(LOCATION_MZONE) then 
		if ec:IsControler(1-tp) then 
			Duel.Destroy(ec,REASON_EFFECT)
		else 
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	if ec:IsRace(RACE_ZOMBIE) and c:IsFaceup() and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if not ec:IsRace(RACE_ZOMBIE) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spf,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end