--崭新的少女·殴丝
local s, id = GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,c99971800.mfilter,1,1)
	c:EnableReviveLimit()	
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,99971800)
	e0:SetOperation(c99971800.operation)
	c:RegisterEffect(e0)

end









function c99971800.mfilter(c)
	return c:IsRace(0x20) and c:IsSetCard(0x67f)
end
function c99971800.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c99971800.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c99971800.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99971800)
	Duel.Draw(tp,1,REASON_EFFECT)
end
